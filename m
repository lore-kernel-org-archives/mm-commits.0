From: akpm@linux-foundation.org
Subject: [merged] shmem-prepare-huge=-mount-option-and-sysfs-knob.patch
 removed from -mm tree
Date: Wed, 27 Jul 2016 12:02:52 -0700
Message-ID: <5799055c.6YNhPMuZXj7ExYon%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932311AbcG0TCx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 15:02:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: prepare huge= mount option and sysfs knob
has been removed from the -mm tree.  Its filename was
     shmem-prepare-huge=-mount-option-and-sysfs-knob.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: shmem: prepare huge= mount option and sysfs knob

This patch adds new mount option "huge=". It can have following values:

  - "always":
	Attempt to allocate huge pages every time we need a new page;

  - "never":
	Do not allocate huge pages;

  - "within_size":
	Only allocate huge page if it will be fully within i_size.
	Also respect fadvise()/madvise() hints;

  - "advise:
	Only allocate huge pages if requested with fadvise()/madvise();

Default is "never" for now.

"mount -o remount,huge= /mountpoint" works fine after mount: remounting
huge=never will not attempt to break up huge pages at all, just stop
more from being allocated.

No new config option: put this under CONFIG_TRANSPARENT_HUGEPAGE,
which is the appropriate option to protect those who don't want
the new bloat, and with which we shall share some pmd code.

Prohibit the option when !CONFIG_TRANSPARENT_HUGEPAGE, just as mpol is
invalid without CONFIG_NUMA (was hidden in mpol_parse_str(): make it
explicit).

Allow enabling THP only if the machine has_transparent_hugepage().

But what about Shmem with no user-visible mount?  SysV SHM, memfds,
shared anonymous mmaps (of /dev/zero or MAP_ANONYMOUS), GPU drivers'
DRM objects, Ashmem.  Though unlikely to suit all usages, provide
sysfs knob /sys/kernel/mm/transparent_hugepage/shmem_enabled to
experiment with huge on those.

And allow shmem_enabled two further values:

  - "deny":
	For use in emergencies, to force the huge option off from
	all mounts;
  - "force":
	Force the huge option on for all - very useful for testing;

Based on patch by Hugh Dickins.

Link: http://lkml.kernel.org/r/1466021202-61880-28-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h  |    2 
 include/linux/shmem_fs.h |    3 
 mm/huge_memory.c         |    3 
 mm/shmem.c               |  161 +++++++++++++++++++++++++++++++++++++
 4 files changed, 168 insertions(+), 1 deletion(-)

diff -puN include/linux/huge_mm.h~shmem-prepare-huge=-mount-option-and-sysfs-knob include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~shmem-prepare-huge=-mount-option-and-sysfs-knob
+++ a/include/linux/huge_mm.h
@@ -41,6 +41,8 @@ enum transparent_hugepage_flag {
 #endif
 };
 
+extern struct kobj_attribute shmem_enabled_attr;
+
 #define HPAGE_PMD_ORDER (HPAGE_PMD_SHIFT-PAGE_SHIFT)
 #define HPAGE_PMD_NR (1<<HPAGE_PMD_ORDER)
 
diff -puN include/linux/shmem_fs.h~shmem-prepare-huge=-mount-option-and-sysfs-knob include/linux/shmem_fs.h
--- a/include/linux/shmem_fs.h~shmem-prepare-huge=-mount-option-and-sysfs-knob
+++ a/include/linux/shmem_fs.h
@@ -28,9 +28,10 @@ struct shmem_sb_info {
 	unsigned long max_inodes;   /* How many inodes are allowed */
 	unsigned long free_inodes;  /* How many are left for allocation */
 	spinlock_t stat_lock;	    /* Serialize shmem_sb_info changes */
+	umode_t mode;		    /* Mount mode for root directory */
+	unsigned char huge;	    /* Whether to try for hugepages */
 	kuid_t uid;		    /* Mount uid for root directory */
 	kgid_t gid;		    /* Mount gid for root directory */
-	umode_t mode;		    /* Mount mode for root directory */
 	struct mempolicy *mpol;     /* default memory policy for mappings */
 };
 
diff -puN mm/huge_memory.c~shmem-prepare-huge=-mount-option-and-sysfs-knob mm/huge_memory.c
--- a/mm/huge_memory.c~shmem-prepare-huge=-mount-option-and-sysfs-knob
+++ a/mm/huge_memory.c
@@ -442,6 +442,9 @@ static struct attribute *hugepage_attr[]
 	&enabled_attr.attr,
 	&defrag_attr.attr,
 	&use_zero_page_attr.attr,
+#ifdef CONFIG_SHMEM
+	&shmem_enabled_attr.attr,
+#endif
 #ifdef CONFIG_DEBUG_VM
 	&debug_cow_attr.attr,
 #endif
diff -puN mm/shmem.c~shmem-prepare-huge=-mount-option-and-sysfs-knob mm/shmem.c
--- a/mm/shmem.c~shmem-prepare-huge=-mount-option-and-sysfs-knob
+++ a/mm/shmem.c
@@ -289,6 +289,87 @@ static bool shmem_confirm_swap(struct ad
 }
 
 /*
+ * Definitions for "huge tmpfs": tmpfs mounted with the huge= option
+ *
+ * SHMEM_HUGE_NEVER:
+ *	disables huge pages for the mount;
+ * SHMEM_HUGE_ALWAYS:
+ *	enables huge pages for the mount;
+ * SHMEM_HUGE_WITHIN_SIZE:
+ *	only allocate huge pages if the page will be fully within i_size,
+ *	also respect fadvise()/madvise() hints;
+ * SHMEM_HUGE_ADVISE:
+ *	only allocate huge pages if requested with fadvise()/madvise();
+ */
+
+#define SHMEM_HUGE_NEVER	0
+#define SHMEM_HUGE_ALWAYS	1
+#define SHMEM_HUGE_WITHIN_SIZE	2
+#define SHMEM_HUGE_ADVISE	3
+
+/*
+ * Special values.
+ * Only can be set via /sys/kernel/mm/transparent_hugepage/shmem_enabled:
+ *
+ * SHMEM_HUGE_DENY:
+ *	disables huge on shm_mnt and all mounts, for emergency use;
+ * SHMEM_HUGE_FORCE:
+ *	enables huge on shm_mnt and all mounts, w/o needing option, for testing;
+ *
+ */
+#define SHMEM_HUGE_DENY		(-1)
+#define SHMEM_HUGE_FORCE	(-2)
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+/* ifdef here to avoid bloating shmem.o when not necessary */
+
+int shmem_huge __read_mostly;
+
+static int shmem_parse_huge(const char *str)
+{
+	if (!strcmp(str, "never"))
+		return SHMEM_HUGE_NEVER;
+	if (!strcmp(str, "always"))
+		return SHMEM_HUGE_ALWAYS;
+	if (!strcmp(str, "within_size"))
+		return SHMEM_HUGE_WITHIN_SIZE;
+	if (!strcmp(str, "advise"))
+		return SHMEM_HUGE_ADVISE;
+	if (!strcmp(str, "deny"))
+		return SHMEM_HUGE_DENY;
+	if (!strcmp(str, "force"))
+		return SHMEM_HUGE_FORCE;
+	return -EINVAL;
+}
+
+static const char *shmem_format_huge(int huge)
+{
+	switch (huge) {
+	case SHMEM_HUGE_NEVER:
+		return "never";
+	case SHMEM_HUGE_ALWAYS:
+		return "always";
+	case SHMEM_HUGE_WITHIN_SIZE:
+		return "within_size";
+	case SHMEM_HUGE_ADVISE:
+		return "advise";
+	case SHMEM_HUGE_DENY:
+		return "deny";
+	case SHMEM_HUGE_FORCE:
+		return "force";
+	default:
+		VM_BUG_ON(1);
+		return "bad_val";
+	}
+}
+
+#else /* !CONFIG_TRANSPARENT_HUGEPAGE */
+
+#define shmem_huge SHMEM_HUGE_DENY
+
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+
+/*
  * Like add_to_page_cache_locked, but error if expected item has gone.
  */
 static int shmem_add_to_page_cache(struct page *page,
@@ -2860,11 +2941,24 @@ static int shmem_parse_options(char *opt
 			sbinfo->gid = make_kgid(current_user_ns(), gid);
 			if (!gid_valid(sbinfo->gid))
 				goto bad_val;
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+		} else if (!strcmp(this_char, "huge")) {
+			int huge;
+			huge = shmem_parse_huge(value);
+			if (huge < 0)
+				goto bad_val;
+			if (!has_transparent_hugepage() &&
+					huge != SHMEM_HUGE_NEVER)
+				goto bad_val;
+			sbinfo->huge = huge;
+#endif
+#ifdef CONFIG_NUMA
 		} else if (!strcmp(this_char,"mpol")) {
 			mpol_put(mpol);
 			mpol = NULL;
 			if (mpol_parse_str(value, &mpol))
 				goto bad_val;
+#endif
 		} else {
 			pr_err("tmpfs: Bad mount option %s\n", this_char);
 			goto error;
@@ -2910,6 +3004,7 @@ static int shmem_remount_fs(struct super
 		goto out;
 
 	error = 0;
+	sbinfo->huge = config.huge;
 	sbinfo->max_blocks  = config.max_blocks;
 	sbinfo->max_inodes  = config.max_inodes;
 	sbinfo->free_inodes = config.max_inodes - inodes;
@@ -2943,6 +3038,11 @@ static int shmem_show_options(struct seq
 	if (!gid_eq(sbinfo->gid, GLOBAL_ROOT_GID))
 		seq_printf(seq, ",gid=%u",
 				from_kgid_munged(&init_user_ns, sbinfo->gid));
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	/* Rightly or wrongly, show huge mount option unmasked by shmem_huge */
+	if (sbinfo->huge)
+		seq_printf(seq, ",huge=%s", shmem_format_huge(sbinfo->huge));
+#endif
 	shmem_show_mpol(seq, sbinfo->mpol);
 	return 0;
 }
@@ -3282,6 +3382,13 @@ int __init shmem_init(void)
 		pr_err("Could not kern_mount tmpfs\n");
 		goto out1;
 	}
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	if (has_transparent_hugepage() && shmem_huge < SHMEM_HUGE_DENY)
+		SHMEM_SB(shm_mnt->mnt_sb)->huge = shmem_huge;
+	else
+		shmem_huge = 0; /* just in case it was patched */
+#endif
 	return 0;
 
 out1:
@@ -3293,6 +3400,60 @@ out3:
 	return error;
 }
 
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(CONFIG_SYSFS)
+static ssize_t shmem_enabled_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	int values[] = {
+		SHMEM_HUGE_ALWAYS,
+		SHMEM_HUGE_WITHIN_SIZE,
+		SHMEM_HUGE_ADVISE,
+		SHMEM_HUGE_NEVER,
+		SHMEM_HUGE_DENY,
+		SHMEM_HUGE_FORCE,
+	};
+	int i, count;
+
+	for (i = 0, count = 0; i < ARRAY_SIZE(values); i++) {
+		const char *fmt = shmem_huge == values[i] ? "[%s] " : "%s ";
+
+		count += sprintf(buf + count, fmt,
+				shmem_format_huge(values[i]));
+	}
+	buf[count - 1] = '\n';
+	return count;
+}
+
+static ssize_t shmem_enabled_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	char tmp[16];
+	int huge;
+
+	if (count + 1 > sizeof(tmp))
+		return -EINVAL;
+	memcpy(tmp, buf, count);
+	tmp[count] = '\0';
+	if (count && tmp[count - 1] == '\n')
+		tmp[count - 1] = '\0';
+
+	huge = shmem_parse_huge(tmp);
+	if (huge == -EINVAL)
+		return -EINVAL;
+	if (!has_transparent_hugepage() &&
+			huge != SHMEM_HUGE_NEVER && huge != SHMEM_HUGE_DENY)
+		return -EINVAL;
+
+	shmem_huge = huge;
+	if (shmem_huge < SHMEM_HUGE_DENY)
+		SHMEM_SB(shm_mnt->mnt_sb)->huge = shmem_huge;
+	return count;
+}
+
+struct kobj_attribute shmem_enabled_attr =
+	__ATTR(shmem_enabled, 0644, shmem_enabled_show, shmem_enabled_store);
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE && CONFIG_SYSFS */
+
 #else /* !CONFIG_SHMEM */
 
 /*
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are



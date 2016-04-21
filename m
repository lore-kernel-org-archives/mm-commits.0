From: akpm@linux-foundation.org
Subject: [to-be-updated]
 huge-tmpfs-huge=n-mount-option-and-proc-sys-vm-shmem_huge.patch removed
 from -mm tree
Date: Thu, 21 Apr 2016 13:45:40 -0700
Message-ID: <57193bf4.S88kP1G0tANwQiOq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55061 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbcDUUpl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2016 16:45:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, andreslc@google.com, kirill.shutemov@linux.intel.com, quning@gmail.com, rientjes@google.com, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: huge tmpfs: huge=N mount option and /proc/sys/vm/shmem_huge
has been removed from the -mm tree.  Its filename was
     huge-tmpfs-huge=n-mount-option-and-proc-sys-vm-shmem_huge.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: huge tmpfs: huge=N mount option and /proc/sys/vm/shmem_huge

Plumb in a new "huge=1" or "huge=0" mount option to tmpfs: I don't
want to get into a maze of boot options, madvises and fadvises at
this stage, nor extend the use of the existing THP tuning to tmpfs;
though either might be pursued later on.  We just want a way to ask
a tmpfs filesystem to favor huge pages, and a way to turn that off
again when it doesn't work out so well.  Default of course is off.

"mount -o remount,huge=N /mountpoint" works fine after mount:
remounting from huge=1 (on) to huge=0 (off) will not attempt to
break up huge pages at all, just stop more from being allocated.

It's possible that we shall allow more values for the option later,
to select different strategies (e.g. how hard to try when allocating
huge pages, or when to map hugely and when not, or how sparse a huge
page should be before it is split up), either for experiments, or well
baked in: so use an unsigned char in the superblock rather than a bool.

No new config option: put this under CONFIG_TRANSPARENT_HUGEPAGE,
which is the appropriate option to protect those who don't want
the new bloat, and with which we shall share some pmd code.  Use a
"name=numeric_value" format like most other tmpfs options.  Prohibit
the option when !CONFIG_TRANSPARENT_HUGEPAGE, just as mpol is invalid
without CONFIG_NUMA (was hidden in mpol_parse_str(): make it explicit).
Allow setting >0 only if the machine has_transparent_hugepage().

But what about Shmem with no user-visible mount?  SysV SHM, memfds,
shared anonymous mmaps (of /dev/zero or MAP_ANONYMOUS), GPU drivers'
DRM objects, ashmem.  Though unlikely to suit all usages, provide
sysctl /proc/sys/vm/shmem_huge to experiment with huge on those.  We
may add a memfd_create flag and a per-file huge/non-huge fcntl later.

And allow shmem_huge two further values: -1 for use in emergencies,
to force the huge option off from all mounts; and (currently) 2,
to force the huge option on for all - very useful for testing.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Ning Qu <quning@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/tmpfs.txt |   45 +++++++++++++++++
 Documentation/sysctl/vm.txt         |   16 ++++++
 include/linux/shmem_fs.h            |   16 ++++--
 kernel/sysctl.c                     |   12 ++++
 mm/shmem.c                          |   66 ++++++++++++++++++++++++++
 5 files changed, 149 insertions(+), 6 deletions(-)

diff -puN Documentation/filesystems/tmpfs.txt~huge-tmpfs-huge=n-mount-option-and-proc-sys-vm-shmem_huge Documentation/filesystems/tmpfs.txt
--- a/Documentation/filesystems/tmpfs.txt~huge-tmpfs-huge=n-mount-option-and-proc-sys-vm-shmem_huge
+++ a/Documentation/filesystems/tmpfs.txt
@@ -140,9 +140,52 @@ will give you tmpfs instance on /mytmpfs
 RAM/SWAP in 10240 inodes and it is only accessible by root.
 
 
+Huge tmpfs
+==========
+
+If CONFIG_TRANSPARENT_HUGEPAGE is enabled, tmpfs has a mount (or remount)
+option for transparent huge pagecache, giving the efficiency advantage of
+hugepages (from less TLB pressure and fewer pagetable levels), without
+the inflexibility of hugetlbfs.  Huge tmpfs pages can be swapped out when
+memory pressure demands, just as ordinary tmpfs pages can be swapped out.
+
+huge=0    default, don't attempt to allocate hugepages.
+huge=1    allocate hugepages when available, and mmap on hugepage boundaries.
+
+So 'mount -t tmpfs -o huge=1 tmpfs /mytmpfs' will give you a huge tmpfs.
+
+Huge tmpfs pages can be slower to allocate than ordinary pages (since they
+may require compaction), and slower to set up initially than hugetlbfs pages
+(since a team of small pages is managed instead of a single compound page);
+but once set up and mapped, huge tmpfs performance should match hugetlbfs.
+
+/proc/sys/vm/shmem_huge (intended for experimentation only):
+
+Default 0; write 1 to set tmpfs mount option huge=1 on the kernel's
+internal shmem mount, to use huge pages transparently for SysV SHM,
+memfds, shared anonymous mmaps, GPU DRM objects, and ashmem.
+
+In addition to 0 and 1, it also accepts 2 to force the huge=1 option
+automatically on for all tmpfs mounts (intended for testing), or -1
+to force huge off for all (intended for safety if bugs appeared).
+
+/proc/meminfo, /sys/devices/system/node/nodeN/meminfo show:
+
+Shmem:             35016 kB   total shmem/tmpfs memory (subset of Cached)
+ShmemHugePages:    26624 kB   tmpfs hugepages completed (subset of Shmem)
+ShmemPmdMapped:    12288 kB   tmpfs hugepages with huge mappings in userspace
+ShmemFreeHoles:   671444 kB   reserved for team pages but available to shrinker
+
+/proc/vmstat, /proc/zoneinfo, /sys/devices/system/node/nodeN/vmstat show:
+
+nr_shmem 8754                 total shmem/tmpfs pages (subset of nr_file_pages)
+nr_shmem_hugepages 13         tmpfs hugepages completed (each 512 in nr_shmem)
+nr_shmem_pmdmapped 6          tmpfs hugepages with huge mappings in userspace
+nr_shmem_freeholes 167861     pages reserved for team but available to shrinker
+
 Author:
    Christoph Rohland <cr@sap.com>, 1.12.01
 Updated:
-   Hugh Dickins, 4 June 2007
+   Hugh Dickins, 4 June 2007, 3 Oct 2015
 Updated:
    KOSAKI Motohiro, 16 Mar 2010
diff -puN Documentation/sysctl/vm.txt~huge-tmpfs-huge=n-mount-option-and-proc-sys-vm-shmem_huge Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~huge-tmpfs-huge=n-mount-option-and-proc-sys-vm-shmem_huge
+++ a/Documentation/sysctl/vm.txt
@@ -56,6 +56,7 @@ Currently, these files are in /proc/sys/
 - page-cluster
 - panic_on_oom
 - percpu_pagelist_fraction
+- shmem_huge
 - stat_interval
 - stat_refresh
 - swappiness
@@ -748,6 +749,21 @@ sysctl, it will revert to this default b
 
 ==============================================================
 
+shmem_huge
+
+Default 0; write 1 to set tmpfs mount option huge=1 on the kernel's
+internal shmem mount, to use huge pages transparently for SysV SHM,
+memfds, shared anonymous mmaps, GPU DRM objects, and ashmem.
+
+In addition to 0 and 1, it also accepts 2 to force the huge=1 option
+automatically on for all tmpfs mounts (intended for testing), or -1
+to force huge off for all (intended for safety if bugs appeared).
+
+See Documentation/filesystems/tmpfs.txt for info on huge tmpfs.
+/proc/sys/vm/shmem_huge is intended for experimentation only.
+
+==============================================================
+
 stat_interval
 
 The time interval between which vm statistics are updated.  The default
diff -puN include/linux/shmem_fs.h~huge-tmpfs-huge=n-mount-option-and-proc-sys-vm-shmem_huge include/linux/shmem_fs.h
--- a/include/linux/shmem_fs.h~huge-tmpfs-huge=n-mount-option-and-proc-sys-vm-shmem_huge
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
 
@@ -69,18 +70,23 @@ static inline struct page *shmem_read_ma
 }
 
 #ifdef CONFIG_TMPFS
-
 extern int shmem_add_seals(struct file *file, unsigned int seals);
 extern int shmem_get_seals(struct file *file);
 extern long shmem_fcntl(struct file *file, unsigned int cmd, unsigned long arg);
-
 #else
-
 static inline long shmem_fcntl(struct file *f, unsigned int c, unsigned long a)
 {
 	return -EINVAL;
 }
+#endif /* CONFIG_TMPFS */
 
-#endif
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(CONFIG_SHMEM)
+# ifdef CONFIG_SYSCTL
+struct ctl_table;
+extern int shmem_huge, shmem_huge_min, shmem_huge_max;
+extern int shmem_huge_sysctl(struct ctl_table *table, int write,
+			     void __user *buffer, size_t *lenp, loff_t *ppos);
+# endif /* CONFIG_SYSCTL */
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE && CONFIG_SHMEM */
 
 #endif
diff -puN kernel/sysctl.c~huge-tmpfs-huge=n-mount-option-and-proc-sys-vm-shmem_huge kernel/sysctl.c
--- a/kernel/sysctl.c~huge-tmpfs-huge=n-mount-option-and-proc-sys-vm-shmem_huge
+++ a/kernel/sysctl.c
@@ -43,6 +43,7 @@
 #include <linux/ratelimit.h>
 #include <linux/compaction.h>
 #include <linux/hugetlb.h>
+#include <linux/shmem_fs.h>
 #include <linux/initrd.h>
 #include <linux/key.h>
 #include <linux/times.h>
@@ -1313,6 +1314,17 @@ static struct ctl_table vm_table[] = {
 		.extra1		= &zero,
 		.extra2		= &one_hundred,
 	},
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(CONFIG_SHMEM)
+	{
+		.procname	= "shmem_huge",
+		.data		= &shmem_huge,
+		.maxlen		= sizeof(shmem_huge),
+		.mode		= 0644,
+		.proc_handler	= shmem_huge_sysctl,
+		.extra1		= &shmem_huge_min,
+		.extra2		= &shmem_huge_max,
+	},
+#endif
 #ifdef CONFIG_HUGETLB_PAGE
 	{
 		.procname	= "nr_hugepages",
diff -puN mm/shmem.c~huge-tmpfs-huge=n-mount-option-and-proc-sys-vm-shmem_huge mm/shmem.c
--- a/mm/shmem.c~huge-tmpfs-huge=n-mount-option-and-proc-sys-vm-shmem_huge
+++ a/mm/shmem.c
@@ -58,6 +58,7 @@ static struct vfsmount *shm_mnt;
 #include <linux/falloc.h>
 #include <linux/splice.h>
 #include <linux/security.h>
+#include <linux/sysctl.h>
 #include <linux/swapops.h>
 #include <linux/mempolicy.h>
 #include <linux/namei.h>
@@ -289,6 +290,25 @@ static bool shmem_confirm_swap(struct ad
 }
 
 /*
+ * Definitions for "huge tmpfs": tmpfs mounted with the huge=1 option
+ */
+
+/* Special values for /proc/sys/vm/shmem_huge */
+#define SHMEM_HUGE_DENY		(-1)
+#define SHMEM_HUGE_FORCE	(2)
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+/* ifdef here to avoid bloating shmem.o when not necessary */
+
+int shmem_huge __read_mostly;
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
@@ -2857,11 +2877,21 @@ static int shmem_parse_options(char *opt
 			sbinfo->gid = make_kgid(current_user_ns(), gid);
 			if (!gid_valid(sbinfo->gid))
 				goto bad_val;
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+		} else if (!strcmp(this_char, "huge")) {
+			if (kstrtou8(value, 10, &sbinfo->huge) < 0 ||
+			    sbinfo->huge >= SHMEM_HUGE_FORCE)
+				goto bad_val;
+			if (sbinfo->huge && !has_transparent_hugepage())
+				goto bad_val;
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
@@ -2907,6 +2937,7 @@ static int shmem_remount_fs(struct super
 		goto out;
 
 	error = 0;
+	sbinfo->huge = config.huge;
 	sbinfo->max_blocks  = config.max_blocks;
 	sbinfo->max_inodes  = config.max_inodes;
 	sbinfo->free_inodes = config.max_inodes - inodes;
@@ -2940,6 +2971,9 @@ static int shmem_show_options(struct seq
 	if (!gid_eq(sbinfo->gid, GLOBAL_ROOT_GID))
 		seq_printf(seq, ",gid=%u",
 				from_kgid_munged(&init_user_ns, sbinfo->gid));
+	/* Rightly or wrongly, show huge mount option unmasked by shmem_huge */
+	if (sbinfo->huge)
+		seq_printf(seq, ",huge=%u", sbinfo->huge);
 	shmem_show_mpol(seq, sbinfo->mpol);
 	return 0;
 }
@@ -3278,6 +3312,13 @@ int __init shmem_init(void)
 		pr_err("Could not kern_mount tmpfs\n");
 		goto out1;
 	}
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	if (has_transparent_hugepage())
+		SHMEM_SB(shm_mnt->mnt_sb)->huge = (shmem_huge > 0);
+	else
+		shmem_huge = 0;	/* just in case it was patched */
+#endif
 	return 0;
 
 out1:
@@ -3289,6 +3330,31 @@ out3:
 	return error;
 }
 
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(CONFIG_SYSCTL)
+int shmem_huge_min = SHMEM_HUGE_DENY;
+int shmem_huge_max = SHMEM_HUGE_FORCE;
+/*
+ * /proc/sys/vm/shmem_huge sysctl for internal shm_mnt, and mount override:
+ * -1 disables huge on shm_mnt and all mounts, for emergency use
+ *  0 disables huge on internal shm_mnt (which has no way to be remounted)
+ *  1  enables huge on internal shm_mnt (which has no way to be remounted)
+ *  2  enables huge on shm_mnt and all mounts, w/o needing option, for testing
+ *     (but we may add more huge options, and push that 2 for testing upwards)
+ */
+int shmem_huge_sysctl(struct ctl_table *table, int write,
+		      void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	int err;
+
+	if (!has_transparent_hugepage())
+		shmem_huge_max = 0;
+	err = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+	if (write && !err && !IS_ERR(shm_mnt))
+		SHMEM_SB(shm_mnt->mnt_sb)->huge = (shmem_huge > 0);
+	return err;
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE && CONFIG_SYSCTL */
+
 #else /* !CONFIG_SHMEM */
 
 /*
_

Patches currently in -mm which might be from hughd@google.com are

huge-pagecache-mmap_sem-is-unlocked-when-truncation-splits-pmd.patch
mm-update_lru_size-warn-and-reset-bad-lru_size.patch
mm-update_lru_size-do-the-__mod_zone_page_state.patch
mm-use-__setpageswapbacked-and-dont-clearpageswapbacked.patch
tmpfs-preliminary-minor-tidyups.patch
mm-proc-sys-vm-stat_refresh-to-force-vmstat-update.patch
huge-mm-move_huge_pmd-does-not-need-new_vma.patch
huge-pagecache-extend-mremap-pmd-rmap-lockout-to-files.patch
arch-fix-has_transparent_hugepage.patch
huge-tmpfs-try-to-allocate-huge-pages-split-into-a-team.patch
huge-tmpfs-avoid-team-pages-in-a-few-places.patch
huge-tmpfs-shrinker-to-migrate-and-free-underused-holes.patch
huge-tmpfs-get_unmapped_area-align-fault-supply-huge-page.patch
huge-tmpfs-try_to_unmap_one-use-page_check_address_transhuge.patch
huge-tmpfs-avoid-premature-exposure-of-new-pagetable.patch
huge-tmpfs-map-shmem-by-huge-page-pmd-or-by-page-team-ptes.patch
huge-tmpfs-disband-split-huge-pmds-on-race-or-memory-failure.patch
huge-tmpfs-extend-get_user_pages_fast-to-shmem-pmd.patch
huge-tmpfs-use-unevictable-lru-with-variable-hpage_nr_pages.patch
huge-tmpfs-fix-mlocked-meminfo-track-huge-unhuge-mlocks.patch
huge-tmpfs-fix-mapped-meminfo-track-huge-unhuge-mappings.patch
huge-tmpfs-mem_cgroup-move-charge-on-shmem-huge-pages.patch
huge-tmpfs-proc-pid-smaps-show-shmemhugepages.patch
huge-tmpfs-recovery-framework-for-reconstituting-huge-pages.patch
huge-tmpfs-recovery-shmem_recovery_populate-to-fill-huge-page.patch
huge-tmpfs-recovery-shmem_recovery_remap-remap_team_by_pmd.patch
huge-tmpfs-recovery-shmem_recovery_swapin-to-read-from-swap.patch
huge-tmpfs-recovery-tweak-shmem_getpage_gfp-to-fill-team.patch
huge-tmpfs-recovery-debugfs-stats-to-complete-this-phase.patch
huge-tmpfs-recovery-page-migration-call-back-into-shmem.patch


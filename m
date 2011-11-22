From: akpm@linux-foundation.org
Subject: + thp-improve-the-error-code-path.patch added to -mm tree
Date: Tue, 22 Nov 2011 15:08:32 -0800
Message-ID: <201111222308.pAMN8cRM007811@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:54799 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab1KVXIm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2011 18:08:42 -0500
Received: by fabs1 with SMTP id s1so32794fab.1
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2011 15:08:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, aarcange@redhat.com, jweiner@redhat.com, minchan.kim@gmail.com, rientjes@google.com


The patch titled
     Subject: thp: improve the error code path
has been added to the -mm tree.  Its filename is
     thp-improve-the-error-code-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Shaohua Li <shaohua.li@intel.com>
Subject: thp: improve the error code path

Improve the error code path.  Delete unnecessary sysfs file for example. 
Also remove the #ifdef xxx to make code better.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   71 +++++++++++++++++++++++++++++++--------------
 1 file changed, 50 insertions(+), 21 deletions(-)

diff -puN mm/huge_memory.c~thp-improve-the-error-code-path mm/huge_memory.c
--- a/mm/huge_memory.c~thp-improve-the-error-code-path
+++ a/mm/huge_memory.c
@@ -487,41 +487,68 @@ static struct attribute_group khugepaged
 	.attrs = khugepaged_attr,
 	.name = "khugepaged",
 };
-#endif /* CONFIG_SYSFS */
 
-static int __init hugepage_init(void)
+static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
 {
 	int err;
-#ifdef CONFIG_SYSFS
-	static struct kobject *hugepage_kobj;
-#endif
-
-	err = -EINVAL;
-	if (!has_transparent_hugepage()) {
-		transparent_hugepage_flags = 0;
-		goto out;
-	}
 
-#ifdef CONFIG_SYSFS
-	err = -ENOMEM;
-	hugepage_kobj = kobject_create_and_add("transparent_hugepage", mm_kobj);
-	if (unlikely(!hugepage_kobj)) {
+	*hugepage_kobj = kobject_create_and_add("transparent_hugepage", mm_kobj);
+	if (unlikely(!*hugepage_kobj)) {
 		printk(KERN_ERR "hugepage: failed kobject create\n");
-		goto out;
+		return -ENOMEM;
 	}
 
-	err = sysfs_create_group(hugepage_kobj, &hugepage_attr_group);
+	err = sysfs_create_group(*hugepage_kobj, &hugepage_attr_group);
 	if (err) {
 		printk(KERN_ERR "hugepage: failed register hugeage group\n");
-		goto out;
+		goto delete_obj;
 	}
 
-	err = sysfs_create_group(hugepage_kobj, &khugepaged_attr_group);
+	err = sysfs_create_group(*hugepage_kobj, &khugepaged_attr_group);
 	if (err) {
 		printk(KERN_ERR "hugepage: failed register hugeage group\n");
-		goto out;
+		goto remove_hp_group;
+	}
+
+	return 0;
+
+remove_hp_group:
+	sysfs_remove_group(*hugepage_kobj, &hugepage_attr_group);
+delete_obj:
+	kobject_put(*hugepage_kobj);
+	return err;
+}
+
+static void __init hugepage_exit_sysfs(struct kobject *hugepage_kobj)
+{
+	sysfs_remove_group(hugepage_kobj, &khugepaged_attr_group);
+	sysfs_remove_group(hugepage_kobj, &hugepage_attr_group);
+	kobject_put(hugepage_kobj);
+}
+#else
+static inline int hugepage_init_sysfs(struct kobject **hugepage_kobj)
+{
+	return 0;
+}
+
+static inline void hugepage_exit_sysfs(struct kobject *hugepage_kobj)
+{
+}
+#endif /* CONFIG_SYSFS */
+
+static int __init hugepage_init(void)
+{
+	int err;
+	struct kobject *hugepage_kobj;
+
+	if (!has_transparent_hugepage()) {
+		transparent_hugepage_flags = 0;
+		return -EINVAL;
 	}
-#endif
+
+	err = hugepage_init_sysfs(&hugepage_kobj);
+	if (err)
+		return err;
 
 	err = khugepaged_slab_init();
 	if (err)
@@ -545,7 +572,9 @@ static int __init hugepage_init(void)
 
 	set_recommended_min_free_kbytes();
 
+	return 0;
 out:
+	hugepage_exit_sysfs(hugepage_kobj);
 	return err;
 }
 module_init(hugepage_init)
_
Subject: Subject: thp: improve the error code path

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
linux-next.patch
x86-tlb-flush-avoid-superflous-leave_mm.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
thp-improve-the-error-code-path.patch
thp-remove-unnecessary-tlb-flush-for-mprotect.patch
thp-add-tlb_remove_pmd_tlb_entry.patch
thp-improve-order-in-lru-list-for-split-huge-page.patch
intel_idle-fix-api-misuse.patch
intel_idle-disable-auto_demotion-for-hotplugged-cpus.patch


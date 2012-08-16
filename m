From: akpm@linux-foundation.org
Subject: + device_cgroup-introduce-dev_whitelist_clean.patch added to -mm tree
Date: Thu, 16 Aug 2012 13:11:02 -0700
Message-ID: <20120816201103.880C45C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:35192 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030304Ab2HPULG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Aug 2012 16:11:06 -0400
Received: by bkcjc3 with SMTP id jc3so150177bkc.1
        for <mm-commits@vger.kernel.org>; Thu, 16 Aug 2012 13:11:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aris@redhat.com, jmorris@namei.org, lizefan@huawei.com, serge.hallyn@canonical.com, tj@kernel.org, xemul@openvz.org


The patch titled
     Subject: device_cgroup: introduce dev_whitelist_clean()
has been added to the -mm tree.  Its filename is
     device_cgroup-introduce-dev_whitelist_clean.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Aristeu Rozanski <aris@redhat.com>
Subject: device_cgroup: introduce dev_whitelist_clean()

This function cleans all the items in a whitelist and will be used by the next
patches.

Signed-off-by: Aristeu Rozanski <aris@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: James Morris <jmorris@namei.org>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/device_cgroup.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff -puN security/device_cgroup.c~device_cgroup-introduce-dev_whitelist_clean security/device_cgroup.c
--- a/security/device_cgroup.c~device_cgroup-introduce-dev_whitelist_clean
+++ a/security/device_cgroup.c
@@ -154,6 +154,22 @@ remove:
 	}
 }
 
+/**
+ * dev_whitelist_clean - frees all entries of the whitelist
+ * @dev_cgroup: dev_cgroup with the whitelist to be cleaned
+ *
+ * called under devcgroup_mutex
+ */
+static void dev_whitelist_clean(struct dev_cgroup *dev_cgroup)
+{
+	struct dev_whitelist_item *wh, *tmp;
+
+	list_for_each_entry_safe(wh, tmp, &dev_cgroup->whitelist, list) {
+		list_del(&wh->list);
+		kfree(wh);
+	}
+}
+
 /*
  * called from kernel/cgroup.c with cgroup_lock() held.
  */
@@ -200,13 +216,9 @@ static struct cgroup_subsys_state *devcg
 static void devcgroup_destroy(struct cgroup *cgroup)
 {
 	struct dev_cgroup *dev_cgroup;
-	struct dev_whitelist_item *wh, *tmp;
 
 	dev_cgroup = cgroup_to_devcgroup(cgroup);
-	list_for_each_entry_safe(wh, tmp, &dev_cgroup->whitelist, list) {
-		list_del(&wh->list);
-		kfree(wh);
-	}
+	dev_whitelist_clean(dev_cgroup);
 	kfree(dev_cgroup);
 }
 
_

Patches currently in -mm which might be from aris@redhat.com are

linux-next.patch
x86-pat-remove-the-dependency-on-vm_pgoff-in-track-untrack-pfn-vma-routines.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn.patch
mm-x86-pat-rework-linear-pfn-mmap-tracking.patch
mm-introduce-arch-specific-vma-flag-vm_arch_1.patch
mm-kill-vma-flag-vm_insertpage.patch
mm-kill-vma-flag-vm_can_nonlinear.patch
mm-use-mm-exe_file-instead-of-first-vm_executable-vma-vm_file.patch
mm-kill-vma-flag-vm_executable-and-mm-num_exe_file_vmas.patch
mm-prepare-vm_dontdump-for-using-in-drivers.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter.patch
device_cgroup-add-deny_all-in-dev_cgroup-structure.patch
device_cgroup-introduce-dev_whitelist_clean.patch
device_cgroup-convert-device_cgroup-internally-to-policy-exceptions.patch
device_cgroup-rename-whitelist-to-exception-list.patch


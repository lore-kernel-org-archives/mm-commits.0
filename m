From: akpm@linux-foundation.org
Subject: [merged] device_cgroup-add-deny_all-in-dev_cgroup-structure.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:19:04 -0700
Message-ID: <20121005201904.C5171100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:61892 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757185Ab2JEUTG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:19:06 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so236985vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:19:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aris@redhat.com, jmorris@namei.org, lizefan@huawei.com, serge.hallyn@canonical.com, tj@kernel.org, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Subject: device_cgroup: add "deny_all" in dev_cgroup structure
has been removed from the -mm tree.  Its filename was
     device_cgroup-add-deny_all-in-dev_cgroup-structure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Aristeu Rozanski <aris@redhat.com>
Subject: device_cgroup: add "deny_all" in dev_cgroup structure

deny_all will determine if the default policy is to deny all device access
unless for the ones in the exception list.

This variable will be used in the next patches to convert device_cgroup
internally into a default policy + rules.

Signed-off-by: Aristeu Rozanski <aris@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: James Morris <jmorris@namei.org>
Cc: Pavel Emelyanov <xemul@openvz.org>
Acked-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/device_cgroup.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN security/device_cgroup.c~device_cgroup-add-deny_all-in-dev_cgroup-structure security/device_cgroup.c
--- a/security/device_cgroup.c~device_cgroup-add-deny_all-in-dev_cgroup-structure
+++ a/security/device_cgroup.c
@@ -42,6 +42,7 @@ struct dev_whitelist_item {
 struct dev_cgroup {
 	struct cgroup_subsys_state css;
 	struct list_head whitelist;
+	bool deny_all;
 };
 
 static inline struct dev_cgroup *css_to_devcgroup(struct cgroup_subsys_state *s)
@@ -178,12 +179,14 @@ static struct cgroup_subsys_state *devcg
 		wh->minor = wh->major = ~0;
 		wh->type = DEV_ALL;
 		wh->access = ACC_MASK;
+		dev_cgroup->deny_all = false;
 		list_add(&wh->list, &dev_cgroup->whitelist);
 	} else {
 		parent_dev_cgroup = cgroup_to_devcgroup(parent_cgroup);
 		mutex_lock(&devcgroup_mutex);
 		ret = dev_whitelist_copy(&dev_cgroup->whitelist,
 				&parent_dev_cgroup->whitelist);
+		dev_cgroup->deny_all = parent_dev_cgroup->deny_all;
 		mutex_unlock(&devcgroup_mutex);
 		if (ret) {
 			kfree(dev_cgroup);
@@ -409,9 +412,11 @@ handle:
 	case DEVCG_ALLOW:
 		if (!parent_has_perm(devcgroup, &wh))
 			return -EPERM;
+		devcgroup->deny_all = false;
 		return dev_whitelist_add(devcgroup, &wh);
 	case DEVCG_DENY:
 		dev_whitelist_rm(devcgroup, &wh);
+		devcgroup->deny_all = true;
 		break;
 	default:
 		return -EINVAL;
_

Patches currently in -mm which might be from aris@redhat.com are

origin.patch
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


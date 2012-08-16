From: akpm@linux-foundation.org
Subject: + device_cgroup-add-deny_all-in-dev_cgroup-structure.patch added to -mm tree
Date: Thu, 16 Aug 2012 13:10:59 -0700
Message-ID: <20120816201100.6401B100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:50068 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030304Ab2HPULB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Aug 2012 16:11:01 -0400
Received: by obbwc20 with SMTP id wc20so2205660obb.1
        for <mm-commits@vger.kernel.org>; Thu, 16 Aug 2012 13:11:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aris@redhat.com, jmorris@namei.org, lizefan@huawei.com, serge.hallyn@canonical.com, tj@kernel.org, xemul@openvz.org


The patch titled
     Subject: device_cgroup: add "deny_all" in dev_cgroup structure
has been added to the -mm tree.  Its filename is
     device_cgroup-add-deny_all-in-dev_cgroup-structure.patch

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
Cc: Serge Hallyn <serge.hallyn@canonical.com>
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


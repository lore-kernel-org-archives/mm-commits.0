From: akpm@linux-foundation.org
Subject: + cgroups-include-hierarchy-ids-in-proc-pid-cgroup.patch added to -mm tree
Date: Tue, 08 Apr 2008 17:18:50 -0700
Message-ID: <200804090018.m390Ioio018327@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46551 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750942AbYDIATW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2008 20:19:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, xemul@openvz.org


The patch titled
     cgroups: include hierarchy ids in /proc/<pid>/cgroup
has been added to the -mm tree.  Its filename is
     cgroups-include-hierarchy-ids-in-proc-pid-cgroup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: include hierarchy ids in /proc/<pid>/cgroup
From: Paul Menage <menage@google.com>

Extend the /proc/<pid>/cgroup file to include the appropriate hierarchy ID on
each line.

Currently this ID isn't really needed since a hierarchy can be completely
identified by the set of subsystems bound to it, but this is likely to change
in the near future in order to support stateless subsystems and
merging/rebinding of subsystems.  Getting this change into 2.6.25 reduces the
need for an API change later.

Signed-off-by: Paul Menage <menage@google.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/cgroup.c~cgroups-include-hierarchy-ids-in-proc-pid-cgroup kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-include-hierarchy-ids-in-proc-pid-cgroup
+++ a/kernel/cgroup.c
@@ -2569,6 +2569,7 @@ static int proc_cgroup_show(struct seq_f
 		/* Skip this hierarchy if it has no active subsystems */
 		if (!root->actual_subsys_bits)
 			continue;
+		seq_printf(m, "%lu:", root->subsys_bits);
 		for_each_subsys(root, ss)
 			seq_printf(m, "%s%s", count++ ? "," : "", ss->name);
 		seq_putc(m, ':');
_

Patches currently in -mm which might be from menage@google.com are

origin.patch
cgroups-include-hierarchy-ids-in-proc-pid-cgroup.patch
make-cgroup_enable_task_cg_lists-static.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch
cgroup-api-files-add-res_counter_read_u64.patch
cgroup-api-files-use-read_u64-in-memory-controller.patch
cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroup-api-files-add-cgroup-map-data-type.patch
cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch
cgroup-api-files-drop-mem_cgroup_force_empty.patch
cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch
cgroup-api-files-make-cgroup_debug-default-to-off.patch
cgroups-_s64-files-add-cgroups-read_s64-write_s64-file-methods.patch
cgroups-_s64-files-use-read_s64-write_s64-in-cfs-cgroup-for-rt_runtime-file.patch
cgroup-annotate-cgroup_init_subsys-with-__init.patch
cgroup-switch-to-proc_create.patch
cgroups-add-the-trigger-callback-to-struct-cftype.patch
cgroups-implement-device-whitelist-v6.patch
cgroups-implement-device-whitelist-v6-checkpatch-fixes.patch
cgroups-implement-device-whitelist-v6-cleanups.patch
cgroups-implement-device-whitelist-doc.patch
cgroups-implement-device-whitelist-v6-fix.patch
cgroups-use-a-hash-table-for-css_set-finding.patch
cgroups-simplify-init_subsys.patch
cgroups-remove-the-css_set-linked-list.patch
cgroups-introduce-cft-read_seq-v2.patch
memcgroup-move-memory-controller-allocations-to-their-own-slabs.patch
memcgroup-use-triggers-in-force_empty-and-max_usage-files.patch
memcgroup-implement-failcounter-reset.patch
memcgroup-implement-failcounter-reset-checkpatch-fixes.patch
memcgroup-make-the-memory-controller-more-desktop-responsive.patch
cpuset-hardwall-flag-switch-cpusets-to-use-the-bulk-cgroup_add_files-api.patch
cpuset-hardwall-flag-add-a-mem_hardwall-flag-to-cpusets.patch
add-a-refcount-check-in-dput.patch


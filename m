From: akpm@linux-foundation.org
Subject: +
 fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch added to -mm tree
Date: Wed, 19 Feb 2014 13:40:48 -0800
Message-ID: <530524e0.NgKMTcbE7GgzZFmd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33422 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422AbaBSVkt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Feb 2014 16:40:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, davej@redhat.com, davej@fedoraproject.org, akinobu.mita@gmail.com, akpm@linux-foundation.org

Subject: + fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch added to -mm tree
To: akpm@linux-foundation.org,akinobu.mita@gmail.com,davej@fedoraproject.org,davej@redhat.com,rientjes@google.com
From: akpm@linux-foundation.org
Date: Wed, 19 Feb 2014 13:40:48 -0800


The patch titled
     Subject: fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix
has been added to the -mm tree.  Its filename is
     fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix

don't make make_it_fail unsigned

Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Dave Jones <davej@fedoraproject.org>
Cc: Dave Jones <davej@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/proc/base.c~fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix fs/proc/base.c
--- a/fs/proc/base.c~fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix
+++ a/fs/proc/base.c
@@ -1207,7 +1207,7 @@ static ssize_t proc_fault_inject_read(st
 	struct task_struct *task = get_proc_task(file_inode(file));
 	char buffer[PROC_NUMBUF];
 	size_t len;
-	unsigned int make_it_fail;
+	int make_it_fail;
 
 	if (!task)
 		return -ESRCH;
@@ -1224,7 +1224,7 @@ static ssize_t proc_fault_inject_write(s
 {
 	struct task_struct *task;
 	char buffer[PROC_NUMBUF], *end;
-	unsigned int make_it_fail;
+	int make_it_fail;
 
 	if (!capable(CAP_SYS_RESOURCE))
 		return -EPERM;
@@ -1236,7 +1236,7 @@ static ssize_t proc_fault_inject_write(s
 	make_it_fail = simple_strtol(strstrip(buffer), &end, 0);
 	if (*end)
 		return -EINVAL;
-	if (make_it_fail > 1)
+	if (make_it_fail < 0 || make_it_fail > 1)
 		return -EINVAL;
 
 	task = get_proc_task(file_inode(file));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
drop_caches-add-some-documentation-and-info-message.patch
mmnuma-reorganize-change_pmd_range-fix.patch
include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
kernel-groupsc-remove-return-value-of-set_groups-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch
initramfs-debug-detected-compression-method-fix.patch
linux-next.patch
linux-next-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


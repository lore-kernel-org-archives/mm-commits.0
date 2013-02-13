From: akpm@linux-foundation.org
Subject: [merged] kernel-pidc-reenable-interrupts-when-alloc_pid-fails-because-init-has-exited.patch removed from -mm tree
Date: Wed, 13 Feb 2013 12:36:04 -0800
Message-ID: <20130213203604.C5AF65A41B5@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:42616 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934138Ab3BMUgG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Feb 2013 15:36:06 -0500
Received: by mail-qe0-f74.google.com with SMTP id a11so165004qen.5
        for <mm-commits@vger.kernel.org>; Wed, 13 Feb 2013 12:36:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, jwboyer@redhat.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/pid.c: reenable interrupts when alloc_pid() fails because init has exited
has been removed from the -mm tree.  Its filename was
     kernel-pidc-reenable-interrupts-when-alloc_pid-fails-because-init-has-exited.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: kernel/pid.c: reenable interrupts when alloc_pid() fails because init has exited

We're forgetting to reenable local interrupts on an error path.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Reported-by: Josh Boyer <jwboyer@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/pid.c~kernel-pidc-reenable-interrupts-when-alloc_pid-fails-because-init-has-exited kernel/pid.c
--- a/kernel/pid.c~kernel-pidc-reenable-interrupts-when-alloc_pid-fails-because-init-has-exited
+++ a/kernel/pid.c
@@ -331,7 +331,7 @@ out:
 	return pid;
 
 out_unlock:
-	spin_unlock(&pidmap_lock);
+	spin_unlock_irq(&pidmap_lock);
 out_free:
 	while (++i <= ns->level)
 		free_pidmap(pid->numbers + i);
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
linux-next.patch
nsproxy-remove-duplicate-task_cred_xxx-for-user_ns.patch
signal-allow-to-send-any-siginfo-to-itself.patch
coredump-remove-redundant-defines-for-dumpable-states.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix-fix.patch
kexec-add-the-values-related-to-buddy-system-for-filtering-free-pages.patch
kexec-get-rid-of-duplicate-check-for-hole_end.patch
kexec-export-pg_hwpoison-flag-into-vmcoreinfo.patch
ipc-convert-to-idr_alloc.patch
ipc-convert-to-idr_alloc-fix.patch
sysctl-fix-null-checking-in-bin_dn_node_address.patch
sysctl-put-get-get_uts-into-config_proc_sysctl-code-block.patch
namespaces-utsname-fix-wrong-comment-about-clone_uts_ns.patch


From: akpm@linux-foundation.org
Subject: + kernel-pidc-reenable-interrupts-when-alloc_pid-fails-because-init-has-exited.patch added to -mm tree
Date: Mon, 11 Feb 2013 15:54:15 -0800
Message-ID: <20130211235415.B03AD5A4242__31115.2856717401$1360626888$gmane$org@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:42422 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760104Ab3BKXyR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Feb 2013 18:54:17 -0500
Received: by mail-ie0-f202.google.com with SMTP id k14so1223821iea.5
        for <mm-commits@vger.kernel.org>; Mon, 11 Feb 2013 15:54:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, jwboyer@redhat.com, stable@vger.kernel.org


The patch titled
     Subject: kernel/pid.c: reenable interrupts when alloc_pid() fails because init has exited
has been added to the -mm tree.  Its filename is
     kernel-pidc-reenable-interrupts-when-alloc_pid-fails-because-init-has-exited.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kernel-pidc-reenable-interrupts-when-alloc_pid-fails-because-init-has-exited.patch
linux-next.patch
nsproxy-remove-duplicate-task_cred_xxx-for-user_ns.patch
signal-allow-to-send-any-siginfo-to-itself.patch
coredump-remove-redundant-defines-for-dumpable-states.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix-fix.patch
kexec-add-the-values-related-to-buddy-system-for-filtering-free-pages.patch
kexec-get-rid-of-duplicate-check-for-hole_end.patch
ipc-convert-to-idr_alloc.patch
ipc-convert-to-idr_alloc-fix.patch
sysctl-fix-null-checking-in-bin_dn_node_address.patch
sysctl-put-get-get_uts-into-config_proc_sysctl-code-block.patch
namespaces-utsname-fix-wrong-comment-about-clone_uts_ns.patch


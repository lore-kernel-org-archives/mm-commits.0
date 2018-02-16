From: akpm@linux-foundation.org
Subject: + proc-move-proc-sysvipc-creation-to-where-it-belongs.patch added to -mm tree
Date: Fri, 16 Feb 2018 12:34:14 -0800
Message-ID: <5a874046.PWiviAj6InIwwX6F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46558 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750819AbeBPUeP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Feb 2018 15:34:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, dave@stgolabs.net, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: move /proc/sysvipc creation to where it belongs
has been added to the -mm tree.  Its filename is
     proc-move-proc-sysvipc-creation-to-where-it-belongs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-move-proc-sysvipc-creation-to-where-it-belongs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-move-proc-sysvipc-creation-to-where-it-belongs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: move /proc/sysvipc creation to where it belongs

Link: http://lkml.kernel.org/r/20180216161732.GA10297@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/root.c |    4 ----
 ipc/util.c     |    1 +
 2 files changed, 1 insertion(+), 4 deletions(-)

diff -puN fs/proc/root.c~proc-move-proc-sysvipc-creation-to-where-it-belongs fs/proc/root.c
--- a/fs/proc/root.c~proc-move-proc-sysvipc-creation-to-where-it-belongs
+++ a/fs/proc/root.c
@@ -136,10 +136,6 @@ void __init proc_root_init(void)
 	proc_symlink("mounts", NULL, "self/mounts");
 
 	proc_net_init();
-
-#ifdef CONFIG_SYSVIPC
-	proc_mkdir("sysvipc", NULL);
-#endif
 	proc_mkdir("fs", NULL);
 	proc_mkdir("driver", NULL);
 	proc_create_mount_point("fs/nfsd"); /* somewhere for the nfsd filesystem to be mounted */
diff -puN ipc/util.c~proc-move-proc-sysvipc-creation-to-where-it-belongs ipc/util.c
--- a/ipc/util.c~proc-move-proc-sysvipc-creation-to-where-it-belongs
+++ a/ipc/util.c
@@ -89,6 +89,7 @@ static int __init ipc_init(void)
 {
 	int err_sem, err_msg;
 
+	proc_mkdir("sysvipc", NULL);
 	err_sem = sem_init();
 	WARN(err_sem, "ipc: sysv sem_init failed: %d\n", err_sem);
 	err_msg = msg_init();
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-do-less-stuff-under-pde_unload_lock.patch
proc-move-proc-sysvipc-creation-to-where-it-belongs.patch
seq_file-delete-small-value-optimization.patch


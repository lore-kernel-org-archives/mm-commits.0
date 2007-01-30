From: akpm@osdl.org
Subject: + sysctl-move-sysv-ipc-sysctls-to-their-own-file-fix-2.patch added to -mm tree
Date: Mon, 29 Jan 2007 22:35:52 -0800
Message-ID: <200701300635.l0U6Zqfc011163@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45098 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933122AbXA3Gf4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 01:35:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gcoady.lk@gmail.com, ebiederm@xmission.com


The patch titled
     typo in ipc/ipc_sysctl.c -> compile failure
has been added to the -mm tree.  Its filename is
     sysctl-move-sysv-ipc-sysctls-to-their-own-file-fix-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: typo in ipc/ipc_sysctl.c -> compile failure
From: Grant Coady <gcoady.lk@gmail.com>

Fix typos causing compile failure when CONFIG_PROC_FS not set in
ipc/ipc_sysctl.c, compile tested.

ipc/ipc_sysctl.c:107: error: `proc_ipc_doulongvec_minmax' undeclared here (not in a function)
ipc/ipc_sysctl.c:107: error: initializer element is not constant
[...]
ipc/ipc_sysctl.c:164: error: (near initialization for `ipc_kern_table[7]')
make[1]: *** [ipc/ipc_sysctl.o] Error 1
make: *** [ipc] Error 2

Also applies cleanly to 2.6.20-rc6-mm3.

Signed-off-by: Grant Coady <gcoady.lk@gmail.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 ipc/ipc_sysctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN ipc/ipc_sysctl.c~sysctl-move-sysv-ipc-sysctls-to-their-own-file-fix-2 ipc/ipc_sysctl.c
--- a/ipc/ipc_sysctl.c~sysctl-move-sysv-ipc-sysctls-to-their-own-file-fix-2
+++ a/ipc/ipc_sysctl.c
@@ -50,8 +50,8 @@ static int proc_ipc_doulongvec_minmax(ct
 }
 
 #else
-#define proc_ipc_do_ulongvec_minmax NULL
-#define proc_ipc_do_intvec	    NULL
+#define proc_ipc_doulongvec_minmax NULL
+#define proc_ipc_dointvec	   NULL
 #endif
 
 #ifdef CONFIG_SYSCTL_SYSCALL
_

Patches currently in -mm which might be from gcoady.lk@gmail.com are

sysctl-move-sysv-ipc-sysctls-to-their-own-file-fix-2.patch

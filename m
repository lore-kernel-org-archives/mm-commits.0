From: akpm@linux-foundation.org
Subject: [folded-merged]
 ipc-consolidate-all-xxxctl_down-functions-fix.patch removed from -mm tree
Date: Mon, 03 Feb 2020 17:05:54 -0800
Message-ID: <20200204010554.wc64BwcG7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726872AbgBDBFz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Feb 2020 20:05:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, natechancellor@gmail.com


The patch titled
     Subject: ipc/msg.c: Adjust indentation in ksys_msgctl
has been removed from the -mm tree.  Its filename was
     ipc-consolidate-all-xxxctl_down-functions-fix.patch

This patch was dropped because it was folded into ipc-consolidate-all-xxxctl_down-functions.patch

------------------------------------------------------
From: Nathan Chancellor <natechancellor@gmail.com>
Subject: ipc/msg.c: Adjust indentation in ksys_msgctl

Clang warns:

../ipc/msg.c:621:4: warning: misleading indentation; statement is not
part of the previous 'if' [-Wmisleading-indentation]
                 return msgctl_down(ns, msqid, cmd, &msqid64.msg_perm,
msqid64.msg_qbytes);
                 ^
../ipc/msg.c:619:3: note: previous statement is here
                if (copy_msqid_from_user(&msqid64, buf, version))
                ^
1 warning generated.

This warning occurs because there is a space after the tab on this line.
Remove it so that the indentation is consistent with the Linux kernel
coding style and clang no longer warns.

Link: https://github.com/ClangBuiltLinux/linux/issues/829
Link: http://lkml.kernel.org/r/20191218032932.37479-1-natechancellor@gmail.com
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/ipc/msg.c~ipc-consolidate-all-xxxctl_down-functions-fix
+++ a/ipc/msg.c
@@ -618,7 +618,8 @@ static long ksys_msgctl(int msqid, int c
 	case IPC_SET:
 		if (copy_msqid_from_user(&msqid64, buf, version))
 			return -EFAULT;
-		 return msgctl_down(ns, msqid, cmd, &msqid64.msg_perm, msqid64.msg_qbytes);
+		return msgctl_down(ns, msqid, cmd, &msqid64.msg_perm,
+				   msqid64.msg_qbytes);
 	case IPC_RMID:
 		return msgctl_down(ns, msqid, cmd, NULL, 0);
 	default:
_

Patches currently in -mm which might be from natechancellor@gmail.com are

ipc-consolidate-all-xxxctl_down-functions.patch

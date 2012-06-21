From: akpm@linux-foundation.org
Subject: [merged] c-r-prctl-move-pr_get_tid_address-to-a-proper-place.patch removed from -mm tree
Date: Thu, 21 Jun 2012 12:25:46 -0700
Message-ID: <20120621192546.6CBF2A00B0@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:43415 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760120Ab2FUTZr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 15:25:47 -0400
Received: by mail-vb0-f74.google.com with SMTP id l22so95172vbn.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 12:25:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, avagin@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, keescook@chromium.org, oleg@redhat.com, serge.hallyn@canonical.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: c/r: prctl: Move PR_GET_TID_ADDRESS to a proper place
has been removed from the -mm tree.  Its filename was
     c-r-prctl-move-pr_get_tid_address-to-a-proper-place.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: c/r: prctl: Move PR_GET_TID_ADDRESS to a proper place

During merging of PR_GET_TID_ADDRESS patch the code has been misplaced (it
happened to appear under PR_MCE_KILL) in result noone can use this option.

Fix it by moving code snippet to a proper place.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/sys.c~c-r-prctl-move-pr_get_tid_address-to-a-proper-place kernel/sys.c
--- a/kernel/sys.c~c-r-prctl-move-pr_get_tid_address-to-a-proper-place
+++ a/kernel/sys.c
@@ -2127,9 +2127,6 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 				else
 					return -EINVAL;
 				break;
-		case PR_GET_TID_ADDRESS:
-			error = prctl_get_tid_address(me, (int __user **)arg2);
-			break;
 			default:
 				return -EINVAL;
 			}
@@ -2147,6 +2144,9 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 		case PR_SET_MM:
 			error = prctl_set_mm(arg2, arg3, arg4, arg5);
 			break;
+		case PR_GET_TID_ADDRESS:
+			error = prctl_get_tid_address(me, (int __user **)arg2);
+			break;
 		case PR_SET_CHILD_SUBREAPER:
 			me->signal->is_child_subreaper = !!arg2;
 			error = 0;
_

Patches currently in -mm which might be from gorcunov@openvz.org are

origin.patch
linux-next.patch
c-r-prctl-less-paranoid-prctl_set_mm_exe_file.patch
c-r-fcntl-add-f_getowner_uids-option.patch


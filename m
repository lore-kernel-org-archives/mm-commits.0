From: akpm@linux-foundation.org
Subject: + c-r-prctl-move-pr_get_tid_address-to-a-proper-place.patch added to -mm tree
Date: Mon, 18 Jun 2012 14:12:39 -0700
Message-ID: <20120618211241.1078AA0395@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:49253 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab2FRVMm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Jun 2012 17:12:42 -0400
Received: by ghbz15 with SMTP id z15so480643ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 18 Jun 2012 14:12:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, avagin@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, keescook@chromium.org, oleg@redhat.com, serge.hallyn@canonical.com, xemul@parallels.com


The patch titled
     Subject: c/r: prctl: Move PR_GET_TID_ADDRESS to a proper place
has been added to the -mm tree.  Its filename is
     c-r-prctl-move-pr_get_tid_address-to-a-proper-place.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: c/r: prctl: Move PR_GET_TID_ADDRESS to a proper place

Patches currently in -mm which might be from gorcunov@openvz.org are

linux-next.patch
c-r-prctl-move-pr_get_tid_address-to-a-proper-place.patch
c-r-fcntl-add-f_getowner_uids-option.patch


From: akpm@linux-foundation.org
Subject: + kernel-exitc-fix-shadows-sparse-warning.patch added to -mm tree
Date: Wed, 27 Jan 2010 14:25:36 -0800
Message-ID: <201001272225.o0RMPaNi003378@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58912 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754449Ab0A0WZi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jan 2010 17:25:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tfransosi@gmail.com


The patch titled
     kernel/exit.c: fix shadows sparse warning
has been added to the -mm tree.  Its filename is
     kernel-exitc-fix-shadows-sparse-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/exit.c: fix shadows sparse warning
From: Thiago Farina <tfransosi@gmail.com>

kernel/exit.c:1183:26: warning: symbol 'status' shadows an earlier one
kernel/exit.c:1173:21: originally declared here

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/exit.c~kernel-exitc-fix-shadows-sparse-warning kernel/exit.c
--- a/kernel/exit.c~kernel-exitc-fix-shadows-sparse-warning
+++ a/kernel/exit.c
@@ -1181,7 +1181,7 @@ static int wait_task_zombie(struct wait_
 
 	if (unlikely(wo->wo_flags & WNOWAIT)) {
 		int exit_code = p->exit_code;
-		int why, status;
+		int why;
 
 		get_task_struct(p);
 		read_unlock(&tasklist_lock);
_

Patches currently in -mm which might be from tfransosi@gmail.com are

linux-next.patch
kernel-exitc-fix-shadows-sparse-warning.patch
console-vgaconc-mark-file-local-symbol-static.patch


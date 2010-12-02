From: akpm@linux-foundation.org
Subject: + do_exit-make-sure-we-run-with-get_fs-==-user_ds.patch added to -mm tree
Date: Wed, 01 Dec 2010 16:30:09 -0800
Message-ID: <201012020030.oB20U96k020833@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49491 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754725Ab0LBAaQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Dec 2010 19:30:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nelhage@ksplice.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     do_exit(): make sure that we run with get_fs() == USER_DS.
has been added to the -mm tree.  Its filename is
     do_exit-make-sure-we-run-with-get_fs-==-user_ds.patch

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
Subject: do_exit(): make sure that we run with get_fs() == USER_DS.
From: Nelson Elhage <nelhage@ksplice.com>

If a user manages to trigger an oops with fs set to KERNEL_DS, fs is not
otherwise reset before do_exit().  do_exit may later (via mm_release in
fork.c) do a put_user to a user-controlled address, potentially allowing a
user to leverage an oops into a controlled write into kernel memory.

A more logical place to put this might be when we know an oops has
occurred, before we call do_exit(), but that would involve changing every
architecture, in multiple places.  Let's just stick it in do_exit instead.

Signed-off-by: Nelson Elhage <nelhage@ksplice.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN kernel/exit.c~do_exit-make-sure-we-run-with-get_fs-==-user_ds kernel/exit.c
--- a/kernel/exit.c~do_exit-make-sure-we-run-with-get_fs-==-user_ds
+++ a/kernel/exit.c
@@ -914,6 +914,14 @@ NORET_TYPE void do_exit(long code)
 	if (unlikely(!tsk->pid))
 		panic("Attempted to kill the idle task!");
 
+	/*
+	 * If do_exit is called because this processes oopsed, it's possible
+	 * that get_fs() was left as KERNEL_DS, so reset it to USER_DS before
+	 * continuing. This is relevant at least for clearing clear_child_tid in
+	 * mm_release.
+	 */
+	set_fs(USER_DS);
+
 	tracehook_report_exit(&code);
 
 	validate_creds_for_do_exit(tsk);
_

Patches currently in -mm which might be from nelhage@ksplice.com are

do_exit-make-sure-we-run-with-get_fs-==-user_ds.patch
do_exit-make-sure-we-run-with-get_fs-==-user_ds-fix.patch


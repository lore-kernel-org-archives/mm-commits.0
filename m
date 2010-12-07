From: akpm@linux-foundation.org
Subject: [merged] do_exit-make-sure-we-run-with-get_fs-==-user_ds.patch removed from -mm tree
Date: Tue, 07 Dec 2010 11:46:53 -0800
Message-ID: <201012071948.oB7JmSjS004614@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753200Ab0LGTsf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Dec 2010 14:48:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nelhage@ksplice.com, kosaki.motohiro@jp.fujitsu.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     do_exit(): make sure that we run with get_fs() == USER_DS
has been removed from the -mm tree.  Its filename was
     do_exit-make-sure-we-run-with-get_fs-==-user_ds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: do_exit(): make sure that we run with get_fs() == USER_DS
From: Nelson Elhage <nelhage@ksplice.com>

If a user manages to trigger an oops with fs set to KERNEL_DS, fs is not
otherwise reset before do_exit().  do_exit may later (via mm_release in
fork.c) do a put_user to a user-controlled address, potentially allowing a
user to leverage an oops into a controlled write into kernel memory.

This is only triggerable in the presence of another bug, but this
potentially turns a lot of DoS bugs into privilege escalations, so it's
worth fixing.  I have proof-of-concept code which uses this bug along with
CVE-2010-3849 to write a zero to an arbitrary kernel address, so I've
tested that this is not theoretical.


A more logical place to put this fix might be when we know an oops has
occurred, before we call do_exit(), but that would involve changing every
architecture, in multiple places.  Let's just stick it in do_exit instead.

[akpm@linux-foundation.org: update code comment]
Signed-off-by: Nelson Elhage <nelhage@ksplice.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN kernel/exit.c~do_exit-make-sure-we-run-with-get_fs-==-user_ds kernel/exit.c
--- a/kernel/exit.c~do_exit-make-sure-we-run-with-get_fs-==-user_ds
+++ a/kernel/exit.c
@@ -914,6 +914,15 @@ NORET_TYPE void do_exit(long code)
 	if (unlikely(!tsk->pid))
 		panic("Attempted to kill the idle task!");
 
+	/*
+	 * If do_exit is called because this processes oopsed, it's possible
+	 * that get_fs() was left as KERNEL_DS, so reset it to USER_DS before
+	 * continuing. Amongst other possible reasons, this is to prevent
+	 * mm_release()->clear_child_tid() from writing to a user-controlled
+	 * kernel address.
+	 */
+	set_fs(USER_DS);
+
 	tracehook_report_exit(&code);
 
 	validate_creds_for_do_exit(tsk);
_

Patches currently in -mm which might be from nelhage@ksplice.com are



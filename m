From: akpm@linux-foundation.org
Subject: + kill-unused-sesssion-and-group-values-in-rocket-driver.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:54:46 -0800
Message-ID: <200703151854.l2FIsmC4023470@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36231 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932562AbXCOS6I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 14:58:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sukadev@us.ibm.com, clg@fr.ibm.com, containers@lists.osdl.org, ebiederm@xmission.com, haveblue@us.ibm.com, serue@us.ibm.com


The patch titled
     Kill unused sesssion and group values in rocket driver
has been added to the -mm tree.  Its filename is
     kill-unused-sesssion-and-group-values-in-rocket-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Kill unused sesssion and group values in rocket driver
From: Sukadev Bhattiprolu <sukadev@us.ibm.com>

The process_session() and process_group() values are not really used by the
driver.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: <containers@lists.osdl.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rocket.c     |    3 ---
 drivers/char/rocket_int.h |    2 --
 2 files changed, 5 deletions(-)

diff -puN drivers/char/rocket.c~kill-unused-sesssion-and-group-values-in-rocket-driver drivers/char/rocket.c
--- a/drivers/char/rocket.c~kill-unused-sesssion-and-group-values-in-rocket-driver
+++ a/drivers/char/rocket.c
@@ -1014,9 +1014,6 @@ static int rp_open(struct tty_struct *tt
 	/*
 	 * Info->count is now 1; so it's safe to sleep now.
 	 */
-	info->session = process_session(current);
-	info->pgrp = process_group(current);
-
 	if ((info->flags & ROCKET_INITIALIZED) == 0) {
 		cp = &info->channel;
 		sSetRxTrigger(cp, TRIG_1);
diff -puN drivers/char/rocket_int.h~kill-unused-sesssion-and-group-values-in-rocket-driver drivers/char/rocket_int.h
--- a/drivers/char/rocket_int.h~kill-unused-sesssion-and-group-values-in-rocket-driver
+++ a/drivers/char/rocket_int.h
@@ -1156,8 +1156,6 @@ struct r_port {
 	int xmit_head;
 	int xmit_tail;
 	int xmit_cnt;
-	int session;
-	int pgrp;
 	int cd_status;
 	int ignore_status_mask;
 	int read_status_mask;
_

Patches currently in -mm which might be from sukadev@us.ibm.com are

attach_pid-with-struct-pid-parameter.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-and-sid-of-init-process.patch
use-struct-pid-parameter-in-copy_process.patch
remove-the-likelypid-check-in-copy_process.patch
use-task_pgrp-task_session-in-copy_process.patch
kill-unused-sesssion-and-group-values-in-rocket-driver.patch
fix-some-coding-style-errors-in-autofs.patch
replace-pid_t-in-autofs-with-struct-pid-reference.patch

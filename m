From: akpm@linux-foundation.org
Subject: - kill-unused-sesssion-and-group-values-in-rocket-driver.patch removed from -mm tree
Date: Fri, 11 May 2007 22:34:41 -0700
Message-ID: <200705120534.l4C5YfK1002220@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750930AbXELFe5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:34:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sukadev@us.ibm.com, clg@fr.ibm.com, containers@lists.osdl.org, ebiederm@xmission.com, haveblue@us.ibm.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Kill unused sesssion and group values in rocket driver
has been removed from the -mm tree.  Its filename was
     kill-unused-sesssion-and-group-values-in-rocket-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1158,8 +1158,6 @@ struct r_port {
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

origin.patch

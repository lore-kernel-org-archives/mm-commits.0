From: akpm@linux-foundation.org
Subject: [merged] init-fix-bug-where-environment-vars-cant-be-passed-via-boot-args.patch removed from -mm tree
Date: Fri, 20 Apr 2012 11:57:15 -0700
Message-ID: <20120420185715.EAFCEA035C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:59929 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948Ab2DTS5S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Apr 2012 14:57:18 -0400
Received: by faaa19 with SMTP id a19so53262faa.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Apr 2012 11:57:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cmetcalf@tilera.com, mm-commits@vger.kernel.org


The patch titled
     Subject: init: fix bug where environment vars can't be passed via boot args
has been removed from the -mm tree.  Its filename was
     init-fix-bug-where-environment-vars-cant-be-passed-via-boot-args.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Return-Path: <cmetcalf@tilera.com>
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on z
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=7.0 tests=BAYES_00 autolearn=ham
	version=3.3.1
Received: from localhost (localhost [127.0.0.1])
	by localhost.localdomain (8.14.3/8.14.3) with ESMTP id q36HCQvS022542
	for <akpm@localhost>; Fri, 6 Apr 2012 10:12:26 -0700
X-Original-To: akpm@linux-foundation.org
Delivered-To: akpm@mail.linuxfoundation.org
Received: from mail.linuxfoundation.org [140.211.169.12]
	by localhost with IMAP (fetchmail-6.3.11)
	for <akpm@localhost> (single-drop); Fri, 06 Apr 2012 10:12:26 -0700 (PDT)
Received: from smtp1.linuxfoundation.org (smtp1.linux-foundation.org [172.17.192.35])
	by mail.linuxfoundation.org (Postfix) with ESMTP id 3A77D276
	for <akpm@linux-foundation.org>; Fri,  6 Apr 2012 17:11:57 +0000 (UTC)
X-Greylist: from auto-whitelisted by SQLgrey-1.7.6
Received: from mail-pz0-f43.google.com (mail-pz0-f43.google.com [209.85.210.43])
	by smtp1.linuxfoundation.org (Postfix) with ESMTPS id 97D9D2004E
	for <akpm@linux-foundation.org>; Fri,  6 Apr 2012 17:11:56 +0000 (UTC)
Received: by dadn15 with SMTP id n15sf3535704dad.2
        for <akpm@linux-foundation.org>; Fri, 06 Apr 2012 10:11:56 -0700 (PDT)
Received: by 10.68.189.166 with SMTP id gj6mr3772205pbc.140.1333732316222;
        Fri, 06 Apr 2012 10:11:56 -0700 (PDT)
Received: by 10.68.189.166 with SMTP id gj6mr3772199pbc.140.1333732316176;
        Fri, 06 Apr 2012 10:11:56 -0700 (PDT)
Received: from king.tilera.com (206.83.70.73.ptr.us.xo.net. [206.83.70.73])
        by mx.google.com with ESMTP id l7si9060870pbj.56.2012.04.06.10.11.55;
        Fri, 06 Apr 2012 10:11:55 -0700 (PDT)
Received-SPF: neutral (google.com: 206.83.70.73 is neither permitted nor denied by best guess record for domain of cmetcalf@tilera.com) client-ip=206.83.70.73;
Authentication-Results: mx.google.com; spf=neutral (google.com: 206.83.70.73 is neither permitted nor denied by best guess record for domain of cmetcalf@tilera.com) smtp.mail=cmetcalf@tilera.com
Received: from lab-41.internal.tilera.com ([10.8.0.210]) by king.tilera.com over TLS secured channel with Microsoft SMTPSVC(6.0.3790.3959);
	 Fri, 6 Apr 2012 13:11:54 -0400
Received: (from cmetcalf@localhost)
	by lab-41.internal.tilera.com (8.13.8/8.12.11/Submit) id q36HBpAh015060;
	Fri, 6 Apr 2012 13:11:51 -0400
Message-Id: <201204061711.q36HBpAh015060@lab-41.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 6 Apr 2012 12:53:50 -0400
Subject: init: fix bug where environment vars can't be passed via boot args
To: Pawel Moll <pawel.moll@arm.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 06 Apr 2012 17:11:54.0788 (UTC) FILETIME=[5DBA6640:01CD1418]

Commit 026cee0086f had the side-effect of dropping the '=' from
the unknown boot arguments that are passed to init as environment
variables.  This is because parse_args() puts a NUL in the string
where the '=' was when it passes the "param" and "val" pointers
to the parsing subfunctions.  Previously, unknown_bootoption() was
the last parse_args() subfunction to run, and it carefully put back
the '=' character.  Now ignore_unknown_bootoption() is the last
one to run, and it wasn't doing the necessary repair, so the
envp params ended up with the embedded NUL and were no longer
seen as valid environment variables by init.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 init/main.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/init/main.c b/init/main.c
index 9d454f0..44b2433 100644
--- a/init/main.c
+++ b/init/main.c
@@ -225,13 +225,9 @@ static int __init loglevel(char *str)
 
 early_param("loglevel", loglevel);
 
-/*
- * Unknown boot options get handed to init, unless they look like
- * unused parameters (modprobe will find them in /proc/cmdline).
- */
-static int __init unknown_bootoption(char *param, char *val)
+/* Change NUL term back to "=", to make "param" the whole string. */
+static int __init repair_env_string(char *param, char *val)
 {
-	/* Change NUL term back to "=", to make "param" the whole string. */
 	if (val) {
 		/* param=val or param="val"? */
 		if (val == param+strlen(param)+1)
@@ -243,6 +239,16 @@ static int __init unknown_bootoption(char *param, char *val)
 		} else
 			BUG();
 	}
+	return 0;
+}
+
+/*
+ * Unknown boot options get handed to init, unless they look like
+ * unused parameters (modprobe will find them in /proc/cmdline).
+ */
+static int __init unknown_bootoption(char *param, char *val)
+{
+	repair_env_string(param, val);
 
 	/* Handle obsolete-style parameters */
 	if (obsolete_checksetup(param))
@@ -732,11 +738,6 @@ static char *initcall_level_names[] __initdata = {
 	"late parameters",
 };
 
-static int __init ignore_unknown_bootoption(char *param, char *val)
-{
-	return 0;
-}

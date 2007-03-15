From: akpm@linux-foundation.org
Subject: + explicitly-set-pgid-and-sid-of-init-process.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:54:37 -0800
Message-ID: <200703151854.l2FIsdDB023458@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36448 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbXCOTBi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 15:01:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sukadev@us.ibm.com, clg@fr.ibm.com, containers@lists.osdl.org, ebiederm@xmission.com, haveblue@us.ibm.com, herbert@13thfloor.at, serue@us.ibm.com


The patch titled
     Explicitly set pgid and sid of init process
has been added to the -mm tree.  Its filename is
     explicitly-set-pgid-and-sid-of-init-process.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Explicitly set pgid and sid of init process
From: Sukadev Bhattiprolu <sukadev@us.ibm.com>

Explicitly set pgid and sid of init process to 1.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: <containers@lists.osdl.org>
Acked-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN init/main.c~explicitly-set-pgid-and-sid-of-init-process init/main.c
--- a/init/main.c~explicitly-set-pgid-and-sid-of-init-process
+++ a/init/main.c
@@ -783,6 +783,7 @@ static int __init init(void * unused)
 	 */
 	init_pid_ns.child_reaper = current;
 
+	__set_special_pids(1, 1);
 	cad_pid = task_pid(current);
 
 	smp_prepare_cpus(max_cpus);
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

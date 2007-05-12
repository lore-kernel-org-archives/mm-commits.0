From: akpm@linux-foundation.org
Subject: - explicitly-set-pgid-and-sid-of-init-process.patch removed from -mm tree
Date: Fri, 11 May 2007 22:34:32 -0700
Message-ID: <200705120534.l4C5YW7a002209@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756186AbXELFfT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:35:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sukadev@us.ibm.com, clg@fr.ibm.com, containers@lists.osdl.org, ebiederm@xmission.com, haveblue@us.ibm.com, herbert@13thfloor.at, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Explicitly set pgid and sid of init process
has been removed from the -mm tree.  Its filename was
     explicitly-set-pgid-and-sid-of-init-process.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -801,6 +801,7 @@ static int __init kernel_init(void * unu
 	 */
 	init_pid_ns.child_reaper = current;
 
+	__set_special_pids(1, 1);
 	cad_pid = task_pid(current);
 
 	smp_prepare_cpus(max_cpus);
_

Patches currently in -mm which might be from sukadev@us.ibm.com are

origin.patch

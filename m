From: akpm@linux-foundation.org
Subject: - container-freezer-skip-frozen-cgroups-during-power-management-resume.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:34:26 -0700
Message-ID: <200810202034.m9KKYQCm010853@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753628AbYJTUff (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:35:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthltc@us.ibm.com, clg@fr.ibm.com, rjw@sisk.pl, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     container freezer: skip frozen cgroups during power management resume
has been removed from the -mm tree.  Its filename was
     container-freezer-skip-frozen-cgroups-during-power-management-resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: container freezer: skip frozen cgroups during power management resume
From: Matt Helsley <matthltc@us.ibm.com>

When a system is resumed after a suspend, it will also unfreeze frozen
cgroups.

This patchs modifies the resume sequence to skip the tasks which are part
of a frozen control group.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Acked-by: Serge E. Hallyn <serue@us.ibm.com>
Tested-by: Matt Helsley <matthltc@us.ibm.com>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/process.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN kernel/power/process.c~container-freezer-skip-frozen-cgroups-during-power-management-resume kernel/power/process.c
--- a/kernel/power/process.c~container-freezer-skip-frozen-cgroups-during-power-management-resume
+++ a/kernel/power/process.c
@@ -135,6 +135,9 @@ static void thaw_tasks(bool nosig_only)
 		if (nosig_only && should_send_signal(p))
 			continue;
 
+		if (cgroup_frozen(p))
+			continue;
+
 		thaw_process(p);
 	} while_each_thread(g, p);
 	read_unlock(&tasklist_lock);
_

Patches currently in -mm which might be from matthltc@us.ibm.com are

origin.patch


From: akpm@linux-foundation.org
Subject: [merged] drivers-idle-intel_idlec-fix-confusing-code-identation.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:17:09 -0700
Message-ID: <20120322201709.6FB1BA024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:43027 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773Ab2CVURK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:17:10 -0400
Received: by mail-yw0-f74.google.com with SMTP id m50so403040yhg.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:17:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcos.mage@gmail.com, len.brown@intel.com, lenb@kernel.org, srivatsa.bhat@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/idle/intel_idle.c: fix confusing code identation
has been removed from the -mm tree.  Its filename was
     drivers-idle-intel_idlec-fix-confusing-code-identation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
Subject: drivers/idle/intel_idle.c: fix confusing code identation

Fix a code indentation in the function intel_idle_cpu_init that looks
confusing.o

Suggested-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
Cc: "Brown, Len" <len.brown@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/idle/intel_idle.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/idle/intel_idle.c~drivers-idle-intel_idlec-fix-confusing-code-identation drivers/idle/intel_idle.c
--- a/drivers/idle/intel_idle.c~drivers-idle-intel_idlec-fix-confusing-code-identation
+++ a/drivers/idle/intel_idle.c
@@ -507,8 +507,7 @@ int intel_idle_cpu_init(int cpu)
 		int num_substates;
 
 		if (cstate > max_cstate) {
-			printk(PREFIX "max_cstate %d reached\n",
-			       max_cstate);
+			printk(PREFIX "max_cstate %d reached\n", max_cstate);
 			break;
 		}
 
@@ -524,8 +523,9 @@ int intel_idle_cpu_init(int cpu)
 		dev->states_usage[dev->state_count].driver_data =
 			(void *)get_driver_data(cstate);
 
-			dev->state_count += 1;
-		}
+		dev->state_count += 1;
+	}
+
 	dev->cpu = cpu;
 
 	if (cpuidle_register_device(dev)) {
_

Patches currently in -mm which might be from marcos.mage@gmail.com are

origin.patch
linux-next.patch


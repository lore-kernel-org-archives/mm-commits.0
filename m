From: akpm@linux-foundation.org
Subject: + mem-hotplug-fix-potential-race-while-building-zonelist-for-new-populated-zone-fix.patch added to -mm tree
Date: Fri, 21 May 2010 13:08:14 -0700
Message-ID: <201005212008.o4LK8EEg031554@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751085Ab0EUUIo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 May 2010 16:08:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haicheng.li@linux.intel.com, andi.kleen@intel.com, cl@linux-foundation.org, fengguang.wu@intel.com, mel@csn.ul.ie, tj@kernel.org


The patch titled
     cpu_up: hold zonelists_mutex when build_all_zonelists
has been added to the -mm tree.  Its filename is
     mem-hotplug-fix-potential-race-while-building-zonelist-for-new-populated-zone-fix.patch

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
Subject: cpu_up: hold zonelists_mutex when build_all_zonelists
From: Haicheng Li <haicheng.li@linux.intel.com>

We should always hold zonelists_mutex when calling build_all_zonelists
unless system_state == SYSTEM_BOOTING.

Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi.kleen@intel.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpu.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN kernel/cpu.c~mem-hotplug-fix-potential-race-while-building-zonelist-for-new-populated-zone-fix kernel/cpu.c
--- a/kernel/cpu.c~mem-hotplug-fix-potential-race-while-building-zonelist-for-new-populated-zone-fix
+++ a/kernel/cpu.c
@@ -357,8 +357,11 @@ int __cpuinit cpu_up(unsigned int cpu)
 		return -ENOMEM;
 	}
 
-	if (pgdat->node_zonelists->_zonerefs->zone == NULL)
+	if (pgdat->node_zonelists->_zonerefs->zone == NULL) {
+		mutex_lock(&zonelists_mutex);
 		build_all_zonelists(NULL);
+		mutex_unlock(&zonelists_mutex);
+	}
 #endif
 
 	cpu_maps_update_begin();
_

Patches currently in -mm which might be from haicheng.li@linux.intel.com are

mem-hotplug-separate-setup_per_cpu_pageset-into-separate-functions.patch
mem-hotplug-avoid-multiple-zones-sharing-same-boot-strapping-boot_pageset.patch
mem-hotplug-avoid-multiple-zones-sharing-same-boot-strapping-boot_pageset-fix.patch
mem-hotplug-fix-potential-race-while-building-zonelist-for-new-populated-zone.patch
mem-hotplug-fix-potential-race-while-building-zonelist-for-new-populated-zone-fix.patch


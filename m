From: akpm@linux-foundation.org
Subject: - coretemp-recognize-nehalem-cpus.patch removed from -mm tree
Date: Mon, 18 Aug 2008 12:40:14 -0700
Message-ID: <200808181940.m7IJeEjp008434@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759943AbYHRTtS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 15:49:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djwong@us.ibm.com, kent.liu@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     coretemp: recognize Nehalem CPUs
has been removed from the -mm tree.  Its filename was
     coretemp-recognize-nehalem-cpus.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: coretemp: recognize Nehalem CPUs
From: "Darrick J. Wong" <djwong@us.ibm.com>

Add in the CPUID for Nehalem chips.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Cc: Kent Liu <kent.liu@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/coretemp.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/hwmon/coretemp.c~coretemp-recognize-nehalem-cpus drivers/hwmon/coretemp.c
--- a/drivers/hwmon/coretemp.c~coretemp-recognize-nehalem-cpus
+++ a/drivers/hwmon/coretemp.c
@@ -413,10 +413,11 @@ static int __init coretemp_init(void)
 	for_each_online_cpu(i) {
 		struct cpuinfo_x86 *c = &cpu_data(i);
 
-		/* check if family 6, models 0xe, 0xf, 0x16, 0x17 */
+		/* check if family 6, models 0xe, 0xf, 0x16, 0x17, 0x1A */
 		if ((c->cpuid_level < 0) || (c->x86 != 0x6) ||
 		    !((c->x86_model == 0xe) || (c->x86_model == 0xf) ||
-			(c->x86_model == 0x16) || (c->x86_model == 0x17))) {
+			(c->x86_model == 0x16) || (c->x86_model == 0x17) ||
+			(c->x86_model == 0x1A))) {
 
 			/* supported CPU not found, but report the unknown
 			   family 6 CPU */
_

Patches currently in -mm which might be from djwong@us.ibm.com are

origin.patch


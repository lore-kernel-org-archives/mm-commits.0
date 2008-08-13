From: akpm@linux-foundation.org
Subject: + coretemp-recognize-nehalem-cpus.patch added to -mm tree
Date: Wed, 13 Aug 2008 15:55:44 -0700
Message-ID: <200808132255.m7DMtiEa010908@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752894AbYHMW4t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 18:56:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djwong@us.ibm.com


The patch titled
     coretemp: recognize Nehalem CPUs
has been added to the -mm tree.  Its filename is
     coretemp-recognize-nehalem-cpus.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: coretemp: recognize Nehalem CPUs
From: "Darrick J. Wong" <djwong@us.ibm.com>

Add in the CPUID for Nehalem chips.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/coretemp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/hwmon/coretemp.c~coretemp-recognize-nehalem-cpus drivers/hwmon/coretemp.c
--- a/drivers/hwmon/coretemp.c~coretemp-recognize-nehalem-cpus
+++ a/drivers/hwmon/coretemp.c
@@ -416,7 +416,8 @@ static int __init coretemp_init(void)
 		/* check if family 6, models 0xe, 0xf, 0x16, 0x17 */
 		if ((c->cpuid_level < 0) || (c->x86 != 0x6) ||
 		    !((c->x86_model == 0xe) || (c->x86_model == 0xf) ||
-			(c->x86_model == 0x16) || (c->x86_model == 0x17))) {
+			(c->x86_model == 0x16) || (c->x86_model == 0x17) ||
+			(c->x86_model == 0x1A))) {
 
 			/* supported CPU not found, but report the unknown
 			   family 6 CPU */
_

Patches currently in -mm which might be from djwong@us.ibm.com are

i5k_amb-provide-labels-for-temperature-sensors.patch
ibmaem-update-the-documentation-to-reflect-the-current-name.patch
ibmaem-prevent-infinite-probing-loop-on-x3650-m2-systems.patch
ibmaem-dont-query-the-entire-sensor-repository-when-reading-energy-meter.patch
coretemp-recognize-nehalem-cpus.patch


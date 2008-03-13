From: akpm@linux-foundation.org
Subject: + ibmpex-report-temperatures-in-mc-not-c.patch added to -mm tree
Date: Thu, 13 Mar 2008 15:39:44 -0700
Message-ID: <200803132239.m2DMdixY004119@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753121AbYCMWpW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 18:45:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djwong@us.ibm.com, mhoffman@lightlink.com


The patch titled
     ibmpex: report temperatures in mC, not C
has been added to the -mm tree.  Its filename is
     ibmpex-report-temperatures-in-mc-not-c.patch

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
Subject: ibmpex: report temperatures in mC, not C
From: "Darrick J. Wong" <djwong@us.ibm.com>

ibmpex's temperature sensors report incorrect units.  Apply a conversion
factor so that tempertures report correctly.  Until now, no systems seemed to
report temperatures this way, but evidently QS2x blades do.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/ibmpex.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/hwmon/ibmpex.c~ibmpex-report-temperatures-in-mc-not-c drivers/hwmon/ibmpex.c
--- a/drivers/hwmon/ibmpex.c~ibmpex-report-temperatures-in-mc-not-c
+++ a/drivers/hwmon/ibmpex.c
@@ -410,7 +410,7 @@ static int ibmpex_find_sensors(struct ib
 			sensor_type = TEMP_SENSOR;
 			num_temp++;
 			sensor_counter = num_temp;
-			data->sensors[i].multiplier = 1;
+			data->sensors[i].multiplier = 1000;
 		} else
 			continue;
 
_

Patches currently in -mm which might be from djwong@us.ibm.com are

adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit.patch
git-scsi-misc.patch
mptbase-reset-ioc-initiator-during-pci-resume.patch
scsi-aic94xx-cleanups.patch
ibmpex-correct-power-use-multipliers-for-qs2x-blade.patch
ibmpex-update-kconfig-to-list-more-supported-models.patch
ibmpex-report-temperatures-in-mc-not-c.patch


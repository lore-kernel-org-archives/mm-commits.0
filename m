From: akpm@linux-foundation.org
Subject: [merged] merge_configsh-fix-bug-in-final-check.patch removed from -mm tree
Date: Tue, 17 Jan 2012 13:01:07 -0800
Message-ID: <20120117210108.257F25C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:43842 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab2AQVBK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2012 16:01:10 -0500
Received: by eaaf1 with SMTP id f1so70829eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jan 2012 13:01:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: john.stultz@linaro.org, dvhart@linux.intel.com, lacombar@gmail.com, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: merge_config.sh: fix bug in final check
has been removed from the -mm tree.  Its filename was
     merge_configsh-fix-bug-in-final-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: John Stultz <john.stultz@linaro.org>
Subject: merge_config.sh: fix bug in final check

Arnaud Lacombe pointed out the final checking that the requested configs
were included in the final .config was broken.

The example was that if you had a fragment that disabled
CONFIG_DECOMPRESS_GZIP applied to a normal defconfig, there would be no
final warning that CONFIG_DECOMPRESS_GZIP was acutally set in the final
.config.

This bug was introduced by me in v3 of the original patch, and the
following patch reverts the invalid change.

Signed-off-by: John Stultz <john.stultz@linaro.org>
Reported-by: Arnaud Lacombe <lacombar@gmail.com>
Cc: Darren Hart <dvhart@linux.intel.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Arnaud Lacombe <lacombar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/merge_config.sh |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/kconfig/merge_config.sh~merge_configsh-fix-bug-in-final-check scripts/kconfig/merge_config.sh
--- a/scripts/kconfig/merge_config.sh~merge_configsh-fix-bug-in-final-check
+++ a/scripts/kconfig/merge_config.sh
@@ -104,8 +104,8 @@ make KCONFIG_ALLCONFIG=$TMP_FILE $ALLTAR
 # Check all specified config values took (might have missed-dependency issues)
 for CFG in $(sed -n "$SED_CONFIG_EXP" $TMP_FILE); do
 
-	REQUESTED_VAL=$(sed -n "$SED_CONFIG_EXP" $TMP_FILE | grep -w -e "$CFG")
-	ACTUAL_VAL=$(sed -n "$SED_CONFIG_EXP" .config | grep -w -e "$CFG")
+	REQUESTED_VAL=$(grep -w -e "$CFG" $TMP_FILE)
+	ACTUAL_VAL=$(grep -w -e "$CFG" .config)
 	if [ "x$REQUESTED_VAL" != "x$ACTUAL_VAL" ] ; then
 		echo "Value requested for $CFG not in final .config"
 		echo "Requested value:  $REQUESTED_VAL"
_

Patches currently in -mm which might be from john.stultz@linaro.org are

origin.patch
linux-next.patch


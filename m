From: akpm@linux-foundation.org
Subject: [merged] init-check-printed-flag-to-skip-printing-message.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:31:10 -0700
Message-ID: <20120326193110.75610A00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:54224 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558Ab2CZTbM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:31:12 -0400
Received: by mail-ey0-f202.google.com with SMTP id q10so289982eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:31:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dtundlam@nvidia.com, ext-phil.2.carmody@nokia.com, greg@kroah.com, pdeschrijver@nvidia.com, rmk+kernel@arm.linux.org.uk, snanda@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: init: check printed flag to skip printing message
has been removed from the -mm tree.  Its filename was
     init-check-printed-flag-to-skip-printing-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Diwakar Tundlam <dtundlam@nvidia.com>
Subject: init: check printed flag to skip printing message

Otherwise the 'Calibration skipped' message gets printed everytime a CPU
is hotplugged in, cluttering console for systems that frequently hotplug
CPUs.

Signed-off-by: Diwakar Tundlam <dtundlam@nvidia.com>
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Greg KH <greg@kroah.com>
Cc: Sameer Nanda <snanda@chromium.org>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/calibrate.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN init/calibrate.c~init-check-printed-flag-to-skip-printing-message init/calibrate.c
--- a/init/calibrate.c~init-check-printed-flag-to-skip-printing-message
+++ a/init/calibrate.c
@@ -267,7 +267,8 @@ void __cpuinit calibrate_delay(void)
 
 	if (per_cpu(cpu_loops_per_jiffy, this_cpu)) {
 		lpj = per_cpu(cpu_loops_per_jiffy, this_cpu);
-		pr_info("Calibrating delay loop (skipped) "
+		if (!printed)
+			pr_info("Calibrating delay loop (skipped) "
 				"already calibrated this CPU");
 	} else if (preset_lpj) {
 		lpj = preset_lpj;
_

Patches currently in -mm which might be from dtundlam@nvidia.com are

origin.patch


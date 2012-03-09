From: akpm@linux-foundation.org
Subject: + init-check-printed-flag-to-skip-printing-message.patch added to -mm tree
Date: Thu, 08 Mar 2012 16:07:44 -0800
Message-ID: <20120309000745.2067FA02AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:63019 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759237Ab2CIAHr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Mar 2012 19:07:47 -0500
Received: by wejx9 with SMTP id x9so39324wej.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Mar 2012 16:07:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dtundlam@nvidia.com, ext-phil.2.carmody@nokia.com, greg@kroah.com, pdeschrijver@nvidia.com, rmk+kernel@arm.linux.org.uk, snanda@chromium.org


The patch titled
     Subject: init: check printed flag to skip printing message
has been added to the -mm tree.  Its filename is
     init-check-printed-flag-to-skip-printing-message.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: init: check printed flag to skip printing message

Patches currently in -mm which might be from dtundlam@nvidia.com are

linux-next.patch
init-check-printed-flag-to-skip-printing-message.patch


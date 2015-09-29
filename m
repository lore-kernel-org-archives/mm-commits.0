From: akpm@linux-foundation.org
Subject: + thermal-avoid-division-by-zero-in-power-allocator.patch added
 to -mm tree
Date: Tue, 29 Sep 2015 13:34:17 -0700
Message-ID: <560af5c9.nf8U+CXFQ/zsApKu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39298 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbbI2UeS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Sep 2015 16:34:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, djkurtz@chromium.org, edubezval@gmail.com, javi.merino@arm.com, rui.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thermal: avoid division by zero in power allocator
has been added to the -mm tree.  Its filename is
     thermal-avoid-division-by-zero-in-power-allocator.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thermal-avoid-division-by-zero-in-power-allocator.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thermal-avoid-division-by-zero-in-power-allocator.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: thermal: avoid division by zero in power allocator

During boot I get a div by zero Oops regression starting in v4.3-rc3.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Javi Merino <javi.merino@arm.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/power_allocator.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN drivers/thermal/power_allocator.c~thermal-avoid-division-by-zero-in-power-allocator drivers/thermal/power_allocator.c
--- a/drivers/thermal/power_allocator.c~thermal-avoid-division-by-zero-in-power-allocator
+++ a/drivers/thermal/power_allocator.c
@@ -144,6 +144,16 @@ static void estimate_pid_constants(struc
 		switch_on_temp = 0;
 
 	temperature_threshold = control_temp - switch_on_temp;
+	/*
+	 * estimate_pid_constants() tries to find appropriate default
+	 * values for thermal zones that don't provide them. If a
+	 * system integrator has configured a thermal zone with two
+	 * passive trip points at the same temperature, that person
+	 * hasn't put any effort to set up the thermal zone properly
+	 * so just give up.
+	 */
+	if (!temperature_threshold)
+		return;
 
 	if (!tz->tzp->k_po || force)
 		tz->tzp->k_po = int_to_frac(sustainable_power) /
_

Patches currently in -mm which might be from aarcange@redhat.com are

thermal-avoid-division-by-zero-in-power-allocator.patch


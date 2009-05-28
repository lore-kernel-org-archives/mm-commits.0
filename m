From: akpm@linux-foundation.org
Subject: [merged] acpi-processor-remove-spurious-newline-from-warning-message.patch removed from -mm tree
Date: Thu, 28 May 2009 12:26:54 -0700
Message-ID: <200905281926.n4SJQsfI002596@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41930 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754817AbZE1T1Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 15:27:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elendil@planet.nl, len.brown@intel.com, rui.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     ACPI processor: remove spurious newline from warning message
has been removed from the -mm tree.  Its filename was
     acpi-processor-remove-spurious-newline-from-warning-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ACPI processor: remove spurious newline from warning message
From: Frans Pop <elendil@planet.nl>

Commit 4973b22a ("ACPI processor: reset the throttling state once it's
invalid") introduced a new warning which prints a spurious newline.

The ACPI_WARNING macro that is used already takes care of adding a
newline, after adding ACPI_CA_VERSION to the message.  Remove the newline
to avoid the message getting split into two lines.

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_throttling.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/acpi/processor_throttling.c~acpi-processor-remove-spurious-newline-from-warning-message drivers/acpi/processor_throttling.c
--- a/drivers/acpi/processor_throttling.c~acpi-processor-remove-spurious-newline-from-warning-message
+++ a/drivers/acpi/processor_throttling.c
@@ -840,7 +840,7 @@ static int acpi_processor_get_throttling
 		state = acpi_get_throttling_state(pr, value);
 		if (state == -1) {
 			ACPI_WARNING((AE_INFO,
-				"Invalid throttling state, reset\n"));
+				"Invalid throttling state, reset"));
 			state = 0;
 			ret = acpi_processor_set_throttling(pr, state);
 			if (ret)
_

Patches currently in -mm which might be from elendil@planet.nl are

linux-next.patch


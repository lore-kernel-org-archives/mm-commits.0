From: akpm@linux-foundation.org
Subject: - acpi-cpufreq-cleanup-move-bailing-out-of-function-before-locking-the-mutex.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:13:47 -0700
Message-ID: <200807301913.m6UJDllB010787@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55312 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752355AbYG3TOw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:14:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: trenn@suse.de, andi@firstfloor.org, davej@codemonkey.org.uk, lenb@kernel.org, mingo@elte.hu, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     acpi cpufreq cleanup: move bailing out of function before locking the mutex
has been removed from the -mm tree.  Its filename was
     acpi-cpufreq-cleanup-move-bailing-out-of-function-before-locking-the-mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi cpufreq cleanup: move bailing out of function before locking the mutex
From: Thomas Renninger <trenn@suse.de>

Signed-off-by: Thomas Renninger <trenn@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_perflib.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/acpi/processor_perflib.c~acpi-cpufreq-cleanup-move-bailing-out-of-function-before-locking-the-mutex drivers/acpi/processor_perflib.c
--- a/drivers/acpi/processor_perflib.c~acpi-cpufreq-cleanup-move-bailing-out-of-function-before-locking-the-mutex
+++ a/drivers/acpi/processor_perflib.c
@@ -95,10 +95,10 @@ static int acpi_processor_ppc_notifier(s
 	if (ignore_ppc)
 		return 0;
 
-	mutex_lock(&performance_mutex);

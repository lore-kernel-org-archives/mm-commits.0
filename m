From: akpm@linux-foundation.org
Subject: + acpi-cpufreq-cleanup-move-bailing-out-of-function-before-locking-the-mutex.patch added to -mm tree
Date: Sun, 20 Jul 2008 23:39:19 -0700
Message-ID: <200807210639.m6L6dJsA021714@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45597 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751796AbYGUGj5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jul 2008 02:39:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: trenn@suse.de, andi@firstfloor.org, davej@codemonkey.org.uk, lenb@kernel.org, mingo@elte.hu, venkatesh.pallipadi@intel.com


The patch titled
     acpi cpufreq cleanup: Move bailing out of function before locking the mutex
has been added to the -mm tree.  Its filename is
     acpi-cpufreq-cleanup-move-bailing-out-of-function-before-locking-the-mutex.patch

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
Subject: acpi cpufreq cleanup: Move bailing out of function before locking the mutex
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

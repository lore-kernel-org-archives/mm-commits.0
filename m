From: akpm@linux-foundation.org
Subject: + drivers-cpufreq-acpi-cpufreqc-fix-memory-leak.patch added to -mm tree
Date: Wed, 06 Jul 2011 15:42:03 -0700
Message-ID: <201107062242.p66Mg3eE004237@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51581 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752959Ab1GFWmG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jul 2011 18:42:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: luming.yu@gmail.com, lenb@kernel.org, luming.yu@intel.com


The patch titled
     drivers/cpufreq/acpi-cpufreq.c: fix memory leak
has been added to the -mm tree.  Its filename is
     drivers-cpufreq-acpi-cpufreqc-fix-memory-leak.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/cpufreq/acpi-cpufreq.c: fix memory leak
From: Luming Yu <luming.yu@gmail.com>

I came across a memory leak during a cyclic cpu-online-offline test.

Signed-off-by: Yu Luming <luming.yu@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/acpi-cpufreq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/cpufreq/acpi-cpufreq.c~drivers-cpufreq-acpi-cpufreqc-fix-memory-leak drivers/cpufreq/acpi-cpufreq.c
--- a/drivers/cpufreq/acpi-cpufreq.c~drivers-cpufreq-acpi-cpufreqc-fix-memory-leak
+++ a/drivers/cpufreq/acpi-cpufreq.c
@@ -759,7 +759,7 @@ static void __exit acpi_cpufreq_exit(voi
 
 	cpufreq_unregister_driver(&acpi_cpufreq_driver);
 
-	free_percpu(acpi_perf_data);
+	free_acpi_perf_data();
 }
 
 module_param(acpi_pstate_strict, uint, 0644);
_

Patches currently in -mm which might be from luming.yu@gmail.com are

drivers-cpufreq-acpi-cpufreqc-fix-memory-leak.patch


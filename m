From: akpm@linux-foundation.org
Subject: + drivers-cpufreq-pcc-cpufreqc-avoid-null-pointer-dereference.patch added to -mm tree
Date: Thu, 08 Sep 2011 16:54:48 -0700
Message-ID: <201109082354.p88NsmVK015794@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35479 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754223Ab1IHXyx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Sep 2011 19:54:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nagananda.chumbalkar@hp.com, davej@codemonkey.org.uk, lenb@kernel.org, stable@kernel.org


The patch titled
     drivers/cpufreq/pcc-cpufreq.c: avoid NULL pointer dereference
has been added to the -mm tree.  Its filename is
     drivers-cpufreq-pcc-cpufreqc-avoid-null-pointer-dereference.patch

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
Subject: drivers/cpufreq/pcc-cpufreq.c: avoid NULL pointer dereference
From: Naga Chumbalkar <nagananda.chumbalkar@hp.com>

per_cpu(processors, n) can be NULL.

Loading CPUFreq modules[  437.661360] BUG: unable to handle kernel NULL pointer
dereference at (null)
IP: [<ffffffffa0434314>] pcc_cpufreq_cpu_init+0x74/0x220 [pcc_cpufreq]

It's better to avoid the oops by failing the driver, and allowing the
system to boot.

Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Len Brown <lenb@kernel.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/pcc-cpufreq.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/cpufreq/pcc-cpufreq.c~drivers-cpufreq-pcc-cpufreqc-avoid-null-pointer-dereference drivers/cpufreq/pcc-cpufreq.c
--- a/drivers/cpufreq/pcc-cpufreq.c~drivers-cpufreq-pcc-cpufreqc-avoid-null-pointer-dereference
+++ a/drivers/cpufreq/pcc-cpufreq.c
@@ -261,6 +261,9 @@ static int pcc_get_offset(int cpu)
 	pr = per_cpu(processors, cpu);
 	pcc_cpu_data = per_cpu_ptr(pcc_cpu_info, cpu);
 
+	if (!pr)
+		return -ENODEV;
+
 	status = acpi_evaluate_object(pr->handle, "PCCP", NULL, &buffer);
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
_

Patches currently in -mm which might be from nagananda.chumbalkar@hp.com are

drivers-cpufreq-pcc-cpufreqc-avoid-null-pointer-dereference.patch
linux-next.patch


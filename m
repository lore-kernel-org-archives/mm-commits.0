From: akpm@linux-foundation.org
Subject: + powernow-k8-fix-misleading-variable-naming.patch added to -mm tree
Date: Thu, 08 Jul 2010 15:13:16 -0700
Message-ID: <201007082213.o68MDGrw032138@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753732Ab0GHWOE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jul 2010 18:14:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: borislav.petkov@amd.com, Mark.Langsdorf@amd.com, davej@redhat.com, trenn@suse.de


The patch titled
     powernow-k8: fix misleading variable naming
has been added to the -mm tree.  Its filename is
     powernow-k8-fix-misleading-variable-naming.patch

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
Subject: powernow-k8: fix misleading variable naming
From: Borislav Petkov <borislav.petkov@amd.com>

rdmsr() takes the lower 32 bits as a second argument and the high 32 as a
third.  Fix the names accordingly since they were swapped.

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Mark Langsdorf <Mark.Langsdorf@amd.com>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/cpu/cpufreq/powernow-k8.c~powernow-k8-fix-misleading-variable-naming arch/x86/kernel/cpu/cpufreq/powernow-k8.c
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c~powernow-k8-fix-misleading-variable-naming
+++ a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -912,8 +912,8 @@ static int fill_powernow_table_pstate(st
 {
 	int i;
 	u32 hi = 0, lo = 0;
-	rdmsr(MSR_PSTATE_CUR_LIMIT, hi, lo);
-	data->max_hw_pstate = (hi & HW_PSTATE_MAX_MASK) >> HW_PSTATE_MAX_SHIFT;
+	rdmsr(MSR_PSTATE_CUR_LIMIT, lo, hi);
+	data->max_hw_pstate = (lo & HW_PSTATE_MAX_MASK) >> HW_PSTATE_MAX_SHIFT;
 
 	for (i = 0; i < data->acpi_data.state_count; i++) {
 		u32 index;
_

Patches currently in -mm which might be from borislav.petkov@amd.com are

linux-next.patch
powernow-k8-limit-pstate-transition-latency-check.patch
powernow-k8-fix-misleading-variable-naming.patch


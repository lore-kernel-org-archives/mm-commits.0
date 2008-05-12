From: akpm@linux-foundation.org
Subject: + cpufreq-arusoe-longrun-cpufreq-module-reports-false-min-freq.patch added to -mm tree
Date: Mon, 12 May 2008 14:49:13 -0700
Message-ID: <200805122149.m4CLnDgl010963@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751431AbYELVvA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 17:51:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: max@stro.at, davej@codemonkey.org.uk, kazssym@hypercore.co.jp


The patch titled
     cpufreq: arusoe: longrun cpufreq module reports false min freq
has been added to the -mm tree.  Its filename is
     cpufreq-arusoe-longrun-cpufreq-module-reports-false-min-freq.patch

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
Subject: cpufreq: arusoe: longrun cpufreq module reports false min freq
From: maximilian attems <max@stro.at>

The longrun cpufreq module reports a false minimum frequency 3MHz on
300-600MHz Crusoe processor.  This may be due to a calculation bug in the
module.

Original patch from Kaz Sasayama <kazssym@hypercore.co.jp>
submitted as http://bugs.debian.org/468149 patch ported to x86

Cc: Kaz Sasayama <kazssym@hypercore.co.jp>
Signed-off-by: maximilian attems <max@stro.at>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/cpufreq/longrun.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/cpu/cpufreq/longrun.c~cpufreq-arusoe-longrun-cpufreq-module-reports-false-min-freq arch/x86/kernel/cpu/cpufreq/longrun.c
--- a/arch/x86/kernel/cpu/cpufreq/longrun.c~cpufreq-arusoe-longrun-cpufreq-module-reports-false-min-freq
+++ a/arch/x86/kernel/cpu/cpufreq/longrun.c
@@ -245,7 +245,7 @@ static unsigned int __init longrun_deter
 	if ((ecx > 95) || (ecx == 0) || (eax < ebx))
 		return -EIO;
 
-	edx = (eax - ebx) / (100 - ecx);
+	edx = ((eax - ebx) * 100) / (100 - ecx);
 	*low_freq = edx * 1000; /* back to kHz */
 
 	dprintk("low frequency is %u kHz\n", *low_freq);
_

Patches currently in -mm which might be from max@stro.at are

linux-next.patch
cpufreq-arusoe-longrun-cpufreq-module-reports-false-min-freq.patch


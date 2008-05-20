From: akpm@linux-foundation.org
Subject: - cpufreq-arusoe-longrun-cpufreq-module-reports-false-min-freq.patch removed from -mm tree
Date: Tue, 20 May 2008 14:14:43 -0700
Message-ID: <200805202114.m4KLEhFk011493@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38207 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763390AbYETVYj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 17:24:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: max@stro.at, davej@codemonkey.org.uk, kazssym@hypercore.co.jp, mm-commits@vger.kernel.org


The patch titled
     cpufreq: crusoe: longrun cpufreq module reports false min freq
has been removed from the -mm tree.  Its filename was
     cpufreq-arusoe-longrun-cpufreq-module-reports-false-min-freq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpufreq: crusoe: longrun cpufreq module reports false min freq
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
typesh-dont-expose-struct-ustat-to-userspace.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4697A7493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="px8+rK6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117F1C433C8;
	Mon, 11 Dec 2023 01:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257830;
	bh=ezXaH5x1M3ZvFi/NGoGFlrP8YOyagk/b+3x+X9tn500=;
	h=Date:To:From:Subject:From;
	b=px8+rK6Fmhf1Aqrx+/Wfc9CP6vcsuVAjwqBYzlFF3vJOR5P3MEjbKHLZ1ewOjf1Ms
	 coh+1xnt5E5PD1bzfEcQTK3iCjoE/7IfLkn+oafZXc4zdYdd846wlpF+cA1BJOEoNV
	 85qPEw3C8Hx+hr+NNdoNyfRRaHgk6jCl1WtH6SVU=
Date: Sun, 10 Dec 2023 17:23:49 -0800
To: mm-commits@vger.kernel.org,tsbogend@alpha.franken.de,sfr@rothwell.id.au,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mips-smp-fix-setup_profiling_timer-prototype.patch removed from -mm tree
Message-Id: <20231211012350.117F1C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mips: smp: fix setup_profiling_timer() prototype
has been removed from the -mm tree.  Its filename was
     mips-smp-fix-setup_profiling_timer-prototype.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mips: smp: fix setup_profiling_timer() prototype
Date: Mon, 4 Dec 2023 12:57:09 +0100

The function is unconditionally defined in smp.c but is conditionally
declared in a header that is not included here.

arch/mips/kernel/smp.c:473:5: error: no previous prototype for 'setup_profiling_timer' [-Werror=missing-prototypes]

Add the missing #include and #ifdef to match the declaration.

Link: https://lkml.kernel.org/r/20231204115710.2247097-20-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@rothwell.id.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/smp.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/mips/kernel/smp.c~mips-smp-fix-setup_profiling_timer-prototype
+++ a/arch/mips/kernel/smp.c
@@ -10,6 +10,7 @@
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/profile.h>
 #include <linux/smp.h>
 #include <linux/spinlock.h>
 #include <linux/threads.h>
@@ -468,11 +469,13 @@ int __cpu_up(unsigned int cpu, struct ta
 	return 0;
 }
 
+#ifdef CONFIG_PROFILING
 /* Not really SMP stuff ... */
 int setup_profiling_timer(unsigned int multiplier)
 {
 	return 0;
 }
+#endif
 
 static void flush_tlb_all_ipi(void *info)
 {
_

Patches currently in -mm which might be from arnd@arndb.de are

kexec-fix-kexec_file-dependencies.patch
kexec-fix-kexec_file-dependencies-fix.patch
kexec-select-crypto-from-kexec_file-instead-of-depending-on-it.patch
makefileextrawarn-turn-on-missing-prototypes-globally.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA327493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VoNtXIID"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B615C433C9;
	Mon, 11 Dec 2023 01:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257828;
	bh=Wcjn4zRuV2GlxO2O6g7RySi3CQMRRYamp2HpHPEjq7o=;
	h=Date:To:From:Subject:From;
	b=VoNtXIIDhmlNMPwx+WEAVxgmvSR/k7oE22loWZV684T4WkAOhPJvZwnEUwlark4g7
	 RndpS8Bd7mb3/eKWQNljlmSpqWCUGg2S34YBLHXYA0ivNjHyVbSgowUj6KEx2zAPHq
	 /EPx/RePi/wwsXZnR/MOMUzoQojuXgLCwXRNOfXI=
Date: Sun, 10 Dec 2023 17:23:47 -0800
To: mm-commits@vger.kernel.org,tsbogend@alpha.franken.de,sfr@rothwell.id.au,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mips-suspend-include-linux-suspendh-as-needed.patch removed from -mm tree
Message-Id: <20231211012348.1B615C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mips: suspend: include linux/suspend.h as needed
has been removed from the -mm tree.  Its filename was
     mips-suspend-include-linux-suspendh-as-needed.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mips: suspend: include linux/suspend.h as needed
Date: Mon, 4 Dec 2023 12:57:07 +0100

A couple of functions are defined by the architecture and declared in
linux/suspend.h, but mips is lacking the corresponding #include statement
before the definition:

arch/mips/power/cpu.c:16:6: warning: no previous prototype for 'save_processor_state' [-Wmissing-prototypes]
arch/mips/power/cpu.c:26:6: warning: no previous prototype for 'restore_processor_state' [-Wmissing-prototypes]
arch/mips/power/cpu.c:36:5: warning: no previous prototype for 'pfn_is_nosave' [-Wmissing-prototypes]
arch/mips/power/hibernate.c:6:5: warning: no previous prototype for 'swsusp_arch_resume' [-Wmissing-prototypes]

Link: https://lkml.kernel.org/r/20231204115710.2247097-18-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@rothwell.id.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/power/cpu.c       |    1 +
 arch/mips/power/hibernate.c |    1 +
 2 files changed, 2 insertions(+)

--- a/arch/mips/power/cpu.c~mips-suspend-include-linux-suspendh-as-needed
+++ a/arch/mips/power/cpu.c
@@ -6,6 +6,7 @@
  * Author: Hu Hongbing <huhb@lemote.com>
  *	   Wu Zhangjin <wuzhangjin@gmail.com>
  */
+#include <linux/suspend.h>
 #include <asm/sections.h>
 #include <asm/fpu.h>
 #include <asm/dsp.h>
--- a/arch/mips/power/hibernate.c~mips-suspend-include-linux-suspendh-as-needed
+++ a/arch/mips/power/hibernate.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <linux/suspend.h>
 #include <asm/tlbflush.h>
 
 extern int restore_image(void);
_

Patches currently in -mm which might be from arnd@arndb.de are

kexec-fix-kexec_file-dependencies.patch
kexec-fix-kexec_file-dependencies-fix.patch
kexec-select-crypto-from-kexec_file-instead-of-depending-on-it.patch
makefileextrawarn-turn-on-missing-prototypes-globally.patch


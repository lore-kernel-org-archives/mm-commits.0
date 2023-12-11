Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564267493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cPehLdCI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 243B9C433C8;
	Mon, 11 Dec 2023 01:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257826;
	bh=6bqi38QB9CSOoCSCupuRCXeqeKPyKHT81lXM8T9tDsk=;
	h=Date:To:From:Subject:From;
	b=cPehLdCIK7yXMfkD+7fgLQJchn+rWOjTesWnmc9OpvaBEbUygsiBGHjtlRRKmDLFJ
	 VIzkcj70ECZcmBfuFPB0Pw3bxd9T6NfCRGNdwsIzdk2DQTbdsKr/uwXrCGrQHJZtPN
	 BrtGQyllCIlqb4i2YPViIWVO/PejlB5EFF+wDaj8=
Date: Sun, 10 Dec 2023 17:23:45 -0800
To: mm-commits@vger.kernel.org,tsbogend@alpha.franken.de,sfr@rothwell.id.au,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mips-spram-fix-missing-prototype-warning-for-spram_config.patch removed from -mm tree
Message-Id: <20231211012346.243B9C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mips: spram: fix missing prototype warning for spram_config
has been removed from the -mm tree.  Its filename was
     mips-spram-fix-missing-prototype-warning-for-spram_config.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mips: spram: fix missing prototype warning for spram_config
Date: Mon, 4 Dec 2023 12:57:04 +0100

arch/mips/kernel/spram.c:194:6: error: no previous prototype for 'spram_config' [-Werror=missing-prototypes]

Link: https://lkml.kernel.org/r/20231204115710.2247097-15-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@rothwell.id.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/spram.h |    2 +-
 arch/mips/kernel/spram.c      |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/arch/mips/include/asm/spram.h~mips-spram-fix-missing-prototype-warning-for-spram_config
+++ a/arch/mips/include/asm/spram.h
@@ -3,7 +3,7 @@
 #define _MIPS_SPRAM_H
 
 #if defined(CONFIG_MIPS_SPRAM)
-extern __init void spram_config(void);
+extern void spram_config(void);
 #else
 static inline void spram_config(void) { }
 #endif /* CONFIG_MIPS_SPRAM */
--- a/arch/mips/kernel/spram.c~mips-spram-fix-missing-prototype-warning-for-spram_config
+++ a/arch/mips/kernel/spram.c
@@ -12,6 +12,7 @@
 #include <asm/mipsregs.h>
 #include <asm/r4kcache.h>
 #include <asm/hazards.h>
+#include <asm/spram.h>
 
 /*
  * These definitions are correct for the 24K/34K/74K SPRAM sample
_

Patches currently in -mm which might be from arnd@arndb.de are

kexec-fix-kexec_file-dependencies.patch
kexec-fix-kexec_file-dependencies-fix.patch
kexec-select-crypto-from-kexec_file-instead-of-depending-on-it.patch
makefileextrawarn-turn-on-missing-prototypes-globally.patch


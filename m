Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB167493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uZlJ20Bw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1931CC433C7;
	Mon, 11 Dec 2023 01:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257827;
	bh=VLWFOivws/iS8FYhzRXuPtOHhgvz5KZtWnD00jtycyc=;
	h=Date:To:From:Subject:From;
	b=uZlJ20BwXrfoYVcd7X1iOnOkJDa4eMf4HMX8tWDNS52qVJVO1k7TI1KN510okOIu7
	 lsy+7cQHEq5/62PGunWplW8YbLEYWO3ekx12k3fKEUSoEDPce3NMd7BLRpTOO6Mw0E
	 sTzvJRHg5L278vNzXJh41Rm70RI6ssFV1QFPodsI=
Date: Sun, 10 Dec 2023 17:23:46 -0800
To: mm-commits@vger.kernel.org,tsbogend@alpha.franken.de,sfr@rothwell.id.au,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mips-mt-include-asm-mips_mth.patch removed from -mm tree
Message-Id: <20231211012347.1931CC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mips: mt: include asm/mips_mt.h
has been removed from the -mm tree.  Its filename was
     mips-mt-include-asm-mips_mth.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mips: mt: include asm/mips_mt.h
Date: Mon, 4 Dec 2023 12:57:05 +0100

These two functions have a global prototype but the header is not included
before the function definitions:

arch/mips/kernel/mips-mt.c:50:6: error: no previous prototype for 'mips_mt_regdump' [-Werror=missing-prototypes]
arch/mips/kernel/mips-mt.c:159:6: error: no previous prototype for 'mips_mt_set_cpuoptions' [-Werror=missing-prototypes]

Link: https://lkml.kernel.org/r/20231204115710.2247097-16-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@rothwell.id.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/mips-mt.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/mips/kernel/mips-mt.c~mips-mt-include-asm-mips_mth
+++ a/arch/mips/kernel/mips-mt.c
@@ -19,6 +19,7 @@
 #include <asm/mipsmtregs.h>
 #include <asm/r4kcache.h>
 #include <asm/cacheflush.h>
+#include <asm/mips_mt.h>
 
 int vpelimit;
 
_

Patches currently in -mm which might be from arnd@arndb.de are

kexec-fix-kexec_file-dependencies.patch
kexec-fix-kexec_file-dependencies-fix.patch
kexec-select-crypto-from-kexec_file-instead-of-depending-on-it.patch
makefileextrawarn-turn-on-missing-prototypes-globally.patch


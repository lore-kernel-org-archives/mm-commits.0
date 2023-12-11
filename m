Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F747493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jsn0Ck1j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA61C433C8;
	Mon, 11 Dec 2023 01:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257831;
	bh=hNuMa48ohosfJnZDxaNWgdyGQ0Sc9Bp5NaPh2f5bXSs=;
	h=Date:To:From:Subject:From;
	b=jsn0Ck1jXGENsajUyGGHqZY7aKvppRALsvhiN2cBc0kQd1PKLfC7+H74VRnepTFiC
	 1Raj9juSXYMcBbwFJxohvrmhDi9M4nnTSnyyCNFz2f0fEkyuG84NMk0fuCFtN1LXqJ
	 2Huf0/HwDsykdgsd1+3Z9fwyOIb4ML+kh2oUiQXg=
Date: Sun, 10 Dec 2023 17:23:50 -0800
To: mm-commits@vger.kernel.org,tsbogend@alpha.franken.de,sfr@rothwell.id.au,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mips-kexec-include-linux-rebooth.patch removed from -mm tree
Message-Id: <20231211012351.1EA61C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mips: kexec: include linux/reboot.h
has been removed from the -mm tree.  Its filename was
     mips-kexec-include-linux-rebooth.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mips: kexec: include linux/reboot.h
Date: Mon, 4 Dec 2023 12:57:10 +0100

Two functions are provided for kexec, but the mips implementation is
missing the corresponding #include statment:

arch/mips/kernel/machine_kexec.c:136:1: error: no previous prototype for 'machine_shutdown' [-Werror=missing-prototypes]
arch/mips/kernel/machine_kexec.c:152:1: error: no previous prototype for 'machine_crash_shutdown' [-Werror=missing-prototypes]

Link: https://lkml.kernel.org/r/20231204115710.2247097-21-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@rothwell.id.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/machine_kexec.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/mips/kernel/machine_kexec.c~mips-kexec-include-linux-rebooth
+++ a/arch/mips/kernel/machine_kexec.c
@@ -8,6 +8,7 @@
 #include <linux/mm.h>
 #include <linux/delay.h>
 #include <linux/libfdt.h>
+#include <linux/reboot.h>
 
 #include <asm/cacheflush.h>
 #include <asm/page.h>
_

Patches currently in -mm which might be from arnd@arndb.de are

kexec-fix-kexec_file-dependencies.patch
kexec-fix-kexec_file-dependencies-fix.patch
kexec-select-crypto-from-kexec_file-instead-of-depending-on-it.patch
makefileextrawarn-turn-on-missing-prototypes-globally.patch


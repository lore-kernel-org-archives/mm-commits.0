Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B947493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jJDu09ed"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA4DC433C7;
	Mon, 11 Dec 2023 01:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257820;
	bh=q0NXn33p3PAa3VHDbIRumtiJTqKmD9pfwniiTv1Vdo4=;
	h=Date:To:From:Subject:From;
	b=jJDu09edf0LlyM/BTGDAJl3NVD2ZeB9CE8uRnhZRsjvVlJBrMVwfJkNchHUQM7l33
	 tlJLpM0YJXOravwCRkMsIiHPkFxQ1BBAFX45Tw/+RQyozsh7RtVyPncL+cOujz5NJf
	 3Wlo+Wn19FjaiWIsEHiCBUOQccXH/D6aaR62/Dbk=
Date: Sun, 10 Dec 2023 17:23:38 -0800
To: mm-commits@vger.kernel.org,tsbogend@alpha.franken.de,sfr@rothwell.id.au,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mips-move-jump_label_apply_nops-declaration-to-header.patch removed from -mm tree
Message-Id: <20231211012340.5EA4DC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mips: move jump_label_apply_nops() declaration to header
has been removed from the -mm tree.  Its filename was
     mips-move-jump_label_apply_nops-declaration-to-header.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mips: move jump_label_apply_nops() declaration to header
Date: Mon, 4 Dec 2023 12:56:58 +0100

Instead of an extern declaration in the C file with the caller, move it to
an appropriate header, avoiding

arch/mips/kernel/jump_label.c:93:6: error: no previous prototype for 'jump_label_apply_nops' [-Werror=missing-prototypes]

Link: https://lkml.kernel.org/r/20231204115710.2247097-9-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@rothwell.id.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/jump_label.h |    3 +++
 arch/mips/kernel/module.c          |    3 +--
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/arch/mips/include/asm/jump_label.h~mips-move-jump_label_apply_nops-declaration-to-header
+++ a/arch/mips/include/asm/jump_label.h
@@ -15,6 +15,9 @@
 #include <linux/types.h>
 #include <asm/isa-rev.h>
 
+struct module;
+extern void jump_label_apply_nops(struct module *mod);
+
 #define JUMP_LABEL_NOP_SIZE 4
 
 #ifdef CONFIG_64BIT
--- a/arch/mips/kernel/module.c~mips-move-jump_label_apply_nops-declaration-to-header
+++ a/arch/mips/kernel/module.c
@@ -20,8 +20,7 @@
 #include <linux/kernel.h>
 #include <linux/spinlock.h>
 #include <linux/jump_label.h>
-
-extern void jump_label_apply_nops(struct module *mod);
+#include <asm/jump_label.h>
 
 struct mips_hi16 {
 	struct mips_hi16 *next;
_

Patches currently in -mm which might be from arnd@arndb.de are

kexec-fix-kexec_file-dependencies.patch
kexec-fix-kexec_file-dependencies-fix.patch
kexec-select-crypto-from-kexec_file-instead-of-depending-on-it.patch
makefileextrawarn-turn-on-missing-prototypes-globally.patch


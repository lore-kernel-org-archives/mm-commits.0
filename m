Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9901F7493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i7l7cEpn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61CA4C433C9;
	Mon, 11 Dec 2023 01:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257816;
	bh=/3C2ixC4sr2mA3k7s/z2eSgEqzKMXQMcKXN2VC1Wdsc=;
	h=Date:To:From:Subject:From;
	b=i7l7cEpn7r7qRQUDrx7s97BQEpGw1PVWfRmhN4QL9ut5I/OE5n97O25HbNje/5d1w
	 UDYaXw74UN6au5sqw3AEwnMPrgrXcG4y2WXAzHQPrFt3UuLs5C28O6Twp0rKhS6X1y
	 V+/+kwQzyFIxS7Bpz8xbwFxkqFi7wb05CLXDrqjo=
Date: Sun, 10 Dec 2023 17:23:35 -0800
To: mm-commits@vger.kernel.org,tsbogend@alpha.franken.de,sfr@rothwell.id.au,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mips-signal-move-sigcontext-declarations-to-header.patch removed from -mm tree
Message-Id: <20231211012336.61CA4C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mips: signal: move sigcontext declarations to header
has been removed from the -mm tree.  Its filename was
     mips-signal-move-sigcontext-declarations-to-header.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mips: signal: move sigcontext declarations to header
Date: Mon, 4 Dec 2023 12:56:55 +0100

Function declarations should be in a shared header to ensure the
prototypes match the definition:

arch/mips/kernel/signal.c:439:5: error: no previous prototype for 'setup_sigcontext' [-Werror=missing-prototypes]
arch/mips/kernel/signal.c:516:5: error: no previous prototype for 'restore_sigcontext' [-Werror=missing-prototypes]

Link: https://lkml.kernel.org/r/20231204115710.2247097-6-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@rothwell.id.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/signal-common.h |    3 +++
 arch/mips/kernel/signal_n32.c    |    3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/mips/kernel/signal-common.h~mips-signal-move-sigcontext-declarations-to-header
+++ a/arch/mips/kernel/signal-common.h
@@ -40,4 +40,7 @@ _restore_fp_context(void __user *fpregs,
 extern asmlinkage int _save_msa_all_upper(void __user *buf);
 extern asmlinkage int _restore_msa_all_upper(void __user *buf);
 
+extern int setup_sigcontext(struct pt_regs *, struct sigcontext __user *);
+extern int restore_sigcontext(struct pt_regs *, struct sigcontext __user *);
+
 #endif	/* __SIGNAL_COMMON_H */
--- a/arch/mips/kernel/signal_n32.c~mips-signal-move-sigcontext-declarations-to-header
+++ a/arch/mips/kernel/signal_n32.c
@@ -33,9 +33,6 @@
  */
 #define __NR_N32_restart_syscall	6214
 
-extern int setup_sigcontext(struct pt_regs *, struct sigcontext __user *);
-extern int restore_sigcontext(struct pt_regs *, struct sigcontext __user *);
-
 struct ucontextn32 {
 	u32		    uc_flags;
 	s32		    uc_link;
_

Patches currently in -mm which might be from arnd@arndb.de are

kexec-fix-kexec_file-dependencies.patch
kexec-fix-kexec_file-dependencies-fix.patch
kexec-select-crypto-from-kexec_file-instead-of-depending-on-it.patch
makefileextrawarn-turn-on-missing-prototypes-globally.patch


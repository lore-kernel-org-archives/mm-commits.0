Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0EB2AEFE
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 03:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733800244; cv=none; b=X7c04q93kwpFx2O0M06bbYjnP415Bti2IiZsrJj8B0WC7g5GcNAJnP3UXEaLjM4Zc0GO5OVtCk0ArOBpM4b3llPVeP7c718kDEcE4FBU2O5pdFWya/H91RE/wXOH5Ss8c/QnqrBrYuAy7eS9z/9CMDcdn0NbkiuM6g0jvIueePQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733800244; c=relaxed/simple;
	bh=hotXKuhBoL9UpRkbcVnl945sO4Poh12mTvi0qy5Z4VY=;
	h=Date:To:From:Subject:Message-Id; b=kNWwtibwjMhV2R2eBpPYUO1v0gwYVzCYoKBSIR4Kr3oqZpfvpQgc8R2Q/0i2RX33WnurT40iKBqKehBQxenyrwI+tqdZJVkSCmBfJJAeTxMAOiSkb7HO3ud1bPlzBeENerpcZKJpWaTXiX4K6+Voik8vQ3E4kT12UuhAHNpHxvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AN40ma/q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AN40ma/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B8FC4CED1;
	Tue, 10 Dec 2024 03:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733800244;
	bh=hotXKuhBoL9UpRkbcVnl945sO4Poh12mTvi0qy5Z4VY=;
	h=Date:To:From:Subject:From;
	b=AN40ma/qzyP22Ux0TtLkP4Bmkl8edZkCsmSjo1/4gvlPd3TdX1tOQN0xjfcv1KNX2
	 o8ZNZw8cgQ0GeVvZl/hB8kv6gkw6n/nyjdRDfuoJlYjsZWUDMOmng4ogSt1dwJgpSH
	 rEzrnWOqESHSNz0XxfOluz8dTrCKYeVJrgVahNFE=
Date: Mon, 09 Dec 2024 19:10:43 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,kees@kernel.org,catalin.marinas@arm.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-execmem-make-arch_wants_execmem_late-depend-on-execmem.patch added to mm-unstable branch
Message-Id: <20241210031044.23B8FC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/execmem: make ARCH_WANTS_EXECMEM_LATE depend on EXECMEM
has been added to the -mm mm-unstable branch.  Its filename is
     mm-execmem-make-arch_wants_execmem_late-depend-on-execmem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-execmem-make-arch_wants_execmem_late-depend-on-execmem.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/execmem: make ARCH_WANTS_EXECMEM_LATE depend on EXECMEM
Date: Mon, 9 Dec 2024 08:42:51 +0530

Late initialisation of EXECMEM inherently requires EXECMEM itself, and
hence this dependency should not be left with the subscribing platforms.

Link: https://lkml.kernel.org/r/20241209031251.515903-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig       |    1 +
 arch/arm64/Kconfig |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm64/Kconfig~mm-execmem-make-arch_wants_execmem_late-depend-on-execmem
+++ a/arch/arm64/Kconfig
@@ -113,7 +113,7 @@ config ARM64
 	select ARCH_WANT_FRAME_POINTERS
 	select ARCH_WANT_HUGE_PMD_SHARE if ARM64_4K_PAGES || (ARM64_16K_PAGES && !ARM64_VA_BITS_36)
 	select ARCH_WANT_LD_ORPHAN_WARN
-	select ARCH_WANTS_EXECMEM_LATE if EXECMEM
+	select ARCH_WANTS_EXECMEM_LATE
 	select ARCH_WANTS_NO_INSTR
 	select ARCH_WANTS_THP_SWAP if ARM64_4K_PAGES
 	select ARCH_HAS_UBSAN
--- a/arch/Kconfig~mm-execmem-make-arch_wants_execmem_late-depend-on-execmem
+++ a/arch/Kconfig
@@ -1058,6 +1058,7 @@ config ARCH_WANTS_MODULES_DATA_IN_VMALLO
 
 config ARCH_WANTS_EXECMEM_LATE
 	bool
+	depends on EXECMEM
 	help
 	  For architectures that do not allocate executable memory early on
 	  boot, but rather require its initialization late when there is
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-execmem-make-arch_wants_execmem_late-depend-on-execmem.patch


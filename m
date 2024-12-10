Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCDA1D88BE
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 04:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733803334; cv=none; b=dkc6hkwEAokOWbgKC+VNzT5y1UQs7C9lRPlbk8yS85lZj4g/T6Vv+qvHUbzBffd3JC/J82AQYgXCoxvN85F67NumxfaQ0ZavwpuK52jjPMj2RGENAu0vbj5dilZLO0moPlYJTktFPRJvLv6LRxyB4e20nrN2EOATvLLk9mvocDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733803334; c=relaxed/simple;
	bh=s0F/+k6Ds/IgyOiHxuLvBsJuP3vsTodiTwgXfG5QReE=;
	h=Date:To:From:Subject:Message-Id; b=lnhG1FHoKn0yd5CPg2HeXUvYzghe8tJvDMfwNP2NNHh/0H2sKBKlOyVK/l6IYDEmd1G+aDFnpZsI0WuvzqKrQb9lnmU7Ok4Ey/b57ZrKIHtSSpPGbJ7alS1Q3pk6ilxYcjwoh1VndfZSLkY/WN71jBy9ZkL6wl8GfT2AyXmSAM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nNWlG5ns; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nNWlG5ns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65C8C4CED6;
	Tue, 10 Dec 2024 04:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733803333;
	bh=s0F/+k6Ds/IgyOiHxuLvBsJuP3vsTodiTwgXfG5QReE=;
	h=Date:To:From:Subject:From;
	b=nNWlG5nsaastgUIeQLVuefJB8H9CSaRYSEmULWH1ih8F3EyePYHSvPyfUd/yITUhU
	 81grSs4so3bBb/zN865rXcB6OwKLfBoPNR5B1rcivdnOkX1iRolbVtxeWjgXdMaLBM
	 0ir/WSy5TpAdltQEQT739B89PJA5k+Qra647cps0=
Date: Mon, 09 Dec 2024 20:02:13 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,kees@kernel.org,catalin.marinas@arm.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-execmem-make-arch_wants_execmem_late-depend-on-execmem.patch removed from -mm tree
Message-Id: <20241210040213.A65C8C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/execmem: make ARCH_WANTS_EXECMEM_LATE depend on EXECMEM
has been removed from the -mm tree.  Its filename was
     mm-execmem-make-arch_wants_execmem_late-depend-on-execmem.patch

This patch was dropped because an updated version will be issued

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



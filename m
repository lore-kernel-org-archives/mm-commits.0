Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D0027FB3A
	for <mm-commits@vger.kernel.org>; Sat,  6 Dec 2025 22:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765058814; cv=none; b=aqMg+m5yFOyzi8vkj8bxbU/c8JZMVeXmBXCJvr5VE9ZIOXxQDCVJkxAJGadWH8Z7c+ddzFnqRDZoRpaoaAGnV/p1dqtGaL8FFYckJItbIulCWae8f9P5EXX+ZvHvIxqMYE52L2TG5cGRMA4ZSXOCloPTdFHbyfHk+gUZSChLdBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765058814; c=relaxed/simple;
	bh=nJgqAm8mJRGrSjuG4X2Wxg1TY6mVG3POz0EqyEdme04=;
	h=Date:To:From:Subject:Message-Id; b=adjrZauiYCmo4D5mpjXL4hWz1StJIZFOAcIsNufiOyQzrWANXLITeOdAUt4xz06joWQdLtV7QH9rddSlokzAUZe75ooSDIeO3O75IP6wHaPWxpnwEBHap5hY+Wa/5JVrdR/gDD3VuranbZMdvwGmKyW/M6OshaWBzUlCq39jyb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cZEnYMV1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cZEnYMV1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7961C4CEF5;
	Sat,  6 Dec 2025 22:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765058813;
	bh=nJgqAm8mJRGrSjuG4X2Wxg1TY6mVG3POz0EqyEdme04=;
	h=Date:To:From:Subject:From;
	b=cZEnYMV14K3QzLXAPTMu7yOFwC6Xi/HMu5dDY4TN+PSkRnz05TXFWDFMoAZWRtHru
	 jLaaMEjuC7cMHCIR7SlRhLxLGnTtQtz04cPv4iuz9WJRLQBx/i1PtkCS5ALhdjcTu9
	 2mWozYN2brg/sDbxf/C5UlOSGw/DSjqqqkVS12u8=
Date: Sat, 06 Dec 2025 14:06:53 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd_luo-add-config_shmem-dependency.patch added to mm-nonmm-unstable branch
Message-Id: <20251206220653.D7961C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memfd_luo: add CONFIG_SHMEM dependency
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mm-memfd_luo-add-config_shmem-dependency.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memfd_luo-add-config_shmem-dependency.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm: memfd_luo: add CONFIG_SHMEM dependency
Date: Thu, 4 Dec 2025 11:01:58 +0100

The new memfd code fails to link without SHMEM:

aarch64-linux-ld: mm/memfd_luo.o: in function `memfd_luo_retrieve_folios':
memfd_luo.c:(.text.memfd_luo_retrieve_folios+0xdc): undefined reference to `shmem_add_to_page_cache'
memfd_luo.c:(.text.memfd_luo_retrieve_folios+0x11c): undefined reference to `shmem_inode_acct_blocks'
memfd_luo.c:(.text.memfd_luo_retrieve_folios+0x134): undefined reference to `shmem_recalc_inode'

Add a Kconfig dependency to disallow that configuration.

Link: https://lkml.kernel.org/r/20251204100203.1034394-1-arnd@kernel.org
Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/liveupdate/Kconfig~mm-memfd_luo-add-config_shmem-dependency
+++ a/kernel/liveupdate/Kconfig
@@ -54,6 +54,7 @@ config KEXEC_HANDOVER_ENABLE_DEFAULT
 config LIVEUPDATE
 	bool "Live Update Orchestrator"
 	depends on KEXEC_HANDOVER
+	depends on SHMEM
 	help
 	  Enable the Live Update Orchestrator. Live Update is a mechanism,
 	  typically based on kexec, that allows the kernel to be updated
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-damon-tests-core-kunit-avoid-damos_test_commit-stack-warning.patch
mm-shmem-avoid-build-warning-for-config_shmem=n.patch
mm-memfd_luo-add-config_shmem-dependency.patch


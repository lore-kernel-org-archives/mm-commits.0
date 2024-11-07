Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A3E1D4337
	for <mm-commits@vger.kernel.org>; Thu,  7 Nov 2024 22:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731017779; cv=none; b=Kdi/0UR+4qoFFAfNwWrlfCYQHYgmu04Vz/4qpF65A3mtaxoNam1y6hJXl5EmsJpCsEd+LcpYFkUfmmnvxhncb6R8eP3Fcgsf8ecjX90YSN/iT3OOHLkIo+8j2DKd58lFNbxBrzt3JmAhh0jd2PHp2QOqoM0hoTk9elEjEh02JTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731017779; c=relaxed/simple;
	bh=wxKgMsGmkK+4tOqDazdQJnHmXKtiyT3uSPXxRCjRpkk=;
	h=Date:To:From:Subject:Message-Id; b=YfnNiU9irwi5v/zUp1Bl9UXjaOmH8xj71w1vcNX875ob7q4W9Gd8AR+wjxHHE7tTIpusc3qG4978uXPA4VcpkYh1SdbF40rwetykNdIn+CgSdWt7cbBIkO+vQAF0GOR/OuJnR0B4VuVbKaxSMkouKKykB/OFff7yxhRQfhBYqb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sDtMxMTP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sDtMxMTP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5CFC4CECC;
	Thu,  7 Nov 2024 22:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731017779;
	bh=wxKgMsGmkK+4tOqDazdQJnHmXKtiyT3uSPXxRCjRpkk=;
	h=Date:To:From:Subject:From;
	b=sDtMxMTPWf6bF+3i8A+/K2rJhkvI3lcRcuOP4iSDazwsCNiUekIGsYSfP5TfW9d18
	 hpSck7RqeG7DZi5XQBujh9zDozf1GCxsYCiAbcdOVB+PSfDqLfqXq6ulwxkNMuDbDM
	 JAWE891/LppWKBxNtThlRGcuagiLjzSr6DKExJD8=
Date: Thu, 07 Nov 2024 14:16:18 -0800
To: mm-commits@vger.kernel.org,nathan@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] x86-module-prepare-module-loading-for-rox-allocations-of-text-fix.patch removed from -mm tree
Message-Id: <20241107221619.7B5CFC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/alternatives: fix writable address in cfi_rewrite_endbr()
has been removed from the -mm tree.  Its filename was
     x86-module-prepare-module-loading-for-rox-allocations-of-text-fix.patch

This patch was dropped because it was folded into x86-module-prepare-module-loading-for-rox-allocations-of-text.patch

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: x86/alternatives: fix writable address in cfi_rewrite_endbr()
Date: Tue, 5 Nov 2024 10:49:57 +0200

Commit ("x86/module: prepare module loading for ROX allocations of text")
missed the offset that should be added to the writable address passed to
poison_endbr() from cfi_rewrite_endbr() and this causes boot failures on
kernels running with cfi=fineibt on machines that support IBT.

Add required offset to wr_addr argument to fix the issue.

Link: https://lkml.kernel.org/r/ZysRwR29Ji8CcbXc@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reported-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/alternative.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/alternative.c~x86-module-prepare-module-loading-for-rox-allocations-of-text-fix
+++ a/arch/x86/kernel/alternative.c
@@ -1241,7 +1241,7 @@ static void cfi_rewrite_endbr(s32 *start
 		void *addr = (void *)s + *s;
 		void *wr_addr = module_writable_address(mod, addr);
 
-		poison_endbr(addr+16, wr_addr, false);
+		poison_endbr(addr + 16, wr_addr + 16, false);
 	}
 }
 
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-vmalloc-group-declarations-depending-on-config_mmu-together.patch
mm-vmalloc-dont-account-for-number-of-nodes-for-huge_vmap-allocations.patch
asm-generic-introduce-text-patchingh.patch
module-prepare-to-handle-rox-allocations-for-text.patch
arch-introduce-set_direct_map_valid_noflush.patch
x86-module-prepare-module-loading-for-rox-allocations-of-text.patch
execmem-add-support-for-cache-of-large-rox-pages.patch
x86-module-enable-rox-caches-for-module-text-on-64-bit.patch


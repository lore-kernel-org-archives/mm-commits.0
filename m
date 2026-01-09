Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E09F279DC3
	for <mm-commits@vger.kernel.org>; Fri,  9 Jan 2026 15:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767974006; cv=none; b=dQGP6EHQAnfaaiUczl8wGlL31xVMFrb/3hkIQjmfbpWHfjKz7z+GDnNvPMEzOxV6FZiPN7nYoWr8NQY7DLGHG4jXH8BnL781T4hHT1uM5ZuCNhc9H7KCF2mO7EtIgcOwlhHY15Y94ARbKYEzcjD/9KiF5Gma/wDJSh5mWf9JRd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767974006; c=relaxed/simple;
	bh=gYx7UxQ/e6g9SdVBD9ABY4AJMQRbzfMDfYJTEZmef/k=;
	h=Date:To:From:Subject:Message-Id; b=qawPDNYkLC7vZ78R0+2KtkYkNOlzuSKPNdQqGP48YGQlOdfqutGIcpikav3CZlqad6QBSbfoEilZhd6krPZFkuZHrbbxC4ifIFcIUrqqa4nIUD4h55XsYt2IwXR+X+oyqdMhr1x1V3lY/RX/JXDZTiGK1NOnlseq3vkkMZ0JAeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w4U8QLt6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w4U8QLt6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90BE5C4CEF1;
	Fri,  9 Jan 2026 15:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767974005;
	bh=gYx7UxQ/e6g9SdVBD9ABY4AJMQRbzfMDfYJTEZmef/k=;
	h=Date:To:From:Subject:From;
	b=w4U8QLt6dYCr2qfliRvADDEBUo1S2W1bm2YWjv6z+nS3+JQ/DJX/A5WTTL87lP+p0
	 ZdU0/7+d0hpbeqqB9e6HQ4OMiW4lnb5fbI0CpCP1nMb71EWqccLCRHDcivgVmRHYuz
	 GQlcZDkIZC4c9eRwD69W5auPmFoAkVmr6OQu5TSE=
Date: Fri, 09 Jan 2026 07:53:24 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,hewenliang4@huawei.com,graf@amazon.com,longwei27@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-test-clean-up-residual-memory-upon-test_kho-module-unload.patch added to mm-nonmm-unstable branch
Message-Id: <20260109155325.90BE5C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: test: clean up residual memory upon test_kho module unload
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-test-clean-up-residual-memory-upon-test_kho-module-unload.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-test-clean-up-residual-memory-upon-test_kho-module-unload.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Long Wei <longwei27@huawei.com>
Subject: kho: test: clean up residual memory upon test_kho module unload
Date: Wed, 7 Jan 2026 10:24:27 +0800

During the initialization phase, the test_kho module invokes the
kho_preserve_folio function, which internally configures bitmaps within
kho_mem_track and establishes chunk linked lists in KHO.  Upon unloading
the test_kho module, it is necessary to clean up these states.

Link: https://lkml.kernel.org/r/20260107022427.4114424-1-longwei27@huawei.com
Signed-off-by: Long Wei <longwei27@huawei.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: hewenliang <hewenliang4@huawei.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kho.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/lib/test_kho.c~kho-test-clean-up-residual-memory-upon-test_kho-module-unload
+++ a/lib/test_kho.c
@@ -340,11 +340,15 @@ module_init(kho_test_init);
 
 static void kho_test_cleanup(void)
 {
+	/* unpreserve and free the data stored in folios */
+	kho_test_unpreserve_data(&kho_test_state);
 	for (int i = 0; i < kho_test_state.nr_folios; i++)
 		folio_put(kho_test_state.folios[i]);
 
 	kvfree(kho_test_state.folios);
-	vfree(kho_test_state.folios_info);
+
+	/* Unpreserve and release the FDT folio */
+	kho_unpreserve_folio(kho_test_state.fdt);
 	folio_put(kho_test_state.fdt);
 }
 
_

Patches currently in -mm which might be from longwei27@huawei.com are

kho-test-clean-up-residual-memory-upon-test_kho-module-unload.patch


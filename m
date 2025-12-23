Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D41034B41C
	for <mm-commits@vger.kernel.org>; Tue, 23 Dec 2025 19:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766517872; cv=none; b=jgAZKSKvE64pX94fmH3+cmb+9B/xWNxDn36zdT3bxTn5ITx3DpfYbkF6MYJ45kpBUgygcSUgZj1D5bnmoYlzvuVpDWMiNdE3wJ4ui5kat5oVwT9vDmCrPwy/HsXHmorBnKDXsXisPAy6LgHjp+v30AIBhMmzkyiATC/qY2pa//M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766517872; c=relaxed/simple;
	bh=gBXzQSoS622GkUMwg5tVblpkLbivFUxjwLaH1x/m3j8=;
	h=Date:To:From:Subject:Message-Id; b=iPLlLLhzZcyKlUC1r0N6Q9xe9MLbA/l1l48RemgEzvJFyGPWboDtUWKOn/4fxVnDgn/ntQPaZ8y1+SKCCM43j3+GGBTDXAB2VZGe+fWeJpnfpA2F0IPqSi80aViRSB1zPxuxeqbr010JdslS0EBPwJWK9sPoU+zaek3YSStCBZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o1UbbJOO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o1UbbJOO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA6C6C113D0;
	Tue, 23 Dec 2025 19:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766517871;
	bh=gBXzQSoS622GkUMwg5tVblpkLbivFUxjwLaH1x/m3j8=;
	h=Date:To:From:Subject:From;
	b=o1UbbJOOqwVAldHglr5xJpCUlqZQN3nE9y3SF0oj6Sk4A8eMeYVDJYjGN3tf4eMQY
	 8HmlZhf05fj+/a7aglrx3kfDh8AbQ7tuzWkSV2+IbKyULGOmKbaOPisPxxtXeNP10U
	 49CsWROjHxSWsgn5rlnt6D7blxC+uiP13qbk5FVA=
Date: Tue, 23 Dec 2025 11:24:31 -0800
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,pedrodemargomes@gmail.com,david@kernel.org,chengming.zhou@linux.dev,sashal@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-ksm-fix-pte_unmap_unlock-of-wrong-address-in-break_ksm_pmd_entry.patch removed from -mm tree
Message-Id: <20251223192431.BA6C6C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ksm: fix pte_unmap_unlock of wrong address in break_ksm_pmd_entry
has been removed from the -mm tree.  Its filename was
     mm-ksm-fix-pte_unmap_unlock-of-wrong-address-in-break_ksm_pmd_entry.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sasha Levin <sashal@kernel.org>
Subject: mm/ksm: fix pte_unmap_unlock of wrong address in break_ksm_pmd_entry
Date: Sat, 20 Dec 2025 15:29:26 -0500

On ARM32 with HIGHMEM/HIGHPTE, break_ksm_pmd_entry() triggers a BUG during
KSM unmerging because pte_unmap_unlock() is passed a pointer that may be
beyond the mapped PTE page.

The issue occurs when the PTE iteration loop completes without finding a
KSM page.  After the loop, 'ptep' has been incremented past the last PTE
entry.  On ARM32 LPAE with 512 PTEs per page (512 * 8 = 4096 bytes), this
means ptep points to the next page, outside the kmap'd region.

When pte_unmap_unlock(ptep, ptl) calls kunmap_local(ptep), it unmaps the
wrong page address, leaving the original kmap slot still mapped.  The next
kmap_local then finds this slot unexpectedly occupied:

  WARNING: mm/highmem.c:622 kunmap_local_indexed  (address mismatch)
  kernel BUG at mm/highmem.c:564  __kmap_local_pfn_prot  (slot not empty)

Fix this by passing start_ptep to pte_unmap_unlock(), which always points
within the originally mapped PTE page.

Reproducer: Run LTP ksm03 test on ARM32 with HIGHMEM enabled.  The test
triggers KSM merging followed by unmerging (writing 0 then 2 to
/sys/kernel/mm/ksm/run), which exercises break_ksm_pmd_entry().

Link: https://lkml.kernel.org/r/20251220202926.318366-1-sashal@kernel.org
Fixes: 5d4939fc2258 ("ksm: perform a range-walk in break_ksm")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Assisted-by: claude-opus-4-5-20251101
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/ksm.c~mm-ksm-fix-pte_unmap_unlock-of-wrong-address-in-break_ksm_pmd_entry
+++ a/mm/ksm.c
@@ -650,7 +650,7 @@ static int break_ksm_pmd_entry(pmd_t *pm
 		}
 	}
 out_unlock:
-	pte_unmap_unlock(ptep, ptl);
+	pte_unmap_unlock(start_ptep, ptl);
 	return found;
 }
 
_

Patches currently in -mm which might be from sashal@kernel.org are



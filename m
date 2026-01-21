Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44EB35CBB3
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966063; cv=none; b=sBMmyZFkXH+HdYzAU8DN4aFbafmRvDk2nrL5rnL5CdzmWxd4BxTezUMsxYXLY5sIyHCAypIWAwrM9M4kRyJK/otbIfoANXd4JQBD0oXpzBCPIVvBsUbyt5wYfN3TXn7lPpbxzLHrBPassixlpSVVZssBhyq/uheMdLNDootJ6D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966063; c=relaxed/simple;
	bh=JZ06DjekpmxqNPhCG++oAi24Oi9ur+VOQ3fssQ1zpoc=;
	h=Date:To:From:Subject:Message-Id; b=ikqGvgyAW5uqeAmw/qS7FjjFu+bwf5R6tyTIAkUIfVjIQahbmU9XD4ZN1CR3QONamAM/mq6UbZgayHZHBJ9t31f0t8YCGLJRvEyUENCv9xzXBCdkOewrTwip94Sqn8+Pa3STFv/Vf+2K0nhDNTziqH8phInEPwiu+orWAdfHgRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=It1n1fZk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="It1n1fZk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB3DC16AAE;
	Wed, 21 Jan 2026 03:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966062;
	bh=JZ06DjekpmxqNPhCG++oAi24Oi9ur+VOQ3fssQ1zpoc=;
	h=Date:To:From:Subject:From;
	b=It1n1fZkcPWqi6H9q616vlJ5FrqSfHApUne5UXA/Varw9kMgYo6r3lDqBgfvTOdtk
	 h5UgHUu7rwoyBa523PZAZsPKYOkb3Bb0zTtc2rEfDh/eDCcgymhY7M0mV1X7A06M1m
	 qgz223UDhCE2rh7Q9WcKWSSAqe3fXH4dCyotkpCc=
Date: Tue, 20 Jan 2026 19:27:42 -0800
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,kaushlendra.kumar@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-mm-thp_swap_allocator_test-fix-small-folio-alignment.patch removed from -mm tree
Message-Id: <20260121032742.BAB3DC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/mm/thp_swap_allocator_test: fix small folio alignment
has been removed from the -mm tree.  Its filename was
     tools-mm-thp_swap_allocator_test-fix-small-folio-alignment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Subject: tools/mm/thp_swap_allocator_test: fix small folio alignment
Date: Tue, 9 Dec 2025 08:47:45 +0530

Use ALIGNMENT_SMALLFOLIO instead of ALIGNMENT_MTHP when allocating small
folios to ensure correct memory alignment for the test case.

Before: test allocates small folios with 64KB alignment
(ALIGNMENT_MTHP) when only 4KB alignment (ALIGNMENT_SMALLFOLIO) is
needed.  This wastes address space and may cause allocation failures on
systems with fragmented memory.

Worst-case impact: this only affects thp_swap_allocator_test tool
behavior.

Link: https://lkml.kernel.org/r/20251209031745.2723120-1-kaushlendra.kumar@intel.com
Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/thp_swap_allocator_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/mm/thp_swap_allocator_test.c~tools-mm-thp_swap_allocator_test-fix-small-folio-alignment
+++ a/tools/mm/thp_swap_allocator_test.c
@@ -142,7 +142,7 @@ int main(int argc, char *argv[])
 	}
 
 	if (use_small_folio) {
-		mem2 = aligned_alloc_mem(MEMSIZE_SMALLFOLIO, ALIGNMENT_MTHP);
+		mem2 = aligned_alloc_mem(MEMSIZE_SMALLFOLIO, ALIGNMENT_SMALLFOLIO);
 		if (mem2 == NULL) {
 			fprintf(stderr, "Failed to allocate small folios memory\n");
 			free(mem1);
_

Patches currently in -mm which might be from kaushlendra.kumar@intel.com are



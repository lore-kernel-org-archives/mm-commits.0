Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70E71D90DD
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 03:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765855901; cv=none; b=DVwlA5awnsy1ZOj68pGNeNFCrBBRyVlMOlz7QcYWydJXBOybrFrP008ngYULMCsGwygocmr+SjJGZ/2pA11Me25e+SGxEJDyB4h4mI9fFMqaBgQUSJT0XDN5Xscd9Q2/K9x8OAvWMlMI8CYV4DXEVtdDoXP1XL3a9GIcI0fUPUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765855901; c=relaxed/simple;
	bh=kmiWC9BTlc91tONYvhvE+fWfU2zXC83oc9g/q6+o8Vc=;
	h=Date:To:From:Subject:Message-Id; b=tIvO6OVWM8ksOnSBXmqYxiirTkZK5KDBpoO9g1zNLZeIfTPyuSpqcV13Oj3O3p3sg/bO7ljuR4+j+QKokZDTaaHdk44MkSnGCGlzBmtCvHli73THGpgs64FXm6dpP6rZeMYVtowggaOxVPRuoUZ4sAIfwxBX/Dy2/VlXuOdOYco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mp7K2qwi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mp7K2qwi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B904C4CEFB;
	Tue, 16 Dec 2025 03:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765855901;
	bh=kmiWC9BTlc91tONYvhvE+fWfU2zXC83oc9g/q6+o8Vc=;
	h=Date:To:From:Subject:From;
	b=mp7K2qwi4MmkhNPw6PYDH46XTyodw/N92Gz/wJDWoHFpz6DkucrCC/OlUxfAjUXPk
	 RSkvsqeTkPri2GMrvbGy5H4z88UAYzRtq64CKeJWHPvw2B7W8xnfTZf8ayqF3C70Dn
	 NTlJuR6o28lthT7kmHRcAoAC1b/uZuQV1s3rioI4=
Date: Mon, 15 Dec 2025 19:31:40 -0800
To: mm-commits@vger.kernel.org,kaushlendra.kumar@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-thp_swap_allocator_test-fix-small-folio-alignment.patch added to mm-new branch
Message-Id: <20251216033141.2B904C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/mm/thp_swap_allocator_test: fix small folio alignment
has been added to the -mm mm-new branch.  Its filename is
     tools-mm-thp_swap_allocator_test-fix-small-folio-alignment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-thp_swap_allocator_test-fix-small-folio-alignment.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Subject: tools/mm/thp_swap_allocator_test: fix small folio alignment
Date: Tue, 9 Dec 2025 08:47:45 +0530

Use ALIGNMENT_SMALLFOLIO instead of ALIGNMENT_MTHP when allocating small
folios to ensure correct memory alignment for the test case.

Link: https://lkml.kernel.org/r/20251209031745.2723120-1-kaushlendra.kumar@intel.com
Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
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

tools-mm-page_owner_sort-fix-timestamp-comparison-for-stable-sorting.patch
tools-mm-thp_swap_allocator_test-fix-small-folio-alignment.patch


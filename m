Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AFFB258CE6
	for <mm-commits@vger.kernel.org>; Wed, 26 Feb 2025 21:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740606219; cv=none; b=BC9E7GiTsTI5CZnnM9xAkiT/Mbl5ELgDsb1SJBdTbzqs0Ya5TPf25BOXnTz+D6skFxAQnxrtPF3ujrqZFZUXffzwUxuAjlwpPedMfEvhj/tTcPrQwLi5+pg5oPfChmd0gKWMLQ0QU5Sv7Y0+lDliN+2ngYSLiuDTONGLwPFmbV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740606219; c=relaxed/simple;
	bh=0pGYn6K0fFtTaFGjsB8NFj1V8bJOTo3T56peQbwGdNM=;
	h=Date:To:From:Subject:Message-Id; b=kBaJBypMAHsBKJCCMtNl+IzAH31K2VeQdML9VnyrGxjKAaGDFWO+QVBA9ffVQ0nvOPuRdmHEWBeppu4s99cG0kRFz7kh1mqOLbuTqsXvucBB3O9yEas1ZgUb/gNBKpSmshMcOC89P9+nLHCyggWblnpxFpPErIbVr08AoynzKls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tyiN5h93; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tyiN5h93"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B5AC4CEE7;
	Wed, 26 Feb 2025 21:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740606219;
	bh=0pGYn6K0fFtTaFGjsB8NFj1V8bJOTo3T56peQbwGdNM=;
	h=Date:To:From:Subject:From;
	b=tyiN5h93iXHIVZPdFrOVmPpvGtm7UOoegASjGVzHrgHiTMvcY/L2dpTRCXv8qg7xp
	 ayy0H/z+9yDS05hJAutbjMEtfTHpZt1Q0y9l5Dy3CvRjGkdFtlpyQsmVrQIwHi2yXx
	 X2UGK1xcSrbQJOcIFLLrkW1fO5rUtt65ZOvpzQ3I=
Date: Wed, 26 Feb 2025 13:43:38 -0800
To: mm-commits@vger.kernel.org,djwong@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-assert-the-folio-is-locked-in-folio_start_writeback.patch added to mm-unstable branch
Message-Id: <20250226214338.E9B5AC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: assert the folio is locked in folio_start_writeback()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-assert-the-folio-is-locked-in-folio_start_writeback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-assert-the-folio-is-locked-in-folio_start_writeback.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: assert the folio is locked in folio_start_writeback()
Date: Wed, 26 Feb 2025 15:36:12 +0000

The folio must be locked when we start writeback in order to prevent
writeback from being started twice on the same folio.  I don't expect this
to catch any problems, but it should be good documentation.

Link: https://lkml.kernel.org/r/20250226153614.3774896-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/page-writeback.c~mm-assert-the-folio-is-locked-in-folio_start_writeback
+++ a/mm/page-writeback.c
@@ -3109,6 +3109,7 @@ void __folio_start_writeback(struct foli
 	int access_ret;
 
 	VM_BUG_ON_FOLIO(folio_test_writeback(folio), folio);
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 
 	if (mapping && mapping_use_writeback_tags(mapping)) {
 		XA_STATE(xas, &mapping->i_pages, folio_index(folio));
_

Patches currently in -mm which might be from willy@infradead.org are

dax-remove-access-to-page-index.patch
dax-use-folios-more-widely-within-dax.patch
fs-convert-block_commit_write-to-take-a-folio.patch
fs-remove-page_file_mapping.patch
fs-remove-folio_file_mapping.patch
mm-assert-the-folio-is-locked-in-folio_start_writeback.patch
ocfs2-use-memcpy_to_folio-in-ocfs2_symlink_get_block.patch
ocfs2-remove-reference-to-bh-b_page.patch


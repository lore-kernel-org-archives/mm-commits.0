Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306181F1319
	for <mm-commits@vger.kernel.org>; Mon, 19 May 2025 23:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747695920; cv=none; b=c+MiDdCQCXVEQuvI2YFlA4WWv9rTVrbja4bc3d/DK1GIS4bKg/mp7VbGf/6qOnRnFI62z6ngH4ViiguJwxEtohFXD+4p9S1qwvdp0ySOf2k4jcJX4k1HC45LL4zew1ibhtVPNB4+jv3uSOFQSNjWjhog8B/xWZevf95Prb/feBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747695920; c=relaxed/simple;
	bh=VZaIWsIGvffOxWIabTXILAoQRAJ7qiMpvapqCcEKoRI=;
	h=Date:To:From:Subject:Message-Id; b=s2g9kg7Wshq1hgDS9CVCi+iI+o11l0fCmAB7eRNN3FjCoKw07D5/q1Mo0yy/nNiwKAbdVRxVsMF4HcekmRqSScrEaPEZH0kwbqH+GQvGUcpg7QEdyiel8u5eqfTsw4CIQxNVZeGJ/OiIlgwXMKhM2cd/Prd6ERFqh+WndL+TmJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O0vIZJKP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O0vIZJKP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AAF9C4CEE4;
	Mon, 19 May 2025 23:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747695916;
	bh=VZaIWsIGvffOxWIabTXILAoQRAJ7qiMpvapqCcEKoRI=;
	h=Date:To:From:Subject:From;
	b=O0vIZJKPdSjlKCVBlv4CsJnPPpf2DiVGtczhehsh1xxIVm3QtGkMWNiPD5G8Eawl0
	 Y7ic61xdzQCXk/DrCJolhhmcQUXMWxeRaKygODyjrye+gxiviZ1HFH0p5w9Og9wvKs
	 NiTGWCht1DV5S2ePOYk2cNL/I2bt4Bumr1HJFtyc=
Date: Mon, 19 May 2025 16:05:16 -0700
To: mm-commits@vger.kernel.org,geert@linux-m68k.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + m68k-remove-use-of-page-index.patch added to mm-new branch
Message-Id: <20250519230516.9AAF9C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: m68k: remove use of page->index
has been added to the -mm mm-new branch.  Its filename is
     m68k-remove-use-of-page-index.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/m68k-remove-use-of-page-index.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: m68k: remove use of page->index
Date: Fri, 16 May 2025 16:13:29 +0100

Switch to using struct ptdesc to store the markbits which will allow us to
remove index from struct page.

Link: https://lkml.kernel.org/r/20250516151332.3705351-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/mm/motorola.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/m68k/mm/motorola.c~m68k-remove-use-of-page-index
+++ a/arch/m68k/mm/motorola.c
@@ -105,7 +105,8 @@ static struct list_head ptable_list[3] =
 
 #define PD_PTABLE(page) ((ptable_desc *)&(virt_to_page((void *)(page))->lru))
 #define PD_PAGE(ptable) (list_entry(ptable, struct page, lru))
-#define PD_MARKBITS(dp) (*(unsigned int *)&PD_PAGE(dp)->index)
+#define PD_PTDESC(ptable) (list_entry(ptable, struct ptdesc, pt_list))
+#define PD_MARKBITS(dp) (*(unsigned int *)&PD_PTDESC(dp)->pt_index)
 
 static const int ptable_shift[3] = {
 	7+2, /* PGD */
_

Patches currently in -mm which might be from willy@infradead.org are

highmem-add-folio_test_partial_kmap.patch
m68k-remove-use-of-page-index.patch
mm-rename-page-index-to-page-__folio_index.patch
ntfs3-use-folios-more-in-ntfs_compress_write.patch
iov-remove-copy_page_from_iter_atomic.patch


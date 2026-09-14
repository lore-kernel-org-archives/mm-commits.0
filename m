Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE9425E469
	for <mm-commits@vger.kernel.org>; Mon, 14 Sep 2026 00:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789347065; cv=none; b=r0r1NYmlPpySkOM+3HLNyoKOMsi7Z5R3yF4q3av70At2+C7bRyF+GYGE/SiCt12J9dhEHDnjBcWgL/0tQ9vX1N5s7BLIvLeP/FJ48mhti6aJy/ki+nqBy0gsWUuN6FUJv8GthuTDYGM/XjLc8dT9bXmXhWe/1bxTViH+NmwtGOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789347065; c=relaxed/simple;
	bh=vTZD0JMbqoMvpaOTdGjNwu2f34atw7VwB2cjjZeQBH8=;
	h=Date:To:From:Subject:Message-Id; b=Tonzrp2u5TO0iF61aDiSNN6WOrTw2ES0UJTT4+9xxwn5huYMIg8B/ljXQnCAFtZbfDlvZ576Jklq1EtZb4ZRtYMfeqxUjlQ5N1DX0hSBVlnKBckfaM6wkNOpOqdVRyVtAPGpFlP5cd5uqFV/Y3Juu4XMWFuf86+BFFtEf+8pDQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xpDM2Eyl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xpDM2Eyl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27081F000FF;
	Mon, 14 Sep 2026 00:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789347063;
	bh=CgZYaMiYg/1p85FU2HPO0jz8vsja2U0/txy76UcFcTU=;
	h=Date:To:From:Subject;
	b=xpDM2EylOa8xNg6dzUxAN3ayoYZ/oFWcyfTLgtK22hhEN9KjrYaHLECliJCm8ETl+
	 343S2q0jff1KnGFUJvGAakKb08lwQ0Xg6zuMHFmNmSOuUWxH57zOqGgADGVVT3wxmU
	 2bIhNZMuyl4A4qMEH2DT1f7Cow1nFT7RolD2ADBI=
Date: Sun, 13 Sep 2026 17:51:03 -0700
To: mm-commits@vger.kernel.org,david@kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-add-folio_swap_entry-and-folio_page_swap_entry-fix.patch added to mm-unstable branch
Message-Id: <20260914005103.C27081F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-swap-add-folio_swap_entry-and-folio_page_swap_entry-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-add-folio_swap_entry-and-folio_page_swap_entry-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-add-folio_swap_entry-and-folio_page_swap_entry-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm-swap-add-folio_swap_entry-and-folio_page_swap_entry-fix
Date: Sun, 13 Sep 2026 17:52:28 -0400

adjust the folio_swap_entry() kerneldoc summary, per David

Link: https://lore.kernel.org/20260913-folio_swap_entry-doc-fix-1@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
---

 include/linux/swap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/swap.h~mm-swap-add-folio_swap_entry-and-folio_page_swap_entry-fix
+++ a/include/linux/swap.h
@@ -273,7 +273,7 @@ struct swap_info_struct {
 };
 
 /**
- * folio_swap_entry - Return the swap entry for a page within a folio.
+ * folio_swap_entry - Return the swap entry at a page index within a folio.
  * @folio: The folio.
  * @idx: The index of the page within the folio.
  *
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-page_io-convert-write-completion-handlers-to-folios.patch
mm-remove-pagereclaim.patch
mm-page_io-use-swap-entries-directly-in-zeromap-helpers.patch
mm-page_io-rename-bio_associate_blkg_from_page.patch
mm-page_io-refer-to-folios-in-swap_writeout-comments.patch
mm-swap-rename-__swap_writepage-to-__swap_writeout.patch
mm-remove-unused-mark_page_reserved.patch
mm-remove-unused-totalram_pages_inc-and-totalram_pages_dec.patch
mm-remove-pagewriteback.patch
mm-swap-add-folio_swap_entry-and-folio_page_swap_entry.patch
mm-swap-add-folio_swap_entry-and-folio_page_swap_entry-fix.patch
mm-huge_memory-add-a-comment-to-the-open-coded-swap-entry.patch
mm-rmap-use-folio_page_swap_entry-in-ttu_anon_swapbacked_folio.patch
mm-zswap-use-folio_swap_entry-in-zswap_store_page.patch
mm-swapfile-use-folio_page_swap_entry.patch
arm64-mte-make-mte_save_tags-and-mte_restore_tags-static.patch
arm64-mte-pass-the-swap-entry-to-mte_save_tags.patch
mm-swap-remove-page_swap_entry.patch


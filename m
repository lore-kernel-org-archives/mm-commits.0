Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793640416;
	b=FrjDwexR2cZs8lgYnO+MhazpSCiEgHW1bJnLyaRezbZ6DOiqtuQ4oEA2KHIz9zaRGl5u
	 qjsQUOVDRlWFW8wLV+neUfU114bi/LLNHqGWEaROAAofgOt3mMRa2ccIHixberm4R80zL
	 w3kHr4eqsqM6zzPDsIA297xmQYm9ef1teLhklK6feiIMKcFFkYHELAcyqh3bODlNxWIb/
	 Jo2tmUvC9zmQYagVs4BJlztPBTsPXOtuNpFaJ1eU/HtlOYAFPMT6qEmNf7VYxPL6aWy0/
	 keUUBF0ApAj/fDgXTua2PbZMqLley1fUYv5Qnrrh+r4EtNa+YLgQj8P+bBfElE7yHjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793640416;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=tYfngvg7XT++PTXAkAj7iYdIkJ9HOL/wrOfCuyIiTzo=;
	b=uZNbKFMlp2gZolAH2OPrhalR4SIFDHj7lI2k+7vuTwHv0ZNAj9yg+Qk/GeGEumQ6HDml
	 0KZTxFY4CJhQPI0UyLG2A1DibBFY1wPEJ7Y0U4eLlM1a13TcesLrTznMzHs8vZ3knM1L/
	 N4pbaJsJu2qcixmDKx2CLBREaRVCkxDWnSaZ1kbdY+rWOqeYnv6nXux4fd5YsGzs3stxY
	 Zn57oZwYrWiH22afC8ke7y0C29YzuT0IinmnklxpJoLJa5xulN59k9Q8tbFgAn/YUut8s
	 t5uZ4P/uI2FsiJTmMZ7ZuzA5zk5ZoVnzsySEZS+J0/2OKu5yCCSLgYJpmTEpkUXUX/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GNaz5Hhm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D90A606BA72;
	Mon,  2 Nov 2026 17:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GNaz5Hhm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694BF1F00A17;
	Mon,  2 Nov 2026 17:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793640416;
	bh=tYfngvg7XT++PTXAkAj7iYdIkJ9HOL/wrOfCuyIiTzo=;
	h=Date:To:From:Subject;
	b=GNaz5HhmwDE1JItIUsfPm+ic7J+edAf3m8aaajVzpj/lnt0mDHInwzvcHoVDJwp9B
	 ZYZnppwpNXSs26WC3KLr22XFa+hFIqgWuSI587YrNDua4abDpT+NvgNwCTfUm6tBFj
	 6YbWbcq+mUSixzj4BpOC1on0GRe5WlELTq+HnANc=
Date: Mon, 02 Nov 2026 09:26:53 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,
	krystianmkaniewski@gmail.com,jack@suse.cz,david@kernel.org,
	jose.fernandez@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-stop-fault-around-when-the-walk-steps-back.patch added to mm-hotfixes-unstable branch
Message-Id: <20261102172656.694BF1F00A17@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/filemap: stop fault-around when the walk steps back
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-filemap-stop-fault-around-when-the-walk-steps-back.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-stop-fault-around-when-the-walk-steps-back.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
Subject: mm/filemap: stop fault-around when the walk steps back
Date: Sat, 31 Oct 2026 04:33:59 +0000

filemap_map_pages() can dereference a PTE pointer outside the page table
it locked.  KASAN has reported this as a use-after-free read [1].  The
same path can also write out of bounds.  When the stray entry reads as
none, the fault-around loop maps a page there with set_pte_range().

Its fault-around loop walks the page cache and moves vmf->pte by the
change in index.  A lower index moves it back.  xas_find() can step back
to a lower index when a multi-index entry is split during the walk.

[1] fixes xas_find(), but the loop still relies on the walk never stepping
back.  Stop the fault-around when the walk steps back.  ->fault() maps the
faulting page if the loop did not.

Link: https://lore.kernel.org/20261031-jf-mm-filemap-map-pages-lower-bound-v2-1-21029744e589@linux.dev
Link: https://lore.kernel.org/20260904121301.200049-1-krystianmkaniewski@gmail.com [1]
Fixes: 6b24ca4a1a8d ("mm: Use multi-index entries in the page cache")
Signed-off-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Krystian Kaniewski <krystianmkaniewski@gmail.com>
Cc: <stable@vger.kernel.org>
---

 mm/filemap.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/filemap.c~mm-filemap-stop-fault-around-when-the-walk-steps-back
+++ a/mm/filemap.c
@@ -3968,6 +3968,13 @@ vm_fault_t filemap_map_pages(struct vm_f
 		unsigned long end;
 		vm_fault_t map_ret;
 
+		/* A lower index could move vmf->pte out of its page table. */
+		if (unlikely(xas.xa_index < last_pgoff)) {
+			folio_unlock(folio);
+			folio_put(folio);
+			break;
+		}
+
 		addr += (xas.xa_index - last_pgoff) << PAGE_SHIFT;
 		vmf->pte += xas.xa_index - last_pgoff;
 		last_pgoff = xas.xa_index;
_

Patches currently in -mm which might be from jose.fernandez@linux.dev are

mm-filemap-stop-fault-around-when-the-walk-steps-back.patch


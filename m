Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B206C1A0BE0
	for <mm-commits@vger.kernel.org>; Thu,  2 Apr 2026 20:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775160954; cv=none; b=EvtpRNMUqUmYDfPfiYomN4XUpQv956C1djBBMTIu1gl8ZYFVmyf/9kgffBDKIy6M6nKALDgwOvlFghovhJdXDcq7JsERdYBGPzd91lhGLwa3lEvLpVU3Jlbd1AB9f3lPDtYU+FhP4y1jqjEuscnGYYkcvDArVF4GQKwLxmY8P98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775160954; c=relaxed/simple;
	bh=6DLKErAJLFfWiFWkDZAS0ygy/J7jTkJqn7oWZju4rNA=;
	h=Date:To:From:Subject:Message-Id; b=lNT/lv/ySoAv2v1CAOteAHD82jvkaqQ+86E7MD2jYoa1zx3rTLrLV8LyyPJrN+xjbJwxhoVjQA/EWhcMw08fzrtwNaIe9pHfRJ60XIQxczJ0XwC3ShzmKkt8Nt24k3FdGHpRoBK8EKvL5S8r7UoIg/5NTIwLpM5BrIS0lJku/kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dph2kalm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dph2kalm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4815BC116C6;
	Thu,  2 Apr 2026 20:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775160954;
	bh=6DLKErAJLFfWiFWkDZAS0ygy/J7jTkJqn7oWZju4rNA=;
	h=Date:To:From:Subject:From;
	b=dph2kalmhI84E6rXYA2OfSBuQdOSOS44p3257c0iSy2/beAU+gJK+YIEMmK0tdzKx
	 QfbRLy6zbyWkiI1G62vL6dp02/ThaL8ME6xcAvSW+ZwHAo2eS5RaeFSqTqlHCbO9P7
	 l7ngmE5oAeoRCvh61DzgL4hMOF+lMTN59kkzqnGw=
Date: Thu, 02 Apr 2026 13:15:53 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,neil@brown.name,kasong@tencent.com,david@kernel.org,chrisl@kernel.org,bhe@redhat.com,devnexen@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_io-use-sio-len-for-pswpin-accounting-in-sio_read_complete.patch added to mm-unstable branch
Message-Id: <20260402201554.4815BC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_io: use sio->len for PSWPIN accounting in sio_read_complete()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_io-use-sio-len-for-pswpin-accounting-in-sio_read_complete.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_io-use-sio-len-for-pswpin-accounting-in-sio_read_complete.patch

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
From: David Carlier <devnexen@gmail.com>
Subject: mm/page_io: use sio->len for PSWPIN accounting in sio_read_complete()
Date: Thu, 2 Apr 2026 07:14:07 +0100

sio_read_complete() uses sio->pages to account global PSWPIN vm events,
but sio->pages tracks the number of bvec entries (folios), not base pages.

While large folios cannot currently reach this path (SWP_FS_OPS and
SWP_SYNCHRONOUS_IO are mutually exclusive, and mTHP swap-in allocation is
gated on SWP_SYNCHRONOUS_IO), the accounting is semantically inconsistent
with the per-memcg path which correctly uses folio_nr_pages().

Use sio->len >> PAGE_SHIFT instead, which gives the correct base page
count since sio->len is accumulated via folio_size(folio).

Link: https://lkml.kernel.org/r/20260402061408.36119-1-devnexen@gmail.com
Signed-off-by: David Carlier <devnexen@gmail.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: NeilBrown <neil@brown.name>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_io.c~mm-page_io-use-sio-len-for-pswpin-accounting-in-sio_read_complete
+++ a/mm/page_io.c
@@ -497,7 +497,7 @@ static void sio_read_complete(struct kio
 			folio_mark_uptodate(folio);
 			folio_unlock(folio);
 		}
-		count_vm_events(PSWPIN, sio->pages);
+		count_vm_events(PSWPIN, sio->len >> PAGE_SHIFT);
 	} else {
 		for (p = 0; p < sio->pages; p++) {
 			struct folio *folio = page_folio(sio->bvec[p].bv_page);
_

Patches currently in -mm which might be from devnexen@gmail.com are

mm-hugetlb-restore-reservation-on-error-in-hugetlb_mfill_atomic_pte-resubmission-path.patch
mm-page_io-use-sio-len-for-pswpin-accounting-in-sio_read_complete.patch


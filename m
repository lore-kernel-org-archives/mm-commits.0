Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564921C8639
	for <mm-commits@vger.kernel.org>; Fri, 11 Apr 2025 22:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744411241; cv=none; b=oISUed8AXafADgp1b2ZUqNcXD0mv7T2U3Iw8TDpWf8Rmgbap2Nxgx2jV7D9WXvicS3/2kS5N4Sg/9+nvVucz4Wyah6xV1B+NOyHeyEd6sft/S6K03j09NTCLNSMolkFqBXFqDfRL71sn6OCkANpbKg11QLt1LezTeMq1PkABKM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744411241; c=relaxed/simple;
	bh=Vbk7RLiqEQkR/QRlv0rccGQrUJIG8Vnzdzen6gDKi/0=;
	h=Date:To:From:Subject:Message-Id; b=Cii77D5Sq7+qcYedMHOtl6SDt6f22HhKsyTIdCEAQZNRaYnLWQTwCcMZLnpqPXVKA3HDKx0slMUyWRTUrNLeSAnYzSnWq1K0kmsyPXPFlgZPBZ5d3nsU/B4sXUcAVWw8szuWY28xw6Xa8qRZVp9PZkT9sM0B2t2fpGh/AyIOQHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jk0IgRtM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jk0IgRtM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A328CC4CEE2;
	Fri, 11 Apr 2025 22:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744411239;
	bh=Vbk7RLiqEQkR/QRlv0rccGQrUJIG8Vnzdzen6gDKi/0=;
	h=Date:To:From:Subject:From;
	b=jk0IgRtM8W4ctnkhCCvWayX/VOt/w9AMrf61ZEMzguAJDG+h7joc3PJldnGIWS1gl
	 dz/wHbj9Hjo/Beuvizl2BmFtCm/Rvwdh9+vAxvhG1afjdzhsjIBciicmfixXB5mnA0
	 skaq1qYapKUOE2VpqRHAFJ/ImW5TxyLRyk+6mFJw=
Date: Fri, 11 Apr 2025 15:40:38 -0700
To: mm-commits@vger.kernel.org,yangge1116@126.com,wangkefeng.wang@huawei.com,david@redhat.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-set-active-flag-after-adding-the-folio-to-activate-fbatch.patch added to mm-new branch
Message-Id: <20250411224039.A328CC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap: set active flag after adding the folio to activate fbatch
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-set-active-flag-after-adding-the-folio-to-activate-fbatch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-set-active-flag-after-adding-the-folio-to-activate-fbatch.patch

This patch will later appear in the mm-new branch at
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
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: mm/swap: set active flag after adding the folio to activate fbatch
Date: Fri, 11 Apr 2025 16:28:57 +0800

We notiched a 12.3% performance regression for LibMicro pwrite testcase
due to commit 33dfe9204f29 ("mm/gup: clear the LRU flag of a page before
adding to LRU batch").

The testcase is executed as follows, and the file is tmpfs file.
  pwrite -E -C 200 -L -S -W -N "pwrite_t1k" -s 1k -I 500 -f $TFILE

this testcase writes 1KB (only one page) to the tmpfs and repeats this
step for many times.  The Flame graph shows the performance regression
comes from folio_mark_accessed() and workingset_activation().

folio_mark_accessed() is called for the same page for many times.  Before
the commit, each call will add the page to activate fbatch.  When the
fbatch is full, the fbatch is drained and the page is promoted to active
list.  And then, folio_mark_accessed() does nothing in later calls.

But after the commit, the folio clear lru flags after it is added to
activate fbatch.  After then, folio_mark_accessed will never call
folio_activate() again due to the page is without lru flag, and the fbatch
will not be full and the folio will not be marked active, later
folio_mark_accessed() calls will always call workingset_activation(),
leading to performance regression.

Besides, repeated workingset_age_nonresident() call before the folio is
drained from activate fbatch leads to unreasonable
lruvec->nonresident_age.

To fix it, set active flag after the folio is cleared lru flag when adding
the folio to activate fbatch.

Link: https://lkml.kernel.org/r/20250411082857.2426539-1-tujinjiang@huawei.com
Fixes: 33dfe9204f29 ("mm/gup: clear the LRU flag of a page before adding to LRU batch")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: yangge <yangge1116@126.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

--- a/mm/swap.c~mm-swap-set-active-flag-after-adding-the-folio-to-activate-fbatch
+++ a/mm/swap.c
@@ -175,6 +175,8 @@ static void folio_batch_move_lru(struct
 	folios_put(fbatch);
 }
 
+static void lru_activate(struct lruvec *lruvec, struct folio *folio);
+
 static void __folio_batch_add_and_move(struct folio_batch __percpu *fbatch,
 		struct folio *folio, move_fn_t move_fn,
 		bool on_lru, bool disable_irq)
@@ -184,6 +186,14 @@ static void __folio_batch_add_and_move(s
 	if (on_lru && !folio_test_clear_lru(folio))
 		return;
 
+	if (move_fn == lru_activate) {
+		if (folio_test_unevictable(folio)) {
+			folio_set_lru(folio);
+			return;
+		}
+		folio_set_active(folio);
+	}
+
 	folio_get(folio);
 
 	if (disable_irq)
@@ -299,12 +309,15 @@ static void lru_activate(struct lruvec *
 {
 	long nr_pages = folio_nr_pages(folio);
 
-	if (folio_test_active(folio) || folio_test_unevictable(folio))
-		return;
-
+	/*
+	 * We check unevictable flag isn't set and set active flag
+	 * after we clear lru flag. Unevictable and active flag
+	 * couldn't be modified before we set lru flag again.
+	 */
+	VM_WARN_ON_ONCE(!folio_test_active(folio));
+	VM_WARN_ON_ONCE(folio_test_unevictable(folio));
 
 	lruvec_del_folio(lruvec, folio);
-	folio_set_active(folio);
 	lruvec_add_folio(lruvec, folio);
 	trace_mm_lru_activate(folio);
 
@@ -341,6 +354,11 @@ void folio_activate(struct folio *folio)
 	if (!folio_test_clear_lru(folio))
 		return;
 
+	if (folio_test_unevictable(folio) || folio_test_active(folio)) {
+		folio_set_lru(folio);
+		return;
+	}
+	folio_set_active(folio);
 	lruvec = folio_lruvec_lock_irq(folio);
 	lru_activate(lruvec, folio);
 	unlock_page_lruvec_irq(lruvec);
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

mm-contig_alloc-fix-alloc_contig_range-when-__gfp_comp-and-order-max_order.patch
mm-hugetlb-fix-set_max_huge_pages-when-there-are-surplus-pages.patch
mm-swap-set-active-flag-after-adding-the-folio-to-activate-fbatch.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09461B0F3C
	for <mm-commits@vger.kernel.org>; Mon, 14 Apr 2025 21:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744667926; cv=none; b=SIb+FJLZx43sAVgc3sVs8LH+igLugHCbztsGsgMURwdqaiUYkuLfPZwo+k2ltxSPoksU9UGsPHwbJTLY2rNJ0xod1oHC2DNT5Qp6BIFCc87oTVudTdEETQ8Z2mcAVOLhkFk04RkjbvJSB7B5bVPUlm2DeRUtuqsZUasmcunfV7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744667926; c=relaxed/simple;
	bh=shDMQwERSY1383swrSSx8zHfyGRt/UWmfJN3MR7GQxM=;
	h=Date:To:From:Subject:Message-Id; b=FtFk46OtuUzwGr0/S+LxTpqC614t5w3doo9E4hhpprTyX9j5tQ+scNOjjho1+oQ7vYXWeUo2GxixgHHiQ5HIe30FkNaYy7vM/F2CBohCwGtTTCR3LEpIx64CtTJ+rTS5psW9ZaPJy9Ip+Kzt8m/6cHF0c9pmAgZOaUACtat8ijI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f1+7ycYt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f1+7ycYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F920C4CEE2;
	Mon, 14 Apr 2025 21:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744667925;
	bh=shDMQwERSY1383swrSSx8zHfyGRt/UWmfJN3MR7GQxM=;
	h=Date:To:From:Subject:From;
	b=f1+7ycYt+4B0x+hdiUOdOHiDBjww2HCWIT8UXE5R+gmNK0PAgxTqtnD9wtBXXiphf
	 Ci5Dy8g6HKiY8AsqNOT1+W8zpNv7WCNsppidqERolYdB4BWSwGgserOWTgfxfc4VNV
	 nF7UDxWE1k1OfFDR+owwiROPSj8mClAFzceH6OOA=
Date: Mon, 14 Apr 2025 14:58:44 -0700
To: mm-commits@vger.kernel.org,yangge1116@126.com,wangkefeng.wang@huawei.com,david@redhat.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-swap-set-active-flag-after-adding-the-folio-to-activate-fbatch.patch removed from -mm tree
Message-Id: <20250414215845.3F920C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap: set active flag after adding the folio to activate fbatch
has been removed from the -mm tree.  Its filename was
     mm-swap-set-active-flag-after-adding-the-folio-to-activate-fbatch.patch

This patch was dropped because it had testing failures

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


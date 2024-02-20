Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3C941AAC
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 22:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708467326; cv=none; b=FhVrQPzSsX9gCB/al/eLeOPRwCiuw4Yns1ody8r0CzizbrBv1P8ISzx3wzUL60an/5j3848vomnS6C7rBnBhrjL3BvkgZuUiHPLj3elQoRaS6N9B+UBqbAHKVXuxmdDLwd90Bsy5SDJPKbcq7dEh7CH1r/clT2xQ5Z5QQm6U2zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708467326; c=relaxed/simple;
	bh=kTWnyas+lEB54H8nFOP3TRyrL3jnr5hegvPw6zvQBAM=;
	h=Date:To:From:Subject:Message-Id; b=URuSDgw82pEoexKCV6sw0sBcUlqoRcn4vqqTJp8+xeu/M7GWWHXCQlRwRaETp3VnFAVRibRmfugMZU6KpzZ5tG0YA0ot3eKggFxxjbOEfjhKbDBewLXOI7lP+8IxsbQKjsG8oEOCM4WD5u1IsXGjHFjV8qK/skp6NXckB1vG+jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hWirCdIN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hWirCdIN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B508C433C7;
	Tue, 20 Feb 2024 22:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708467326;
	bh=kTWnyas+lEB54H8nFOP3TRyrL3jnr5hegvPw6zvQBAM=;
	h=Date:To:From:Subject:From;
	b=hWirCdINM9SOF15Mue6SLOhgTNBC0NILO92SHhAzefD6YlLsIF/rGMXUJU8brKLPF
	 Jqzi/Hn9ZplLH25QLhV74pSQBS0EihkJJBMIE0OP2vV/OfGXtbyCsnP1XlIQY9ISH/
	 C+32VvoBDN43kOf90u1IjHmy1loIOSLeRUYaksb0=
Date: Tue, 20 Feb 2024 14:15:25 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-swap_state-update-zswap-lrus-protection-range-with-the-folio-locked-fix.patch removed from -mm tree
Message-Id: <20240220221526.2B508C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap_state: update zswap LRU's protection range with the folio locked (fix)
has been removed from the -mm tree.  Its filename was
     mm-swap_state-update-zswap-lrus-protection-range-with-the-folio-locked-fix.patch

This patch was dropped because it was folded into mm-swap_state-update-zswap-lrus-protection-range-with-the-folio-locked.patch

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: mm/swap_state: update zswap LRU's protection range with the folio locked (fix)
Date: Tue, 6 Feb 2024 11:13:55 -0800

The if (folio) checks inside zswap_folio_swapin() is no longer needed.

Link: https://lkml.kernel.org/r/20240206191355.83755-1-nphamcs@gmail.com
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/zswap.c~mm-swap_state-update-zswap-lrus-protection-range-with-the-folio-locked-fix
+++ a/mm/zswap.c
@@ -377,11 +377,9 @@ void zswap_folio_swapin(struct folio *fo
 {
 	struct lruvec *lruvec;
 
-	if (folio) {
-		VM_WARN_ON_ONCE(!folio_test_locked(folio));
-		lruvec = folio_lruvec(folio);
-		atomic_long_inc(&lruvec->zswap_lruvec_state.nr_zswap_protected);
-	}
+	VM_WARN_ON_ONCE(!folio_test_locked(folio));
+	lruvec = folio_lruvec(folio);
+	atomic_long_inc(&lruvec->zswap_lruvec_state.nr_zswap_protected);
 }
 
 /*********************************
_

Patches currently in -mm which might be from nphamcs@gmail.com are

mm-swap_state-update-zswap-lrus-protection-range-with-the-folio-locked.patch
mm-cachestat-fix-folio-read-after-free-in-cache-walk.patch
selftests-zswap-add-zswap-selftest-file-to-zswap-maintainer-entry.patch
selftests-fix-the-zswap-invasive-shrink-test.patch
selftests-add-zswapin-and-no-zswap-tests.patch


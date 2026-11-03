Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672118;
	b=5DE63TWhy4rqQUmKU3tJUoJts6zHFCRz3jqwIbLs0XyVaWon6wLHjTDrNnk8R+OhOxoE
	 N1x5lqedjbf5vDOKLBhU/W7l7CYFtmovPStYAAF1XaNV7JOLX83rE0GGi52Pw3Ko0qi7K
	 ZdhVFaCpguF4sCwjnrUnmPSRlFD6jv9OgX2g53ML1hCOEOU2dx3iZb1++G7yMn/r8npcp
	 5rPG5Tq4e9AmYKJqw6ePuXaJHmAp5z19UAoa+uKFotWFCF1ut73Y8zpNzsVqY3A4EN3DP
	 j5JHiT+QehH2QLhaINEknQLjJsbXPXFXEpyH7TPpV7BojjOAcB/F7aFKYrau8wExT0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672118;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=E/do+f3KHZgTKsN4NSUw4YW6Ljl0i0l9ziaYlqvvjVI=;
	b=KwxCEH8XlNg6Mz3pdIchYwefRRYqb7A5pKCEkyj5AnLjovl/WQXShIZSdhcfrMdXwqj7
	 RrfXpLKDgEQUwUq4RDvrR6WHeMGgZRIebM9p6Rv/oQTS4I1DxsiYczKW9kUiI7cK+74Gv
	 cMr8htm0+oAY3913rjJUQfSBdKT1QUzVbHH7tU9KKiuJbdIGnl7wKmEW4HYHLNmTi8H1F
	 DFa0+6e9c80JPS2pxk8tSMTURTiwquKu3vHnMCQboWeyanWp9yhGepBzYaUIETrdfb8XY
	 r4mMPQDYN2Or1qsh5Vpp/t+bdolE6mUfFoPqoqun8jmCkISSEmkJ+XNEn1llRtFqXoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qrXjYpVr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCB3606A324;
	Tue,  3 Nov 2026 02:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qrXjYpVr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B2181F000C1;
	Tue,  3 Nov 2026 02:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672118;
	bh=E/do+f3KHZgTKsN4NSUw4YW6Ljl0i0l9ziaYlqvvjVI=;
	h=Date:To:From:Subject;
	b=qrXjYpVrE4xodamJhlChsa0lpTR5+580pFjFQP46iOEyyn2V6oVsSJUGpEwnH+bJa
	 nPY78UjQBTTRx9gPToRyVHKxNe9Rc2UzrONfkBqrAxjTgM716z2e8zd2+j0Jp2U5ZF
	 V019FhEbfgWglgX/u9xEOslbsTdKgwvqn5ZMEScw=
Date: Mon, 02 Nov 2026 18:15:17 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,
	usama.arif@linux.dev,stable@vger.kernel.org,ryan.roberts@arm.com,
	nico.pache@linux.dev,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,
	hughd@google.com,dev.jain@arm.com,david@kernel.org,
	baolin.wang@linux.alibaba.com,baohua@kernel.org,kylebot@openai.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-khugepaged-flush-deferred-unmaps-before-dropping-a-failed-folio.patch removed from -mm tree
Message-Id: <20261103021518.2B2181F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/khugepaged: flush deferred unmaps before dropping a failed folio
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-flush-deferred-unmaps-before-dropping-a-failed-folio.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kyle Zeng <kylebot@openai.com>
Subject: mm/khugepaged: flush deferred unmaps before dropping a failed folio
Date: Tue,  6 Oct 2026 21:10:01 -0700

collapse_file() can fail its reference-count or dirty-folio check after
unmapping with TTU_BATCH_FLUSH.  Both paths put back the isolated folio,
then unlock it and drop the lookup reference before reaching the common
try_to_unmap_flush().

The page-cache reference does not keep the folio stable once the lock is
released.  Another collapse can replace and free it.  With its PTEs
already gone, that collapse cannot flush the first task's per-task TLB
batch, and retract_page_tables() skips short or unaligned VMAs.  A CPU can
therefore retain a user translation to the freed folio.  This has been
reproduced with unprivileged MADV_COLLAPSE on a memfd.

Flush at out_unlock while the lookup reference and folio lock are still
held.  The common flush continues to cover the accumulated pagelist on
both success and rollback, preserving batching on successful collapses.

Link: https://lore.kernel.org/20261007041001.43181-1-kylebot@openai.com
Fixes: 6d9df8a5889c ("mm/thp: collapse_file() do try_to_unmap(TTU_BATCH_FLUSH)")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Hugh Dickins <hughd@google.com>
Assisted-by: LLM
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
---

 mm/khugepaged.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-flush-deferred-unmaps-before-dropping-a-failed-folio
+++ a/mm/khugepaged.c
@@ -2467,6 +2467,11 @@ static enum scan_result collapse_file(st
 		index += folio_nr_pages(folio);
 		continue;
 out_unlock:
+		/*
+		 * The folio may have been unmapped with TTU_BATCH_FLUSH.
+		 * Flush before releasing the lock and our last reference.
+		 */
+		try_to_unmap_flush();
 		folio_unlock(folio);
 		folio_put(folio);
 		goto xa_unlocked;
@@ -2477,9 +2482,8 @@ xa_locked:
 xa_unlocked:
 
 	/*
-	 * If collapse is successful, flush must be done now before copying.
-	 * If collapse is unsuccessful, does flush actually need to be done?
-	 * Do it anyway, to clear the state.
+	 * Flush before copying the folios, or releasing them in rollback.
+	 * This is a no-op if out_unlock already flushed the batch.
 	 */
 	try_to_unmap_flush();
 
_

Patches currently in -mm which might be from kylebot@openai.com are



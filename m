Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A2F18D
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560116; cv=none; b=p6TP7zDqKBOW70txa+TW03S0ZuBWYDcwyMz9n5k/QnpFjNnRMKIFZP3EIczgGWWm2hJ9RHXBSxtz2P8Wj7qy8M7dLGJLMwZfOQviTJ4HKvg8jhLPEsZmaI8GQhMB4/zSULwUxHEtwwfadT85JKS9zf8oX8xtS09sYzaXIf7TMgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560116; c=relaxed/simple;
	bh=hfsHCa15dt4w/8x45ayuvmMr9+P5/ZJvF2qn/7YyneQ=;
	h=Date:To:From:Subject:Message-Id; b=e5C66Ok+mU2HcwwLaSRakxFi2MuJjRBri1EkcpjyUcDqYj8+UYhnNBLc0KMkiQRY821DC8rMi9kf/U3sEeqN68qyhLVW6YnwpM17cATZDKi0FrOLEqB7Hw40WoYCXlCIXw+kK6SxfonsIBe7Ybfp0C1eN5h1ishxHSFxddDLN0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k5p5UNnb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k5p5UNnb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB16C433C7;
	Thu, 22 Feb 2024 00:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560116;
	bh=hfsHCa15dt4w/8x45ayuvmMr9+P5/ZJvF2qn/7YyneQ=;
	h=Date:To:From:Subject:From;
	b=k5p5UNnbGio+zrVHzCgdTXXWyIeMYHReqBpfKp1X9DBmbxDt3Bqe8QPsPVsvJtdsv
	 WR0LKKlaDWNqYukLK5JRc6S5Or2GxDute3YuEr25Y+CBEtznkyxKguzYaAYCBh8l84
	 PtPxqdqCkQYXOlBZ8peAfBpA0PN8icVDHfxaFo/k=
Date: Wed, 21 Feb 2024 16:01:55 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-clean-up-zswap_entry_put.patch removed from -mm tree
Message-Id: <20240222000156.7FB16C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: clean up zswap_entry_put()
has been removed from the -mm tree.  Its filename was
     mm-zswap-clean-up-zswap_entry_put.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: clean up zswap_entry_put()
Date: Mon, 29 Jan 2024 20:36:41 -0500

Remove stale comment and unnecessary local variable.

Link: https://lkml.kernel.org/r/20240130014208.565554-6-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/mm/zswap.c~mm-zswap-clean-up-zswap_entry_put
+++ a/mm/zswap.c
@@ -545,15 +545,11 @@ static void zswap_entry_get(struct zswap
 	entry->refcount++;
 }
 
-/* caller must hold the tree lock
-* remove from the tree and free it, if nobody reference the entry
-*/
+/* caller must hold the tree lock */
 static void zswap_entry_put(struct zswap_entry *entry)
 {
-	int refcount = --entry->refcount;
-
-	WARN_ON_ONCE(refcount < 0);
-	if (refcount == 0) {
+	WARN_ON_ONCE(!entry->refcount);
+	if (--entry->refcount == 0) {
 		WARN_ON_ONCE(!RB_EMPTY_NODE(&entry->rbnode));
 		zswap_entry_free(entry);
 	}
_

Patches currently in -mm which might be from hannes@cmpxchg.org are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCDD36403C
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622899; cv=none; b=rZakgXN5Hqgu4WJiQR7+9tub9YvCFzlxmsyUnJV4lBlDoUooXEAAZ/w0+YSjpLIe4Rk0YbbRqwzRtwd7akMVB8tgtO6L8+MwrM1h9nRUhBqhmDaY9tC4gH1cXdmpOuMV1DnFFNhd5mYuiBTPPksswFZt2dUAPJvld9YHNDU4lRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622899; c=relaxed/simple;
	bh=xHhKeFb+kNfPhA4t9nAX93UsuVyQtJNuAgN7Kj4dPNU=;
	h=Date:To:From:Subject:Message-Id; b=a7uPeNNEEzLpyt/AdvVVmbj0Gv/nU0AubpxctbzKoyVj8rC5t2fRUwGTY8PoOfcUwIC484PwW0UbvpsoAfr0SEtgKlj49kn9jrZojTAulBoJD6LY1cPXUPFCEe60rj17Nm1LtQru5J0eUTor0/Q6Aa3vzfajmwlKxvafQuHm0ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x2fBswoC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x2fBswoC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818B71F00A3A;
	Tue, 25 Aug 2026 01:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622896;
	bh=QH4PtB1u4UvyPw3bGYWzVqUj/AvoGVDtUhL24lAGni0=;
	h=Date:To:From:Subject;
	b=x2fBswoCPc1bJ51NqD8zg7Vcj18t++co2BDS3qBb7/ynxIkVtOnaI+XAeU2gBWAgD
	 1nEi0EqjO/EDdcjCIF0C8XF76E3ixwqOJ/Xtw3hE5HoeEbPthDLpo36Idn1/xz3kVD
	 IrtXv8xJV+CVR7OF98BjceEySGQl2d3qY/pVUkFk=
Date: Mon, 24 Aug 2026 18:54:56 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-fix-swap_cluster_lock-config_swap-stub-signature-mismatch.patch removed from -mm tree
Message-Id: <20260825015456.818B71F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap: fix swap_cluster_lock() !CONFIG_SWAP stub signature mismatch
has been removed from the -mm tree.  Its filename was
     mm-swap-fix-swap_cluster_lock-config_swap-stub-signature-mismatch.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: mm/swap: fix swap_cluster_lock() !CONFIG_SWAP stub signature mismatch
Date: Fri, 17 Jul 2026 15:11:04 +0800

The !CONFIG_SWAP stub for swap_cluster_lock() has mismatched prototype: it
has an extra unused irq argument and uses pgoff_t instead of unsigned long
for offset.  All callers are under CONFIG_SWAP so the extra parameter is
dead.

Delete the unused stub function entirely.

Link: https://lore.kernel.org/20260717071104.73467-1-hongfu.li@linux.dev
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Acked-by: Kairui Song <kasong@tencent.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Hongfu Li <lihongfu@kylinos.cn>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/mm/swap.h~mm-swap-fix-swap_cluster_lock-config_swap-stub-signature-mismatch
+++ a/mm/swap.h
@@ -358,11 +358,6 @@ void swap_update_readahead(struct folio
 			   unsigned long addr);
 
 #else /* CONFIG_SWAP */
-static inline struct swap_cluster_info *swap_cluster_lock(
-	struct swap_info_struct *si, pgoff_t offset, bool irq)
-{
-	return NULL;
-}
 
 static inline struct swap_cluster_info *swap_cluster_get_and_lock(
 		struct folio *folio)
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

mm-use-a-folio-in-the-softleaf_is_device_private-path.patch


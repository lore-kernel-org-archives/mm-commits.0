Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742E03F58EA
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525503; cv=none; b=KYG/OTc+/Edg61l+b8iql0MdviESjjIkgU/9HCa2vw+x6eSKP9Qu8OEq0cIb73EJJrRLn1rwDYlAkEkelUbpjW9OFimoaJ1KxG6uUs1pItuVRAo6BnOWHcUyzDh2vISjeoQLl07rROyPyfVgPJ3nd8p0WCP98zYBfOeU/7eHJ8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525503; c=relaxed/simple;
	bh=6Ji1NqYLDJrkDKyssn2bv16apQz5G73eYl/2HW6ynnQ=;
	h=Date:To:From:Subject:Message-Id; b=XPEcvcep7ZPBPuJ/7Ti638+h0BMWweXTNJ6QFQ6EWwdwWyKXArdFYjtEe2lzxip+orftYQSDrqXKwf+jVZMGYngSXASXpW4yL5y+YLuaQeQwnp0psj4TX+HqjZ0eu/FzOzItAA9nXB3M5frxXMC2A2Lv1F/l3IoJmiwYJsmFC0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qcyrxZKB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qcyrxZKB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9FF1F00893;
	Fri,  9 Oct 2026 05:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525502;
	bh=Pt3Ylfy7DXZbG+ps07MVZF9K+QPvWxVRMcpWWswWb9k=;
	h=Date:To:From:Subject;
	b=qcyrxZKBBy1dY/6vvkwpieq/rde1uarMP0JvUJEhY99J417O2R4pi+ezpqG6IsEO5
	 J9Q+NEaHo1uwAKAO2266Nq4jill/x3v45sSDWtitRj7Mejk+tWeysXbT/lPVyWrP74
	 p0AIVB7Gyx2uK2ElvaARk+l4/3NgY08D3j2UjPmA=
Date: Thu, 08 Oct 2026 22:58:21 -0700
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,nphamcs@gmail.com,luizcap@redhat.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-return-early-from-swap_extend_table_try_free-on-first-non-zero-entry.patch removed from -mm tree
Message-Id: <20261009055822.4A9FF1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: return early from swap_extend_table_try_free() on first non-zero entry
has been removed from the -mm tree.  Its filename was
     mm-swap-return-early-from-swap_extend_table_try_free-on-first-non-zero-entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm, swap: return early from swap_extend_table_try_free() on first non-zero entry
Date: Mon, 7 Sep 2026 17:13:55 +0800

Return immediately when the first non-zero swap count is found as any
non-zero swap count prevents freeing extend_table and further iteration is
pointless.

Link: https://lore.kernel.org/20260907091356.53026-4-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Youngjun Park <youngjun.park@lge.com>
Acked-by: Kairui Song <kasong@tencent.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Luiz Capitulino <luizcap@redhat.com>
Cc: Nhat Pham <nphamcs@gmail.com>
---

 mm/swapfile.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/mm/swapfile.c~mm-swap-return-early-from-swap_extend_table_try_free-on-first-non-zero-entry
+++ a/mm/swapfile.c
@@ -1523,20 +1523,17 @@ int swap_retry_table_alloc(swp_entry_t e
 static void swap_extend_table_try_free(struct swap_cluster_info *ci)
 {
 	unsigned long i;
-	bool can_free = true;
 
 	if (!ci->extend_table)
 		return;
 
 	for (i = 0; i < SWAPFILE_CLUSTER; i++) {
 		if (ci->extend_table[i])
-			can_free = false;
+			return;
 	}
 
-	if (can_free) {
-		kfree(ci->extend_table);
-		ci->extend_table = NULL;
-	}
+	kfree(ci->extend_table);
+	ci->extend_table = NULL;
 }
 
 /* Decrease the swap count of one slot, without freeing it */
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040447482
	for <mm-commits@vger.kernel.org>; Thu, 28 Nov 2024 00:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732754386; cv=none; b=ogSNTKHwBEr7EHY+H6SOY2X9ggb40Oh6osK6IlPF37VNbFoJ3+vRjcWcSUj9GWDAtRbFmNpSzE+40ONCdW0CTBWn8xsgl616PWKDOIJ88GQk7XovDAPHsvAJiJdjaRlNVjehuesBioAZVJIMu3Ymw3UIOC/pxuF4nH1KFAwgKY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732754386; c=relaxed/simple;
	bh=2g1dgy082ZyfWjHcHCbGrKc/ZJuHy1HZOvx/h0zsMnM=;
	h=Date:To:From:Subject:Message-Id; b=QL09CorlnshRNpCWHaaNThGPQ5g2HGW7+SD0aHxsV/VM+f0OdgcxOqyhO5ALq3/JB239EYeEznHPvmYJFpimLzmpNnrXOPU7f7JvBdgsheyDny/f/koRf9xyRb2B7qJ3wQTDOWxHJKrCCi6JgRMWZT3hnDv44AHpL4c8vpsxubs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F/8uelID; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F/8uelID"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA22C4CECC;
	Thu, 28 Nov 2024 00:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732754385;
	bh=2g1dgy082ZyfWjHcHCbGrKc/ZJuHy1HZOvx/h0zsMnM=;
	h=Date:To:From:Subject:From;
	b=F/8uelIDSEgLYKjRYHcn30QDGPNPLtDUn433fjKyLJ0aGxsB42jgqre2aA9fiE2nV
	 fRcJr75TjcBRixx9F6oq9Ge1jg0FznA2HnO7ZILSX6C+VcQpYSmEjaIz8WQ6fONFKi
	 HwrpX8brAw/cQAClwKS97QiFH74b/jBFRppNbcZ8=
Date: Wed, 27 Nov 2024 16:39:44 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,aliceryhl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-add-lru_stop-to-comment-about-dropping-the-lru-lock.patch added to mm-unstable branch
Message-Id: <20241128003945.4FA22C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: add LRU_STOP to comment about dropping the lru lock
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-add-lru_stop-to-comment-about-dropping-the-lru-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-add-lru_stop-to-comment-about-dropping-the-lru-lock.patch

This patch will later appear in the mm-unstable branch at
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
From: Alice Ryhl <aliceryhl@google.com>
Subject: mm/zswap: add LRU_STOP to comment about dropping the lru lock
Date: Wed, 27 Nov 2024 13:53:29 +0000

This function has been able to return LRU_STOP since commit b49547ade38a
("mm/zswap: stop lru list shrinking when encounter warm region").  To
reduce confusion, update the comment to also list LRU_STOP as an option.

Link: https://lkml.kernel.org/r/20241127-lru-stop-comment-v1-1-f54a7cba9429@google.com
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-add-lru_stop-to-comment-about-dropping-the-lru-lock
+++ a/mm/zswap.c
@@ -1156,7 +1156,7 @@ static enum lru_status shrink_memcg_cb(s
 
 	/*
 	 * It's safe to drop the lock here because we return either
-	 * LRU_REMOVED_RETRY or LRU_RETRY.
+	 * LRU_REMOVED_RETRY, LRU_RETRY or LRU_STOP.
 	 */
 	spin_unlock(&l->lock);
 
_

Patches currently in -mm which might be from aliceryhl@google.com are

mm-zswap-add-lru_stop-to-comment-about-dropping-the-lru-lock.patch


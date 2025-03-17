Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199C52153E0
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188245; cv=none; b=hoED3pkuO1mhtgpA/LhNCbg5M/7RecKZXaKfpayjEInwU7bcl6Qr76F1pAoYpcHBC0c2hly7HsYgUUrt9rdxRAv3OKm347rC5sUnITsyDbe9di9F59npib7aqv/zJUqXD0QFXh8AmKB8UWDR2HhtRKzUaHEGB+Cd7gf/rizjVwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188245; c=relaxed/simple;
	bh=juIvVZKwC5cYCqS9jTjbFQIEFaLgF0amwyAOCgFeQ0c=;
	h=Date:To:From:Subject:Message-Id; b=RzTpYgbN/IkqGYGpF7JL6Svj3AEVmlWqL6iDDK6vY30METRgurfgL+R5olxyvmWj+9179eXqxSObod29LrW3tTU52czy1eyZxqjFd7DicEbpESiJXYHR7x78wGDR75JfrHXjy2rZQz/ECUnX4IyzMmIFn837/HOahG+w1U6Bd4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yfOAbM7c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yfOAbM7c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F33DC4CEEC;
	Mon, 17 Mar 2025 05:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188244;
	bh=juIvVZKwC5cYCqS9jTjbFQIEFaLgF0amwyAOCgFeQ0c=;
	h=Date:To:From:Subject:From;
	b=yfOAbM7cYxFArlG5UMMN9UfElO837efTWqd9FN5yqwW3sV3tO1MTwOK/sj96EYGEY
	 iKJ7Do3uHMB0v8MC3fedgG98yqCNhBCPK8IBM4d6JzRoLT+H8HZ2uoEoStd9ql4bEn
	 QlFDto3Aca1XGCamUXp1Rt24qLDPSQniQZEEHWww=
Date: Sun, 16 Mar 2025 22:10:44 -0700
To: mm-commits@vger.kernel.org,ryncsn@gmail.com,chrisl@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap_statec-remove-the-meaningless-code-comment.patch removed from -mm tree
Message-Id: <20250317051044.7F33DC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap_state.c: remove the meaningless code comment
has been removed from the -mm tree.  Its filename was
     mm-swap_statec-remove-the-meaningless-code-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/swap_state.c: remove the meaningless code comment
Date: Wed, 5 Feb 2025 17:27:17 +0800

Since commit 8d93b41c09d1 ("mm: Convert add_to_swap_cache to XArray"),
there's no returned _EEXIT, so the code comment doesn't make sense any
more.

Link: https://lkml.kernel.org/r/20250205092721.9395-9-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/swap_state.c~mm-swap_statec-remove-the-meaningless-code-comment
+++ a/mm/swap_state.c
@@ -203,10 +203,6 @@ bool add_to_swap(struct folio *folio)
 	err = add_to_swap_cache(folio, entry,
 			__GFP_HIGH|__GFP_NOMEMALLOC|__GFP_NOWARN, NULL);
 	if (err)
-		/*
-		 * add_to_swap_cache() doesn't return -EEXIST, so we can safely
-		 * clear SWAP_HAS_CACHE flag.
-		 */
 		goto fail;
 	/*
 	 * Normally the folio will be dirtied in unmap because its
_

Patches currently in -mm which might be from bhe@redhat.com are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FDC28E3
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628224; cv=none; b=sKW+y5Z63u7g3jmnrjOZtxdaRL0oGs6pAJ3gzuGJs2JEwkjnGIXf6qoYs1ZP3zm4Nln/j5PO1WMfcewlAexnHvTOugBUmn7iPn6AdHqveQJlkqr4poVNSI+I53S18litahG4+TQ30tUUfs1IOjHnKLJ5QJNCglguP/UNZkn/724=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628224; c=relaxed/simple;
	bh=1UGPehUEnoyznpGK5xAiPMhArpHanWOn6BaYB9pdbhc=;
	h=Date:To:From:Subject:Message-Id; b=UHDumHLKHOh0AdWWZn/gINQNIf7a4VN81Poig9VveR2cyvxOJe4KXO+eDow/fRs1QZfMJ3cW+Rs8TM7qjAVkqXIat83oluB+a1F67IwyGw0gIy6/Z8AynO0HFKBSqFpogEKgsda4n4FZXtyqyTp/K58BTG5TM2k856nI/Qs/djs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KxtsNyiD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KxtsNyiD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EBFC116B1;
	Sat, 29 Jun 2024 02:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628224;
	bh=1UGPehUEnoyznpGK5xAiPMhArpHanWOn6BaYB9pdbhc=;
	h=Date:To:From:Subject:From;
	b=KxtsNyiDIkx4Rb6iIhyBZLactz16Xy9hFW/fufi40RHJl+iok+OVKcA5ET5GJcb9I
	 hAOpjtNkI4v/9e43LY8hYZNYnJwdXIJnTSYsshZFwoZs55xK7eYILWWTmodXBVqmqx
	 ADHWSDksBd/nMjLfKV8/vlJqzKq/hfMwCFdTGUGc=
Date: Fri, 28 Jun 2024 19:30:23 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-fix-a-typo-in-comment-about-gfp-flag.patch removed from -mm tree
Message-Id: <20240629023023.F0EBFC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: fix a typo in comment about GFP flag
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-a-typo-in-comment-about-gfp-flag.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/page_alloc: fix a typo in comment about GFP flag
Date: Wed, 19 Jun 2024 01:06:11 +0000

The GFP flags used to choose the zonelist is __GFP_THISNODE.

Let's change it to what exactly it should be.

Link: https://lkml.kernel.org/r/20240619010612.20740-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-a-typo-in-comment-about-gfp-flag
+++ a/mm/page_alloc.c
@@ -5241,7 +5241,7 @@ static void build_zonelists_in_node_orde
 }
 
 /*
- * Build gfp_thisnode zonelists
+ * Build __GFP_THISNODE zonelists
  */
 static void build_thisnode_zonelists(pg_data_t *pgdat)
 {
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are



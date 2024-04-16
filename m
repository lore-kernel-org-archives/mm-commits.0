Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163C81E876
	for <mm-commits@vger.kernel.org>; Tue, 16 Apr 2024 19:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713297321; cv=none; b=FsVs7gouurkv80ZhoYxjHQaOpSyNiS3ZXh7c95dnn36eqJrKNlHlCEakdriKWm2zJufEV2PtlPHCreyYJVV4O/Eala2c5wMFZrEquYl6PU1THwxS6KuVE7z33UY4UCNyk9J8z5K2qekLq2odV21ZTyLmwoGYxygDJ4Q73tu+Zso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713297321; c=relaxed/simple;
	bh=w17tctT4gefGqn6mulYTtPxNuqTpNBqgvHTQSH9dLXU=;
	h=Date:To:From:Subject:Message-Id; b=JbGAJa/l3uO0c5bhal5kkPasrXGbquyKb3qbsjXegZm5jl6lioJq6BUUsYsFXbWTD+jGV7YgpFnhqTesqDy38+HSPbWri3uKnF+hqskYtHdL2ZEnV3bJmKjew8KseuUD3PBLpdgjVJj9wuUuTFNI/XjSfUgn0nk6lf7iUpxZbfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MwEoSu1k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MwEoSu1k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E449C113CE;
	Tue, 16 Apr 2024 19:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713297320;
	bh=w17tctT4gefGqn6mulYTtPxNuqTpNBqgvHTQSH9dLXU=;
	h=Date:To:From:Subject:From;
	b=MwEoSu1kGrGMwlgyQ+zbXyK6gbBYhpC8BT0DhmUGL/6bj+Zf3vGx6iL/phHf0/mfw
	 yL+CxpCjweFySUbGYkuQYhNN3ZSNBaYwsVrds9PZt/i/c4hYiZf9NoXvGYlIFEv8T3
	 SUYqcVJI2Q3+xNFVNoZqs42H6N5/dBS9hQl2y+Co=
Date: Tue, 16 Apr 2024 12:55:19 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-xarray-introduce-a-new-helper-xas_get_order-v4.patch added to mm-unstable branch
Message-Id: <20240416195520.7E449C113CE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/xarray: introduce a new helper xas_get_order
has been added to the -mm mm-unstable branch.  Its filename is
     lib-xarray-introduce-a-new-helper-xas_get_order-v4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-xarray-introduce-a-new-helper-xas_get_order-v4.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: lib/xarray: introduce a new helper xas_get_order
Date: Tue, 16 Apr 2024 15:17:21 +0800

simplify comment, sparse warning fix, per Matthew Wilcox

Link: https://lkml.kernel.org/r/20240416071722.45997-4-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xarray.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/xarray.c~lib-xarray-introduce-a-new-helper-xas_get_order-v4
+++ a/lib/xarray.c
@@ -1750,7 +1750,7 @@ unlock:
 EXPORT_SYMBOL(xa_store_range);
 
 /**
- * xas_get_order() - Get the order of an loaded entry after xas_load.
+ * xas_get_order() - Get the order of an entry.
  * @xas: XArray operation state.
  *
  * Called after xas_load, the xas should not be in an error state.
@@ -1769,7 +1769,7 @@ int xas_get_order(struct xa_state *xas)
 
 		if (slot >= XA_CHUNK_SIZE)
 			break;
-		if (!xa_is_sibling(xas->xa_node->slots[slot]))
+		if (!xa_is_sibling(xa_entry(xas->xa, xas->xa_node, slot)))
 			break;
 		order++;
 	}
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-filemap-return-early-if-failed-to-allocate-memory-for-split.patch
mm-filemap-clean-up-hugetlb-exclusion-code.patch
lib-xarray-introduce-a-new-helper-xas_get_order.patch
lib-xarray-introduce-a-new-helper-xas_get_order-v4.patch
mm-filemap-optimize-filemap-folio-adding.patch


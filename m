Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB9F242D66
	for <mm-commits@vger.kernel.org>; Mon, 15 Sep 2025 22:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757974669; cv=none; b=N9nDT8WQ53ZlB9B7CfQ70aUgTku6PJKCumGZDEhO2cjz6BrsVMz1cpRIsEZl7stPxNRcw0lYjmDSuCEPDy6+VvXwm8HSvQvL/a6nO8Odh3kHvrqR8fdUoB8yZoEWfbRIc7c5n6xSJK17Qdjk9OlJXNzFXi/5EKk6yRNhhyCnY/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757974669; c=relaxed/simple;
	bh=dFqreTldrdDnk4QU3tn14q/irM9IzGKY2o8SwZv00pY=;
	h=Date:To:From:Subject:Message-Id; b=twOcbwZyNyDr4iuBNfWd3qMSTMVvSmvMAh971b9SKPzmwmzd8Ttjfq2WIPXoPcGl2a4c3Qa2Gus+Tjvx9pNF6enRJakaG5RxFryrqqTgydrp3AYS1Qx2p60BFNj0G6D9mnz3dWWTqMSQ9J6QRggRIa5v+EOPkIRHLBVZNlCXy3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=prBB/FXM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="prBB/FXM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C0AC4CEF1;
	Mon, 15 Sep 2025 22:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757974669;
	bh=dFqreTldrdDnk4QU3tn14q/irM9IzGKY2o8SwZv00pY=;
	h=Date:To:From:Subject:From;
	b=prBB/FXMq9eryc74rRNpUBKV7vXtHcIutASIm90RYp4ahx3Lmfh/823qmLdEAiGbR
	 wqxruo0VSOzCbZ79z+eUiU6clXlvIhZh1VhjO8pxttguGj4yCYtbiBN+I0IME13Olz
	 YW3GxsS9XmhZt5POypKOIicy09zcJqSK57nWpTbk=
Date: Mon, 15 Sep 2025 15:17:48 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,usamaarif642@gmail.com,souravpanda@google.com,shakeel.butt@linux.dev,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,hannes@cmpxchg.org,00107082@163.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-avoid-warnings-when-freeing-non-compound-tail-pages.patch added to mm-unstable branch
Message-Id: <20250915221749.32C0AC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: avoid warnings when freeing non-compound "tail" pages
has been added to the -mm mm-unstable branch.  Its filename is
     alloc_tag-avoid-warnings-when-freeing-non-compound-tail-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-avoid-warnings-when-freeing-non-compound-tail-pages.patch

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: alloc_tag: avoid warnings when freeing non-compound "tail" pages
Date: Mon, 15 Sep 2025 14:27:56 -0700

When freeing "tail" pages of a non-compount high-order page, we properly
subtract the allocation tag counters, however later when these pages are
released, alloc_tag_sub() will issue warnings because tags for these pages
are NULL.

This issue was originally anticipated by Vlastimil in his review [1] and
then recently reported by David.  Prevent warnings by marking the tags
empty.

Link: https://lkml.kernel.org/r/20250915212756.3998938-4-surenb@google.com
Link: https://lore.kernel.org/all/6db0f0c8-81cb-4d04-9560-ba73d63db4b8@suse.cz/ [1]
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: David Wang <00107082@163.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~alloc_tag-avoid-warnings-when-freeing-non-compound-tail-pages
+++ a/mm/page_alloc.c
@@ -5240,9 +5240,16 @@ static void ___free_pages(struct page *p
 		__free_frozen_pages(page, order, fpi_flags);
 	else if (!head) {
 		pgalloc_tag_sub_pages(tag, (1 << order) - 1);
-		while (order-- > 0)
+		while (order-- > 0) {
+			/*
+			 * The "tail" pages of this non-compound high-order
+			 * page will have no code tags, so to avoid warnings
+			 * mark them as empty.
+			 */
+			clear_page_tag_ref(page + (1 << order));
 			__free_frozen_pages(page + (1 << order), order,
 					    fpi_flags);
+		}
 	}
 }
 
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-use-release_pages-in-the-cleanup-path.patch
alloc_tag-prevent-enabling-memory-profiling-if-it-was-shut-down.patch
alloc_tag-avoid-warnings-when-freeing-non-compound-tail-pages.patch


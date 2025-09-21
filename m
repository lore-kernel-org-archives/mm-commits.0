Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1AE2C08A2
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489985; cv=none; b=nO0vKIUxbyPKmtlmKatxdmX8nt5ciNcUCLEIK2x7xB1CY3MswJOx2nyLzQM+PZeI1C7IdConXcPKN01yYpNxOSHXyQuJEkp9pPrGhU3SAgATmAswzeOh2i+uTcAliipeZuvxMU8XIQdJ5/KBwJ/VVeMo5E4eP4evk7QRJvZcDkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489985; c=relaxed/simple;
	bh=9UM7GzJoSKHMx+GYBJgOyG1znVW27KNz6XRUQdaGB2E=;
	h=Date:To:From:Subject:Message-Id; b=ho2hQPfjEnaHTGQx1X/GOR8nREWDW0VsXVNQc6TcOtQEsO6vusV+ckqt+fJ0BVHJqC/+Evv+bTogKNAVuyMUofL6/9cWdJwftwwxdQT2urN0krHyIZDqGo9D1TB0CsA3TQEpc1WG9wCVCWw+TzMPXksaebmPx+L9WMYKOhKG4DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WsJxvbWk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WsJxvbWk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D46C4CEE7;
	Sun, 21 Sep 2025 21:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489985;
	bh=9UM7GzJoSKHMx+GYBJgOyG1znVW27KNz6XRUQdaGB2E=;
	h=Date:To:From:Subject:From;
	b=WsJxvbWkfVD5D9P1rV9Su0FTOPRiyREO+HFvbMckYDei704hHjAOnD9K9DD7uxDdQ
	 jxpD3bsn+ePey7UDAaWxVbTOk2JCdFO3Ypi5zuhA/fMEWIV7ZN4u/lmD9TFDJ44t/J
	 o/Y20xp4hNTMc7GOi+LGWA9k64N3xQM9WLGVIk8I=
Date: Sun, 21 Sep 2025 14:26:24 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,usamaarif642@gmail.com,souravpanda@google.com,shakeel.butt@linux.dev,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,hannes@cmpxchg.org,00107082@163.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] alloc_tag-avoid-warnings-when-freeing-non-compound-tail-pages.patch removed from -mm tree
Message-Id: <20250921212625.43D46C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: avoid warnings when freeing non-compound "tail" pages
has been removed from the -mm tree.  Its filename was
     alloc_tag-avoid-warnings-when-freeing-non-compound-tail-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Usama Arif <usamaarif642@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sourav Panda <souravpanda@google.com>
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



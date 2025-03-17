Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4F8215782
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188296; cv=none; b=QQgf9P33eNC4e4WWZmgC84V/nZo7qxGJ2C5IQ4c1c6+kcdfJky+E8j6fyx8DEsbF+DcJcUSTdvpB4JyDgeWCqYrTyxRyjwXu4THLF2SABA4PAsk/MSVBgy9TL8FZkWYwNxWIGMcN3stjEuZ5Ff8SHscKbNia0Sd1L39InLYg4UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188296; c=relaxed/simple;
	bh=dkzQS4GNJ7BfccrY3Wl7tbnDfAXV5+RuHk8nUeQOGks=;
	h=Date:To:From:Subject:Message-Id; b=JHGwNFXZesftLgW6RyFfP38s7VBcLEv1MJNxEUw70FcTBLhp6qHKPDhjkarHZ6cdgwLkNpSgmnZ2vCqtFiAlZTSZGr77wTBCo5DXpxUh10jkMM1SHu+SlWgaOE29pvwsHzf3teNJRfxyGOnIzbrXEtv7vAAP1EqYkX0QeMKpQys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iz3oEIQu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iz3oEIQu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C457C4CEEC;
	Mon, 17 Mar 2025 05:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188296;
	bh=dkzQS4GNJ7BfccrY3Wl7tbnDfAXV5+RuHk8nUeQOGks=;
	h=Date:To:From:Subject:From;
	b=iz3oEIQuyWcEQko8btG0Y5Ym+JPON47KYJj/sX7dyCSK1tVh0715SDN+LMR+OTumm
	 jvAmFQX58VBu00hAWELchC2oOZ8eplyT43//fiZzb+Z7yI01ZmqVbdd9UAIRAam59A
	 8QQf5JURUgmT4JdWbEteAwCH0BmBF+DbXkClLiwc=
Date: Sun, 16 Mar 2025 22:11:35 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,guanjun@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] filemap-remove-redundant-folio_test_large-check-in-filemap_free_folio.patch removed from -mm tree
Message-Id: <20250317051136.0C457C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: filemap: remove redundant folio_test_large check in filemap_free_folio
has been removed from the -mm tree.  Its filename was
     filemap-remove-redundant-folio_test_large-check-in-filemap_free_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Guanjun <guanjun@linux.alibaba.com>
Subject: filemap: remove redundant folio_test_large check in filemap_free_folio
Date: Thu, 13 Feb 2025 13:56:12 +0800

The folio_test_large() check in filemap_free_folio() is unnecessary
because folio_nr_pages(), which is called internally already performs this
check.  Removing the redundant condition simplifies the code and avoids
double validation.

This change improves code readability and reduces unnecessary operations
in the folio freeing path.

Link: https://lkml.kernel.org/r/20250213055612.490993-1-guanjun@linux.alibaba.com
Signed-off-by: Guanjun <guanjun@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/filemap.c~filemap-remove-redundant-folio_test_large-check-in-filemap_free_folio
+++ a/mm/filemap.c
@@ -227,15 +227,12 @@ void __filemap_remove_folio(struct folio
 void filemap_free_folio(struct address_space *mapping, struct folio *folio)
 {
 	void (*free_folio)(struct folio *);
-	int refs = 1;
 
 	free_folio = mapping->a_ops->free_folio;
 	if (free_folio)
 		free_folio(folio);
 
-	if (folio_test_large(folio))
-		refs = folio_nr_pages(folio);
-	folio_put_refs(folio, refs);
+	folio_put_refs(folio, folio_nr_pages(folio));
 }
 
 /**
_

Patches currently in -mm which might be from guanjun@linux.alibaba.com are



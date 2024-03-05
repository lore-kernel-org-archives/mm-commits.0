Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0158BE5
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600576; cv=none; b=c9zR7wBuywIp5nncLQbGHEmsKWeg6jfdhe8xKg1ueHpb9EqBoEAYTBoHadkjyoJ+i7Rp6o9AJV0/wMKKL/maDobBFBvMdtjP22JA9wezE6Wg4vNjMVT5+Fpou994SAV/iGepijZfQxOStHZuhR7GKj3+utCswFNg5tUPu/8FCwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600576; c=relaxed/simple;
	bh=YXywscWghgqxWYUfwE8tMvo9jufiu8c7nYnY0EUXGYg=;
	h=Date:To:From:Subject:Message-Id; b=fHXQowwH08I/Y+11hPbNnAotx7NT+dJXqauwx8iD6SRFjeax3UI30CSKtip+mQTEgPuDNzjx71jmA7QuSUf3zLOU1gFCh/6+vNDJ9bH8+nV3CzkOWrRSGDQqaoKkLI+DFte0vsKc38r9WV0RUKZlFxbCE2gKsVOb/8KJa8/t6cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tbcQDKga; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tbcQDKga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2189C433F1;
	Tue,  5 Mar 2024 01:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600575;
	bh=YXywscWghgqxWYUfwE8tMvo9jufiu8c7nYnY0EUXGYg=;
	h=Date:To:From:Subject:From;
	b=tbcQDKgaWneKifFqcK7gNKpAhddFuXSoZXs0giDSSQII3fWd9ZLwniA7N0aEjs6HB
	 fYe2P9b3/xdURq9fc7tVUdKteV27qqt6eny016iMA6/4QijRLeOlU1TgFr/5B9Ra4w
	 NgknZgtKDzbN0O/TotfM5GnjmlqKmBOZgm8Q5S44=
Date: Mon, 04 Mar 2024 17:02:55 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,mgorman@suse.de,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-lru_to_page.patch removed from -mm tree
Message-Id: <20240305010255.D2189C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove lru_to_page()
has been removed from the -mm tree.  Its filename was
     mm-remove-lru_to_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove lru_to_page()
Date: Tue, 27 Feb 2024 17:42:49 +0000

The last user was removed over a year ago; remove the definition.

Link: https://lkml.kernel.org/r/20240227174254.710559-16-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/mm.h~mm-remove-lru_to_page
+++ a/include/linux/mm.h
@@ -227,7 +227,6 @@ int overcommit_policy_handler(struct ctl
 /* test whether an address (unsigned long or pointer) is aligned to PAGE_SIZE */
 #define PAGE_ALIGNED(addr)	IS_ALIGNED((unsigned long)(addr), PAGE_SIZE)
 
-#define lru_to_page(head) (list_entry((head)->prev, struct page, lru))
 static inline struct folio *lru_to_folio(struct list_head *head)
 {
 	return list_entry((head)->prev, struct folio, lru);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-separate-out-folio_flags-from-pageflags.patch
mm-remove-pagewaiters-pagesetwaiters-and-pageclearwaiters.patch
mm-remove-pageyoung-and-pageidle-definitions.patch
mm-add-__dump_folio.patch
mm-add-__dump_folio-fix.patch
mm-add-__dump_folio-fix-2.patch
mm-add-__dump_folio-fix-3.patch
mm-make-dump_page-take-a-const-argument.patch
mm-constify-testing-page-folio-flags.patch
mm-constify-more-page-folio-tests.patch
mm-remove-cast-from-page_to_nid.patch
mm-mempolicy-use-a-folio-in-do_mbind.patch


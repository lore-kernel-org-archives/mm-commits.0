Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140E629D292
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489895; cv=none; b=QNqADAcJfArZtVgB7/QKa7s3ZPY0/qMEuMpIE32G3QQ9fycNk+G8n2fAxniePHdUwK8oichDe/VzEEOd/+3I72ITdY332omrkXjvu7OfRTeBcSPVzfWJs5lJsU2/uZusrmOGfljlr2I+3t6ZPRFoMPNleDNWSXp7gbdZsds9dXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489895; c=relaxed/simple;
	bh=9P91f6PYry0BCK17EFN3dBTGeQnefvs+T0khLM8sXv0=;
	h=Date:To:From:Subject:Message-Id; b=i5aiOLxN8KhZOve+cE2XY6EVbVZrDW+SuM0QIFiWQoaP+zDpzlhvj588ENfTI64rpwxceX0PEg+aOuVSsV2Tfx2KkjNaUTZxkMKWCQwQ2lRe+2EgMTzKCYdj61167DKEtXUhUQPMIWg0onocpW9Mw3YECt1B2/XrJzvVOfCC7II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TKtElI9e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TKtElI9e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB0DC4CEE7;
	Sun, 21 Sep 2025 21:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489895;
	bh=9P91f6PYry0BCK17EFN3dBTGeQnefvs+T0khLM8sXv0=;
	h=Date:To:From:Subject:From;
	b=TKtElI9eYU+1ntRiGR+IhxP6+uoMS8VHBDUwUCMfSqbIwIGjmttES+F9F23q985lA
	 pMoPDDQ85evCzFPjytwakv0qQdzQXhEdwa2HBhsqaoUbH3C0cBDM/wEsMS6PpQO6Be
	 FxdMvcXgkO1PB7BUv3T4vbVWSTnc03U0i1ZK81VU=
Date: Sun, 21 Sep 2025 14:24:54 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-mlock_count-from-struct-page.patch removed from -mm tree
Message-Id: <20250921212454.DFB0DC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove mlock_count from struct page
has been removed from the -mm tree.  Its filename was
     mm-remove-mlock_count-from-struct-page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove mlock_count from struct page
Date: Wed, 3 Sep 2025 20:10:39 +0100

All users now use folio->mlock_count so we can remove this element of
struct page.  Move the useful comments over to struct folio.

Link: https://lkml.kernel.org/r/20250903191041.1630338-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/include/linux/mm_types.h~mm-remove-mlock_count-from-struct-page
+++ a/include/linux/mm_types.h
@@ -94,14 +94,6 @@ struct page {
 			union {
 				struct list_head lru;
 
-				/* Or, for the Unevictable "LRU list" slot */
-				struct {
-					/* Always even, to negate PageTail */
-					void *__filler;
-					/* Count page's or folio's mlocks */
-					unsigned int mlock_count;
-				};
-
 				/* Or, free page */
 				struct list_head buddy_list;
 				struct list_head pcp_list;
@@ -391,7 +383,9 @@ struct folio {
 			union {
 				struct list_head lru;
 	/* private: avoid cluttering the output */
+				/* For the Unevictable "LRU list" slot */
 				struct {
+					/* Avoid compound_head */
 					void *__filler;
 	/* public: */
 					unsigned int mlock_count;
_

Patches currently in -mm which might be from willy@infradead.org are

ksm-use-a-folio-inside-cmp_and_merge_page.patch


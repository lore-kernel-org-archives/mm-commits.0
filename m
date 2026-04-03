Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB995369208
	for <mm-commits@vger.kernel.org>; Fri,  3 Apr 2026 06:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775198550; cv=none; b=CZMvfyL6D+dsLeQ0F+yOXVJgdq7SJmzIH+PiZli5f6ud16fn9tACCC43GUMHUfR1xIKedraDn8SaTSE+c1KU+YxUecdim7zcXwchbyaGBpMFwRkren5dVP1SfZgfJ1B/ixsdg3J9rX11Oi4NsJSwodB4ATvA6ZbURulZhGDx9o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775198550; c=relaxed/simple;
	bh=y6qVogWu4kwK3lDbLF48B7NJBC6zgWPfj9TwOLDEq+s=;
	h=Date:To:From:Subject:Message-Id; b=kIMqqn32diHyEf6EqtUioLhau2uvevv3oSjP4qIannvnUhNZkGDqIZn8D10YSgObPc4KxKASNcYkyZ72GvYfn0d7qc77mmkwM6+QbiwT+IXBk8I15Jv+RZeSy1kJRAAN5uc3GxHbLXh2KuEovr/IaDBPTblQHxIGrdoVicENshg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MdIqlq2e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MdIqlq2e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82EC4C4CEF7;
	Fri,  3 Apr 2026 06:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775198550;
	bh=y6qVogWu4kwK3lDbLF48B7NJBC6zgWPfj9TwOLDEq+s=;
	h=Date:To:From:Subject:From;
	b=MdIqlq2e/3xLLL6WebkEUmRRBwy2bpBPKLehc/oDoNEZFyqQgYiVSdQlcYUccJRXX
	 6m9SBzTWs5YXAXYRXmU+0KlNiYHh8/lOU0Q3krp5bDJ+H1EeB5cgcBgwmPO3y3kLpP
	 UAFUApwemZI9SG7oE9HZ15bqfIVeAtwuUhCmx8UQ=
Date: Thu, 02 Apr 2026 23:42:29 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,kees@kernel.org,dhowells@redhat.com,davidgow@google.com,lk@c--e.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-kunit_iov_iter-fix-memory-leaks.patch removed from -mm tree
Message-Id: <20260403064230.82EC4C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: kunit_iov_iter: fix memory leaks
has been removed from the -mm tree.  Its filename was
     lib-kunit_iov_iter-fix-memory-leaks.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Christian A. Ehrhardt" <lk@c--e.de>
Subject: lib: kunit_iov_iter: fix memory leaks
Date: Thu, 26 Mar 2026 22:49:03 +0100

Use vfree() instead of vunmap() to free the buffer allocated by
iov_kunit_create_buffer() because vunmap() does not honour
VM_MAP_PUT_PAGES.  In order for this to work the page array itself must
not be managed by kunit.

Remove the folio_put() when destroying a folioq.  This is handled by
vfree(), now.

Pointed out by sashiko.dev on a previous iteration of this series.

Tested by running the kunit test 10000 times in a loop.

Link: https://lkml.kernel.org/r/20260326214905.818170-4-lk@c--e.de
Fixes: 2d71340ff1d4 ("iov_iter: Kunit tests for copying to/from an iterator")
Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
Cc: David Howells <dhowells@redhat.com>
Cc: David Gow <davidgow@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/tests/kunit_iov_iter.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/lib/tests/kunit_iov_iter.c~lib-kunit_iov_iter-fix-memory-leaks
+++ a/lib/tests/kunit_iov_iter.c
@@ -42,7 +42,7 @@ static inline u8 pattern(unsigned long x
 
 static void iov_kunit_unmap(void *data)
 {
-	vunmap(data);
+	vfree(data);
 }
 
 static void *__init iov_kunit_create_buffer(struct kunit *test,
@@ -53,17 +53,22 @@ static void *__init iov_kunit_create_buf
 	unsigned long got;
 	void *buffer;
 
-	pages = kunit_kcalloc(test, npages, sizeof(struct page *), GFP_KERNEL);
-        KUNIT_ASSERT_NOT_ERR_OR_NULL(test, pages);
+	pages = kzalloc_objs(struct page *, npages, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, pages);
 	*ppages = pages;
 
 	got = alloc_pages_bulk(GFP_KERNEL, npages, pages);
 	if (got != npages) {
 		release_pages(pages, got);
+		kvfree(pages);
 		KUNIT_ASSERT_EQ(test, got, npages);
 	}
 
 	buffer = vmap(pages, npages, VM_MAP | VM_MAP_PUT_PAGES, PAGE_KERNEL);
+	if (buffer == NULL) {
+		release_pages(pages, got);
+		kvfree(pages);
+	}
         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, buffer);
 
 	kunit_add_action_or_reset(test, iov_kunit_unmap, buffer);
@@ -369,9 +374,6 @@ static void iov_kunit_destroy_folioq(voi
 
 	for (folioq = data; folioq; folioq = next) {
 		next = folioq->next;
-		for (int i = 0; i < folioq_nr_slots(folioq); i++)
-			if (folioq_folio(folioq, i))
-				folio_put(folioq_folio(folioq, i));
 		kfree(folioq);
 	}
 }
_

Patches currently in -mm which might be from lk@c--e.de are



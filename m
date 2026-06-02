Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47A53B83F8
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439038; cv=none; b=VkWTgSuR6HNaaeuViZvJjzfYAfMgPWgpG0KD55OhQHZAW9dp5dGWJNf10LWDxEiHkVrWu+GrCX9APtIuuyS3NGa3bi66pcKxJ+1z0yKQ8bH1c3gjPaDHEapAnTG2Ay3Kq9eLmF9haZw5gbS853DY/1hd1cb6m0dCwb1BfjJuxkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439038; c=relaxed/simple;
	bh=Hul8FgTCzrTVCFE9U1cCXk6znQHNriJoABOuZxzD4bc=;
	h=Date:To:From:Subject:Message-Id; b=BPCdFCPq3ToV0ccmOU5rk8cr8gIuKbxzFMaYzu6qKUw/ky6AbLx9MaL1GRAHHIflXjEys7nUwepY9W+MH7JMnUTEl+lINfz74tSsJ+fsYj19NhBxongf24i9reZdhscTENRKIV8nibZjSddp3dKyy9hYshqd6bfrgWOFoWO/5a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YPpcZzZ7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YPpcZzZ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A9D1F00899;
	Tue,  2 Jun 2026 22:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439035;
	bh=oZSoRfFsSqvAFrWm/E6G9drIjsrC8wM2L33HvuXioDw=;
	h=Date:To:From:Subject;
	b=YPpcZzZ7Fjt+457L/hQawWclUSgyQm7mSce/p7G1N5uBTgtzKhSk5pcFl7h5d+vkv
	 eJVNAP4M2C2w01eaeUpVyQahC70yPlboXlSfQZ18UvbbVAPe7f++mELrmCpzvlhlqR
	 S0E1c9UZm7JTew6qmY3lvaUUXVbCBj2jY9X+M2Fc=
Date: Tue, 02 Jun 2026 15:23:54 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,fmayle@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-readahead-add-kerneldoc-for-read_pages.patch removed from -mm tree
Message-Id: <20260602222355.40A9D1F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/readahead: add kerneldoc for read_pages
has been removed from the -mm tree.  Its filename was
     mm-readahead-add-kerneldoc-for-read_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Frederick Mayle <fmayle@google.com>
Subject: mm/readahead: add kerneldoc for read_pages
Date: Tue, 12 May 2026 13:31:35 -0700

Patch series "mm: document read_pages and simplify usage".

Add a kerneldoc for read_pages() to formalize an invariant and then use
it to simplify the callers in page_cache_ra_unbounded().


This patch (of 2):

Formalize one of the invariants provided by the current implementation so
that callers can depend on it, as discussed in [1].

Link: https://lore.kernel.org/all/20260501061146.6e61392d125cf1847d7cc181@linux-foundation.org/ [1]
Link: https://lore.kernel.org/20260512203154.754075-2-fmayle@google.com
Signed-off-by: Frederick Mayle <fmayle@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/readahead.c~mm-readahead-add-kerneldoc-for-read_pages
+++ a/mm/readahead.c
@@ -146,6 +146,17 @@ file_ra_state_init(struct file_ra_state
 }
 EXPORT_SYMBOL_GPL(file_ra_state_init);
 
+/**
+ * read_pages() - Start IO for a contiguous range of allocated folios in the
+ *                page cache.
+ * @rac: Readahead control.
+ *
+ * When read_pages() returns, it is guaranteed that all of the folios will have
+ * been processed or removed so that ``readahead_count(rac) == 0``. However,
+ * that does not imply that ``readahead_index(rac)`` will be updated to point
+ * to the end of the originally requested range because, for example, the
+ * filesystem may expand the range upwards.
+ */
 static void read_pages(struct readahead_control *rac)
 {
 	const struct address_space_operations *aops = rac->mapping->a_ops;
_

Patches currently in -mm which might be from fmayle@google.com are



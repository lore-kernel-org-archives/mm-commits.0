Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83DE81AC7
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 20:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708548688; cv=none; b=LCj4qnJMWmL6ZeabOfPjtcpSLT8AytXBDS9QOcnWL2ff+EtrhJ7e2Qh4j84IDcqJyLLTSFt5byb9ERof+kK9mKam6yvTpNlwfu4g2MzO5EaC37SYaEV3nYfBFfqK+bcwAD8wotuvn5rkjHNHfDIsaM69Xgnd8AV9PRcvTvFTzo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708548688; c=relaxed/simple;
	bh=TJ2KwI08JJVd80MGP/YS0H7dge4LSkbHNScPwA/Yzls=;
	h=Date:To:From:Subject:Message-Id; b=bGjiExUdECKDX+8zdAHc9MFAtl357wpIwFHOoAXNGqqPwJRoY2nSVrLZThzm855I7LsZcfiwBBgYWd90wWAWjHSSP9BlI/2LL8MQ+oQVlOjwIkWDQWx8EOJMlSOTz8PlA95OlkkmP35peqYtl5Ey5EmgwDiauUaT6K6JTEIVx9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cMD7RjMj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cMD7RjMj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25301C433C7;
	Wed, 21 Feb 2024 20:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708548688;
	bh=TJ2KwI08JJVd80MGP/YS0H7dge4LSkbHNScPwA/Yzls=;
	h=Date:To:From:Subject:From;
	b=cMD7RjMjuxkP18fJOjXnTvOmJJ/CRRBhQqG/W4y+QfXF3AzTraeOhSAcox4vsocEv
	 MkosMm6p7Ko5sAbdyMQEUl25N1QsBI5ghCC8TPJaZLNJqjSpQAtvJX4ODTyE5ONArE
	 Lmstzm5ICM2wYgxvlFIivgFfRFOLjjytOCdFM7Ks=
Date: Wed, 21 Feb 2024 12:51:27 -0800
To: mm-commits@vger.kernel.org,jack@suse.cz,hch@lst.de,dhowells@redhat.com,dchinner@redhat.com,brauner@kernel.org,bfoster@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-factor-folio_prepare_writeback-out-of-write_cache_pages.patch added to mm-unstable branch
Message-Id: <20240221205128.25301C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: writeback: Factor folio_prepare_writeback() out of write_cache_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     writeback-factor-folio_prepare_writeback-out-of-write_cache_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-factor-folio_prepare_writeback-out-of-write_cache_pages.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: writeback: Factor folio_prepare_writeback() out of write_cache_pages()
Date: Thu, 15 Feb 2024 07:36:42 +0100

Reduce write_cache_pages() by about 30 lines; much of it is commentary,
but it all bundles nicely into an obvious function.

[hch@lst.de: rename should_writeback_folio to folio_prepare_writeback per Jan]
Link: https://lkml.kernel.org/r/20240215063649.2164017-8-hch@lst.de
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Dave Chinner <dchinner@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   61 +++++++++++++++++++++++-------------------
 1 file changed, 34 insertions(+), 27 deletions(-)

--- a/mm/page-writeback.c~writeback-factor-folio_prepare_writeback-out-of-write_cache_pages
+++ a/mm/page-writeback.c
@@ -2360,6 +2360,38 @@ void tag_pages_for_writeback(struct addr
 }
 EXPORT_SYMBOL(tag_pages_for_writeback);
 
+static bool folio_prepare_writeback(struct address_space *mapping,
+		struct writeback_control *wbc, struct folio *folio)
+{
+	/*
+	 * Folio truncated or invalidated. We can freely skip it then,
+	 * even for data integrity operations: the folio has disappeared
+	 * concurrently, so there could be no real expectation of this
+	 * data integrity operation even if there is now a new, dirty
+	 * folio at the same pagecache index.
+	 */
+	if (unlikely(folio->mapping != mapping))
+		return false;
+
+	/*
+	 * Did somebody else write it for us?
+	 */
+	if (!folio_test_dirty(folio))
+		return false;
+
+	if (folio_test_writeback(folio)) {
+		if (wbc->sync_mode == WB_SYNC_NONE)
+			return false;
+		folio_wait_writeback(folio);
+	}
+	BUG_ON(folio_test_writeback(folio));
+
+	if (!folio_clear_dirty_for_io(folio))
+		return false;
+
+	return true;
+}
+
 /**
  * write_cache_pages - walk the list of dirty pages of the given address space and write all of them.
  * @mapping: address space structure to write
@@ -2430,38 +2462,13 @@ int write_cache_pages(struct address_spa
 		for (i = 0; i < nr_folios; i++) {
 			folio = fbatch.folios[i];
 			folio_lock(folio);
-
-			/*
-			 * Page truncated or invalidated. We can freely skip it
-			 * then, even for data integrity operations: the page
-			 * has disappeared concurrently, so there could be no
-			 * real expectation of this data integrity operation
-			 * even if there is now a new, dirty page at the same
-			 * pagecache address.
-			 */
-			if (unlikely(folio->mapping != mapping)) {
-continue_unlock:
+			if (!folio_prepare_writeback(mapping, wbc, folio)) {
 				folio_unlock(folio);
 				continue;
 			}
 
-			if (!folio_test_dirty(folio)) {
-				/* someone wrote it for us */
-				goto continue_unlock;
-			}
-
-			if (folio_test_writeback(folio)) {
-				if (wbc->sync_mode != WB_SYNC_NONE)
-					folio_wait_writeback(folio);
-				else
-					goto continue_unlock;
-			}
-
-			BUG_ON(folio_test_writeback(folio));
-			if (!folio_clear_dirty_for_io(folio))
-				goto continue_unlock;
-
 			trace_wbc_writepage(wbc, inode_to_bdi(mapping->host));
+
 			error = writepage(folio, wbc, data);
 			wbc->nr_to_write -= folio_nr_pages(folio);
 
_

Patches currently in -mm which might be from willy@infradead.org are

memcg-convert-mem_cgroup_move_charge_pte_range-to-use-a-folio.patch
memcg-return-the-folio-in-union-mc_target.patch
memcg-use-a-folio-in-get_mctgt_type.patch
memcg-use-a-folio-in-get_mctgt_type_thp.patch
mm-add-pfn_swap_entry_folio.patch
proc-use-pfn_swap_entry_folio-where-obvious.patch
mprotect-use-pfn_swap_entry_folio.patch
highmem-add-kernel-doc-for-memcpy__folio.patch
rmap-replace-two-calls-to-compound_order-with-folio_order.patch
writeback-remove-a-duplicate-prototype-for-tag_pages_for_writeback.patch
writeback-factor-folio_prepare_writeback-out-of-write_cache_pages.patch
writeback-factor-writeback_get_batch-out-of-write_cache_pages.patch
writeback-simplify-the-loops-in-write_cache_pages.patch
pagevec-add-ability-to-iterate-a-queue.patch
writeback-use-the-folio_batch-queue-iterator.patch
writeback-move-the-folio_prepare_writeback-loop-out-of-write_cache_pages.patch
writeback-remove-a-use-of-write_cache_pages-from-do_writepages.patch
bounds-support-non-power-of-two-config_nr_cpus.patch


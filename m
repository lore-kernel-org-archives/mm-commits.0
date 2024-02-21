Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C4F85639
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 20:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708548694; cv=none; b=jQGkU3dHVIzc8A27QP3ZzAaSvHkHMAM6NI3ZMugl8a3TRhit5QDDqxLPh2xsmZlXl+bz/16pWVf/mTiR19/WokmtCA6QbXIrYYQJpi78PF2JcCdwnRdW07I5WfZUKUW/ioszwmamyVN/evjPjtcKCOueCCA6PU3KK06rrq5mThc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708548694; c=relaxed/simple;
	bh=IFJkXcTXeO7vIm7R5J95BhQ5+9nCs3p4mViBySAyfq8=;
	h=Date:To:From:Subject:Message-Id; b=oSUQ773VX9L7B5iJfqiJEQ8/5YY4bHzkTkXuc990w3sALme0iNiERebTlXpiy7/q6M8I89T/5PsoMxCY70lQ8QIj8diw8YHlhMXLXR6W08yvz8893A+q0dQAGU1U0lI7MWVE+Rm6EpCZhM7gfki9VX7TigR1AnkJlC+WV7uDqtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tbskrslk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tbskrslk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E74C433C7;
	Wed, 21 Feb 2024 20:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708548694;
	bh=IFJkXcTXeO7vIm7R5J95BhQ5+9nCs3p4mViBySAyfq8=;
	h=Date:To:From:Subject:From;
	b=tbskrslkpNn1z1AE7O8E9+eaVQsn9x5V+pySOVRlZ5Ukxa713+auEPpXb6pW7xz0V
	 eIZYNil12OwU8PXmeJtxaaOMP6jqBMttiVbr0TvZuRhFzBVy9wEsCloR757b0dHDRM
	 FLxrccv4qAcjG9S/t20XwTBYy4Giplf8z1zL2NtU=
Date: Wed, 21 Feb 2024 12:51:33 -0800
To: mm-commits@vger.kernel.org,jack@suse.cz,hch@lst.de,dhowells@redhat.com,dchinner@redhat.com,brauner@kernel.org,bfoster@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-move-the-folio_prepare_writeback-loop-out-of-write_cache_pages.patch added to mm-unstable branch
Message-Id: <20240221205134.35E74C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: writeback: move the folio_prepare_writeback loop out of write_cache_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     writeback-move-the-folio_prepare_writeback-loop-out-of-write_cache_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-move-the-folio_prepare_writeback-loop-out-of-write_cache_pages.patch

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
Subject: writeback: move the folio_prepare_writeback loop out of write_cache_pages()
Date: Thu, 15 Feb 2024 07:36:47 +0100

Move the loop for should-we-write-this-folio to writeback_get_folio.

[hch@lst.de: fold loop into existing helper instead of a separate one per Jan]
Link: https://lkml.kernel.org/r/20240215063649.2164017-13-hch@lst.de
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Dave Chinner <dchinner@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/mm/page-writeback.c~writeback-move-the-folio_prepare_writeback-loop-out-of-write_cache_pages
+++ a/mm/page-writeback.c
@@ -2411,6 +2411,7 @@ static struct folio *writeback_get_folio
 {
 	struct folio *folio;
 
+retry:
 	folio = folio_batch_next(&wbc->fbatch);
 	if (!folio) {
 		folio_batch_release(&wbc->fbatch);
@@ -2418,8 +2419,17 @@ static struct folio *writeback_get_folio
 		filemap_get_folios_tag(mapping, &wbc->index, wbc_end(wbc),
 				wbc_to_tag(wbc), &wbc->fbatch);
 		folio = folio_batch_next(&wbc->fbatch);
+		if (!folio)
+			return NULL;
+	}
+
+	folio_lock(folio);
+	if (unlikely(!folio_prepare_writeback(mapping, wbc, folio))) {
+		folio_unlock(folio);
+		goto retry;
 	}
 
+	trace_wbc_writepage(wbc, inode_to_bdi(mapping->host));
 	return folio;
 }
 
@@ -2480,14 +2490,6 @@ int write_cache_pages(struct address_spa
 		if (!folio)
 			break;
 
-		folio_lock(folio);
-		if (!folio_prepare_writeback(mapping, wbc, folio)) {
-			folio_unlock(folio);
-			continue;
-		}
-
-		trace_wbc_writepage(wbc, inode_to_bdi(mapping->host));
-
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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2663C488
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 20:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708548682; cv=none; b=Ugvah3UPhmACdmcbRhUCcogpoSvJEZ9C05TvK5OC4yHFVjTe/F6GK6suMsSdOEsGGFBFga2mYhUdckZTCP7tnd9+jZHWenga0pKBCDqhejj4uFtAa//2u3lIhzqsRBeK7CJDFD85WeIOmcM8xGSvSRv2ied0GBcCvKyA4UHGxHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708548682; c=relaxed/simple;
	bh=OspKWaQmwSeglcmvc65DRo186LZWrgp6vh0201IGgB0=;
	h=Date:To:From:Subject:Message-Id; b=jCaCe8RFMdSxQ2VC+9dH5XOmxY2wu6VmBg+NSRSDGhJvu/E6W2Y22I8VsRZAHA35LuFp30zdopqHAEq08vkYRTUlIT8jbdhqSWAqz+ZKdyFHgqKBfqsl5EyA8+cPsAi0AT1L2HgT4NDPLQeBO6XG3Yyjme12L1fZmzfxzqWkOHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zIvfnZe8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zIvfnZe8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D8CC433C7;
	Wed, 21 Feb 2024 20:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708548682;
	bh=OspKWaQmwSeglcmvc65DRo186LZWrgp6vh0201IGgB0=;
	h=Date:To:From:Subject:From;
	b=zIvfnZe83UJC11bOeDegfJqSpZTuz40cGr+CRA/ZKzRTbx/XY32MS1t+zKdm5Rx7h
	 7mHJObSlF/ETxEfh+c20TUVZ2gJ+fDNd2pk1RpQYGZ0pcdk2ttZk5Uk34Wxwx2XJaL
	 CSddpO0A88EvU8XC3Q1SATfjFHh1QJ6YjpGptQ8A=
Date: Wed, 21 Feb 2024 12:51:21 -0800
To: mm-commits@vger.kernel.org,jack@suse.cz,hch@lst.de,dhowells@redhat.com,dchinner@redhat.com,brauner@kernel.org,bfoster@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-remove-a-duplicate-prototype-for-tag_pages_for_writeback.patch added to mm-unstable branch
Message-Id: <20240221205122.32D8CC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: writeback: remove a duplicate prototype for tag_pages_for_writeback
has been added to the -mm mm-unstable branch.  Its filename is
     writeback-remove-a-duplicate-prototype-for-tag_pages_for_writeback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-remove-a-duplicate-prototype-for-tag_pages_for_writeback.patch

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
Subject: writeback: remove a duplicate prototype for tag_pages_for_writeback
Date: Thu, 15 Feb 2024 07:36:37 +0100

[hch@lst.de: split from a larger patch]
Link: https://lkml.kernel.org/r/20240215063649.2164017-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Dave Chinner <dchinner@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/writeback.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/writeback.h~writeback-remove-a-duplicate-prototype-for-tag_pages_for_writeback
+++ a/include/linux/writeback.h
@@ -363,8 +363,6 @@ bool wb_over_bg_thresh(struct bdi_writeb
 typedef int (*writepage_t)(struct folio *folio, struct writeback_control *wbc,
 				void *data);
 
-void tag_pages_for_writeback(struct address_space *mapping,
-			     pgoff_t start, pgoff_t end);
 int write_cache_pages(struct address_space *mapping,
 		      struct writeback_control *wbc, writepage_t writepage,
 		      void *data);
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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0A23A1AF
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 20:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708548697; cv=none; b=ium46P+wRxfXIAQ8ZHj8+nZJPwEG+475odIqlmI5Hh6A5TTFs49JYEvxZdYXxceNZpXdfK9z/76/uCDo9OwlDIeNw30Wgcy+6Tuqrp3b1O8++t37loAGOApZEHSiM19vdbVTOWduh05MIWowT4pWwbkpro3UnzjwDsk9sKZ+7gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708548697; c=relaxed/simple;
	bh=AxAi0RZyctJbe0h42kKPXAVYZPFbn0RbebrHdIcSfvo=;
	h=Date:To:From:Subject:Message-Id; b=FUKwMqefo7rZvtiQCBGgJAvsRY3iuSM4KMyJfghOeB+poRofodkUiqNWQ2fo8PUXjmjFKFggWGtEWBqb1p8YxpEWV24GXTZeYe9BZDo2hpTkHEAGPiERk/VIdC6A40X6UrOPE/fBXOG0C79z+rDmTFiWyBCdpH3gWWLO7aPRFSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FgrmPfsE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FgrmPfsE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C57C43390;
	Wed, 21 Feb 2024 20:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708548696;
	bh=AxAi0RZyctJbe0h42kKPXAVYZPFbn0RbebrHdIcSfvo=;
	h=Date:To:From:Subject:From;
	b=FgrmPfsE+jiSa5eKjJwxTVFbbdWZnPqJ0YhnFKwBlKjISHo+znMTuu0ISN/g+PqkX
	 AgYcckdDtAe8tOh2eqz6+Erw7xbQ2855bXmtUCCClw+gzQ1Q1NG2EierGHO96pSf/b
	 mk4WTlTcAwLSiJhxXNRpp+O3/jG3c4VkSav/3I1Y=
Date: Wed, 21 Feb 2024 12:51:36 -0800
To: mm-commits@vger.kernel.org,jack@suse.cz,hch@lst.de,dhowells@redhat.com,dchinner@redhat.com,brauner@kernel.org,bfoster@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-remove-a-use-of-write_cache_pages-from-do_writepages.patch added to mm-unstable branch
Message-Id: <20240221205136.C3C57C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: writeback: remove a use of write_cache_pages() from do_writepages()
has been added to the -mm mm-unstable branch.  Its filename is
     writeback-remove-a-use-of-write_cache_pages-from-do_writepages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-remove-a-use-of-write_cache_pages-from-do_writepages.patch

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
Subject: writeback: remove a use of write_cache_pages() from do_writepages()
Date: Thu, 15 Feb 2024 07:36:49 +0100

Use the new writeback_iter() directly instead of indirecting through a
callback.

[hch@lst.de: ported to the while based iter style]
Link: https://lkml.kernel.org/r/20240215063649.2164017-15-hch@lst.de
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

--- a/mm/page-writeback.c~writeback-remove-a-use-of-write_cache_pages-from-do_writepages
+++ a/mm/page-writeback.c
@@ -2577,15 +2577,25 @@ int write_cache_pages(struct address_spa
 }
 EXPORT_SYMBOL(write_cache_pages);
 
-static int writepage_cb(struct folio *folio, struct writeback_control *wbc,
-		void *data)
+static int writeback_use_writepage(struct address_space *mapping,
+		struct writeback_control *wbc)
 {
-	struct address_space *mapping = data;
-	int ret = mapping->a_ops->writepage(&folio->page, wbc);
+	struct folio *folio = NULL;
+	struct blk_plug plug;
+	int err;
 
-	if (ret < 0)
-		mapping_set_error(mapping, ret);
-	return ret;
+	blk_start_plug(&plug);
+	while ((folio = writeback_iter(mapping, wbc, folio, &err))) {
+		err = mapping->a_ops->writepage(&folio->page, wbc);
+		if (err == AOP_WRITEPAGE_ACTIVATE) {
+			folio_unlock(folio);
+			err = 0;
+		}
+		mapping_set_error(mapping, err);
+	}
+	blk_finish_plug(&plug);
+
+	return err;
 }
 
 int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
@@ -2601,12 +2611,7 @@ int do_writepages(struct address_space *
 		if (mapping->a_ops->writepages) {
 			ret = mapping->a_ops->writepages(mapping, wbc);
 		} else if (mapping->a_ops->writepage) {
-			struct blk_plug plug;
-
-			blk_start_plug(&plug);
-			ret = write_cache_pages(mapping, wbc, writepage_cb,
-						mapping);
-			blk_finish_plug(&plug);
+			ret = writeback_use_writepage(mapping, wbc);
 		} else {
 			/* deal with chardevs and other special files */
 			ret = 0;
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


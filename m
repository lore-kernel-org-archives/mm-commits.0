Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F7E81AC7
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 20:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708548692; cv=none; b=abnjrHDSoNJsAyscC5+/ZeTWKX3pTnCIz79O8HRK923h8WFl9vW9HQy6V5q3m7K79EXJsSFDNb14aVpiEwj9D7eY05rSLfXe67qpMX3NqAjGVCIgQkXnpYrO4NYaovLbUWWNuxVUAOsX1c2Mp47zlEqjwGJs9jVB/y7UPgib11s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708548692; c=relaxed/simple;
	bh=DhNua0Z4BzAu4+b94S9/eTR3CBKe/aRR4qZgBxoyobA=;
	h=Date:To:From:Subject:Message-Id; b=dDshHwnQpM7WMD+Ex9T1+/ZFQAwyUcmoEK2HnupcaZhC2aA+QHHWPH/PQPd/eEVNQr0Cj+9fzFO/ZQs3dAKREjcK76+pc8ObIWdAR97LhTl0URez9msADja2ldENlazSGlSt8QgYy+wjFZ1PfezoJ1jHhNyzZ0Ya9bvgtUKrtiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Uqz4Xzem; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Uqz4Xzem"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52CFC433C7;
	Wed, 21 Feb 2024 20:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708548691;
	bh=DhNua0Z4BzAu4+b94S9/eTR3CBKe/aRR4qZgBxoyobA=;
	h=Date:To:From:Subject:From;
	b=Uqz4XzemUOOeJQhmXBggHVjdZlLSixu31S4Q+e5/IKboztMBbuPcPkOgutR7oovIc
	 GkD2MJp7D3ZfKbFmM2n4H6FAturhvV+ox0MReS3JU1nnl+hJw9mJJzzCYHtvy5GClZ
	 scNsqepYTZ9UVcOw39fqUXZp5jelUkF0G0BoMCjw=
Date: Wed, 21 Feb 2024 12:51:31 -0800
To: mm-commits@vger.kernel.org,jack@suse.cz,hch@lst.de,dhowells@redhat.com,dchinner@redhat.com,brauner@kernel.org,bfoster@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + pagevec-add-ability-to-iterate-a-queue.patch added to mm-unstable branch
Message-Id: <20240221205131.C52CFC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: pagevec: add ability to iterate a queue
has been added to the -mm mm-unstable branch.  Its filename is
     pagevec-add-ability-to-iterate-a-queue.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/pagevec-add-ability-to-iterate-a-queue.patch

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
Subject: pagevec: add ability to iterate a queue
Date: Thu, 15 Feb 2024 07:36:45 +0100

Add a loop counter inside the folio_batch to let us iterate from 0-nr
instead of decrementing nr and treating the batch as a stack.  It would
generate some very weird and suboptimal I/O patterns for page writeback to
iterate over the batch as a stack.

Link: https://lkml.kernel.org/r/20240215063649.2164017-11-hch@lst.de
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Dave Chinner <dchinner@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagevec.h |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/include/linux/pagevec.h~pagevec-add-ability-to-iterate-a-queue
+++ a/include/linux/pagevec.h
@@ -27,6 +27,7 @@ struct folio;
  */
 struct folio_batch {
 	unsigned char nr;
+	unsigned char i;
 	bool percpu_pvec_drained;
 	struct folio *folios[PAGEVEC_SIZE];
 };
@@ -40,12 +41,14 @@ struct folio_batch {
 static inline void folio_batch_init(struct folio_batch *fbatch)
 {
 	fbatch->nr = 0;
+	fbatch->i = 0;
 	fbatch->percpu_pvec_drained = false;
 }
 
 static inline void folio_batch_reinit(struct folio_batch *fbatch)
 {
 	fbatch->nr = 0;
+	fbatch->i = 0;
 }
 
 static inline unsigned int folio_batch_count(struct folio_batch *fbatch)
@@ -75,6 +78,21 @@ static inline unsigned folio_batch_add(s
 	return folio_batch_space(fbatch);
 }
 
+/**
+ * folio_batch_next - Return the next folio to process.
+ * @fbatch: The folio batch being processed.
+ *
+ * Use this function to implement a queue of folios.
+ *
+ * Return: The next folio in the queue, or NULL if the queue is empty.
+ */
+static inline struct folio *folio_batch_next(struct folio_batch *fbatch)
+{
+	if (fbatch->i == fbatch->nr)
+		return NULL;
+	return fbatch->folios[fbatch->i++];
+}
+
 void __folio_batch_release(struct folio_batch *pvec);
 
 static inline void folio_batch_release(struct folio_batch *fbatch)
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


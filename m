Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCC26C77B73
	for <mm-commits@archiver.kernel.org>; Tue,  2 May 2023 01:11:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbjEBBLZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 1 May 2023 21:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbjEBBLW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 1 May 2023 21:11:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02DF335A8
        for <mm-commits@vger.kernel.org>; Mon,  1 May 2023 18:11:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93156620CD
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 01:11:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67E7C433D2;
        Tue,  2 May 2023 01:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1682989880;
        bh=8dVyYX8fa9yJUCv4gCF5CHI5KHzG8DmjJnvBPZlzqm8=;
        h=Date:To:From:Subject:From;
        b=12Zh9f0UEKCzKpQ7U7ezBYbqgKorCC+VHvd8N42fGHB+gQhL0TqKhHjimfkwlkKh3
         /QBVw/Fku0lbNu3w6cey1773TyOo/WhgjP9hqGKmhCmJgOeiURbhHmQSpU3v8kn5XB
         2fxlqiMjWWGIGUZVjraQj8n/TJKmDKJasxsfKqCc=
Date:   Mon, 01 May 2023 18:11:19 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, tytso@mit.edu,
        richardcochran@gmail.com, peterz@infradead.org, peterx@redhat.com,
        pabeni@redhat.com, oleg@redhat.com, neescoba@cisco.com,
        namhyung@kernel.org, mpenttil@redhat.com, mingo@redhat.com,
        mark.rutland@arm.com, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, leon@kernel.org, kuba@kernel.org,
        kirill@shutemov.name, jonathan.lemon@gmail.com, jolsa@kernel.org,
        john.fastabend@gmail.com, jhubbard@nvidia.com, jgg@nvidia.com,
        jack@suse.cz, irogers@google.com, hawk@kernel.org,
        edumazet@google.com, dennis.dalessandro@cornelisnetworks.com,
        david@redhat.com, david@fromorbit.com, davem@davemloft.net,
        daniel@iogearbox.net, brauner@kernel.org, bmt@zurich.ibm.com,
        bjorn@kernel.org, benve@cisco.com, axboe@kernel.dk, ast@kernel.org,
        asml.silence@gmail.com, alexander.shishkin@linux.intel.com,
        adrian.hunter@intel.com, acme@kernel.org, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-disallow-foll_longterm-gup-fast-writing-to-file-backed-mappings.patch added to mm-unstable branch
Message-Id: <20230502011119.E67E7C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: disallow FOLL_LONGTERM GUP-fast writing to file-backed mappings
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-disallow-foll_longterm-gup-fast-writing-to-file-backed-mappings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-disallow-foll_longterm-gup-fast-writing-to-file-backed-mappings.patch

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
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm/gup: disallow FOLL_LONGTERM GUP-fast writing to file-backed mappings
Date: Tue, 2 May 2023 00:11:49 +0100

Writing to file-backed dirty-tracked mappings via GUP is inherently broken
as we cannot rule out folios being cleaned and then a GUP user writing to
them again and possibly marking them dirty unexpectedly.

This is especially egregious for long-term mappings (as indicated by the
use of the FOLL_LONGTERM flag), so we disallow this case in GUP-fast as we
have already done in the slow path.

We have access to less information in the fast path as we cannot examine
the VMA containing the mapping, however we can determine whether the folio
is anonymous and then whitelist known-good mappings - specifically hugetlb
and shmem mappings.

While we obtain a stable folio for this check, the mapping might not be,
as a truncate could nullify it at any time.  Since doing so requires
mappings to be zapped, we can synchronise against a TLB shootdown
operation.

For some architectures TLB shootdown is synchronised by IPI, against which
we are protected as the GUP-fast operation is performed with interrupts
disabled.  However, other architectures which specify
CONFIG_MMU_GATHER_RCU_TABLE_FREE use an RCU lock for this operation.

In these instances, we acquire an RCU lock while performing our checks. 
If we cannot get a stable mapping, we fall back to the slow path, as
otherwise we'd have to walk the page tables again and it's simpler and
more effective to just fall back.

It's important to note that there are no APIs allowing users to specify
FOLL_FAST_ONLY for a PUP-fast let alone with FOLL_LONGTERM, so we can
always rely on the fact that if we fail to pin on the fast path, the code
will fall back to the slow path which can perform the more thorough check.

Link: https://lkml.kernel.org/r/dee4f4ad6532b0f94d073da263526de334d5d7e0.1682981880.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Kirill A . Shutemov <kirill@shutemov.name>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Bernard Metzler <bmt@zurich.ibm.com>
Cc: Björn Töpel <bjorn@kernel.org>
Cc: Christian Benvenuti <benve@cisco.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Jonathan Lemon <jonathan.lemon@gmail.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: Magnus Karlsson <magnus.karlsson@intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Nelson Escobar <neescoba@cisco.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   87 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 85 insertions(+), 2 deletions(-)

--- a/mm/gup.c~mm-gup-disallow-foll_longterm-gup-fast-writing-to-file-backed-mappings
+++ a/mm/gup.c
@@ -18,6 +18,7 @@
 #include <linux/migrate.h>
 #include <linux/mm_inline.h>
 #include <linux/sched/mm.h>
+#include <linux/shmem_fs.h>
 
 #include <asm/mmu_context.h>
 #include <asm/tlbflush.h>
@@ -95,6 +96,77 @@ retry:
 	return folio;
 }
 
+#ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
+static bool stabilise_mapping_rcu(struct folio *folio)
+{
+	struct address_space *mapping = READ_ONCE(folio->mapping);
+
+	rcu_read_lock();
+
+	return mapping == READ_ONCE(folio->mapping);
+}
+
+static void unlock_rcu(void)
+{
+	rcu_read_unlock();
+}
+#else
+static bool stabilise_mapping_rcu(struct folio *)
+{
+	return true;
+}
+
+static void unlock_rcu(void)
+{
+}
+#endif
+
+/*
+ * Used in the GUP-fast path to determine whether a FOLL_PIN | FOLL_LONGTERM |
+ * FOLL_WRITE pin is permitted for a specific folio.
+ *
+ * This assumes the folio is stable and pinned.
+ *
+ * Writing to pinned file-backed dirty tracked folios is inherently problematic
+ * (see comment describing the writeable_file_mapping_allowed() function). We
+ * therefore try to avoid the most egregious case of a long-term mapping doing
+ * so.
+ *
+ * This function cannot be as thorough as that one as the VMA is not available
+ * in the fast path, so instead we whitelist known good cases.
+ *
+ * The folio is stable, but the mapping might not be. When truncating for
+ * instance, a zap is performed which triggers TLB shootdown. IRQs are disabled
+ * so we are safe from an IPI, but some architectures use an RCU lock for this
+ * operation, so we acquire an RCU lock to ensure the mapping is stable.
+ */
+static bool folio_longterm_write_pin_allowed(struct folio *folio)
+{
+	bool ret;
+
+	/* hugetlb mappings do not require dirty tracking. */
+	if (folio_test_hugetlb(folio))
+		return true;
+
+	if (stabilise_mapping_rcu(folio)) {
+		struct address_space *mapping = folio_mapping(folio);
+
+		/*
+		 * Neither anonymous nor shmem-backed folios require
+		 * dirty tracking.
+		 */
+		ret = folio_test_anon(folio) ||
+			(mapping && shmem_mapping(mapping));
+	} else {
+		/* If the mapping is unstable, fallback to the slow path. */
+		ret = false;
+	}
+
+	unlock_rcu();
+
+	return ret;
+}
+
 /**
  * try_grab_folio() - Attempt to get or pin a folio.
  * @page:  pointer to page to be grabbed
@@ -123,6 +195,8 @@ retry:
  */
 struct folio *try_grab_folio(struct page *page, int refs, unsigned int flags)
 {
+	bool is_longterm = flags & FOLL_LONGTERM;
+
 	if (unlikely(!(flags & FOLL_PCI_P2PDMA) && is_pci_p2pdma_page(page)))
 		return NULL;
 
@@ -136,8 +210,7 @@ struct folio *try_grab_folio(struct page
 		 * right zone, so fail and let the caller fall back to the slow
 		 * path.
 		 */
-		if (unlikely((flags & FOLL_LONGTERM) &&
-			     !is_longterm_pinnable_page(page)))
+		if (unlikely(is_longterm && !is_longterm_pinnable_page(page)))
 			return NULL;
 
 		/*
@@ -149,6 +222,16 @@ struct folio *try_grab_folio(struct page
 			return NULL;
 
 		/*
+		 * Can this folio be safely pinned? We need to perform this
+		 * check after the folio is stabilised.
+		 */
+		if ((flags & FOLL_WRITE) && is_longterm &&
+		    !folio_longterm_write_pin_allowed(folio)) {
+			folio_put_refs(folio, refs);
+			return NULL;
+		}
+
+		/*
 		 * When pinning a large folio, use an exact count to track it.
 		 *
 		 * However, be sure to *also* increment the normal folio
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-mempolicy-correctly-update-prev-when-policy-is-equal-on-mbind.patch
mm-mmap-separate-writenotify-and-dirty-tracking-logic.patch
mm-gup-disallow-foll_longterm-gup-nonfast-writing-to-file-backed-mappings.patch
mm-gup-disallow-foll_longterm-gup-fast-writing-to-file-backed-mappings.patch


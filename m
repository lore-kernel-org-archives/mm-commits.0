From: akpm@linux-foundation.org
Subject: + readahead-remove-sync-async-readahead-call-dependency.patch added to -mm tree
Date: Fri, 10 Apr 2009 16:39:15 -0700
Message-ID: <200904102339.n3ANdGuF021246@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753840AbZDJXls (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 19:41:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, npiggin@suse.de, torvalds@linux-foundation.org, yinghan@google.com


The patch titled
     readahead: remove sync/async readahead call dependency
has been added to the -mm tree.  Its filename is
     readahead-remove-sync-async-readahead-call-dependency.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: readahead: remove sync/async readahead call dependency
From: Wu Fengguang <fengguang.wu@intel.com>

The readahead call scheme is error-prone in that it expects the call sites
to check for async readahead after doing a sync one.  I.e.

			if (!page)
				page_cache_sync_readahead();
			page = find_get_page();
			if (page && PageReadahead(page))
				page_cache_async_readahead();

This is because PG_readahead could be set by a sync readahead for the
_current_ newly faulted in page, and the readahead code simply expects one
more callback on the same page to start the async readahead.  If the
caller fails to do so, it will miss the PG_readahead bits and never able
to start an async readahead.

Eliminate this insane constraint by piggy-backing the async part into the
current readahead window.

Now if an async readahead should be started immediately after a sync one,
the readahead logic itself will do it.  So the following code becomes
valid: (the 'else' in particular)

			if (!page)
				page_cache_sync_readahead();
			else if (PageReadahead(page))
				page_cache_async_readahead();

Cc: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN mm/readahead.c~readahead-remove-sync-async-readahead-call-dependency mm/readahead.c
--- a/mm/readahead.c~readahead-remove-sync-async-readahead-call-dependency
+++ a/mm/readahead.c
@@ -421,6 +421,16 @@ ondemand_readahead(struct address_space 
 	ra->async_size = ra->size > req_size ? ra->size - req_size : ra->size;
 
 readit:
+	/*
+	 * Will this read hit the readahead marker made by itself?
+	 * If so, trigger the readahead marker hit now, and merge
+	 * the resulted next readahead window into the current one.
+	 */
+	if (offset == ra->start && ra->size == ra->async_size) {
+		ra->async_size = get_next_ra_size(ra, max);
+		ra->size += ra->async_size;
+	}
+
 	return ra_submit(ra, mapping, filp);
 }
 
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
readahead-make-mmap_miss-an-unsigned-int.patch
readahead-move-max_sane_readahead-calls-into-force_page_cache_readahead.patch
readahead-apply-max_sane_readahead-limit-in-ondemand_readahead.patch
readahead-remove-one-unnecessary-radix-tree-lookup.patch
readahead-increase-interleaved-readahead-size.patch
readahead-remove-sync-async-readahead-call-dependency.patch
readahead-clean-up-and-simplify-the-code-for-filemap-page-fault-readahead.patch
readahead-sequential-mmap-readahead.patch
readahead-enforce-full-readahead-size-on-async-mmap-readahead.patch
readahead-record-mmap-read-around-states-in-file_ra_state.patch


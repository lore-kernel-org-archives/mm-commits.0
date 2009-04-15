From: akpm@linux-foundation.org
Subject: + readahead-remove-redundant-test-in-shrink_readahead_size_eio.patch added to -mm tree
Date: Wed, 15 Apr 2009 16:42:04 -0700
Message-ID: <200904152342.n3FNg4is010833@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753013AbZDOXns (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Apr 2009 19:43:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com


The patch titled
     readahead: remove redundant test in shrink_readahead_size_eio()
has been added to the -mm tree.  Its filename is
     readahead-remove-redundant-test-in-shrink_readahead_size_eio.patch

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
Subject: readahead: remove redundant test in shrink_readahead_size_eio()
From: Wu Fengguang <fengguang.wu@intel.com>

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/filemap.c~readahead-remove-redundant-test-in-shrink_readahead_size_eio mm/filemap.c
--- a/mm/filemap.c~readahead-remove-redundant-test-in-shrink_readahead_size_eio
+++ a/mm/filemap.c
@@ -1003,9 +1003,6 @@ EXPORT_SYMBOL(grab_cache_page_nowait);
 static void shrink_readahead_size_eio(struct file *filp,
 					struct file_ra_state *ra)
 {
-	if (!ra->ra_pages)
-		return;

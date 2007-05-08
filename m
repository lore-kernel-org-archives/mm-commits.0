From: akpm@linux-foundation.org
Subject: - readahead-remove-size-limit-on-read_ahead_kb.patch removed from -mm tree
Date: Tue, 08 May 2007 01:15:58 -0700
Message-ID: <200705080815.l488Fwos019079@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934650AbXEHIQa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:16:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: remove size limit on read_ahead_kb
has been removed from the -mm tree.  Its filename was
     readahead-remove-size-limit-on-read_ahead_kb.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: readahead: remove size limit on read_ahead_kb
From: Wu Fengguang <wfg@mail.ustc.edu.cn>

Make possible large readahead values harmless.  The stock readahead is
protected by always consulting the avaiable memory before applying this
number.  Other readahead paths have already did so.

Signed-off-by: Wu Fengguang <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/readahead.c~readahead-remove-size-limit-on-read_ahead_kb mm/readahead.c
--- a/mm/readahead.c~readahead-remove-size-limit-on-read_ahead_kb
+++ a/mm/readahead.c
@@ -143,7 +143,7 @@ EXPORT_SYMBOL_GPL(file_ra_state_init);
  */
 static inline unsigned long get_max_readahead(struct file_ra_state *ra)
 {
-	return ra->ra_pages;
+	return max_sane_readahead(ra->ra_pages);
 }
 
 static inline unsigned long get_min_readahead(struct file_ra_state *ra)
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
readahead-remove-size-limit-on-read_ahead_kb.patch
readahead-remove-size-limit-of-max_sectors_kb-on-read_ahead_kb.patch
readahead-partial-sendfile-fix.patch
readahead-turn-on-by-default.patch

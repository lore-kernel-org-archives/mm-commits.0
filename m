Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09BBF17920C
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 18:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719340176; cv=none; b=jCMG3+qbXCbTUcewzk2EVWKT2OHsP/qeR3owYqojQVfZ75OrWZVn1JsBcSO6I3XpTUpKJ1JHX5zSGkmnkkhHnx9vxY4YoXMDGbmsh+8TPDF++eVgtmMnpu9Rkg509BCReeduBK+vccUv9UJHTx1FY+WqVH4jYbxirY6wG8/DTdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719340176; c=relaxed/simple;
	bh=azNnZ0AlIpxuQT2z3PDjm2shtaiItKlG4q2eVUjwFr4=;
	h=Date:To:From:Subject:Message-Id; b=U++wzRWeQYyiVZztVbuxNQNqmORyhhhxau28AwvIVaTnlwppmEZavw4uXayQb9CrCWzbPrz+YLLjruZYOKeFkBhTFDRtmH1De28//B5GsIk9gT6AFJd6oIU47WOUwA8e3mfK6f//IMSHp4kKGP5dl4Rffy/AzHk987Q5J9AnWEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tzd+hRDx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tzd+hRDx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C6CDC32781;
	Tue, 25 Jun 2024 18:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719340175;
	bh=azNnZ0AlIpxuQT2z3PDjm2shtaiItKlG4q2eVUjwFr4=;
	h=Date:To:From:Subject:From;
	b=tzd+hRDxnvL9W86G66JIxy3yzTWMqApG162tnBisSelo/63KmdtUaEo8RO+henbR9
	 TVKhvBg6I4zLHKuNcUDe0OXzSLtv4v4jFZWuFYCvfhCTSpUQ8A16wgOfDsfv3C1+hr
	 3fG9HdNnh24zg7IaCSSmH1WPDahsJpWxhZ1znFT8=
Date: Tue, 25 Jun 2024 11:29:34 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,josef@toxicpanda.com,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-fix-page_cache_next_miss-when-no-hole-found.patch added to mm-unstable branch
Message-Id: <20240625182935.7C6CDC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: filemap: fix page_cache_next_miss() when no hole found
has been added to the -mm mm-unstable branch.  Its filename is
     filemap-fix-page_cache_next_miss-when-no-hole-found.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/filemap-fix-page_cache_next_miss-when-no-hole-found.patch

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
From: Jan Kara <jack@suse.cz>
Subject: filemap: fix page_cache_next_miss() when no hole found
Date: Tue, 25 Jun 2024 12:18:52 +0200

page_cache_next_miss() should return value outside of the specified range
when no hole is found.  However currently it will return the last index
*in* the specified range confusing ondemand_readahead() to think there's a
hole in the searched range and upsetting readahead logic.

Link: https://lkml.kernel.org/r/20240625101909.12234-2-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/filemap.c~filemap-fix-page_cache_next_miss-when-no-hole-found
+++ a/mm/filemap.c
@@ -1752,12 +1752,12 @@ pgoff_t page_cache_next_miss(struct addr
 	while (max_scan--) {
 		void *entry = xas_next(&xas);
 		if (!entry || xa_is_value(entry))
-			break;
+			return xas.xa_index;
 		if (xas.xa_index == 0)
-			break;
+			return 0;
 	}
 
-	return xas.xa_index;
+	return index + max_scan;
 }
 EXPORT_SYMBOL(page_cache_next_miss);
 
_

Patches currently in -mm which might be from jack@suse.cz are

revert-mm-writeback-fix-possible-divide-by-zero-in-wb_dirty_limits-again.patch
mm-avoid-overflows-in-dirty-throttling-logic.patch
readahead-make-sure-sync-readahead-reads-needed-page.patch
filemap-fix-page_cache_next_miss-when-no-hole-found.patch
readahead-properly-shorten-readahead-when-falling-back-to-do_page_cache_ra.patch
readahead-drop-pointless-index-from-force_page_cache_ra.patch
readahead-drop-index-argument-of-page_cache_async_readahead.patch
readahead-drop-dead-code-in-page_cache_ra_order.patch
readahead-drop-dead-code-in-ondemand_readahead.patch
readahead-disentangle-async-and-sync-readahead.patch
readahead-fold-try_context_readahead-into-its-single-caller.patch
readahead-simplify-gotos-in-page_cache_sync_ra.patch


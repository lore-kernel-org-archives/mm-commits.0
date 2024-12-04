Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B00B2391A0
	for <mm-commits@vger.kernel.org>; Wed,  4 Dec 2024 21:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733348747; cv=none; b=l6ihs7nnjeQqpwt+InoRLwds5csc4X8mlqcbb3SbwVPBtTeCq+wyjW2MC/EWnbUq0trVy9Fs96lwMpTp9KT+5pG0K7y9BUwI23rA6McPcNS/Zfiib4fcCuSuuhCdXkbRo1jkz3bYWxJ9kVqCNneM0PAYM+dUgMqP1+00lZ7YuFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733348747; c=relaxed/simple;
	bh=1fT20Up84dkQoqbTV8X5GJ8EKYHEeDBvrPozdRLip+4=;
	h=Date:To:From:Subject:Message-Id; b=awOXka6zfBiMl0s+o+/YOkWiHer4GXAd1uj0Tn4QNYV/lXy//KwYMyWB96uWWRMJDK4qtWJNSpnvpFfYURtF5VICbpmpwVtHjuG+lt/PS3SV7Q4TmgxrqbW1TbyZxreH1VR4Ry1O+Q8UXkr5X8RMc4usdLwnYO7ugQFVpHaZH7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wspRWjAY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wspRWjAY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E70C4CECD;
	Wed,  4 Dec 2024 21:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733348747;
	bh=1fT20Up84dkQoqbTV8X5GJ8EKYHEeDBvrPozdRLip+4=;
	h=Date:To:From:Subject:From;
	b=wspRWjAYb+MOu8JMuY6DXdt/o0lhyVE9AZAW+nEfAC3IPWc9pBQo5OwiSmgtcsJaR
	 th0ImP2S0kvrrXq59spupWnwe+vgznPdPqLtG0wgYHpioDws4jtkNvsXEdCS1+htUW
	 iDQoIZPG1TFglEPLN32RkSASuzesg7r5Gw9LQCi8=
Date: Wed, 04 Dec 2024 13:45:46 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + readahead-properly-shorten-readahead-when-falling-back-to-do_page_cache_ra.patch added to mm-unstable branch
Message-Id: <20241204214547.17E70C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: readahead: properly shorten readahead when falling back to do_page_cache_ra()
has been added to the -mm mm-unstable branch.  Its filename is
     readahead-properly-shorten-readahead-when-falling-back-to-do_page_cache_ra.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/readahead-properly-shorten-readahead-when-falling-back-to-do_page_cache_ra.patch

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
Subject: readahead: properly shorten readahead when falling back to do_page_cache_ra()
Date: Wed, 4 Dec 2024 19:10:16 +0100

When we succeed in creating some folios in page_cache_ra_order() but then
need to fallback to single page folios, we don't shorten the amount to
read passed to do_page_cache_ra() by the amount we've already read.  This
then results in reading more and also in placing another readahead mark in
the middle of the readahead window which confuses readahead code.  Fix the
problem by properly reducing number of pages to read.  Unlike previous
attempt at this fix (commit 7c877586da31) which had to be reverted, we are
now careful to check there is indeed something to read so that we don't
submit negative-sized readahead.

Link: https://lkml.kernel.org/r/20241204181016.15273-3-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/mm/readahead.c~readahead-properly-shorten-readahead-when-falling-back-to-do_page_cache_ra
+++ a/mm/readahead.c
@@ -450,7 +450,8 @@ void page_cache_ra_order(struct readahea
 		struct file_ra_state *ra, unsigned int new_order)
 {
 	struct address_space *mapping = ractl->mapping;
-	pgoff_t index = readahead_index(ractl);
+	pgoff_t start = readahead_index(ractl);
+	pgoff_t index = start;
 	unsigned int min_order = mapping_min_folio_order(mapping);
 	pgoff_t limit = (i_size_read(mapping->host) - 1) >> PAGE_SHIFT;
 	pgoff_t mark = index + ra->size - ra->async_size;
@@ -508,12 +509,18 @@ void page_cache_ra_order(struct readahea
 	/*
 	 * If there were already pages in the page cache, then we may have
 	 * left some gaps.  Let the regular readahead code take care of this
-	 * situation.
+	 * situation below.
 	 */
 	if (!err)
 		return;
 fallback:
-	do_page_cache_ra(ractl, ra->size, ra->async_size);
+	/*
+	 * ->readahead() may have updated readahead window size so we have to
+	 * check there's still something to read.
+	 */
+	if (ra->size > index - start)
+		do_page_cache_ra(ractl, ra->size - (index - start),
+				 ra->async_size);
 }
 
 static unsigned long ractl_max_pages(struct readahead_control *ractl,
_

Patches currently in -mm which might be from jack@suse.cz are

revert-readahead-properly-shorten-readahead-when-falling-back-to-do_page_cache_ra.patch
readahead-dont-shorted-readahead-window-in-read_pages.patch
readahead-properly-shorten-readahead-when-falling-back-to-do_page_cache_ra.patch


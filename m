Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA28136658
	for <mm-commits@vger.kernel.org>; Thu, 17 Oct 2024 21:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729201455; cv=none; b=gv7Ko9kX1/PZPCbS9w+90/LyYQY+uG2locXmgBOPT3Aiqvn2AKUuvFokzjBcf3foOhb20qGQSYoSu3ONiJpc1m8JpKDdiLVnGVVn6q59MJlbKMbVreeir5qlZGO17g9DksNUIJUCYwLClD7F8YFOsdCzWSPW91nAYuOfG5ndL1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729201455; c=relaxed/simple;
	bh=PT+yui11cCVwv1XJ9F9SHIb3Tex7lnvoTvdTwzdaYIw=;
	h=Date:To:From:Subject:Message-Id; b=h2fNMJj7Vgj97TrxgIR4cCGsWWHdg7JXDzsnsiZuljW2VDg8j9yFSFSnjf3kZwh9BMtUlHYsh3YuOb1VedV6NQQOlfUYM5sHq3trKG1MgzlgzuNJ2MCqR+UKGJTQ3mQRDWwUj6iil3nNxJWa2xXszWgLmFeufbU9naPr9PTsJh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L0ZPeabB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L0ZPeabB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CFE3C4CEC3;
	Thu, 17 Oct 2024 21:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729201455;
	bh=PT+yui11cCVwv1XJ9F9SHIb3Tex7lnvoTvdTwzdaYIw=;
	h=Date:To:From:Subject:From;
	b=L0ZPeabBqpnvvqyLaEly/VFDie/L+LbMr5NWjWaY01f8a4az35UOFonqAGUbMN1QO
	 +oXu/HLjn4HGHRMjmRvw7tgAMqiDjQUsbwCQfYvEB7uXwr9jJh3sDCRKLz3oukx2G0
	 PcWhIZDaggfVja2TU0tmD4RnQtJTx4X1FDOtCips=
Date: Thu, 17 Oct 2024 14:44:14 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,mcgrof@kernel.org,p.raghav@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-dont-set-readahead-flag-on-a-folio-when-lookahead_size-nr_to_read.patch added to mm-unstable branch
Message-Id: <20241017214415.2CFE3C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: don't set readahead flag on a folio when lookahead_size > nr_to_read
has been added to the -mm mm-unstable branch.  Its filename is
     mm-dont-set-readahead-flag-on-a-folio-when-lookahead_size-nr_to_read.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-dont-set-readahead-flag-on-a-folio-when-lookahead_size-nr_to_read.patch

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
From: Pankaj Raghav <p.raghav@samsung.com>
Subject: mm: don't set readahead flag on a folio when lookahead_size > nr_to_read
Date: Thu, 17 Oct 2024 08:23:42 +0200

The readahead flag is set on a folio based on the lookahead_size and
nr_to_read.  For example, when the readahead happens from index to index +
nr_to_read, then the readahead `mark` offset from index is set at
nr_to_read - lookahead_size.

There are some scenarios where the lookahead_size > nr_to_read.  For
example, readahead window was created, but the file was truncated before
the readahead starts.  do_page_cache_ra() will clamp the nr_to_read if the
readahead window extends beyond EOF after truncation.  If this happens,
readahead flag should not be set on any folio on the current readahead
window.

The current calculation for `mark` with mapping_min_order > 0 gives
incorrect results when lookahead_size > nr_to_read due to rounding up
operation:

index = 128
nr_to_read = 16
lookahead_size = 28
mapping_min_order = 4 (16 pages)

ra_folio_index = round_up(128 + 16 - 28, 16) = 128;
mark = 128 - 128 = 0; # offset from index to set RA flag

In the above example, the lookahead_size is actually lying outside the
current readahead window.  Without this patch, RA flag will be set
incorrectly on the folio at index 128.  This can lead to marking the
readahead flag on the wrong folio, therefore, triggering a readahead when
it is not necessary.

Explicitly initialize `mark` to be ULONG_MAX and only calculate it when
lookahead_size is within the readahead window.

Link: https://lkml.kernel.org/r/20241017062342.478973-1-kernel@pankajraghav.com
Fixes: 26cfdb395eef ("readahead: allocate folios with mapping_min_order in readahead")
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/mm/readahead.c~mm-dont-set-readahead-flag-on-a-folio-when-lookahead_size-nr_to_read
+++ a/mm/readahead.c
@@ -206,9 +206,9 @@ void page_cache_ra_unbounded(struct read
 		unsigned long nr_to_read, unsigned long lookahead_size)
 {
 	struct address_space *mapping = ractl->mapping;
-	unsigned long ra_folio_index, index = readahead_index(ractl);
+	unsigned long index = readahead_index(ractl);
 	gfp_t gfp_mask = readahead_gfp_mask(mapping);
-	unsigned long mark, i = 0;
+	unsigned long mark = ULONG_MAX, i = 0;
 	unsigned int min_nrpages = mapping_min_folio_nrpages(mapping);
 
 	/*
@@ -232,9 +232,14 @@ void page_cache_ra_unbounded(struct read
 	 * index that only has lookahead or "async_region" to set the
 	 * readahead flag.
 	 */
-	ra_folio_index = round_up(readahead_index(ractl) + nr_to_read - lookahead_size,
-				  min_nrpages);
-	mark = ra_folio_index - index;
+	if (lookahead_size <= nr_to_read) {
+		unsigned long ra_folio_index;
+
+		ra_folio_index = round_up(readahead_index(ractl) +
+					  nr_to_read - lookahead_size,
+					  min_nrpages);
+		mark = ra_folio_index - index;
+	}
 	nr_to_read += readahead_index(ractl) - index;
 	ractl->_index = index;
 
_

Patches currently in -mm which might be from p.raghav@samsung.com are

mm-dont-set-readahead-flag-on-a-folio-when-lookahead_size-nr_to_read.patch


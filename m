Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F932257458;
	Tue, 19 Aug 2025 23:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755646606; cv=none; b=efqh0Cc0upQBFfZa8paFZ9qAtDOp2uZMWLh3ctEIThpGQ9R4sJ0kRAge3+Ytn6Hx82VImZrrcpuTKfpm3mPvm8VNEYu90X4CHuex7gr2iWchfxDxR8N8Hz1D1dNmlgENXaZ1YQsFOfe2Mg6YMrHgWnzD2VJLXVuHcop02IcCUcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755646606; c=relaxed/simple;
	bh=NRpBQlbuwdTUSFW3B29tz6QhldYggfwgNqEHHxIoV1s=;
	h=Date:To:From:Subject:Message-Id; b=PiKFqgp3/MAoC6bzwrzpSMLBqmYRLhzLAFClJNwW+BFGEMREZI8Eg6IHgJpP0aa5/4V/i/jHhYUctBUqo+v8xKrBIwzQWqqN6ZhgNl+TssiEbY7FGkqsHE79DaEKRFK5q3oT4Dp7Sg2NIVjloKZ55If6DWskNr7/opprLnPAjI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KEresYVN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KEresYVN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E90E6C4CEF1;
	Tue, 19 Aug 2025 23:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755646606;
	bh=NRpBQlbuwdTUSFW3B29tz6QhldYggfwgNqEHHxIoV1s=;
	h=Date:To:From:Subject:From;
	b=KEresYVNycwqYhQ3OrXWC5W5VlzgnJm3rOdor2KiIJRR0kVOOoJucfJDlw4UaE3tt
	 RGuBW8/twdbTglcIgnv94WoAS1OhuwOtsmylaEp2YgLI8mF4X/bQk+P+98nIPpzGJV
	 e/7ODy790Ibos+t9u25JnMD/GtTJB4358hxtb+RM=
Date: Tue, 19 Aug 2025 16:36:45 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,stable@vger.kernel.org,ryan@lahfa.xyz,maximilian@mbosch.me,dhowells@redhat.com,ct@flyingcircus.io,brauner@kernel.org,arnout@bzzt.net,asmadeus@codewreck.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] iov_iter-iterate_folioq-fix-handling-of-offset-=-folio-size.patch removed from -mm tree
Message-Id: <20250819233645.E90E6C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: iov_iter: iterate_folioq: fix handling of offset >= folio size
has been removed from the -mm tree.  Its filename was
     iov_iter-iterate_folioq-fix-handling-of-offset-=-folio-size.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dominique Martinet <asmadeus@codewreck.org>
Subject: iov_iter: iterate_folioq: fix handling of offset >= folio size
Date: Wed, 13 Aug 2025 15:04:55 +0900

It's apparently possible to get an iov advanced all the way up to the end
of the current page we're looking at, e.g.

(gdb) p *iter
$24 = {iter_type = 4 '\004', nofault = false, data_source = false, iov_offset = 4096, {__ubuf_iovec = {
      iov_base = 0xffff88800f5bc000, iov_len = 655}, {{__iov = 0xffff88800f5bc000, kvec = 0xffff88800f5bc000,
        bvec = 0xffff88800f5bc000, folioq = 0xffff88800f5bc000, xarray = 0xffff88800f5bc000,
        ubuf = 0xffff88800f5bc000}, count = 655}}, {nr_segs = 2, folioq_slot = 2 '\002', xarray_start = 2}}

Where iov_offset is 4k with 4k-sized folios

This should have been fine because we're only in the 2nd slot and there's
another one after this, but iterate_folioq should not try to map a folio
that skips the whole size, and more importantly part here does not end up
zero (because 'PAGE_SIZE - skip % PAGE_SIZE' ends up PAGE_SIZE and not
zero..), so skip forward to the "advance to next folio" code

Link: https://lkml.kernel.org/r/20250813-iot_iter_folio-v3-0-a0ffad2b665a@codewreck.org
Link: https://lkml.kernel.org/r/20250813-iot_iter_folio-v3-1-a0ffad2b665a@codewreck.org
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Fixes: db0aa2e9566f ("mm: Define struct folio_queue and ITER_FOLIOQ to handle a sequence of folios")
Reported-by: Maximilian Bosch <maximilian@mbosch.me>
Reported-by: Ryan Lahfa <ryan@lahfa.xyz>
Reported-by: Christian Theune <ct@flyingcircus.io>
Reported-by: Arnout Engelen <arnout@bzzt.net>
Link: https://lkml.kernel.org/r/D4LHHUNLG79Y.12PI0X6BEHRHW@mbosch.me/
Acked-by: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>	[6.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/iov_iter.h |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/include/linux/iov_iter.h~iov_iter-iterate_folioq-fix-handling-of-offset-=-folio-size
+++ a/include/linux/iov_iter.h
@@ -160,7 +160,7 @@ size_t iterate_folioq(struct iov_iter *i
 
 	do {
 		struct folio *folio = folioq_folio(folioq, slot);
-		size_t part, remain, consumed;
+		size_t part, remain = 0, consumed;
 		size_t fsize;
 		void *base;
 
@@ -168,14 +168,16 @@ size_t iterate_folioq(struct iov_iter *i
 			break;
 
 		fsize = folioq_folio_size(folioq, slot);
-		base = kmap_local_folio(folio, skip);
-		part = umin(len, PAGE_SIZE - skip % PAGE_SIZE);
-		remain = step(base, progress, part, priv, priv2);
-		kunmap_local(base);
-		consumed = part - remain;
-		len -= consumed;
-		progress += consumed;
-		skip += consumed;
+		if (skip < fsize) {
+			base = kmap_local_folio(folio, skip);
+			part = umin(len, PAGE_SIZE - skip % PAGE_SIZE);
+			remain = step(base, progress, part, priv, priv2);
+			kunmap_local(base);
+			consumed = part - remain;
+			len -= consumed;
+			progress += consumed;
+			skip += consumed;
+		}
 		if (skip >= fsize) {
 			skip = 0;
 			slot++;
_

Patches currently in -mm which might be from asmadeus@codewreck.org are



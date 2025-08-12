Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698802BF006;
	Tue, 12 Aug 2025 01:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754960559; cv=none; b=DZ8yMSh+PcRbi3n4dvQ5SyzSSl2Bz9hdrTZGjes+vJR72YigMSU5cQo0RNrbb0qIkdNPgBI6uOyNp9mRpwNBe46plH9+LvK7C0wam/ksMyWB8nP02VY6Ck1VCkJz/X2zidd85pii/aCBgmkGP16IjLUak0VIMsDPjJ2xAwPYPOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754960559; c=relaxed/simple;
	bh=QNGaoGPX+uZm4m3QPtgruO/pYCxYbHieL/q1FOfWg1I=;
	h=Date:To:From:Subject:Message-Id; b=XkB0JNpgZhH2SLPnlWqRrdLQWCL2j/QF3+y4wd4YzFSsLVEhujs1niC4IAZr6neRETPrMc60dLG0wSk8RF/1oqrQMay3IGBxUcNbDVbNnqlxpPlalzOhLNtuiI9oyxMAuW8QwvExfxkGyoiERYQSXg2AfYLrQhMb8iEsb3bU74c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eIbmrrKF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eIbmrrKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B52F8C4CEED;
	Tue, 12 Aug 2025 01:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754960557;
	bh=QNGaoGPX+uZm4m3QPtgruO/pYCxYbHieL/q1FOfWg1I=;
	h=Date:To:From:Subject:From;
	b=eIbmrrKF0ruNLb+b+m0PVtAeN7UMWOe1WOo4RZbd+cUz5SAjQCCcaZFDMeJuU6FpD
	 LUGPKxLT5LAzXwiNB+iJn0yxkfnQ9579cW9+iMpUx24GpnkdpBDopTAZkSmDjqAoaV
	 jsFyIigQPGc3aDgV6ZJvtCY1PUGy1LkXvG4+6ec0=
Date: Mon, 11 Aug 2025 18:02:37 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,stable@vger.kernel.org,ryan@lahfa.xyz,maximilian@mbosch.me,dhowells@redhat.com,ct@flyingcircus.io,brauner@kernel.org,arnout@bzzt.net,asmadeus@codewreck.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + iov_iter-iterate_folioq-fix-handling-of-offset-=-folio-size.patch added to mm-hotfixes-unstable branch
Message-Id: <20250812010237.B52F8C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: iov_iter: iterate_folioq: fix handling of offset >= folio size
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     iov_iter-iterate_folioq-fix-handling-of-offset-=-folio-size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/iov_iter-iterate_folioq-fix-handling-of-offset-=-folio-size.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Dominique Martinet <asmadeus@codewreck.org>
Subject: iov_iter: iterate_folioq: fix handling of offset >= folio size
Date: Mon, 11 Aug 2025 16:39:05 +0900

So we've had this regression in 9p for..  almost a year, which is way too
long, but there was no "easy" reproducer until yesterday (thank you
again!!)

It turned out to be a bug with iov_iter on folios,
iov_iter_get_pages_alloc2() would advance the iov_iter correctly up to the
end edge of a folio and the later copy_to_iter() fails on the
iterate_folioq() bug.

Happy to consider alternative ways of fixing this, now there's a
reproducer it's all much clearer; for the bug to be visible we basically
need to make and IO with non-contiguous folios in the iov_iter which is
not obvious to test with synthetic VMs, with size that triggers a
zero-copy read followed by a non-zero-copy read.

It's apparently possible to get an iov forwarded all the way up to the end
of the current page we're looking at, e.g.

(gdb) p *iter
$24 = {iter_type = 4 '\004', nofault = false, data_source = false, iov_offset = 4096, {__ubuf_iovec = {
      iov_base = 0xffff88800f5bc000, iov_len = 655}, {{__iov = 0xffff88800f5bc000, kvec = 0xffff88800f5bc000,
        bvec = 0xffff88800f5bc000, folioq = 0xffff88800f5bc000, xarray = 0xffff88800f5bc000,
        ubuf = 0xffff88800f5bc000}, count = 655}}, {nr_segs = 2, folioq_slot = 2 '\002', xarray_start = 2}}

Where iov_offset is 4k with 4k-sized folios

This should have been because we're only in the 2nd slot and there's
another one after this, but iterate_folioq should not try to map a folio
that skips the whole size, and more importantly part here does not end up
zero (because 'PAGE_SIZE - skip % PAGE_SIZE' ends up PAGE_SIZE and not
zero..), so skip forward to the "advance to next folio" code.

Link: https://lkml.kernel.org/r/20250811-iot_iter_folio-v1-0-d9c223adf93c@codewreck.org
Link: https://lkml.kernel.org/r/20250811-iot_iter_folio-v1-1-d9c223adf93c@codewreck.org
Link: https://lkml.kernel.org/r/D4LHHUNLG79Y.12PI0X6BEHRHW@mbosch.me/
Fixes: db0aa2e9566f ("mm: Define struct folio_queue and ITER_FOLIOQ to handle a sequence of folios")
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Reported-by: Maximilian Bosch <maximilian@mbosch.me>
Reported-by: Ryan Lahfa <ryan@lahfa.xyz>
Reported-by: Christian Theune <ct@flyingcircus.io>
Reported-by: Arnout Engelen <arnout@bzzt.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Ryan Lahfa <ryan@lahfa.xyz>
Cc: <stable@vger.kernel.org>	[v6.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/iov_iter.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/iov_iter.h~iov_iter-iterate_folioq-fix-handling-of-offset-=-folio-size
+++ a/include/linux/iov_iter.h
@@ -168,6 +168,8 @@ size_t iterate_folioq(struct iov_iter *i
 			break;
 
 		fsize = folioq_folio_size(folioq, slot);
+		if (skip >= fsize)
+			goto next;
 		base = kmap_local_folio(folio, skip);
 		part = umin(len, PAGE_SIZE - skip % PAGE_SIZE);
 		remain = step(base, progress, part, priv, priv2);
@@ -177,6 +179,7 @@ size_t iterate_folioq(struct iov_iter *i
 		progress += consumed;
 		skip += consumed;
 		if (skip >= fsize) {
+next:
 			skip = 0;
 			slot++;
 			if (slot == folioq_nr_slots(folioq) && folioq->next) {
_

Patches currently in -mm which might be from asmadeus@codewreck.org are

iov_iter-iterate_folioq-fix-handling-of-offset-=-folio-size.patch
iov_iter-iov_folioq_get_pages-dont-leave-empty-slot-behind.patch


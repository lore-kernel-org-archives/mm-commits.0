Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C702FC86F;
	Wed, 13 Aug 2025 23:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755126916; cv=none; b=EhifAdj/FE1EtNJ5H01zT7PJLAU8eIMppjeLO+TdikT4mvod8QDYTr3GgtuZSylmoObb7PutwMwvCrk6pAw5sCW+UI3nAA21R8zk0zJ/bPuEXQi83tUBe+vEWTDaUm0ZrUZgr2tw4f5eliix3v7DhpBuIQNqsATJPfUc9mwNyVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755126916; c=relaxed/simple;
	bh=Ts4k/+30/f+XUEGoWVZFGWd46MHjfr7Ve5FGfWHmHLs=;
	h=Date:To:From:Subject:Message-Id; b=eZAcdMEMOsofEFThP82VdnJxyWtvB+fbqnknxeKwhChEPXP/k7MTMkMx95c/jfTnDIiyK99x+sVzyCwDJrdTtKB1dclEYRmyGPkZhyvnaKggAu3cEPIEtwHB5uYgQhKCFIg/MZIew3FBkAIrWJHXgPZh63mapo2RvSP2VtHx/vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1u8jG06I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1u8jG06I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AADEC4CEF5;
	Wed, 13 Aug 2025 23:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755126915;
	bh=Ts4k/+30/f+XUEGoWVZFGWd46MHjfr7Ve5FGfWHmHLs=;
	h=Date:To:From:Subject:From;
	b=1u8jG06IVi5jhDfMTdLjdlqYZjAF7V6g0lSaq1AsTOh0qK8k9WoBbGGLVTLHG1fse
	 /K+QjON8Ocjl5TUTyGOVES/z7CxXCZUxZj5Rf2TWt7TQPN+VEvIUfaZZFX8Nh+w+65
	 be5VS9EaoGT3sTrRFPZTOlE5dr9rcDhwaJDo+6rk=
Date: Wed, 13 Aug 2025 16:15:10 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,stable@vger.kernel.org,ryan@lahfa.xyz,maximilian@mbosch.me,dhowells@redhat.com,ct@flyingcircus.io,brauner@kernel.org,arnout@bzzt.net,asmadeus@codewreck.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + iov_iter-iterate_folioq-fix-handling-of-offset-=-folio-size.patch added to mm-hotfixes-unstable branch
Message-Id: <20250813231515.7AADEC4CEF5@smtp.kernel.org>
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

iov_iter-iterate_folioq-fix-handling-of-offset-=-folio-size.patch
iov_iter-iov_folioq_get_pages-dont-leave-empty-slot-behind.patch


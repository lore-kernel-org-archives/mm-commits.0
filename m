Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EE01A9F88
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 05:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782363748; cv=none; b=aoOspDddMlgCPbovnrX0HgsKAVCi63lqzmzTgIsp0H+jOeeodi1Emfv2c2INUcVoDiozzMx2dQ0cQR9BqrZYANICEOHI0WRiJrlo5YuQ/mB474CKFlwj/eE2uWKGY9yw5FqHC2sFAKrqztT+at1OGzAtoHom7FYcqAY+H2WxWGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782363748; c=relaxed/simple;
	bh=2gvgNv1IskUahv7OFSAHnq6UeaQ7YKAt8ij0K+07834=;
	h=Date:To:From:Subject:Message-Id; b=KU/Bri1HhjDF9OoX9Qt/iQXMsVU+uEb59nfB0AnHvL1cqzjUDQIgrjFHW6BOQSn9BucBUGQEMu/3Gfm9OwP6L1MSYp9rpFxxnev8p00Ku3r20bZkpHEIXQCWeyYKjyDUiZ9PBfw16NTcXMjNwG2hQSQr4Ivur99lDAwzfDyJBQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ID2z0PEU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ID2z0PEU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B581F000E9;
	Thu, 25 Jun 2026 05:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782363746;
	bh=g603OwzT7IGi3QCBkBqa6M+N7ezHzzlfGIVpfJI+G9c=;
	h=Date:To:From:Subject;
	b=ID2z0PEUIF3cNrMKGD5nluV1Pba9jg2DjnaJVyu9NI3/0aNamjDFexVBgRCRAlA11
	 FEPE8yQHWBTZYznnqlMKZuRIG0GWNKG4UirNNnWMrnKLyoqcP3Th0ybtwiSGNnfxlO
	 AFH1bAlda0UK9D7jZsrWyRLZ56egSMsVSmOJJOds=
Date: Wed, 24 Jun 2026 22:02:26 -0700
To: mm-commits@vger.kernel.org,agruenba@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-writebackh-to-docs-build.patch added to mm-new branch
Message-Id: <20260625050226.D3B581F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add writeback.h to docs build
has been added to the -mm mm-new branch.  Its filename is
     mm-add-writebackh-to-docs-build.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-writebackh-to-docs-build.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add writeback.h to docs build
Date: Mon, 15 Jun 2026 17:22:41 +0100

There's four functions in this header file with kernel-doc; add them to
the htmldocs.

Link: https://lore.kernel.org/20260615162244.2170866-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/mm-api.rst |    1 +
 1 file changed, 1 insertion(+)

--- a/Documentation/core-api/mm-api.rst~mm-add-writebackh-to-docs-build
+++ a/Documentation/core-api/mm-api.rst
@@ -73,6 +73,7 @@ Readahead
 Writeback
 ---------
 
+.. kernel-doc:: include/linux/writeback.h
 .. kernel-doc:: mm/page-writeback.c
    :export:
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-add-writebackh-to-docs-build.patch
fs-free-any-excess-xarray-nodes-in-clear_inode.patch


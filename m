Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4546C3EF0A0
	for <mm-commits@vger.kernel.org>; Wed, 25 Feb 2026 19:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772046743; cv=none; b=c4uL3sCS1WSN2SsnSDc85+FKmnGscYdSz32EXuiahofvKmFAr5pi55tjZrsSNZQxwDlWKU5KcDUwHHgLlDPtCJ0Law9ZKTCdXcW/S1+6sA6GsNzE1Hefy0SrqfS3ubY+7DU1y/56KJQwayc/JMegYBCVIbewNFd5cu0XF2+wjGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772046743; c=relaxed/simple;
	bh=8pONQEjOnIzbNppd011EHMworbDdxATPqKbH9TjzNDs=;
	h=Date:To:From:Subject:Message-Id; b=II6m2D3DKTdKN/lkHjxzSzs7iG6BJPoMSX8qHE1Y2inWcmXnorc+iD2xT46ai9rQSF0Xqa42fcx6eX7f2TObHmX8nwbYeX5hPaNcEkxuYPmDJ58zH/4XGnorGG/pei59yYoDu5JmoJFIpu6tWTfurleTJrAHmDaknmzBXStOAsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UxVvH0HX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UxVvH0HX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A77C2BC9E;
	Wed, 25 Feb 2026 19:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772046742;
	bh=8pONQEjOnIzbNppd011EHMworbDdxATPqKbH9TjzNDs=;
	h=Date:To:From:Subject:From;
	b=UxVvH0HXFVnTXaZZy4u8nWVGtRtWmYjcf2kRY1GbZBSNgTu+L2qcjKj3cXJMpmt1e
	 FkDt7YbzI0sA6OZO5Zoe/RS1YAtjmBsOqvwvIeHtRpoGFA/SwryUzdVYIGYSfzrK+1
	 CV9Ij1OwPKQzhMTT5Yll9e0+5nyVQxLoxmdYdwmo=
Date: Wed, 25 Feb 2026 11:12:22 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,marc.dionne@auristor.com,dhowells@redhat.com,chao@kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-stray-references-to-struct-pagevec.patch added to mm-new branch
Message-Id: <20260225191222.D6A77C2BC9E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove stray references to struct pagevec
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-stray-references-to-struct-pagevec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-stray-references-to-struct-pagevec.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm: remove stray references to struct pagevec
Date: Wed, 25 Feb 2026 12:57:16 -0500

struct pagevec was removed in commit 1e0877d58b1e ("mm: remove struct
pagevec").  Remove remaining forward declarations and change
__folio_batch_release()'s declaration to match its definition.

Link: https://lkml.kernel.org/r/20260225-pagevec_cleanup-v1-1-38e2246363d2@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Cc: Chao Yu <chao@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Marc Dionne <marc.dionne@auristor.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/internal.h       |    1 -
 fs/f2fs/f2fs.h          |    2 --
 include/linux/pagevec.h |    2 +-
 include/linux/swap.h    |    2 --
 4 files changed, 1 insertion(+), 6 deletions(-)

--- a/fs/afs/internal.h~mm-remove-stray-references-to-struct-pagevec
+++ a/fs/afs/internal.h
@@ -31,7 +31,6 @@
 
 #define AFS_CELL_MAX_ADDRS 15
 
-struct pagevec;
 struct afs_call;
 struct afs_vnode;
 struct afs_server_probe;
--- a/fs/f2fs/f2fs.h~mm-remove-stray-references-to-struct-pagevec
+++ a/fs/f2fs/f2fs.h
@@ -28,8 +28,6 @@
 #include <linux/fscrypt.h>
 #include <linux/fsverity.h>
 
-struct pagevec;
-
 #ifdef CONFIG_F2FS_CHECK_FS
 #define f2fs_bug_on(sbi, condition)	BUG_ON(condition)
 #else
--- a/include/linux/pagevec.h~mm-remove-stray-references-to-struct-pagevec
+++ a/include/linux/pagevec.h
@@ -93,7 +93,7 @@ static inline struct folio *folio_batch_
 	return fbatch->folios[fbatch->i++];
 }
 
-void __folio_batch_release(struct folio_batch *pvec);
+void __folio_batch_release(struct folio_batch *fbatch);
 
 static inline void folio_batch_release(struct folio_batch *fbatch)
 {
--- a/include/linux/swap.h~mm-remove-stray-references-to-struct-pagevec
+++ a/include/linux/swap.h
@@ -20,8 +20,6 @@ struct notifier_block;
 
 struct bio;
 
-struct pagevec;
-
 #define SWAP_FLAG_PREFER	0x8000	/* set if swap priority specified */
 #define SWAP_FLAG_PRIO_MASK	0x7fff
 #define SWAP_FLAG_DISCARD	0x10000 /* enable discard for swap */
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-remove-stray-references-to-struct-pagevec.patch


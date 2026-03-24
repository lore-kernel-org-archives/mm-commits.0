Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1676636C581
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388621; cv=none; b=ajh6llShHWqpLQ/cuf1yGsopQ19r49rnCTYCptopYmd0ePURyTvGv2XzNt7p4zvoCB4xsnm3ej1w+ByD775HctFSz10/gA9qBqOolpoh4agg1X7cOCiUDza+GPkmUG9QcUdUg9LyR0gxUrM/wWvfEXyYQCRdhouXTlssqo4n6qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388621; c=relaxed/simple;
	bh=LfM1UxGmNrKZbdjPeLGcvn1mhsQIUM6FHlZon0bgA7c=;
	h=Date:To:From:Subject:Message-Id; b=ZvTFT7ScDSNc+DdsJHFZcWyGs+7QcVm/Cstemjpr2Uc9RpFcAgZUjISYVcDUFtDoBWKCPr58/GAbZ2gctHZXcpbBRaqRehRDUZm137fQ0goPlBRwqryFg1jHn4p4mtDFPRjnlgQ5ZcWvnFyL4lQtO+f1fj+R/C6Pf90PNbCbfbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1F46iA7l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1F46iA7l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48A6C19424;
	Tue, 24 Mar 2026 21:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388621;
	bh=LfM1UxGmNrKZbdjPeLGcvn1mhsQIUM6FHlZon0bgA7c=;
	h=Date:To:From:Subject:From;
	b=1F46iA7lEb9P+eu7RLgInvAxkOS8XzRNd5wQl3DyOg8uFrpUTjDV6CrtqUfltcFq0
	 POzxI6K3T8WIfSCUWH16JgeA/GwX4QIh0b1YHTCHco8HNIQxzr6WthP/iIheoYXyKK
	 DMkJ37z9xkR3DZ3umGaOkqcYBjXMiYlene5fuP0g=
Date: Tue, 24 Mar 2026 14:43:40 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,ljs@kernel.org,jack@suse.cz,david@kernel.org,chrisl@kernel.org,brauner@kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-stray-references-to-struct-pagevec.patch removed from -mm tree
Message-Id: <20260324214340.E48A6C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove stray references to struct pagevec
has been removed from the -mm tree.  Its filename was
     mm-remove-stray-references-to-struct-pagevec.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm: remove stray references to struct pagevec
Date: Wed, 25 Feb 2026 18:44:25 -0500

Patch series "mm: Remove stray references to pagevec", v2.

struct pagevec was removed in commit 1e0877d58b1e ("mm: remove struct
pagevec").  Remove any stray references to it and rename relevant files
and macros accordingly.

While at it, remove unnecessary #includes of pagevec.h (now folio_batch.h)
in .c files.  There are probably more of these that could be removed in .h
files, but those are more complex to verify.


This patch (of 4):

struct pagevec was removed in commit 1e0877d58b1e ("mm: remove struct
pagevec").  Remove remaining forward declarations and change
__folio_batch_release()'s declaration to match its definition.

Link: https://lkml.kernel.org/r/20260225-pagevec_cleanup-v2-0-716868cc2d11@columbia.edu
Link: https://lkml.kernel.org/r/20260225-pagevec_cleanup-v2-1-716868cc2d11@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Chris Li <chrisl@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
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



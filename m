Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405A92727E0
	for <mm-commits@vger.kernel.org>; Thu, 26 Feb 2026 00:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772066546; cv=none; b=iaCM1fNdGhqxqpG8LK32pduPZi0CgL0GSbHorOLL7MmjjivkN0oemXyMZ34CtN7Yva4Os35ylBVt4KZzxKFjRgl5w2rwFpF/NSpakvycWzlFqLSa6fARnnoEGRpwfxmMc+HxDsSXZBLGKTozvAh8SKH50MaBkP9iyte3zGamG68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772066546; c=relaxed/simple;
	bh=7E8zYvu7Hr51jPMUKQWCYRVKF2RatEodENwLn0VCW3o=;
	h=Date:To:From:Subject:Message-Id; b=RAS+1enEpEUg95Ncb22Q8/+JIX12bvtd3qHkVOG7ZASdDCxzTZtKrEdQUy0fx7yPDQPfrgEOeKBx7+kY8GXwHzPgvpbVwnDocj/JbsWMWqqhEPJHyL8ISGloCIfs/9LsACqAIAZLl/A0ZS47XVHKUa3AReKVqVcqmVw+oZ/3Wro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZG5JTLLB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZG5JTLLB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE333C116D0;
	Thu, 26 Feb 2026 00:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772066545;
	bh=7E8zYvu7Hr51jPMUKQWCYRVKF2RatEodENwLn0VCW3o=;
	h=Date:To:From:Subject:From;
	b=ZG5JTLLBHAaBQWY4vuVyZlLL2fp4xSK5Jo/wknHhud6NTRJgLzdRhhqChn9havcHs
	 ixx7h/Hztaz6pA4umhGpr4BBfAPta0M+KA7O+4+THLFVAPyNaisU4i+h2VHZ/xa3S+
	 usMTJNPdnk64KW9NU8f6tjwyWL5Jfx/AtmBY84Rs=
Date: Wed, 25 Feb 2026 16:42:25 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,david@kernel.org,chrisl@kernel.org,brauner@kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-remove-unncessary-pagevech-includes.patch added to mm-new branch
Message-Id: <20260226004225.CE333C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs: remove unncessary pagevec.h includes
has been added to the -mm mm-new branch.  Its filename is
     fs-remove-unncessary-pagevech-includes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-remove-unncessary-pagevech-includes.patch

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
Subject: fs: remove unncessary pagevec.h includes
Date: Wed, 25 Feb 2026 18:44:26 -0500

Remove unused pagevec.h includes from .c files. These were found with
the following command:

  grep -rl '#include.*pagevec\.h' --include='*.c' | while read f; do
  	grep -qE 'PAGEVEC_SIZE|folio_batch' "$f" || echo "$f"
  done

There are probably more removal candidates in .h files, but those are
more complex to analyze.

Link: https://lkml.kernel.org/r/20260225-pagevec_cleanup-v2-2-716868cc2d11@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/write.c                   |    1 -
 fs/dax.c                         |    1 -
 fs/ext4/file.c                   |    1 -
 fs/ext4/page-io.c                |    1 -
 fs/ext4/readpage.c               |    1 -
 fs/f2fs/file.c                   |    1 -
 fs/mpage.c                       |    1 -
 fs/netfs/buffered_write.c        |    1 -
 fs/nfs/blocklayout/blocklayout.c |    1 -
 fs/nfs/dir.c                     |    1 -
 fs/ocfs2/refcounttree.c          |    1 -
 fs/smb/client/connect.c          |    1 -
 fs/smb/client/file.c             |    1 -
 13 files changed, 13 deletions(-)

--- a/fs/afs/write.c~fs-remove-unncessary-pagevech-includes
+++ a/fs/afs/write.c
@@ -10,7 +10,6 @@
 #include <linux/fs.h>
 #include <linux/pagemap.h>
 #include <linux/writeback.h>
-#include <linux/pagevec.h>
 #include <linux/netfs.h>
 #include <trace/events/netfs.h>
 #include "internal.h"
--- a/fs/dax.c~fs-remove-unncessary-pagevech-includes
+++ a/fs/dax.c
@@ -15,7 +15,6 @@
 #include <linux/memcontrol.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
-#include <linux/pagevec.h>
 #include <linux/sched.h>
 #include <linux/sched/signal.h>
 #include <linux/uio.h>
--- a/fs/ext4/file.c~fs-remove-unncessary-pagevech-includes
+++ a/fs/ext4/file.c
@@ -27,7 +27,6 @@
 #include <linux/dax.h>
 #include <linux/filelock.h>
 #include <linux/quotaops.h>
-#include <linux/pagevec.h>
 #include <linux/uio.h>
 #include <linux/mman.h>
 #include <linux/backing-dev.h>
--- a/fs/ext4/page-io.c~fs-remove-unncessary-pagevech-includes
+++ a/fs/ext4/page-io.c
@@ -16,7 +16,6 @@
 #include <linux/string.h>
 #include <linux/buffer_head.h>
 #include <linux/writeback.h>
-#include <linux/pagevec.h>
 #include <linux/mpage.h>
 #include <linux/namei.h>
 #include <linux/uio.h>
--- a/fs/ext4/readpage.c~fs-remove-unncessary-pagevech-includes
+++ a/fs/ext4/readpage.c
@@ -43,7 +43,6 @@
 #include <linux/mpage.h>
 #include <linux/writeback.h>
 #include <linux/backing-dev.h>
-#include <linux/pagevec.h>
 
 #include "ext4.h"
 #include <trace/events/ext4.h>
--- a/fs/f2fs/file.c~fs-remove-unncessary-pagevech-includes
+++ a/fs/f2fs/file.c
@@ -17,7 +17,6 @@
 #include <linux/compat.h>
 #include <linux/uaccess.h>
 #include <linux/mount.h>
-#include <linux/pagevec.h>
 #include <linux/uio.h>
 #include <linux/uuid.h>
 #include <linux/file.h>
--- a/fs/mpage.c~fs-remove-unncessary-pagevech-includes
+++ a/fs/mpage.c
@@ -28,7 +28,6 @@
 #include <linux/mm_inline.h>
 #include <linux/writeback.h>
 #include <linux/backing-dev.h>
-#include <linux/pagevec.h>
 #include "internal.h"
 
 /*
--- a/fs/netfs/buffered_write.c~fs-remove-unncessary-pagevech-includes
+++ a/fs/netfs/buffered_write.c
@@ -10,7 +10,6 @@
 #include <linux/mm.h>
 #include <linux/pagemap.h>
 #include <linux/slab.h>
-#include <linux/pagevec.h>
 #include "internal.h"
 
 static void __netfs_set_group(struct folio *folio, struct netfs_group *netfs_group)
--- a/fs/nfs/blocklayout/blocklayout.c~fs-remove-unncessary-pagevech-includes
+++ a/fs/nfs/blocklayout/blocklayout.c
@@ -36,7 +36,6 @@
 #include <linux/namei.h>
 #include <linux/bio.h>		/* struct bio */
 #include <linux/prefetch.h>
-#include <linux/pagevec.h>
 
 #include "../pnfs.h"
 #include "../nfs4session.h"
--- a/fs/nfs/dir.c~fs-remove-unncessary-pagevech-includes
+++ a/fs/nfs/dir.c
@@ -32,7 +32,6 @@
 #include <linux/nfs_fs.h>
 #include <linux/nfs_mount.h>
 #include <linux/pagemap.h>
-#include <linux/pagevec.h>
 #include <linux/namei.h>
 #include <linux/mount.h>
 #include <linux/swap.h>
--- a/fs/ocfs2/refcounttree.c~fs-remove-unncessary-pagevech-includes
+++ a/fs/ocfs2/refcounttree.c
@@ -31,7 +31,6 @@
 #include <linux/blkdev.h>
 #include <linux/slab.h>
 #include <linux/writeback.h>
-#include <linux/pagevec.h>
 #include <linux/swap.h>
 #include <linux/security.h>
 #include <linux/string.h>
--- a/fs/smb/client/connect.c~fs-remove-unncessary-pagevech-includes
+++ a/fs/smb/client/connect.c
@@ -20,7 +20,6 @@
 #include <linux/delay.h>
 #include <linux/completion.h>
 #include <linux/kthread.h>
-#include <linux/pagevec.h>
 #include <linux/freezer.h>
 #include <linux/namei.h>
 #include <linux/uuid.h>
--- a/fs/smb/client/file.c~fs-remove-unncessary-pagevech-includes
+++ a/fs/smb/client/file.c
@@ -15,7 +15,6 @@
 #include <linux/stat.h>
 #include <linux/fcntl.h>
 #include <linux/pagemap.h>
-#include <linux/pagevec.h>
 #include <linux/writeback.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/delay.h>
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-remove-stray-references-to-struct-pagevec.patch
fs-remove-unncessary-pagevech-includes.patch
folio_batch-rename-pagevech-to-folio_batchh.patch
folio_batch-rename-pagevec_size-to-folio_batch_size.patch


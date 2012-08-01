From: akpm@linux-foundation.org
Subject: [merged] mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:13:31 -0700
Message-ID: <20120801201332.06CE01E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:41190 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab2HAUNd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:13:33 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5410915obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:13:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, dhillf@gmail.com, gaowanlong@cn.fujitsu.com, hughd@google.com, normalperson@yhbt.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, fadvise: don't return -EINVAL when filesystem cannot implement fadvise()
has been removed from the -mm tree.  Its filename was
     mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: mm, fadvise: don't return -EINVAL when filesystem cannot implement fadvise()

Eric Wong reported his test suite failex when /tmp is tmpfs.

https://lkml.org/lkml/2012/2/24/479

Currentlt the input check of POSIX_FADV_WILLNEED has two problems.

- requires a_ops->readpage.  But in fact, force_page_cache_readahead()
  requires that the target filesystem has either ->readpage or ->readpages.

- returns -EINVAL when the filesystem doesn't have ->readpage.  But
  posix says that fadvise is merely a hint.  Thus fadvise() should return
  0 if filesystem has no means of implementing fadvise().  The userland
  application should not know nor care whcih type of filesystem backs the
  TMPDIR directory, as Eric pointed out.  There is nothing which userspace
  can do to solve this error.

So change the return value to 0 when filesytem doesn't support readahead.

[akpm@linux-foundation.org: checkpatch fixes]
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Eric Wong <normalperson@yhbt.net>
Tested-by: Eric Wong <normalperson@yhbt.net>
Reviewed-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fadvise.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff -puN mm/fadvise.c~mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise mm/fadvise.c
--- a/mm/fadvise.c~mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise
+++ a/mm/fadvise.c
@@ -93,11 +93,6 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, lof
 		spin_unlock(&file->f_lock);
 		break;
 	case POSIX_FADV_WILLNEED:
-		if (!mapping->a_ops->readpage) {
-			ret = -EINVAL;
-			break;
-		}
-
 		/* First and last PARTIAL page! */
 		start_index = offset >> PAGE_CACHE_SHIFT;
 		end_index = endbyte >> PAGE_CACHE_SHIFT;
@@ -106,12 +101,13 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, lof
 		nrpages = end_index - start_index + 1;
 		if (!nrpages)
 			nrpages = ~0UL;
-		
-		ret = force_page_cache_readahead(mapping, file,
-				start_index,
-				nrpages);
-		if (ret > 0)
-			ret = 0;
+
+		/*
+		 * Ignore return value because fadvise() shall return
+		 * success even if filesystem can't retrieve a hint,
+		 */
+		force_page_cache_readahead(mapping, file, start_index,
+					   nrpages);
 		break;
 	case POSIX_FADV_NOREUSE:
 		break;
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch


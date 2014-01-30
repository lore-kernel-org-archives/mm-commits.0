From: akpm@linux-foundation.org
Subject: [merged] mm-readaheadc-fix-do_readahead-for-no-readpages.patch
 removed from -mm tree
Date: Thu, 30 Jan 2014 12:05:20 -0800
Message-ID: <52eab080.DzLv9NynQCT391G/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42390 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbaA3UFU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Jan 2014 15:05:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com, mark.rutland@arm.com

Subject: [merged] mm-readaheadc-fix-do_readahead-for-no-readpages.patch removed from -mm tree
To: mark.rutland@arm.com,kirill.shutemov@linux.intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 30 Jan 2014 12:05:20 -0800


The patch titled
     Subject: mm/readahead.c: fix do_readahead() for no readpage(s)
has been removed from the -mm tree.  Its filename was
     mm-readaheadc-fix-do_readahead-for-no-readpages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mark Rutland <mark.rutland@arm.com>
Subject: mm/readahead.c: fix do_readahead() for no readpage(s)

63d0f0a3c7e1 (mm/readahead.c:do_readhead(): don't check for ->readpage)
unintentionally made do_readahead return 0 for all valid files regardless
of whether readahead was supported, rather than the expected -EINVAL. 
This gets forwarded on to userspace, and results in sys_readahead
appearing to succeed in cases that don't make sense (e.g.  when called on
pipes or sockets).  This issue is detected by the LTP readahead01
testcase.

As the exact return value of force_page_cache_readahead is currently never
used, we can simplify it to return only 0 or -EINVAL (when readpage or
readpages is missing).  With that in place we can simply forward on the
return value of force_page_cache_readahead in do_readahead.

This patch performs said change, restoring the expected semantics.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff -puN mm/readahead.c~mm-readaheadc-fix-do_readahead-for-no-readpages mm/readahead.c
--- a/mm/readahead.c~mm-readaheadc-fix-do_readahead-for-no-readpages
+++ a/mm/readahead.c
@@ -211,8 +211,6 @@ out:
 int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
 		pgoff_t offset, unsigned long nr_to_read)
 {
-	int ret = 0;
-
 	if (unlikely(!mapping->a_ops->readpage && !mapping->a_ops->readpages))
 		return -EINVAL;
 
@@ -226,15 +224,13 @@ int force_page_cache_readahead(struct ad
 			this_chunk = nr_to_read;
 		err = __do_page_cache_readahead(mapping, filp,
 						offset, this_chunk, 0);
-		if (err < 0) {
-			ret = err;
-			break;
-		}
-		ret += err;
+		if (err < 0)
+			return err;
+
 		offset += this_chunk;
 		nr_to_read -= this_chunk;
 	}
-	return ret;
+	return 0;
 }
 
 /*
@@ -576,8 +572,7 @@ do_readahead(struct address_space *mappi
 	if (!mapping || !mapping->a_ops)
 		return -EINVAL;
 
-	force_page_cache_readahead(mapping, filp, index, nr);
-	return 0;
+	return force_page_cache_readahead(mapping, filp, index, nr);
 }
 
 SYSCALL_DEFINE3(readahead, int, fd, loff_t, offset, size_t, count)
_

Patches currently in -mm which might be from mark.rutland@arm.com are

origin.patch
linux-next.patch


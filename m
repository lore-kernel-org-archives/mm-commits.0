From: akpm@linux-foundation.org
Subject: [merged] logfs-fix-build-warning.patch removed from -mm tree
Date: Fri, 06 Nov 2015 12:05:39 -0800
Message-ID: <563d0813.qY74fv/LVRsNShAX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48433 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032955AbbKFUFj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:05:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, joern@logfs.org, prasadjoshi.linux@gmail.com, sudip@vectorindia.org, mm-commits@vger.kernel.org


The patch titled
     Subject: logfs: fix build warning
has been removed from the -mm tree.  Its filename was
     logfs-fix-build-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: logfs: fix build warning

fs/logfs/dev_bdev.c: In function '__bdev_writeseg':
include/linux/kernel.h:601:17: warning: comparison of distinct pointer types lacks a cast [enabled by default]
  (void) (&_min1 == &_min2);  \
fs/logfs/dev_bdev.c:84:14: note: in  expansion of macro 'min'
  max_pages = min(nr_pages, BIO_MAX_PAGES);

fs/logfs/dev_bdev.c: In function 'do_erase':
include/linux/kernel.h:601:17: warning: comparison of distinct pointer types lacks a cast [enabled by default]
 (void) (&_min1 == &_min2);  \
fs/logfs/dev_bdev.c:174:14: note: in expansion of macro 'min'
 max_pages = min(nr_pages, BIO_MAX_PAGES);

Lets use min_t and mention the type.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
Cc: Joern Engel <joern@logfs.org>
Cc: Prasad Joshi <prasadjoshi.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/logfs/dev_bdev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/logfs/dev_bdev.c~logfs-fix-build-warning fs/logfs/dev_bdev.c
--- a/fs/logfs/dev_bdev.c~logfs-fix-build-warning
+++ a/fs/logfs/dev_bdev.c
@@ -81,7 +81,7 @@ static int __bdev_writeseg(struct super_
 	unsigned int max_pages;
 	int i;
 
-	max_pages = min(nr_pages, BIO_MAX_PAGES);
+	max_pages = min_t(size_t, nr_pages, BIO_MAX_PAGES);
 
 	bio = bio_alloc(GFP_NOFS, max_pages);
 	BUG_ON(!bio);
@@ -171,7 +171,7 @@ static int do_erase(struct super_block *
 	unsigned int max_pages;
 	int i;
 
-	max_pages = min(nr_pages, BIO_MAX_PAGES);
+	max_pages = min_t(size_t, nr_pages, BIO_MAX_PAGES);
 
 	bio = bio_alloc(GFP_NOFS, max_pages);
 	BUG_ON(!bio);
_

Patches currently in -mm which might be from sudipm.mukherjee@gmail.com are



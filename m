From: akpm@linux-foundation.org
Subject: + logfs-fix-build-warning.patch added to -mm tree
Date: Thu, 01 Oct 2015 16:16:15 -0700
Message-ID: <560dbebf.lDK2DqkCGsEvMnFT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59297 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbbJAXQP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Oct 2015 19:16:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, joern@logfs.org, prasadjoshi.linux@gmail.com, sudip@vectorindia.org, mm-commits@vger.kernel.org


The patch titled
     Subject: logfs: fix build warning
has been added to the -mm tree.  Its filename is
     logfs-fix-build-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/logfs-fix-build-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/logfs-fix-build-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

logfs-fix-build-warning.patch


From: akpm@linux-foundation.org
Subject: + fuse-use-clear_highpage-and-km_user0-instead-of-km_user1.patch added to -mm tree
Date: Wed, 15 Sep 2010 12:12:01 -0700
Message-ID: <201009151912.o8FJC126010306@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755215Ab0IOTMI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Sep 2010 15:12:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, jbeulich@novell.com


The patch titled
     fuse: use clear_highpage() and KM_USER0 instead of KM_USER1
has been added to the -mm tree.  Its filename is
     fuse-use-clear_highpage-and-km_user0-instead-of-km_user1.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fuse: use clear_highpage() and KM_USER0 instead of KM_USER1
From: Miklos Szeredi <mszeredi@suse.cz>

Commit 7909b1c640 (fuse: don't use atomic kmap) removed KM_USER0 usage
from fuse/dev.c.  Switch KM_USER1 uses to KM_USER0 for clarity.  Also
replace open coded clear_highpage().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dev.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN fs/fuse/dev.c~fuse-use-clear_highpage-and-km_user0-instead-of-km_user1 fs/fuse/dev.c
--- a/fs/fuse/dev.c~fuse-use-clear_highpage-and-km_user0-instead-of-km_user1
+++ a/fs/fuse/dev.c
@@ -809,11 +809,9 @@ static int fuse_copy_page(struct fuse_co
 	int err;
 	struct page *page = *pagep;
 
-	if (page && zeroing && count < PAGE_SIZE) {
-		void *mapaddr = kmap_atomic(page, KM_USER1);
-		clear_page(mapaddr);
-		kunmap_atomic(mapaddr, KM_USER1);
-	}
+	if (page && zeroing && count < PAGE_SIZE)
+		clear_highpage(page);
+
 	while (count) {
 		if (cs->write && cs->pipebufs && page) {
 			return fuse_ref_page(cs, page, offset, count);
@@ -830,10 +828,10 @@ static int fuse_copy_page(struct fuse_co
 			}
 		}
 		if (page) {
-			void *mapaddr = kmap_atomic(page, KM_USER1);
+			void *mapaddr = kmap_atomic(page, KM_USER0);
 			void *buf = mapaddr + offset;
 			offset += fuse_copy_do(cs, &buf, &count);
-			kunmap_atomic(mapaddr, KM_USER1);
+			kunmap_atomic(mapaddr, KM_USER0);
 		} else
 			offset += fuse_copy_do(cs, NULL, &count);
 	}
_

Patches currently in -mm which might be from mszeredi@suse.cz are

fuse-use-clear_highpage-and-km_user0-instead-of-km_user1.patch


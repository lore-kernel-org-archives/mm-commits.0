From: akpm@linux-foundation.org
Subject: + hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid.patch added to -mm tree
Date: Thu, 07 Mar 2013 11:19:48 -0800
Message-ID: <20130307191948.8B8CE5A4277@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:56546 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757223Ab3CGTTt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Mar 2013 14:19:49 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so86261qaj.1
        for <mm-commits@vger.kernel.org>; Thu, 07 Mar 2013 11:19:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: slava@dubeyko.com, hch@lst.de


The patch titled
     Subject: [PATCH] hfsplus: fix warnings in fs/hfsplus/bfind.c
has been added to the -mm tree.  Its filename is
     hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH] hfsplus: fix warnings in fs/hfsplus/bfind.c

fs/hfsplus/bfind.c: In function 'hfs_find_1st_rec_by_cnid':
(1) include/uapi/linux/swab.h:60:2: warning: 'search_cnid' may be used uninitialized in this function [-Wmaybe-uninitialized]
(2) include/uapi/linux/swab.h:60:2: warning: 'cur_cnid' may be used uninitialized in this function [-Wmaybe-uninitialized]

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/bfind.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/hfsplus/bfind.c~hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid fs/hfsplus/bfind.c
--- a/fs/hfsplus/bfind.c~hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid
+++ a/fs/hfsplus/bfind.c
@@ -56,7 +56,8 @@ int hfs_find_1st_rec_by_cnid(struct hfs_
 				int *end,
 				int *cur_rec)
 {
-	__be32 cur_cnid, search_cnid;
+	__be32 cur_cnid = 0;
+	__be32 search_cnid = 0;
 
 	if (bnode->tree->cnid == HFSPLUS_EXT_CNID) {
 		cur_cnid = fd->key->ext.cnid;
_

Patches currently in -mm which might be from slava@dubeyko.com are

hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch


From: akpm@linux-foundation.org
Subject: [merged]
 hfsplus-add-missing-curly-braces-in-hfsplus_delete_cat.patch removed from
 -mm tree
Date: Mon, 20 Apr 2015 12:19:01 -0700
Message-ID: <55355125.ayIcc+R7E7WcgLDw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40305 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbbDTTMk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:12:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, hch@lst.de, slava@dubeyko.com, sougata@tuxera.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus: add missing curly braces in hfsplus_delete_cat()
has been removed from the -mm tree.  Its filename was
     hfsplus-add-missing-curly-braces-in-hfsplus_delete_cat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: hfsplus: add missing curly braces in hfsplus_delete_cat()

This doesn't change how the code works, but clearly the curly braces were
intended.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Sougata Santra <sougata@tuxera.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/catalog.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/hfsplus/catalog.c~hfsplus-add-missing-curly-braces-in-hfsplus_delete_cat fs/hfsplus/catalog.c
--- a/fs/hfsplus/catalog.c~hfsplus-add-missing-curly-braces-in-hfsplus_delete_cat
+++ a/fs/hfsplus/catalog.c
@@ -350,10 +350,11 @@ int hfsplus_delete_cat(u32 cnid, struct
 			&fd.search_key->cat.name.unicode,
 			off + 2, len);
 		fd.search_key->key_len = cpu_to_be16(6 + len);
-	} else
+	} else {
 		err = hfsplus_cat_build_key(sb, fd.search_key, dir->i_ino, str);
 		if (unlikely(err))
 			goto out;
+	}
 
 	err = hfs_brec_find(&fd, hfs_find_rec_by_key);
 	if (err)
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
posix_acl-make-posix_acl_create-safer-and-cleaner.patch
linux-next.patch


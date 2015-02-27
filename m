From: akpm@linux-foundation.org
Subject: + hfsplus-add-missing-curly-braces-in-hfsplus_delete_cat.patch
 added to -mm tree
Date: Fri, 27 Feb 2015 13:53:50 -0800
Message-ID: <54f0e76e.jc81XNN7/tsSfZ2F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47957 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632AbbB0Vxv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Feb 2015 16:53:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, hch@lst.de, slava@dubeyko.com, sougata@tuxera.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus: add missing curly braces in hfsplus_delete_cat()
has been added to the -mm tree.  Its filename is
     hfsplus-add-missing-curly-braces-in-hfsplus_delete_cat.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfsplus-add-missing-curly-braces-in-hfsplus_delete_cat.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfsplus-add-missing-curly-braces-in-hfsplus_delete_cat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

rtc-ds1685-fix-conditional-in-ds1685_rtc_sysfs_time_regs_showstore.patch
hfsplus-add-missing-curly-braces-in-hfsplus_delete_cat.patch
memstick-mspro_block-add-missing-curly-braces.patch
linux-next.patch


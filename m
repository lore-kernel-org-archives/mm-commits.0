From: akpm@linux-foundation.org
Subject: [merged]
 hfsplus-remove-unused-routine-hfsplus_attr_build_key_uni.patch removed from -mm tree
Date: Mon, 09 Jun 2014 12:31:47 -0700
Message-ID: <53960ba3.UUpG2b9naHRJLFqY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53907 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaFITbs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:31:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, sougata@tuxera.com, slava@dubeyko.com, hch@infradead.org, anton@tuxera.com, htl10@users.sourceforge.net

Subject: [merged] hfsplus-remove-unused-routine-hfsplus_attr_build_key_uni.patch removed from -mm tree
To: htl10@users.sourceforge.net,anton@tuxera.com,hch@infradead.org,slava@dubeyko.com,sougata@tuxera.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:31:47 -0700


The patch titled
     Subject: hfsplus: remove unused routine hfsplus_attr_build_key_uni
has been removed from the -mm tree.  Its filename was
     hfsplus-remove-unused-routine-hfsplus_attr_build_key_uni.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Subject: hfsplus: remove unused routine hfsplus_attr_build_key_uni

The directory/file catalog b-tree equivalent, hfsplus_build_key_uni(), is
used by hfsplus_find_cat() for internal referencing between catalog
records.  There is no corresponding usage for attributes - attribute
records do not refer to one another.

Signed-off-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Sougata Santra <sougata@tuxera.com>
Cc: Anton Altaparmakov <anton@tuxera.com>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/attributes.c |   25 -------------------------
 fs/hfsplus/hfsplus_fs.h |    3 ---
 2 files changed, 28 deletions(-)

diff -puN fs/hfsplus/attributes.c~hfsplus-remove-unused-routine-hfsplus_attr_build_key_uni fs/hfsplus/attributes.c
--- a/fs/hfsplus/attributes.c~hfsplus-remove-unused-routine-hfsplus_attr_build_key_uni
+++ a/fs/hfsplus/attributes.c
@@ -79,31 +79,6 @@ int hfsplus_attr_build_key(struct super_
 	return 0;
 }
 
-void hfsplus_attr_build_key_uni(hfsplus_btree_key *key,
-					u32 cnid,
-					struct hfsplus_attr_unistr *name)
-{
-	int ustrlen;
-
-	memset(key, 0, sizeof(struct hfsplus_attr_key));
-	ustrlen = be16_to_cpu(name->length);
-	key->attr.cnid = cpu_to_be32(cnid);
-	key->attr.key_name.length = cpu_to_be16(ustrlen);
-	ustrlen *= 2;
-	memcpy(key->attr.key_name.unicode, name->unicode, ustrlen);
-
-	/* The length of the key, as stored in key_len field, does not include
-	 * the size of the key_len field itself.
-	 * So, offsetof(hfsplus_attr_key, key_name) is a trick because
-	 * it takes into consideration key_len field (__be16) of
-	 * hfsplus_attr_key structure instead of length field (__be16) of
-	 * hfsplus_attr_unistr structure.
-	 */
-	key->key_len =
-		cpu_to_be16(offsetof(struct hfsplus_attr_key, key_name) +
-				ustrlen);
-}

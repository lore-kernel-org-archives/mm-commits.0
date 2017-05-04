From: akpm@linux-foundation.org
Subject: [merged] mm-sparse-refine-usemap_size-a-little.patch
 removed from -mm tree
Date: Thu, 04 May 2017 12:11:09 -0700
Message-ID: <20170504191109.KKdmvtNDE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51340 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755950AbdEDTLK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 May 2017 15:11:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, richard.weiyang@gmail.com, tj@kernel.org


The patch titled
     Subject: mm/sparse: refine usemap_size() a little
has been removed from the -mm tree.  Its filename was
     mm-sparse-refine-usemap_size-a-little.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/sparse: refine usemap_size() a little

Current implementation calculates usemap_size in two steps:
    * calculate number of bytes to cover these bits
    * calculate number of "unsigned long" to cover these bytes

It would be more clear by:
    * calculate number of "unsigned long" to cover these bits
    * multiple it with sizeof(unsigned long)

This patch refine usemap_size() a little to make it more easy to
understand.

Link: http://lkml.kernel.org/r/20170310043713.96871-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN mm/sparse.c~mm-sparse-refine-usemap_size-a-little mm/sparse.c
--- a/mm/sparse.c~mm-sparse-refine-usemap_size-a-little
+++ a/mm/sparse.c
@@ -248,10 +248,7 @@ static int __meminit sparse_init_one_sec
 
 unsigned long usemap_size(void)
 {
-	unsigned long size_bytes;
-	size_bytes = roundup(SECTION_BLOCKFLAGS_BITS, 8) / 8;
-	size_bytes = roundup(size_bytes, sizeof(unsigned long));
-	return size_bytes;
+	return BITS_TO_LONGS(SECTION_BLOCKFLAGS_BITS) * sizeof(unsigned long);
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-page_alloc-return-0-in-case-this-node-has-no-page-within-the-zone.patch


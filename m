From: akpm@linux-foundation.org
Subject: [patch 045/102] mm/sparse: refine usemap_size() a little
Date: Wed, 03 May 2017 14:53:51 -0700
Message-ID: <20170503215351.s0Jwl0N1Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48732 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751700AbdECVyH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:54:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, richard.weiyang@gmail.com, tj@kernel.org, torvalds@linux-foundation.org

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

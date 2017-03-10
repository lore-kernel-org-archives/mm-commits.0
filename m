From: akpm@linux-foundation.org
Subject: + mm-sparse-refine-usemap_size-a-little.patch added to -mm tree
Date: Fri, 10 Mar 2017 14:41:22 -0800
Message-ID: <58c32b92.qgOCFj/bIjx+ym6m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41906 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932724AbdCJWlX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Mar 2017 17:41:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard.weiyang@gmail.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sparse: refine usemap_size() a little
has been added to the -mm tree.  Its filename is
     mm-sparse-refine-usemap_size-a-little.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-sparse-refine-usemap_size-a-little.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-sparse-refine-usemap_size-a-little.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-sparse-refine-usemap_size-a-little.patch
mm-page_alloc-return-0-in-case-this-node-has-no-page-within-the-zone.patch


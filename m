From: akpm@linux-foundation.org
Subject: [patch 104/127] linux/mm.h: canonicalize macro PAGE_ALIGNED()
 definition
Date: Fri, 07 Oct 2016 17:02:04 -0700
Message-ID: <57f8377c.WwuxSWeHA+lvFmf/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39533 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932840AbcJHACF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 20:02:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, zijun_hu@htc.com

From: zijun_hu <zijun_hu@htc.com>
Subject: linux/mm.h: canonicalize macro PAGE_ALIGNED() definition

macro PAGE_ALIGNED() is prone to cause error because it doesn't follow
convention to parenthesize parameter @addr within macro body, for example
unsigned long *ptr = kmalloc(...); PAGE_ALIGNED(ptr + 16); for the left
parameter of macro IS_ALIGNED(), (unsigned long)(ptr + 16) is desired but
the actual one is (unsigned long)ptr + 16.

It is fixed by simply canonicalizing macro PAGE_ALIGNED() definition.

Link: http://lkml.kernel.org/r/57EA6AE7.7090807@zoho.com
Signed-off-by: zijun_hu <zijun_hu@htc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mm.h~linux-mmh-canonicalize-macro-page_aligned-definition include/linux/mm.h
--- a/include/linux/mm.h~linux-mmh-canonicalize-macro-page_aligned-definition
+++ a/include/linux/mm.h
@@ -126,7 +126,7 @@ extern int overcommit_kbytes_handler(str
 #define PAGE_ALIGN(addr) ALIGN(addr, PAGE_SIZE)
 
 /* test whether an address (unsigned long or pointer) is aligned to PAGE_SIZE */
-#define PAGE_ALIGNED(addr)	IS_ALIGNED((unsigned long)addr, PAGE_SIZE)
+#define PAGE_ALIGNED(addr)	IS_ALIGNED((unsigned long)(addr), PAGE_SIZE)
 
 /*
  * Linux kernel virtual memory manager primitives.
_

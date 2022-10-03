Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02368C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:14:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiJCVOm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiJCVNb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:13:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F2252E6B
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:08:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39549B811BF
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:08:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9652C433C1;
        Mon,  3 Oct 2022 21:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831291;
        bh=9IBf0MO378TcYsSAXCs8uq7JCQZnCBheoVpZFmPWIFo=;
        h=Date:To:From:Subject:From;
        b=1isKQ4TO8NhWLPtr4wKOjcHiiucIqrkOEUYt5S2I35C71DTKgKwRKl90PDLGCU52k
         3MAjK1a2/4Z3CZ/b0kTQ7dr8ARYg0nvmifhr49HnbkrA6R90hgKVC+a9AS2BE6wHSH
         LTLy/JKxfr5RWAbM89Th1q0Ee+V6xHaQmjHY6FC0=
Date:   Mon, 03 Oct 2022 14:08:10 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, vegard.nossum@oracle.com, vbabka@suse.cz,
        tglx@linutronix.de, sfr@canb.auug.org.au, rostedt@goodmis.org,
        rientjes@google.com, pmladek@suse.com, peterz@infradead.org,
        penberg@kernel.org, mst@redhat.com, mingo@redhat.com,
        mark.rutland@arm.com, luto@kernel.org, keescook@chromium.org,
        iii@linux.ibm.com, iamjoonsoo.kim@lge.com,
        herbert@gondor.apana.org.au, hch@lst.de,
        gregkh@linuxfoundation.org, gor@linux.ibm.com, elver@google.com,
        edumazet@google.com, ebiggers@kernel.org, ebiggers@google.com,
        dvyukov@google.com, cl@linux.com, bp@alien8.de, axboe@kernel.dk,
        ast@kernel.org, arnd@arndb.de, andreyknvl@google.com,
        andreyknvl@gmail.com, glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] asm-generic-instrument-usercopy-in-cacheflushh.patch removed from -mm tree
Message-Id: <20221003210810.D9652C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: asm-generic: instrument usercopy in cacheflush.h
has been removed from the -mm tree.  Its filename was
     asm-generic-instrument-usercopy-in-cacheflushh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: asm-generic: instrument usercopy in cacheflush.h
Date: Thu, 15 Sep 2022 17:03:39 +0200

Notify memory tools about usercopy events in copy_to_user_page() and
copy_from_user_page().

Link: https://lkml.kernel.org/r/20220915150417.722975-6-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/cacheflush.h |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/include/asm-generic/cacheflush.h~asm-generic-instrument-usercopy-in-cacheflushh
+++ a/include/asm-generic/cacheflush.h
@@ -2,6 +2,8 @@
 #ifndef _ASM_GENERIC_CACHEFLUSH_H
 #define _ASM_GENERIC_CACHEFLUSH_H
 
+#include <linux/instrumented.h>
+
 struct mm_struct;
 struct vm_area_struct;
 struct page;
@@ -105,14 +107,22 @@ static inline void flush_cache_vunmap(un
 #ifndef copy_to_user_page
 #define copy_to_user_page(vma, page, vaddr, dst, src, len)	\
 	do { \
+		instrument_copy_to_user((void __user *)dst, src, len); \
 		memcpy(dst, src, len); \
 		flush_icache_user_page(vma, page, vaddr, len); \
 	} while (0)
 #endif
 
+
 #ifndef copy_from_user_page
-#define copy_from_user_page(vma, page, vaddr, dst, src, len) \
-	memcpy(dst, src, len)
+#define copy_from_user_page(vma, page, vaddr, dst, src, len)		  \
+	do {								  \
+		instrument_copy_from_user_before(dst, (void __user *)src, \
+						 len);			  \
+		memcpy(dst, src, len);					  \
+		instrument_copy_from_user_after(dst, (void __user *)src, len, \
+						0);			  \
+	} while (0)
 #endif
 
 #endif /* _ASM_GENERIC_CACHEFLUSH_H */
_

Patches currently in -mm which might be from glider@google.com are



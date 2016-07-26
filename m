From: akpm@linux-foundation.org
Subject: [patch 024/126] mm: faster kmalloc_array(), kcalloc()
Date: Tue, 26 Jul 2016 15:22:08 -0700
Message-ID: <5797e290.DC7Qo2kcjO9jkQUM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56546 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757758AbcGZWWK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:22:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, adobriyan@gmail.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com

From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: mm: faster kmalloc_array(), kcalloc()

When both arguments to kmalloc_array() or kcalloc() are known at compile
time then their product is known at compile time but search for kmalloc
cache happens at runtime not at compile time.

Link: http://lkml.kernel.org/r/20160627213454.GA2440@p183.telecom.by
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/slab.h~mm-faster-kmalloc_array-kcalloc include/linux/slab.h
--- a/include/linux/slab.h~mm-faster-kmalloc_array-kcalloc
+++ a/include/linux/slab.h
@@ -565,6 +565,8 @@ static inline void *kmalloc_array(size_t
 {
 	if (size != 0 && n > SIZE_MAX / size)
 		return NULL;
+	if (__builtin_constant_p(n) && __builtin_constant_p(size))
+		return kmalloc(n * size, flags);
 	return __kmalloc(n * size, flags);
 }
 
_

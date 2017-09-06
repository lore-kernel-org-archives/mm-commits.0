From: akpm@linux-foundation.org
Subject: [patch 015/119] mm/slub.c: add a naive detection of double
 free or corruption
Date: Wed, 06 Sep 2017 16:19:22 -0700
Message-ID: <20170906231922.NPtw_S3Sv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49240 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750944AbdIFXTY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:19:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.popov@linux.com, cl@linux.com, iamjoonsoo.kim@lge.com, keescook@chromium.org, luto@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, nicolas.pitre@linaro.org, paulmck@linux.vnet.ibm.com, penberg@kernel.org, riel@redhat.com, rientjes@google.com, tj@kernel.org, torvalds@linux-foundation.org, tycho@docker.com

From: Alexander Popov <alex.popov@linux.com>
Subject: mm/slub.c: add a naive detection of double free or corruption

Add an assertion similar to "fasttop" check in GNU C Library allocator as
a part of SLAB_FREELIST_HARDENED feature.  An object added to a singly
linked freelist should not point to itself.  That helps to detect some
double free errors (e.g.  CVE-2017-2636) without slub_debug and KASAN.

Link: http://lkml.kernel.org/r/1502468246-1262-1-git-send-email-alex.popov@linux.com
Signed-off-by: Alexander Popov <alex.popov@linux.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Paul E McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Tycho Andersen <tycho@docker.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/slub.c~mm-slubc-add-a-naive-detection-of-double-free-or-corruption mm/slub.c
--- a/mm/slub.c~mm-slubc-add-a-naive-detection-of-double-free-or-corruption
+++ a/mm/slub.c
@@ -290,6 +290,10 @@ static inline void set_freepointer(struc
 {
 	unsigned long freeptr_addr = (unsigned long)object + s->offset;
 
+#ifdef CONFIG_SLAB_FREELIST_HARDENED
+	BUG_ON(object == fp); /* naive detection of double free or corruption */
+#endif
+
 	*(void **)freeptr_addr = freelist_ptr(s, fp, freeptr_addr);
 }
 
_

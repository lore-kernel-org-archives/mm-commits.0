From: akpm@linux-foundation.org
Subject: + mm-faster-kmalloc_array-kcalloc.patch added to -mm tree
Date: Mon, 11 Jul 2016 15:42:36 -0700
Message-ID: <578420dc.coVVNF/YMpTKnwyT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43923 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbcGKWmh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jul 2016 18:42:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: faster kmalloc_array(), kcalloc()
has been added to the -mm tree.  Its filename is
     mm-faster-kmalloc_array-kcalloc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-faster-kmalloc_array-kcalloc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-faster-kmalloc_array-kcalloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from adobriyan@gmail.com are

mm-faster-kmalloc_array-kcalloc.patch
cflags-add-wunused-but-set-parameter.patch
ban-config_localversion_auto-with-allmodconfig.patch
ipc-delete-nr_ipc_ns.patch


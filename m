From: akpm@linux-foundation.org
Subject: [merged] mm-faster-kmalloc_array-kcalloc.patch removed from -mm
 tree
Date: Wed, 27 Jul 2016 11:59:28 -0700
Message-ID: <57990490.Wn3+tjD+WWkoI0i3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39991 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758148AbcG0S73 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 14:59:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: faster kmalloc_array(), kcalloc()
has been removed from the -mm tree.  Its filename was
     mm-faster-kmalloc_array-kcalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

kbuild-simpler-generation-of-assembly-constants.patch
uapi-move-forward-declarations-of-internal-structures.patch
ban-config_localversion_auto-with-allmodconfig.patch
ipc-delete-nr_ipc_ns.patch


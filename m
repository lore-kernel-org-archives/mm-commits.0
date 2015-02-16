From: akpm@linux-foundation.org
Subject: [merged] mm-slub-introduce-virt_to_obj-function.patch removed
 from -mm tree
Date: Mon, 16 Feb 2015 12:18:01 -0800
Message-ID: <54e25079.zU3B2oqBJM9La99s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51162 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbbBPUSi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:18:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, adech.fo@gmail.com, andi@firstfloor.org, cl@linux.com, dave.hansen@intel.com, dmitryc@google.com, dvyukov@google.com, hpa@zytor.com, iamjoonsoo.kim@lge.com, kcc@google.com, koct9i@gmail.com, mingo@elte.hu, penberg@kernel.org, rientjes@google.com, sasha.levin@oracle.com, tetra2005@gmail.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: slub: introduce virt_to_obj function
has been removed from the -mm tree.  Its filename was
     mm-slub-introduce-virt_to_obj-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: mm: slub: introduce virt_to_obj function

virt_to_obj takes kmem_cache address, address of slab page, address x
pointing somewhere inside slab object, and returns address of the
beginning of object.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Konstantin Serebryany <kcc@google.com>
Cc: Dmitry Chernenkov <dmitryc@google.com>
Signed-off-by: Andrey Konovalov <adech.fo@gmail.com>
Cc: Yuri Gribov <tetra2005@gmail.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN include/linux/slub_def.h~mm-slub-introduce-virt_to_obj-function include/linux/slub_def.h
--- a/include/linux/slub_def.h~mm-slub-introduce-virt_to_obj-function
+++ a/include/linux/slub_def.h
@@ -110,4 +110,20 @@ static inline void sysfs_slab_remove(str
 }
 #endif
 
+
+/**
+ * virt_to_obj - returns address of the beginning of object.
+ * @s: object's kmem_cache
+ * @slab_page: address of slab page
+ * @x: address within object memory range
+ *
+ * Returns address of the beginning of object
+ */
+static inline void *virt_to_obj(struct kmem_cache *s,
+				const void *slab_page,
+				const void *x)
+{
+	return (void *)x - ((x - slab_page) % s->size);
+}
+
 #endif /* _LINUX_SLUB_DEF_H */
_

Patches currently in -mm which might be from a.ryabinin@samsung.com are

origin.patch


From: akpm@linux-foundation.org
Subject: [merged]
 kmemleak-disable-kasan-instrumentation-for-kmemleak.patch removed from -mm
 tree
Date: Mon, 16 Feb 2015 12:18:16 -0800
Message-ID: <54e25088.20WpuDitxkIMqfGq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51219 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbbBPUSx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:18:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, adech.fo@gmail.com, andi@firstfloor.org, catalin.marinas@arm.com, cl@linux.com, dave.hansen@intel.com, dmitryc@google.com, dvyukov@google.com, hpa@zytor.com, iamjoonsoo.kim@lge.com, kcc@google.com, koct9i@gmail.com, mingo@elte.hu, penberg@kernel.org, rientjes@google.com, sasha.levin@oracle.com, tetra2005@gmail.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: kmemleak: disable kasan instrumentation for kmemleak
has been removed from the -mm tree.  Its filename was
     kmemleak-disable-kasan-instrumentation-for-kmemleak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: kmemleak: disable kasan instrumentation for kmemleak

kmalloc internally round up allocation size, and kmemleak uses rounded up
size as object's size.  This makes kasan to complain while kmemleak scans
memory or calculates of object's checksum.  The simplest solution here is
to disable kasan.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
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
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/kmemleak.c~kmemleak-disable-kasan-instrumentation-for-kmemleak mm/kmemleak.c
--- a/mm/kmemleak.c~kmemleak-disable-kasan-instrumentation-for-kmemleak
+++ a/mm/kmemleak.c
@@ -98,6 +98,7 @@
 #include <asm/processor.h>
 #include <linux/atomic.h>
 
+#include <linux/kasan.h>
 #include <linux/kmemcheck.h>
 #include <linux/kmemleak.h>
 #include <linux/memory_hotplug.h>
@@ -1113,7 +1114,10 @@ static bool update_checksum(struct kmeml
 	if (!kmemcheck_is_obj_initialized(object->pointer, object->size))
 		return false;
 
+	kasan_disable_current();
 	object->checksum = crc32(0, (void *)object->pointer, object->size);
+	kasan_enable_current();
+
 	return object->checksum != old_csum;
 }
 
@@ -1164,7 +1168,9 @@ static void scan_block(void *_start, voi
 						  BYTES_PER_POINTER))
 			continue;
 
+		kasan_disable_current();
 		pointer = *ptr;
+		kasan_enable_current();
 
 		object = find_and_get_object(pointer, 1);
 		if (!object)
_

Patches currently in -mm which might be from a.ryabinin@samsung.com are

origin.patch


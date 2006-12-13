From: akpm@osdl.org
Subject: + alpha-increase-percpu_enough_room.patch added to -mm tree
Date: Wed, 13 Dec 2006 13:04:00 -0800
Message-ID: <200612132104.kBDL40M1019955@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:41491 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbWLMVET (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 16:04:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@gmail.com, Jay.Estabrook@hp.com, ink@jurassic.park.msu.ru, rth@twiddle.net


The patch titled
     Alpha: increase PERCPU_ENOUGH_ROOM
has been added to the -mm tree.  Its filename is
     alpha-increase-percpu_enough_room.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Alpha: increase PERCPU_ENOUGH_ROOM
From: "Aneesh Kumar K.V" <aneesh.kumar@gmail.com>

Module loading on Alpha was failing with error "Could not allocate 8 bytes
percpu data".

Looking at dmesg we have the below error "No per-cpu room for modules."

Increase the PERCPU_ENOUGH_ROOM in a similar way as x86_64

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@gmail.com>
Cc: <Jay.Estabrook@hp.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-alpha/percpu.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+)

diff -puN include/asm-alpha/percpu.h~alpha-increase-percpu_enough_room include/asm-alpha/percpu.h
--- a/include/asm-alpha/percpu.h~alpha-increase-percpu_enough_room
+++ a/include/asm-alpha/percpu.h
@@ -1,6 +1,20 @@
 #ifndef __ALPHA_PERCPU_H
 #define __ALPHA_PERCPU_H
 
+/*
+ * Increase the per cpu area for Alpha so that
+ * modules using percpu area can load.
+ */
+#ifdef CONFIG_MODULES
+# define PERCPU_MODULE_RESERVE 8192
+#else
+# define PERCPU_MODULE_RESERVE 0
+#endif
+
+#define PERCPU_ENOUGH_ROOM \
+	(ALIGN(__per_cpu_end - __per_cpu_start, SMP_CACHE_BYTES) + \
+	 PERCPU_MODULE_RESERVE)
+
 #include <asm-generic/percpu.h>
 
 #endif /* __ALPHA_PERCPU_H */
_

Patches currently in -mm which might be from aneesh.kumar@gmail.com are

kobject-kobject_uevent-returns-manageable-value.patch
alpha-increase-percpu_enough_room.patch


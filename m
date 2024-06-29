Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C6FBE47
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628255; cv=none; b=TBgo6W2CaW8Vhdfe9mk4io0GuGaRJ211NXf1l1Mlgk5q2uWw/ucPhDc5/rbo2o2jr9a/t196aHvorITqMY5kwv/RIJPgaHPSERtMjZCiyrTebbnbMzy5C7CkoRaQ62ZyQBqM/7r6d+ooTi7rrzK90LeARU3qV7dcOS/Rt6pHiGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628255; c=relaxed/simple;
	bh=XVoqQUhsB3q8tnr2AtnnUDDuTzr978HXbO6C6SiaCIY=;
	h=Date:To:From:Subject:Message-Id; b=fc0CwPzWxMs9ACGKXhwh3k7jIUvyWxv/NZUFmkRA9i7vV4wzYNB6jlNIPuaSZRLKbG2x90C+0LMpxUxExoQIAxFL1+SL3l1EFjVAn57m/GVVnbcfIVHpYuD6i4HZT9tFY7n0tgknLdPBXs1nx4EliLlGTQcccF85nb7ysKZjTlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AUbnPYHt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AUbnPYHt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE98C116B1;
	Sat, 29 Jun 2024 02:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628255;
	bh=XVoqQUhsB3q8tnr2AtnnUDDuTzr978HXbO6C6SiaCIY=;
	h=Date:To:From:Subject:From;
	b=AUbnPYHtd1g+mswsbNNTpIoXyvfX+sIeMdrX99Z8x2z92dLJRSTGQnQjqQIyx2c2k
	 mCehMXkS0Q+8i+I1g8NWAwrGxh38KSvlap5Ta15vm7YN+AUvRgQ8jZSeOMhNTXKKDf
	 dAkKvqm1kdLpQcC8OmmZWJqzRKheQffvycHB+fuk=
Date: Fri, 28 Jun 2024 19:30:55 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmsan-expose-kmsan_warn_on.patch removed from -mm tree
Message-Id: <20240629023055.9DE98C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kmsan: expose KMSAN_WARN_ON()
has been removed from the -mm tree.  Its filename was
     kmsan-expose-kmsan_warn_on.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: kmsan: expose KMSAN_WARN_ON()
Date: Fri, 21 Jun 2024 13:35:00 +0200

KMSAN_WARN_ON() is required for implementing s390-specific KMSAN
functions, but right now it's available only to the KMSAN internal
functions.  Expose it to subsystems through <linux/kmsan.h>.

Link: https://lkml.kernel.org/r/20240621113706.315500-17-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <kasan-dev@googlegroups.com>
Cc: Marco Elver <elver@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kmsan.h |   25 +++++++++++++++++++++++++
 mm/kmsan/kmsan.h      |   24 +-----------------------
 2 files changed, 26 insertions(+), 23 deletions(-)

--- a/include/linux/kmsan.h~kmsan-expose-kmsan_warn_on
+++ a/include/linux/kmsan.h
@@ -268,6 +268,29 @@ static inline void *memset_no_sanitize_m
 	return __memset(s, c, n);
 }
 
+extern bool kmsan_enabled;
+extern int panic_on_kmsan;
+
+/*
+ * KMSAN performs a lot of consistency checks that are currently enabled by
+ * default. BUG_ON is normally discouraged in the kernel, unless used for
+ * debugging, but KMSAN itself is a debugging tool, so it makes little sense to
+ * recover if something goes wrong.
+ */
+#define KMSAN_WARN_ON(cond)                                           \
+	({                                                            \
+		const bool __cond = WARN_ON(cond);                    \
+		if (unlikely(__cond)) {                               \
+			WRITE_ONCE(kmsan_enabled, false);             \
+			if (panic_on_kmsan) {                         \
+				/* Can't call panic() here because */ \
+				/* of uaccess checks. */              \
+				BUG();                                \
+			}                                             \
+		}                                                     \
+		__cond;                                               \
+	})
+
 #else
 
 static inline void kmsan_init_shadow(void)
@@ -380,6 +403,8 @@ static inline void *memset_no_sanitize_m
 	return memset(s, c, n);
 }
 
+#define KMSAN_WARN_ON WARN_ON
+
 #endif
 
 #endif /* _LINUX_KMSAN_H */
--- a/mm/kmsan/kmsan.h~kmsan-expose-kmsan_warn_on
+++ a/mm/kmsan/kmsan.h
@@ -11,6 +11,7 @@
 #define __MM_KMSAN_KMSAN_H
 
 #include <linux/irqflags.h>
+#include <linux/kmsan.h>
 #include <linux/mm.h>
 #include <linux/nmi.h>
 #include <linux/pgtable.h>
@@ -34,29 +35,6 @@
 #define KMSAN_META_SHADOW (false)
 #define KMSAN_META_ORIGIN (true)
 
-extern bool kmsan_enabled;
-extern int panic_on_kmsan;
-
-/*
- * KMSAN performs a lot of consistency checks that are currently enabled by
- * default. BUG_ON is normally discouraged in the kernel, unless used for
- * debugging, but KMSAN itself is a debugging tool, so it makes little sense to
- * recover if something goes wrong.
- */
-#define KMSAN_WARN_ON(cond)                                           \
-	({                                                            \
-		const bool __cond = WARN_ON(cond);                    \
-		if (unlikely(__cond)) {                               \
-			WRITE_ONCE(kmsan_enabled, false);             \
-			if (panic_on_kmsan) {                         \
-				/* Can't call panic() here because */ \
-				/* of uaccess checks. */              \
-				BUG();                                \
-			}                                             \
-		}                                                     \
-		__cond;                                               \
-	})
-
 /*
  * A pair of metadata pointers to be returned by the instrumentation functions.
  */
_

Patches currently in -mm which might be from iii@linux.ibm.com are



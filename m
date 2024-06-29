Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C90134A8
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628261; cv=none; b=BrNbeXmhbGsMhP2cFBHP9HnT6W1EpoKrHIja36BCtV/qF/ViCn852PKL0TziUJRTC0nH2KTwA+/5VP34XBPGF+PQWLAHGB16bIDUtSuq0zoh1Y+M2xv1RHu1H7vxOJz5h1LWKbyoYEuY685PGsTzbIFae/70OEwgmVAgzaTUnpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628261; c=relaxed/simple;
	bh=d06oanJcv3ATerC+WEVVMTuvKeKUpO0bFM0Uspez4cU=;
	h=Date:To:From:Subject:Message-Id; b=VkBU90PySHiQ41b7hyhP5pOqj6/m0r54hBA3r4EixUGuxcDyHc7DfZebzmWRZVdMnIgbRz7B8VNDVpkzmEwYIZ08+SLM8lKdleZ1wVEEVh84wpLFEX7JBiMgiSnrX8jixADxycpddZvm0cc+1QcRcSbwBOwTaErJUX2zxDWw+NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iktIPeYh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iktIPeYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A511C116B1;
	Sat, 29 Jun 2024 02:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628261;
	bh=d06oanJcv3ATerC+WEVVMTuvKeKUpO0bFM0Uspez4cU=;
	h=Date:To:From:Subject:From;
	b=iktIPeYhC1vbggXhXlcAWd4VAUINIwtolq+hwpRGHnKG4M8uPGl7BCTcCcKqfi2NM
	 auN05MAv24TaMHHEmgixRuw17NQm6fq53F5BjbMYUZupECMhJDniCxDnFE363W9LHx
	 IbOp0gjo+hIReQ8Pw6DnYmtz8lrQO2YF6h3vVlD0=
Date: Fri, 28 Jun 2024 19:31:00 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-zlib-unpoison-dfltcc-output-buffers.patch removed from -mm tree
Message-Id: <20240629023101.1A511C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/zlib: unpoison DFLTCC output buffers
has been removed from the -mm tree.  Its filename was
     lib-zlib-unpoison-dfltcc-output-buffers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: lib/zlib: unpoison DFLTCC output buffers
Date: Fri, 21 Jun 2024 13:35:04 +0200

The constraints of the DFLTCC inline assembly are not precise: they do not
communicate the size of the output buffers to the compiler, so it cannot
automatically instrument it.

Add the manual kmsan_unpoison_memory() calls for the output buffers.  The
logic is the same as in [1].

[1] https://github.com/zlib-ng/zlib-ng/commit/1f5ddcc009ac3511e99fc88736a9e1a6381168c5

Link: https://lkml.kernel.org/r/20240621113706.315500-21-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reported-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
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

 lib/zlib_dfltcc/dfltcc.h      |    1 +
 lib/zlib_dfltcc/dfltcc_util.h |   28 ++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

--- a/lib/zlib_dfltcc/dfltcc.h~lib-zlib-unpoison-dfltcc-output-buffers
+++ a/lib/zlib_dfltcc/dfltcc.h
@@ -80,6 +80,7 @@ struct dfltcc_param_v0 {
     uint8_t csb[1152];
 };
 
+static_assert(offsetof(struct dfltcc_param_v0, csb) == 384);
 static_assert(sizeof(struct dfltcc_param_v0) == 1536);
 
 #define CVT_CRC32 0
--- a/lib/zlib_dfltcc/dfltcc_util.h~lib-zlib-unpoison-dfltcc-output-buffers
+++ a/lib/zlib_dfltcc/dfltcc_util.h
@@ -2,6 +2,8 @@
 #ifndef DFLTCC_UTIL_H
 #define DFLTCC_UTIL_H
 
+#include "dfltcc.h"
+#include <linux/kmsan-checks.h>
 #include <linux/zutil.h>
 
 /*
@@ -20,6 +22,7 @@ typedef enum {
 #define DFLTCC_CMPR 2
 #define DFLTCC_XPND 4
 #define HBT_CIRCULAR (1 << 7)
+#define DFLTCC_FN_MASK ((1 << 7) - 1)
 #define HB_BITS 15
 #define HB_SIZE (1 << HB_BITS)
 
@@ -34,6 +37,7 @@ static inline dfltcc_cc dfltcc(
 )
 {
     Byte *t2 = op1 ? *op1 : NULL;
+    unsigned char *orig_t2 = t2;
     size_t t3 = len1 ? *len1 : 0;
     const Byte *t4 = op2 ? *op2 : NULL;
     size_t t5 = len2 ? *len2 : 0;
@@ -59,6 +63,30 @@ static inline dfltcc_cc dfltcc(
                      : "cc", "memory");
     t2 = r2; t3 = r3; t4 = r4; t5 = r5;
 
+    /*
+     * Unpoison the parameter block and the output buffer.
+     * This is a no-op in non-KMSAN builds.
+     */
+    switch (fn & DFLTCC_FN_MASK) {
+    case DFLTCC_QAF:
+        kmsan_unpoison_memory(param, sizeof(struct dfltcc_qaf_param));
+        break;
+    case DFLTCC_GDHT:
+        kmsan_unpoison_memory(param, offsetof(struct dfltcc_param_v0, csb));
+        break;
+    case DFLTCC_CMPR:
+        kmsan_unpoison_memory(param, sizeof(struct dfltcc_param_v0));
+        kmsan_unpoison_memory(
+                orig_t2,
+                t2 - orig_t2 +
+                    (((struct dfltcc_param_v0 *)param)->sbb == 0 ? 0 : 1));
+        break;
+    case DFLTCC_XPND:
+        kmsan_unpoison_memory(param, sizeof(struct dfltcc_param_v0));
+        kmsan_unpoison_memory(orig_t2, t2 - orig_t2);
+        break;
+    }
+
     if (op1)
         *op1 = t2;
     if (len1)
_

Patches currently in -mm which might be from iii@linux.ibm.com are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA164125A9
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628267; cv=none; b=ZUjfeVNvX7D0piWn/aCw41xMGG2mvbKgzVdadanwfyyWmALjraO6bmowK1P9wbaLTHGnoBel+DiqfiMoTBIlPF9VNpbiwyjGgqWDOTjz9TBbcD/R/H7kR5c/sTJcX5YSgnDTirsIvs9BKTwQ9twUxoPWOXBBfMy9XgfgPbG+Cgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628267; c=relaxed/simple;
	bh=9qyuwK8UjTwfLcK7EfLdu+jdK0ePxTbDUt1+NzDst2Y=;
	h=Date:To:From:Subject:Message-Id; b=lMnNXwKqlHkHsswsrwUvnu88j0QGVuy5dTSRwmPJVywvrRXIX3Ul7KiF0cI7MsiWOiqEZVPiQFUfpKBsJ8WCVBP6PqR00PKSLLzEqPLLnfZjj7rPmbauIFJzOwJjhd0WjMVV2ti6OwBdyQA+zANLjlB0a7bHzm1P11PNOUUPjp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aSjJOMLq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aSjJOMLq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2342C116B1;
	Sat, 29 Jun 2024 02:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628266;
	bh=9qyuwK8UjTwfLcK7EfLdu+jdK0ePxTbDUt1+NzDst2Y=;
	h=Date:To:From:Subject:From;
	b=aSjJOMLqdd3okJgA3pFmNOKdBDW+B1p7K65dC8MbpTeMsXBrCyVsiyvEeblbGVCEy
	 kFCM9GJtIyeGXsojF2RQBd/2NJpq73HgS2Qk5kekTkf9g6KdSDYAKLGciODeLzAgVx
	 uhWogtLbr8gFekTUCTTpatARAM7rQ2wnMVTiCUSw=
Date: Fri, 28 Jun 2024 19:31:06 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] s390-boot-add-the-kmsan-runtime-stub.patch removed from -mm tree
Message-Id: <20240629023106.C2342C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: s390/boot: add the KMSAN runtime stub
has been removed from the -mm tree.  Its filename was
     s390-boot-add-the-kmsan-runtime-stub.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: s390/boot: add the KMSAN runtime stub
Date: Fri, 21 Jun 2024 13:35:08 +0200

It should be possible to have inline functions in the s390 header files,
which call kmsan_unpoison_memory().  The problem is that these header
files might be included by the decompressor, which does not contain KMSAN
runtime, causing linker errors.

Not compiling these calls if __SANITIZE_MEMORY__ is not defined - either
by changing kmsan-checks.h or at the call sites - may cause unintended
side effects, since calling these functions from an uninstrumented code
that is linked into the kernel is valid use case.

One might want to explicitly distinguish between the kernel and the
decompressor.  Checking for a decompressor-specific #define is quite
heavy-handed, and will have to be done at all call sites.

A more generic approach is to provide a dummy kmsan_unpoison_memory()
definition.  This produces some runtime overhead, but only when building
with CONFIG_KMSAN.  The benefit is that it does not disturb the existing
KMSAN build logic and call sites don't need to be changed.

Link: https://lkml.kernel.org/r/20240621113706.315500-25-iii@linux.ibm.com
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

 arch/s390/boot/Makefile |    1 +
 arch/s390/boot/kmsan.c  |    6 ++++++
 2 files changed, 7 insertions(+)

--- /dev/null
+++ a/arch/s390/boot/kmsan.c
@@ -0,0 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/kmsan-checks.h>
+
+void kmsan_unpoison_memory(const void *address, size_t size)
+{
+}
--- a/arch/s390/boot/Makefile~s390-boot-add-the-kmsan-runtime-stub
+++ a/arch/s390/boot/Makefile
@@ -44,6 +44,7 @@ obj-$(findstring y, $(CONFIG_PROTECTED_V
 obj-$(CONFIG_RANDOMIZE_BASE)	+= kaslr.o
 obj-y	+= $(if $(CONFIG_KERNEL_UNCOMPRESSED),,decompressor.o) info.o
 obj-$(CONFIG_KERNEL_ZSTD) += clz_ctz.o
+obj-$(CONFIG_KMSAN) += kmsan.o
 obj-all := $(obj-y) piggy.o syms.o
 
 targets	:= bzImage section_cmp.boot.data section_cmp.boot.preserved.data $(obj-y)
_

Patches currently in -mm which might be from iii@linux.ibm.com are



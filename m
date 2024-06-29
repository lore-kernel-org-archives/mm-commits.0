Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3263171D8
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628277; cv=none; b=uZF8F6YPXlNKLkyDiZxUS5lEGxaNBvwtbR6evNp1ceXl5PNXeGL1GsYNIo4tP5wC+IxzDwk0ZDQ6X6K+zvmM6JUC2u6CWxF0Rja6JZMba7GXdJ/fUuKISuEfDFUQXTEPVWijFMVPE9JwY5OCNfDp8AqX6JGRY/KCiCJMHOK4MiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628277; c=relaxed/simple;
	bh=mnjEEuylIMedoAp1q5TwbsAEvKU6yELUsUS2JSEKMl8=;
	h=Date:To:From:Subject:Message-Id; b=Mw6/c5iIMyBy8pHOmgZPFSNx9erUQblxMI+8WczTM5q1JsyEW1bvNnfKnDVsDfUBLxrUtFAxOtwQhsaSys5eLloDkr23bbSHAlEEgkxdVGXg022FE2xjt8ZVlkHjyXBQ55q04rZxP8tIZ+WuhFlJrHZ4bbvQd6FTK6FR6vKgrAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0TpOQc7U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0TpOQc7U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA8F9C116B1;
	Sat, 29 Jun 2024 02:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628276;
	bh=mnjEEuylIMedoAp1q5TwbsAEvKU6yELUsUS2JSEKMl8=;
	h=Date:To:From:Subject:From;
	b=0TpOQc7UeApdBfecIaP2NiRYaJf1rwxRGEm3ht0tXZd90Kwime1a7IgA7/MpNZxms
	 K9Y5lYWvypU5u/yti9YE07AJ3mxgsDjWKbFJrZV9wL9cv4Rc6TdweG7n/1QaY5K5rB
	 BJPaHvQNmdVDPwsLETKg5hx5SZB2Le7+B9fuwA0c=
Date: Fri, 28 Jun 2024 19:31:16 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] s390-mm-define-kmsan-metadata-for-vmalloc-and-modules.patch removed from -mm tree
Message-Id: <20240629023116.BA8F9C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: s390/mm: define KMSAN metadata for vmalloc and modules
has been removed from the -mm tree.  Its filename was
     s390-mm-define-kmsan-metadata-for-vmalloc-and-modules.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: s390/mm: define KMSAN metadata for vmalloc and modules
Date: Fri, 21 Jun 2024 13:35:15 +0200

The pages for the KMSAN metadata associated with most kernel mappings are
taken from memblock by the common code.  However, vmalloc and module
metadata needs to be defined by the architectures.

Be a little bit more careful than x86: allocate exactly MODULES_LEN for
the module shadow and origins, and then take 2/3 of vmalloc for the
vmalloc shadow and origins.  This ensures that users passing small
vmalloc= values on the command line do not cause module metadata
collisions.

Link: https://lkml.kernel.org/r/20240621113706.315500-32-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
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

 arch/s390/boot/startup.c        |    7 +++++++
 arch/s390/include/asm/pgtable.h |   12 ++++++++++++
 2 files changed, 19 insertions(+)

--- a/arch/s390/boot/startup.c~s390-mm-define-kmsan-metadata-for-vmalloc-and-modules
+++ a/arch/s390/boot/startup.c
@@ -301,11 +301,18 @@ static unsigned long setup_kernel_memory
 	MODULES_END = round_down(kernel_start, _SEGMENT_SIZE);
 	MODULES_VADDR = MODULES_END - MODULES_LEN;
 	VMALLOC_END = MODULES_VADDR;
+	if (IS_ENABLED(CONFIG_KMSAN))
+		VMALLOC_END -= MODULES_LEN * 2;
 
 	/* allow vmalloc area to occupy up to about 1/2 of the rest virtual space left */
 	vsize = (VMALLOC_END - FIXMAP_SIZE) / 2;
 	vsize = round_down(vsize, _SEGMENT_SIZE);
 	vmalloc_size = min(vmalloc_size, vsize);
+	if (IS_ENABLED(CONFIG_KMSAN)) {
+		/* take 2/3 of vmalloc area for KMSAN shadow and origins */
+		vmalloc_size = round_down(vmalloc_size / 3, _SEGMENT_SIZE);
+		VMALLOC_END -= vmalloc_size * 2;
+	}
 	VMALLOC_START = VMALLOC_END - vmalloc_size;
 
 	__memcpy_real_area = round_down(VMALLOC_START - MEMCPY_REAL_SIZE, PAGE_SIZE);
--- a/arch/s390/include/asm/pgtable.h~s390-mm-define-kmsan-metadata-for-vmalloc-and-modules
+++ a/arch/s390/include/asm/pgtable.h
@@ -107,6 +107,18 @@ static inline int is_module_addr(void *a
 	return 1;
 }
 
+#ifdef CONFIG_KMSAN
+#define KMSAN_VMALLOC_SIZE (VMALLOC_END - VMALLOC_START)
+#define KMSAN_VMALLOC_SHADOW_START VMALLOC_END
+#define KMSAN_VMALLOC_SHADOW_END (KMSAN_VMALLOC_SHADOW_START + KMSAN_VMALLOC_SIZE)
+#define KMSAN_VMALLOC_ORIGIN_START KMSAN_VMALLOC_SHADOW_END
+#define KMSAN_VMALLOC_ORIGIN_END (KMSAN_VMALLOC_ORIGIN_START + KMSAN_VMALLOC_SIZE)
+#define KMSAN_MODULES_SHADOW_START KMSAN_VMALLOC_ORIGIN_END
+#define KMSAN_MODULES_SHADOW_END (KMSAN_MODULES_SHADOW_START + MODULES_LEN)
+#define KMSAN_MODULES_ORIGIN_START KMSAN_MODULES_SHADOW_END
+#define KMSAN_MODULES_ORIGIN_END (KMSAN_MODULES_ORIGIN_START + MODULES_LEN)
+#endif
+
 #ifdef CONFIG_RANDOMIZE_BASE
 #define KASLR_LEN	(1UL << 31)
 #else
_

Patches currently in -mm which might be from iii@linux.ibm.com are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7780BE47
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628246; cv=none; b=q9AtMxVPtORBR6n265dzwRbM7IyWSapOB7sLJa8PlZPU4CzLqteszM/pa8yXI3eBLXCIUxWACF7j7EDPK4/PnWvfLnvfu/haczrJi4On55zUMrPnHOJDw38Vfy8tUWHG5BYVUh2wcK4AYNtLY6xFChZrJMCpwxz6gq5vQstez58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628246; c=relaxed/simple;
	bh=toh2DZM02JVqlX8f8SrUBcyDKjyRSo6h4KDp1Vtwshs=;
	h=Date:To:From:Subject:Message-Id; b=h+oLH6hn/rLW9/0dxiMdCPkanc018EhXfJtDcPEG6XIwm4ARtQKVZaP7X6rvXLikwm1cTk4mY4aiq3fWcpwGYBY/UsOdkx6PKFWO9z8GTUZSSbYqzmzpi5rhreh2OOdU+qOhEDGYwg/9Xc/BHTNztOyQidt6NARwM47zYepJyLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tz1ypAWR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tz1ypAWR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA7CC116B1;
	Sat, 29 Jun 2024 02:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628245;
	bh=toh2DZM02JVqlX8f8SrUBcyDKjyRSo6h4KDp1Vtwshs=;
	h=Date:To:From:Subject:From;
	b=tz1ypAWRyavlt92APM3HVpH/1WoLFbMCAQ5qYMWPjN5nCL7xmBDvkA9+KZdGh46dj
	 2VQeVrm6iC3FevMpQNYKBzPbdz2NNZXfU/ShaxFYMazv0r/p6UH617AIgW/56gAq6i
	 77P3zfVvABIa6zvbG9wa6bqmlNfU8vn54bYIRu0c=
Date: Fri, 28 Jun 2024 19:30:45 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmsan-expose-kmsan_get_metadata.patch removed from -mm tree
Message-Id: <20240629023045.BDA7CC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kmsan: expose kmsan_get_metadata()
has been removed from the -mm tree.  Its filename was
     kmsan-expose-kmsan_get_metadata.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: kmsan: expose kmsan_get_metadata()
Date: Fri, 21 Jun 2024 13:34:53 +0200

Each s390 CPU has lowcore pages associated with it.  Each CPU sees its own
lowcore at virtual address 0 through a hardware mechanism called
prefixing.  Additionally, all lowcores are mapped to non-0 virtual
addresses stored in the lowcore_ptr[] array.

When lowcore is accessed through virtual address 0, one needs to resolve
metadata for lowcore_ptr[raw_smp_processor_id()].

Expose kmsan_get_metadata() to make it possible to do this from the arch
code.

Link: https://lkml.kernel.org/r/20240621113706.315500-10-iii@linux.ibm.com
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

 include/linux/kmsan.h      |    9 +++++++++
 mm/kmsan/instrumentation.c |    1 +
 mm/kmsan/kmsan.h           |    1 -
 3 files changed, 10 insertions(+), 1 deletion(-)

--- a/include/linux/kmsan.h~kmsan-expose-kmsan_get_metadata
+++ a/include/linux/kmsan.h
@@ -230,6 +230,15 @@ void kmsan_handle_urb(const struct urb *
  */
 void kmsan_unpoison_entry_regs(const struct pt_regs *regs);
 
+/**
+ * kmsan_get_metadata() - Return a pointer to KMSAN shadow or origins.
+ * @addr:      kernel address.
+ * @is_origin: whether to return origins or shadow.
+ *
+ * Return NULL if metadata cannot be found.
+ */
+void *kmsan_get_metadata(void *addr, bool is_origin);
+
 #else
 
 static inline void kmsan_init_shadow(void)
--- a/mm/kmsan/instrumentation.c~kmsan-expose-kmsan_get_metadata
+++ a/mm/kmsan/instrumentation.c
@@ -14,6 +14,7 @@
 
 #include "kmsan.h"
 #include <linux/gfp.h>
+#include <linux/kmsan.h>
 #include <linux/kmsan_string.h>
 #include <linux/mm.h>
 #include <linux/uaccess.h>
--- a/mm/kmsan/kmsan.h~kmsan-expose-kmsan_get_metadata
+++ a/mm/kmsan/kmsan.h
@@ -66,7 +66,6 @@ struct shadow_origin_ptr {
 
 struct shadow_origin_ptr kmsan_get_shadow_origin_ptr(void *addr, u64 size,
 						     bool store);
-void *kmsan_get_metadata(void *addr, bool is_origin);
 void __init kmsan_init_alloc_meta_for_range(void *start, void *end);
 
 enum kmsan_bug_reason {
_

Patches currently in -mm which might be from iii@linux.ibm.com are



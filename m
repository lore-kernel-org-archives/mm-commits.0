Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5469813ADB
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DGHGZ+hK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209B9C433C8;
	Fri, 29 Dec 2023 20:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880036;
	bh=K3yk5APR8gW0j3bf7u5K3PfAMCB92w5llRHWVGErzZI=;
	h=Date:To:From:Subject:From;
	b=DGHGZ+hKsBhL8AQlv9eTzBNBwDNNDCioVT/D6M2XMBJUgDXbgK/fMSsCFSf4wUk+u
	 NIDSAsDoUQCTou/ILY2opNbfTaDo3b+G+/zq8pW5M+FvDBdw74ScUkhMKfYTQnox34
	 LKJ6C8J01OaBmcv12lj+/WKjLOTNimf0KSqDsda4=
Date: Fri, 29 Dec 2023 12:00:35 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,leitao@debian.org,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,alobakin@pm.me,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-document-kasan_mempool_poison_object.patch removed from -mm tree
Message-Id: <20231229200036.209B9C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: document kasan_mempool_poison_object
has been removed from the -mm tree.  Its filename was
     kasan-document-kasan_mempool_poison_object.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: document kasan_mempool_poison_object
Date: Tue, 19 Dec 2023 23:28:47 +0100

Add documentation comment for kasan_mempool_poison_object.

Link: https://lkml.kernel.org/r/af33ba8cabfa1ad731fe23a3f874bfc8d3b7fed4.1703024586.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Lobakin <alobakin@pm.me>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/include/linux/kasan.h~kasan-document-kasan_mempool_poison_object
+++ a/include/linux/kasan.h
@@ -213,6 +213,24 @@ static __always_inline void * __must_che
 }
 
 void __kasan_mempool_poison_object(void *ptr, unsigned long ip);
+/**
+ * kasan_mempool_poison_object - Check and poison a mempool slab allocation.
+ * @ptr: Pointer to the slab allocation.
+ *
+ * This function is intended for kernel subsystems that cache slab allocations
+ * to reuse them instead of freeing them back to the slab allocator (e.g.
+ * mempool).
+ *
+ * This function poisons a slab allocation without initializing its memory and
+ * without putting it into the quarantine (for the Generic mode).
+ *
+ * This function also performs checks to detect double-free and invalid-free
+ * bugs and reports them.
+ *
+ * This function operates on all slab allocations including large kmalloc
+ * allocations (the ones returned by kmalloc_large() or by kmalloc() with the
+ * size > KMALLOC_MAX_SIZE).
+ */
 static __always_inline void kasan_mempool_poison_object(void *ptr)
 {
 	if (kasan_enabled())
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-stop-leaking-stack-trace-handles.patch


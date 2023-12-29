Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEDB13AF9
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sQUgE3ac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573DCC433C7;
	Fri, 29 Dec 2023 20:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880047;
	bh=I6UsqZ2K2cFssV6lfvQ3rWCND0lZCya7TLz9iAnkMsc=;
	h=Date:To:From:Subject:From;
	b=sQUgE3ace6OOk4sG/uf36oLpXRi4P+388S3a0ITdfBlAm+yNjAIP8c07sLLsg6tBK
	 13twQcejagCRIdzilybJZ4jZTAS+DFdZT8TBruB/X3rI8y2b4nVUcIFQjgb4LpJ0xV
	 sQll6lxQ47i1IuK4U06vmM0NcnPPukCb9ckVNvk0=
Date: Fri, 29 Dec 2023 12:00:46 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,leitao@debian.org,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,alobakin@pm.me,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mempool-skip-slub_debug-poisoning-when-kasan-is-enabled.patch removed from -mm tree
Message-Id: <20231229200047.573DCC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mempool: skip slub_debug poisoning when KASAN is enabled
has been removed from the -mm tree.  Its filename was
     mempool-skip-slub_debug-poisoning-when-kasan-is-enabled.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: mempool: skip slub_debug poisoning when KASAN is enabled
Date: Tue, 19 Dec 2023 23:28:57 +0100

With the changes in the following patch, KASAN starts saving its metadata
within freed mempool elements.

Thus, skip slub_debug poisoning and checking of mempool elements when
KASAN is enabled.  Corruptions of freed mempool elements will be detected
by KASAN anyway.

Link: https://lkml.kernel.org/r/98a4b1617e8ceeb266ef9a46f5e8c7f67a563ad2.1703024586.git.andreyknvl@google.com
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

 mm/mempool.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/mempool.c~mempool-skip-slub_debug-poisoning-when-kasan-is-enabled
+++ a/mm/mempool.c
@@ -56,6 +56,10 @@ static void __check_element(mempool_t *p
 
 static void check_element(mempool_t *pool, void *element)
 {
+	/* Skip checking: KASAN might save its metadata in the element. */
+	if (kasan_enabled())
+		return;
+
 	/* Mempools backed by slab allocator */
 	if (pool->free == mempool_kfree) {
 		__check_element(pool, element, (size_t)pool->pool_data);
@@ -81,6 +85,10 @@ static void __poison_element(void *eleme
 
 static void poison_element(mempool_t *pool, void *element)
 {
+	/* Skip poisoning: KASAN might save its metadata in the element. */
+	if (kasan_enabled())
+		return;
+
 	/* Mempools backed by slab allocator */
 	if (pool->alloc == mempool_kmalloc) {
 		__poison_element(element, (size_t)pool->pool_data);
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-stop-leaking-stack-trace-handles.patch


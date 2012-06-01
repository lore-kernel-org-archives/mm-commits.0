From: akpm@linux-foundation.org
Subject: [merged] introduce-size_max.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:32:50 -0700
Message-ID: <20120601193250.5CEE0A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:57700 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757777Ab2FATcv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:32:51 -0400
Received: by yenl3 with SMTP id l3so248161yen.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:32:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xi.wang@gmail.com, airlied@linux.ie, elder@dreamhost.com, penberg@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: introduce SIZE_MAX
has been removed from the -mm tree.  Its filename was
     introduce-size_max.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Xi Wang <xi.wang@gmail.com>
Subject: introduce SIZE_MAX

ULONG_MAX is often used to check for integer overflow when calculating
allocation size.  While ULONG_MAX happens to work on most systems, there
is no guarantee that `size_t' must be the same size as `long'.

This patch introduces SIZE_MAX, the maximum value of `size_t', to improve
portability and readability for allocation size validation.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Acked-by: Alex Elder <elder@dreamhost.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ceph/snap.c             |    2 +-
 include/drm/drm_mem_util.h |    4 ++--
 include/linux/kernel.h     |    1 +
 include/linux/slab.h       |    2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)

diff -puN fs/ceph/snap.c~introduce-size_max fs/ceph/snap.c
--- a/fs/ceph/snap.c~introduce-size_max
+++ a/fs/ceph/snap.c
@@ -331,7 +331,7 @@ static int build_snap_context(struct cep
 
 	/* alloc new snap context */
 	err = -ENOMEM;
-	if (num > (ULONG_MAX - sizeof(*snapc)) / sizeof(u64))
+	if (num > (SIZE_MAX - sizeof(*snapc)) / sizeof(u64))
 		goto fail;
 	snapc = kzalloc(sizeof(*snapc) + num*sizeof(u64), GFP_NOFS);
 	if (!snapc)
diff -puN include/drm/drm_mem_util.h~introduce-size_max include/drm/drm_mem_util.h
--- a/include/drm/drm_mem_util.h~introduce-size_max
+++ a/include/drm/drm_mem_util.h
@@ -31,7 +31,7 @@
 
 static __inline__ void *drm_calloc_large(size_t nmemb, size_t size)
 {
-	if (size != 0 && nmemb > ULONG_MAX / size)
+	if (size != 0 && nmemb > SIZE_MAX / size)
 		return NULL;
 
 	if (size * nmemb <= PAGE_SIZE)
@@ -44,7 +44,7 @@ static __inline__ void *drm_calloc_large
 /* Modeled after cairo's malloc_ab, it's like calloc but without the zeroing. */
 static __inline__ void *drm_malloc_ab(size_t nmemb, size_t size)
 {
-	if (size != 0 && nmemb > ULONG_MAX / size)
+	if (size != 0 && nmemb > SIZE_MAX / size)
 		return NULL;
 
 	if (size * nmemb <= PAGE_SIZE)
diff -puN include/linux/kernel.h~introduce-size_max include/linux/kernel.h
--- a/include/linux/kernel.h~introduce-size_max
+++ a/include/linux/kernel.h
@@ -35,6 +35,7 @@
 #define LLONG_MAX	((long long)(~0ULL>>1))
 #define LLONG_MIN	(-LLONG_MAX - 1)
 #define ULLONG_MAX	(~0ULL)
+#define SIZE_MAX	(~(size_t)0)
 
 #define STACK_MAGIC	0xdeadbeef
 
diff -puN include/linux/slab.h~introduce-size_max include/linux/slab.h
--- a/include/linux/slab.h~introduce-size_max
+++ a/include/linux/slab.h
@@ -242,7 +242,7 @@ size_t ksize(const void *);
  */
 static inline void *kmalloc_array(size_t n, size_t size, gfp_t flags)
 {
-	if (size != 0 && n > ULONG_MAX / size)
+	if (size != 0 && n > SIZE_MAX / size)
 		return NULL;
 	return __kmalloc(n * size, flags);
 }
_

Patches currently in -mm which might be from xi.wang@gmail.com are

origin.patch
linux-next.patch


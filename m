From: akpm@linux-foundation.org
Subject: + introduce-size_max.patch added to -mm tree
Date: Fri, 20 Apr 2012 16:04:05 -0700
Message-ID: <20120420230405.D5F3AA03B2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:56002 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216Ab2DTXEM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Apr 2012 19:04:12 -0400
Received: by qabg24 with SMTP id g24so119744qab.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Apr 2012 16:04:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xi.wang@gmail.com, airlied@linux.ie, elder@dreamhost.com, penberg@kernel.org


The patch titled
     Subject: introduce SIZE_MAX
has been added to the -mm tree.  Its filename is
     introduce-size_max.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xi Wang <xi.wang@gmail.com>
Subject: introduce SIZE_MAX

ULONG_MAX is often used to check for integer overflow when calculating
allocation size.  While ULONG_MAX happens to work on most systems, there
is no guarantee that `size_t' must be the same size as `long'.

This patch introduces SIZE_MAX, the maximum value of `size_t', to improve
portability and readability for allocation size validation.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Cc: Alex Elder <elder@dreamhost.com>
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
Subject: Subject: introduce SIZE_MAX

Patches currently in -mm which might be from xi.wang@gmail.com are

linux-next.patch
codingstyle-add-kmalloc_array-to-memory-allocators.patch
introduce-size_max.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930AF41B354
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525568; cv=none; b=D0VjN0VNJ8Q+Isn+7F4DzjvZAoYGay/a5jiYSbT5nrh3xNMs1Y9uN6dvTYSgep6PKRbHv2rOtnyOUSTG95XEdqdOsYjSiXnfj7lRnV1anfwFwaXMbY8r+R4+h0FP/kGgi/mi6KY2tjU1MlJrfGKB1PyOye1O9ZVaR5ztexMZJQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525568; c=relaxed/simple;
	bh=NCraXF8NF3qVjCIiVkflrwwoegSZrFF/N9ZsGMuj37g=;
	h=Date:To:From:Subject:Message-Id; b=Hsm9/rD64jj2NjEDR6fRPNRPycPd+d0TlvC+Yk9XNyGWkR0YiwxYtFAxcrfRJa4bmJPBlEgmuSW7rakNVB9lMALNrB3j52tWbzQ2+YzKHBZfeuU2Iy0ZqkVWeTmxnztfqVn/OC0cwFoBG2nfGU1+kqGLfwjGVC2b4SH8/PBXPmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G30Tg8t2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G30Tg8t2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF481F00893;
	Fri,  9 Oct 2026 05:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525567;
	bh=xKBMof2aleeCABjTbpFUf19HPntkWYtPE6NkWRypKE8=;
	h=Date:To:From:Subject;
	b=G30Tg8t2JF0TqWOqMnCHzoQ16iP8RqnlKaohyTCwQdsxU4FUu449wPRkLyacyN/iA
	 I9xmTBcff4pvuUTvKOhwC4YWKpK4q/gxS6v7uN5qPAWgr8pgJdgPstmVCWPOxXuRsG
	 AO6lGflD+gfRPXiGHYHF3NGrgf4DoeI8gZuMh9qQ=
Date: Thu, 08 Oct 2026 22:59:26 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,sparse@chrisli.org,liam@infradead.org,andrewjballance@gmail.com,aliceryhl@google.com,ynorov@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] idr-assert-static-storage-for-define_ida.patch removed from -mm tree
Message-Id: <20261009055927.1BF481F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: idr: assert static storage for DEFINE_IDA()
has been removed from the -mm tree.  Its filename was
     idr-assert-static-storage-for-define_ida.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yury Norov <ynorov@nvidia.com>
Subject: idr: assert static storage for DEFINE_IDA()
Date: Fri, 11 Sep 2026 18:14:42 -0400

DEFINE_IDA() uses IDA_INIT(), which initializes the embedded XArray lock
with a static spinlock initializer.  For an automatic local IDA, lockdep
cannot use the lock address as a persistent class key and reports "INFO:
trying to register non-static key" before disabling itself.

Apply ASSERT_STATIC_STORAGE() to DEFINE_IDA() so that this misuse is
rejected at compile time.  For example:

  void example(void)
  {
          DEFINE_IDA(ida);
          ida_destroy(&ida);
  }

GCC reports:

  error: initializer element is not constant
    name##_storage_check = &(name)
                           ^
  note: in expansion of macro 'ASSERT_STATIC_STORAGE'
    ASSERT_STATIC_STORAGE(name)
  note: in expansion of macro 'DEFINE_IDA'
    DEFINE_IDA(ida);

File-scope definitions and static DEFINE_IDA() within a function remain
valid.  Automatic local IDAs must instead be initialized with ida_init(). 
Direct uses of IDA_INIT() are not covered by this declaration check.

Convert the five automatic local IDAs in the userspace radix-tree tests to
ida_init() so they satisfy the new requirement.

Validated file-scope and static local definitions with a kernel object
build, and confirmed that an automatic local definition fails to compile.

Link: https://lore.kernel.org/20260911221444.1523311-3-ynorov@nvidia.com
Signed-off-by: Yury Norov <ynorov@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: Christopher Li <sparse@chrisli.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
---

 include/linux/idr.h                 |    5 ++++-
 tools/testing/radix-tree/idr-test.c |   20 +++++++++++++++-----
 2 files changed, 19 insertions(+), 6 deletions(-)

--- a/include/linux/idr.h~idr-assert-static-storage-for-define_ida
+++ a/include/linux/idr.h
@@ -16,6 +16,7 @@
 #include <linux/gfp.h>
 #include <linux/percpu.h>
 #include <linux/cleanup.h>
+#include <linux/compiler.h>
 
 struct idr {
 	struct radix_tree_root	idr_rt;
@@ -269,7 +270,9 @@ struct ida {
 #define IDA_INIT(name)	{						\
 	.xa = XARRAY_INIT(name, IDA_INIT_FLAGS)				\
 }
-#define DEFINE_IDA(name)	struct ida name = IDA_INIT(name)
+#define DEFINE_IDA(name)							\
+	struct ida name = IDA_INIT(name);					\
+	ASSERT_STATIC_STORAGE(name)
 
 int ida_alloc_range(struct ida *, unsigned int min, unsigned int max, gfp_t);
 void ida_free(struct ida *, unsigned int id);
--- a/tools/testing/radix-tree/idr-test.c~idr-assert-static-storage-for-define_ida
+++ a/tools/testing/radix-tree/idr-test.c
@@ -460,9 +460,11 @@ void ida_dump(struct ida *);
  */
 void ida_check_nomem(void)
 {
-	DEFINE_IDA(ida);
+	struct ida ida;
 	int id;
 
+	ida_init(&ida);
+
 	id = ida_alloc_min(&ida, 256, GFP_NOWAIT);
 	IDA_BUG_ON(&ida, id != -ENOMEM);
 	id = ida_alloc_min(&ida, 1UL << 30, GFP_NOWAIT);
@@ -475,9 +477,11 @@ void ida_check_nomem(void)
  */
 void ida_check_conv_user(void)
 {
-	DEFINE_IDA(ida);
+	struct ida ida;
 	unsigned long i;
 
+	ida_init(&ida);
+
 	for (i = 0; i < 1000000; i++) {
 		int id = ida_alloc(&ida, GFP_NOWAIT);
 		if (id == -ENOMEM) {
@@ -496,11 +500,13 @@ void ida_check_conv_user(void)
 
 void ida_check_random(void)
 {
-	DEFINE_IDA(ida);
+	struct ida ida;
 	DECLARE_BITMAP(bitmap, 2048);
 	unsigned int i;
 	time_t s = time(NULL);
 
+	ida_init(&ida);
+
  repeat:
 	memset(bitmap, 0, sizeof(bitmap));
 	for (i = 0; i < 100000; i++) {
@@ -522,9 +528,11 @@ void ida_check_random(void)
 
 void ida_alloc_free_test(void)
 {
-	DEFINE_IDA(ida);
+	struct ida ida;
 	unsigned long i;
 
+	ida_init(&ida);
+
 	for (i = 0; i < 10000; i++)
 		assert(ida_alloc_max(&ida, 20000, GFP_KERNEL) == i);
 	assert(ida_alloc_range(&ida, 5, 30, GFP_KERNEL) < 0);
@@ -576,10 +584,12 @@ static void *ida_leak_fn(void *arg)
 
 void ida_thread_tests(void)
 {
-	DEFINE_IDA(ida);
+	struct ida ida;
 	pthread_t threads[20];
 	int i;
 
+	ida_init(&ida);
+
 	for (i = 0; i < ARRAY_SIZE(threads); i++)
 		if (pthread_create(&threads[i], NULL, ida_random_fn, NULL)) {
 			perror("creating ida thread");
_

Patches currently in -mm which might be from ynorov@nvidia.com are



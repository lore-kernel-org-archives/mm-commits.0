Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672244;
	b=hurHtRaJKBVVkBDxlcEtTs6EWToUG5JdGST2MAo8rKAig8+Qgc77Y8+obIpm6FZkltBH
	 FT/N+2xMvjSXPxRKo2Zu5Y8H9qDEjH9MVHK5U503KPHMmNZ2GgHHqAH0k9ItvKMI7tj9h
	 8hgI1NbBNaLZ1AlkosZlnZp0h/+sqiBpLPtUJzXMDTs2VvvTyJBpCL9nIHKDLqG0cdsIN
	 hOiDlHttTV4Xpm1bJqMv5pjBvGyJzKQ1/oR2lRCUuOoZXD1wUr7RmCY7EVk7QBmywy+v5
	 OouPYPzRjCid1kSG7xPuwgrzALQi3f3J6JSJ5+aV+Af7qhvc68SR6sZ7XU9jdqa0ORQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672244;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=s5FOKQpcLnU18zz3u7tSrcFdl3Togb8v0Jo1MAUJyAc=;
	b=cW2a6Pmhz+liV6NMs4qmif9CogkU9qGDK/3m0rmLu0eAYszk9R08++tPjsO+fOMzyK7P
	 MaL41+pvMLmkjs2O9l6/ZAdGpMF+r0uE16cqhirwEVF+uEopZFTfSntxhGT8BJZagvACO
	 zP//x14kqAonEFjIPMM1i1wW6hci960PZLDElAxDqI8Z6e4ogQmgTVncPt9yHGDFHk9Bo
	 a200JgJoNi86Q/Ib/2UerMzR+WLjZtHNIGO8gZ/7HSsOkCwe/vf51V35euukCVaBNzTB5
	 fjJYHt3dSGh9soxKR4kPB8gC9/Ns3C8Erq9EEMohdLp6XONab1iGTRdAu4XLAQ3N5MQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PegqQlVd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B016A606A327;
	Tue,  3 Nov 2026 02:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PegqQlVd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3791E1F00A18;
	Tue,  3 Nov 2026 02:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672243;
	bh=s5FOKQpcLnU18zz3u7tSrcFdl3Togb8v0Jo1MAUJyAc=;
	h=Date:To:From:Subject;
	b=PegqQlVdilFkAfA6qdf63Mp1uK4lxUaX1cq28rv7ZgyWLJopZjHUQWOhZTHcZDZ3V
	 dRiFgL16F9csaH5XqLNdUnojTsNRZ1NPIgdTtR9dil1wsu92KorDVguL1WXCGTx71u
	 sSet4J6ZQoBPn9kWbVevzyAeb8Alk5jvrFhQbHYg=
Date: Mon, 02 Nov 2026 18:17:22 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mason@kernel.org,
	ljs@kernel.org,andrewjballance@gmail.com,aliceryhl@google.com,
	liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-update-internal-warning-and-bug_on-code.patch added to mm-hotfixes-unstable branch
Message-Id: <20261103021723.3791E1F00A18@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: maple_tree: Update internal warning and bug_on code
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maple_tree-update-internal-warning-and-bug_on-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-update-internal-warning-and-bug_on-code.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Liam R. Howlett (Google)" <liam@infradead.org>
Subject: maple_tree: Update internal warning and bug_on code
Date: Mon, 02 Nov 2026 21:07:24 -0500

When CONFIG_DEBUG_MAPLE_TREE is set, call WARN_ON() once per site after
the custom information is dumped about the tree.  Without using the
kernel's WARN_ON calls, syzbot will not catch issues detected by this
code.  The BUG_ON variants now stop instead of dumping and continuing.

Update the non-debug code to call WARN_ON_ONCE() as well.

The userspace tests asserted on dump_stack() but only print on
WARN_ON(), so make WARN() fatal in maple-shared.h and have the maple
test exit with the result of maple_tree_seed().

Link: https://lore.kernel.org/20261103020724.2614498-4-liam@infradead.org
Fixes: f0a1f866aba1 ("maple_tree: add debug BUG_ON and WARN_ON variants")
Signed-off-by: Liam R. Howlett (Google) <liam@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Chris Mason <mason@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: <stable@vger.kernel.org>
---

 include/linux/maple_tree.h          |   48 +++++++++++++-------------
 tools/testing/radix-tree/maple.c    |   13 ++++---
 tools/testing/shared/maple-shared.h |   33 +++++++++++++++++
 3 files changed, 66 insertions(+), 28 deletions(-)

--- a/include/linux/maple_tree.h~maple_tree-update-internal-warning-and-bug_on-code
+++ a/include/linux/maple_tree.h
@@ -684,7 +684,7 @@ void mt_cache_shrink(void);
 		pr_info("Pass: %u Run:%u\n",				\
 			atomic_read(&maple_tree_tests_passed),		\
 			atomic_read(&maple_tree_tests_run));		\
-		dump_stack();						\
+		BUG_ON(1);						\
 	} else {							\
 		atomic_inc(&maple_tree_tests_passed);			\
 	}								\
@@ -700,7 +700,7 @@ void mt_cache_shrink(void);
 		pr_info("Pass: %u Run:%u\n",				\
 			atomic_read(&maple_tree_tests_passed),		\
 			atomic_read(&maple_tree_tests_run));		\
-		dump_stack();						\
+		BUG_ON(1);						\
 	} else {							\
 		atomic_inc(&maple_tree_tests_passed);			\
 	}								\
@@ -717,7 +717,7 @@ void mt_cache_shrink(void);
 		pr_info("Pass: %u Run:%u\n",				\
 			atomic_read(&maple_tree_tests_passed),		\
 			atomic_read(&maple_tree_tests_run));		\
-		dump_stack();						\
+		BUG_ON(1);						\
 	} else {							\
 		atomic_inc(&maple_tree_tests_passed);			\
 	}								\
@@ -726,16 +726,16 @@ void mt_cache_shrink(void);
 #define MT_WARN_ON(__tree, __x)  ({					\
 	int ret = !!(__x);						\
 	atomic_inc(&maple_tree_tests_run);				\
-	if (ret) {							\
-		pr_info("WARN at %s:%d (%u)\n",				\
-		__func__, __LINE__, __x);				\
+	if (!ret) {							\
+		atomic_inc(&maple_tree_tests_passed);			\
+	} else if (__ONCE_LITE_IF(ret)) {				\
+		pr_info("WARN at %s:%d\n",				\
+		__func__, __LINE__);					\
 		mt_dump(__tree, mt_dump_hex);				\
 		pr_info("Pass: %u Run:%u\n",				\
 			atomic_read(&maple_tree_tests_passed),		\
 			atomic_read(&maple_tree_tests_run));		\
-		dump_stack();						\
-	} else {							\
-		atomic_inc(&maple_tree_tests_passed);			\
+		WARN_ON(1);						\
 	}								\
 	unlikely(ret);							\
 })
@@ -743,17 +743,17 @@ void mt_cache_shrink(void);
 #define MAS_WARN_ON(__mas, __x) ({					\
 	int ret = !!(__x);						\
 	atomic_inc(&maple_tree_tests_run);				\
-	if (ret) {							\
-		pr_info("WARN at %s:%d (%u)\n",				\
-		__func__, __LINE__, __x);				\
+	if (!ret) {							\
+		atomic_inc(&maple_tree_tests_passed);			\
+	} else if (__ONCE_LITE_IF(ret)) {				\
+		pr_info("WARN at %s:%d\n",				\
+		__func__, __LINE__);					\
 		mas_dump(__mas);					\
 		mt_dump((__mas)->tree, mt_dump_hex);			\
 		pr_info("Pass: %u Run:%u\n",				\
 			atomic_read(&maple_tree_tests_passed),		\
 			atomic_read(&maple_tree_tests_run));		\
-		dump_stack();						\
-	} else {							\
-		atomic_inc(&maple_tree_tests_passed);			\
+		WARN_ON(1);						\
 	}								\
 	unlikely(ret);							\
 })
@@ -761,18 +761,18 @@ void mt_cache_shrink(void);
 #define MAS_WR_WARN_ON(__wrmas, __x) ({					\
 	int ret = !!(__x);						\
 	atomic_inc(&maple_tree_tests_run);				\
-	if (ret) {							\
-		pr_info("WARN at %s:%d (%u)\n",				\
-		__func__, __LINE__, __x);				\
+	if (!ret) {							\
+		atomic_inc(&maple_tree_tests_passed);			\
+	} else if (__ONCE_LITE_IF(ret)) {				\
+		pr_info("WARN at %s:%d\n",				\
+		__func__, __LINE__);					\
 		mas_wr_dump(__wrmas);					\
 		mas_dump((__wrmas)->mas);				\
 		mt_dump((__wrmas)->mas->tree, mt_dump_hex);		\
 		pr_info("Pass: %u Run:%u\n",				\
 			atomic_read(&maple_tree_tests_passed),		\
 			atomic_read(&maple_tree_tests_run));		\
-		dump_stack();						\
-	} else {							\
-		atomic_inc(&maple_tree_tests_passed);			\
+		WARN_ON(1);						\
 	}								\
 	unlikely(ret);							\
 })
@@ -780,9 +780,9 @@ void mt_cache_shrink(void);
 #define MT_BUG_ON(__tree, __x)		BUG_ON(__x)
 #define MAS_BUG_ON(__mas, __x)		BUG_ON(__x)
 #define MAS_WR_BUG_ON(__mas, __x)	BUG_ON(__x)
-#define MT_WARN_ON(__tree, __x)		WARN_ON(__x)
-#define MAS_WARN_ON(__mas, __x)		WARN_ON(__x)
-#define MAS_WR_WARN_ON(__mas, __x)	WARN_ON(__x)
+#define MT_WARN_ON(__tree, __x)		WARN_ON_ONCE(__x)
+#define MAS_WARN_ON(__mas, __x)		WARN_ON_ONCE(__x)
+#define MAS_WR_WARN_ON(__mas, __x)	WARN_ON_ONCE(__x)
 #endif /* CONFIG_DEBUG_MAPLE_TREE */
 
 /**
--- a/tools/testing/radix-tree/maple.c~maple_tree-update-internal-warning-and-bug_on-code
+++ a/tools/testing/radix-tree/maple.c
@@ -36502,22 +36502,27 @@ static void regression_tests(void)
 	test_spanning_store_regression();
 }
 
-void maple_tree_tests(void)
+int maple_tree_tests(void)
 {
+	int ret;
+
 #if !defined(BENCH)
 	regression_tests();
 	farmer_tests();
 #endif
-	maple_tree_seed();
+	ret = maple_tree_seed();
 	maple_tree_harvest();
+	return ret;
 }
 
 int __weak main(void)
 {
+	int ret;
+
 	maple_tree_init();
-	maple_tree_tests();
+	ret = maple_tree_tests();
 	rcu_barrier();
 	if (nr_allocated)
 		printf("nr_allocated = %d\n", nr_allocated);
-	return 0;
+	return ret ? EXIT_FAILURE : EXIT_SUCCESS;
 }
--- a/tools/testing/shared/maple-shared.h~maple_tree-update-internal-warning-and-bug_on-code
+++ a/tools/testing/shared/maple-shared.h
@@ -8,6 +8,7 @@
 #include "shared.h"
 #include <stdlib.h>
 #include <time.h>
+#include <assert.h>
 #include "linux/init.h"
 
 void maple_rcu_cb(struct rcu_head *head);
@@ -20,5 +21,37 @@ do {
     call_rcu(&((_p_struct)->_memb), rcu_cb);    \
 } while(0);
 
+/* Make WARN() fatal */
+#undef WARN
+#undef WARN_ON
+#undef WARN_ONCE
+#undef WARN_ON_ONCE
+#define WARN(condition, format...) ({				\
+	int __ret_warn_on = !!(condition);			\
+	if (unlikely(__ret_warn_on)) {				\
+		__WARN_printf(format);				\
+		assert(0);					\
+	}							\
+	unlikely(__ret_warn_on);				\
+})
+#define WARN_ON(condition)					\
+	WARN(condition, "assertion failed at %s:%d\n", __FILE__, __LINE__)
+#define WARN_ONCE(condition, format...)	WARN(condition, format)
+#define WARN_ON_ONCE(condition)		WARN_ON(condition)
+
+/* Once state for the debug macros */
+#ifndef __ONCE_LITE_IF
+#define __ONCE_LITE_IF(condition)				\
+	({							\
+		static bool __already_done;			\
+		bool __ret_once = false;			\
+								\
+		if ((condition) && !__already_done) {		\
+			__already_done = true;			\
+			__ret_once = true;			\
+		}						\
+		__ret_once;					\
+	})
+#endif
 
 #endif /* __MAPLE_SHARED_H__ */
_

Patches currently in -mm which might be from liam@infradead.org are

maple_tree-fix-rcu-reader-null-dereference-after-the-tree-is-emptied.patch
maple_tree-test-emptying-tree-while-rcu-reading.patch
maple_tree-update-internal-warning-and-bug_on-code.patch


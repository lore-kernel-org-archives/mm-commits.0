Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794293148;
	b=BNU/AHLhp64hq/VPLd5/T38ZsHUXr9v7Mnx8M3p8/I+RKeUpIWd4VHeWBMgkH5D+vev1
	 33XiELFgzA3jPKSDSxmnGpr/PbZ/CVvwQp+7xrU5MSrJKUekALNrVejo6kxaRfSS4Wkjm
	 2l17wy+xNgInLt1TLl8JtFY9VEzRQ535If+p5kkfRKHguMqqHlA2AGhDawIrnjS/S+h4D
	 OHbaisRU4i62jXbGkeGgZWU7eSpuA5vAIqqi9Xe0zvXqGWSu7Ku5ZJYhoEPDIjJKdSjix
	 XJoSiMDuvA/iTIbF3feiEAgA6NmlLmHxKxhlkyS9RCBsYoYrmSzGLjaC6gLo2CfoVSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794293148;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=lbOT8M8ED9u1VYLVd8o2B6HyIsQR5szHrGzNWAbqF70=;
	b=ATTB91m0IYdsOdeDvKgvlBID/A/YpqHRcOBYZns9xwIn9pR1RuHO37PpYqLdU8LGi1Py
	 QHSe0Q+dYLEcppgMcH5h/+Bs0Yw67zv8UJlOHsS84IeBtmbnVf2ZlVgQi4i/U6MCZMp/w
	 wUMDv2Ojp/dPUwOWqLcFd8YD+QdTMqGvQrbZRTYS9dEJaMdurx4I0y3jldQNqhavr6kfa
	 OyGsyLUQYQU6wJf0o5GPYUZ/+Bb1/sYOfuZaIhqaawbNufnDYWIIYZkwcGh/0T+mRPgyG
	 yA88aCqA46vcK6lwXZT3HZSIwsd4hFHiM3tw6/IMZzktHV1pyO/XKou2W094HSzRFhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=YwPmQJIq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1776B606A648;
	Tue, 10 Nov 2026 06:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=YwPmQJIq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A13D21F0089F;
	Tue, 10 Nov 2026 06:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794293147;
	bh=lbOT8M8ED9u1VYLVd8o2B6HyIsQR5szHrGzNWAbqF70=;
	h=Date:To:From:Subject;
	b=YwPmQJIq42zHgigy7gRzlSDemHp/GWVW5338oGom5YqzJ81Vgy2UtqbKJS06+/uOy
	 D1fUckJVNeEZiShEOER8+kY/LMbCJSE+LRkp9NpnWX214tlupONnjLcra982zXA2kg
	 yVSd1vnGjQGxEFPlXZ0EiFYLxCgbotKfucGK5F5M=
Date: Mon, 09 Nov 2026 22:45:47 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mason@kernel.org,
	ljs@kernel.org,andrewjballance@gmail.com,aliceryhl@google.com,
	liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maple_tree-update-internal-warning-and-bug_on-code.patch removed from -mm tree
Message-Id: <20261110064547.A13D21F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: maple_tree: update internal warning and bug_on code
has been removed from the -mm tree.  Its filename was
     maple_tree-update-internal-warning-and-bug_on-code.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett (Google)" <liam@infradead.org>
Subject: maple_tree: update internal warning and bug_on code
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
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
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



From: akpm@linux-foundation.org
Subject: +
 include-linux-nodemaskh-create-next_node_in-helper-fix-fix.patch added to
 -mm tree
Date: Wed, 30 Mar 2016 16:08:42 -0700
Message-ID: <56fc5c7a.6tPl/b/EePPF/6/j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47858 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbcC3XIn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Mar 2016 19:08:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, js1304@gmail.com, lauraa@codeaurora.org, mhocko@suse.com, n-horiguchi@ah.jp.nec.com, qiuxishi@huawei.com, rientjes@google.com, wangxq10@lzu.edu.cn, zhuhui@xiaomi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include-linux-nodemaskh-create-next_node_in-helper-fix-fix
has been added to the -mm tree.  Its filename is
     include-linux-nodemaskh-create-next_node_in-helper-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-nodemaskh-create-next_node_in-helper-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-nodemaskh-create-next_node_in-helper-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include-linux-nodemaskh-create-next_node_in-helper-fix-fix

next_node_in() is rather large.  Uninline it to saves 420 bytes for 8
callsites.

Create lib/nodemask.c for this.  Move node_random() into lib/nodemask.c.

Cc: Michal Hocko <mhocko@suse.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "Laura Abbott" <lauraa@codeaurora.org>
Cc: Hui Zhu <zhuhui@xiaomi.com>
Cc: Wang Xiaoqiang <wangxq10@lzu.edu.cn>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |    9 +--------
 lib/Makefile             |    2 +-
 lib/nodemask.c           |   30 ++++++++++++++++++++++++++++++
 mm/mempolicy.c           |   16 ----------------
 4 files changed, 32 insertions(+), 25 deletions(-)

diff -puN include/linux/nodemask.h~include-linux-nodemaskh-create-next_node_in-helper-fix-fix include/linux/nodemask.h
--- a/include/linux/nodemask.h~include-linux-nodemaskh-create-next_node_in-helper-fix-fix
+++ a/include/linux/nodemask.h
@@ -266,14 +266,7 @@ static inline int __next_node(int n, con
  * the first node in src if needed.  Returns MAX_NUMNODES if src is empty.
  */
 #define next_node_in(n, src) __next_node_in((n), &(src))
-static inline int __next_node_in(int node, const nodemask_t *srcp)
-{
-	int ret = __next_node(node, srcp);
-
-	if (ret == MAX_NUMNODES)
-		ret = __first_node(srcp);
-	return ret;
-}
+int __next_node_in(int node, const nodemask_t *srcp);
 
 static inline void init_nodemask_of_node(nodemask_t *mask, int node)
 {
diff -puN lib/Makefile~include-linux-nodemaskh-create-next_node_in-helper-fix-fix lib/Makefile
--- a/lib/Makefile~include-linux-nodemaskh-create-next_node_in-helper-fix-fix
+++ a/lib/Makefile
@@ -25,7 +25,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
 	 sha1.o md5.o irq_regs.o argv_split.o \
 	 proportions.o flex_proportions.o ratelimit.o show_mem.o \
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
-	 earlycpio.o seq_buf.o nmi_backtrace.o
+	 earlycpio.o seq_buf.o nmi_backtrace.o nodemask.o
 
 obj-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
 lib-$(CONFIG_MMU) += ioremap.o
diff -puN /dev/null lib/nodemask.c
--- /dev/null
+++ a/lib/nodemask.c
@@ -0,0 +1,30 @@
+#include <linux/nodemask.h>
+#include <linux/module.h>
+#include <linux/random.h>
+
+int __next_node_in(int node, const nodemask_t *srcp)
+{
+	int ret = __next_node(node, srcp);
+
+	if (ret == MAX_NUMNODES)
+		ret = __first_node(srcp);
+	return ret;
+}
+EXPORT_SYMBOL(__next_node_in);
+
+#ifdef CONFIG_NUMA
+/*
+ * Return the bit number of a random bit set in the nodemask.
+ * (returns NUMA_NO_NODE if nodemask is empty)
+ */
+int node_random(const nodemask_t *maskp)
+{
+	int w, bit = NUMA_NO_NODE;
+
+	w = nodes_weight(*maskp);
+	if (w)
+		bit = bitmap_ord_to_pos(maskp->bits,
+			get_random_int() % w, MAX_NUMNODES);
+	return bit;
+}
+#endif
diff -puN mm/mempolicy.c~include-linux-nodemaskh-create-next_node_in-helper-fix-fix mm/mempolicy.c
--- a/mm/mempolicy.c~include-linux-nodemaskh-create-next_node_in-helper-fix-fix
+++ a/mm/mempolicy.c
@@ -97,7 +97,6 @@
 
 #include <asm/tlbflush.h>
 #include <asm/uaccess.h>
-#include <linux/random.h>
 
 #include "internal.h"
 
@@ -1801,21 +1800,6 @@ static inline unsigned interleave_nid(st
 		return interleave_nodes(pol);
 }
 
-/*
- * Return the bit number of a random bit set in the nodemask.
- * (returns NUMA_NO_NODE if nodemask is empty)
- */
-int node_random(const nodemask_t *maskp)
-{
-	int w, bit = NUMA_NO_NODE;
-
-	w = nodes_weight(*maskp);
-	if (w)
-		bit = bitmap_ord_to_pos(maskp->bits,
-			get_random_int() % w, MAX_NUMNODES);
-	return bit;
-}
-
 #ifdef CONFIG_HUGETLBFS
 /*
  * huge_zonelist(@vma, @addr, @gfp_flags, @mpol)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
include-linux-nodemaskh-create-next_node_in-helper.patch
include-linux-nodemaskh-create-next_node_in-helper-fix-fix.patch
mm-hugetlbc-use-first_memory_node.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch


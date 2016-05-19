From: akpm@linux-foundation.org
Subject: [folded-merged]
 include-linux-nodemaskh-create-next_node_in-helper-fix-fix.patch removed
 from -mm tree
Date: Thu, 19 May 2016 16:44:53 -0700
Message-ID: <573e4ff5.IqyutQ+fc6e5xVMD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44881 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737AbcESXoy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 19:44:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, js1304@gmail.com, lauraa@codeaurora.org, mhocko@suse.com, n-horiguchi@ah.jp.nec.com, qiuxishi@huawei.com, rientjes@google.com, wangxq10@lzu.edu.cn, zhuhui@xiaomi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include-linux-nodemaskh-create-next_node_in-helper-fix-fix
has been removed from the -mm tree.  Its filename was
     include-linux-nodemaskh-create-next_node_in-helper-fix-fix.patch

This patch was dropped because it was folded into include-linux-nodemaskh-create-next_node_in-helper.patch

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
Cc: Laura Abbott <lauraa@codeaurora.org>
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
 	 flex_proportions.o ratelimit.o show_mem.o \
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

From: akpm@linux-foundation.org
Subject: [patch 082/101] make __section_nr() more efficient
Date: Thu, 28 Jul 2016 15:48:35 -0700
Message-ID: <579a8bc3.tqnAqzzTRuRpEMZV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57197 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbcG1Wsg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:48:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, zhouchengming1@huawei.com, dave.hansen@intel.com, guohanjun@huawei.com, huawei.libin@huawei.com, tj@kernel.org

From: Zhou Chengming <zhouchengming1@huawei.com>
Subject: make __section_nr() more efficient

When CONFIG_SPARSEMEM_EXTREME is disabled, __section_nr can get
the section number with a subtraction directly.

Link: http://lkml.kernel.org/r/1468988310-11560-1-git-send-email-zhouchengming1@huawei.com
Signed-off-by: Zhou Chengming <zhouchengming1@huawei.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Li Bin <huawei.libin@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN mm/sparse.c~make-__section_nr-more-efficient mm/sparse.c
--- a/mm/sparse.c~make-__section_nr-more-efficient
+++ a/mm/sparse.c
@@ -100,11 +100,7 @@ static inline int sparse_index_init(unsi
 }
 #endif
 
-/*
- * Although written for the SPARSEMEM_EXTREME case, this happens
- * to also work for the flat array case because
- * NR_SECTION_ROOTS==NR_MEM_SECTIONS.
- */
+#ifdef CONFIG_SPARSEMEM_EXTREME
 int __section_nr(struct mem_section* ms)
 {
 	unsigned long root_nr;
@@ -123,6 +119,12 @@ int __section_nr(struct mem_section* ms)
 
 	return (root_nr * SECTIONS_PER_ROOT) + (ms - root);
 }
+#else
+int __section_nr(struct mem_section* ms)
+{
+	return (int)(ms - mem_section[0]);
+}
+#endif
 
 /*
  * During early boot, before section_mem_map is used for an actual
_

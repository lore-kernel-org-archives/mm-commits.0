From: akpm@linux-foundation.org
Subject: - fix-build-failure-when-config_infiniband_ipoib_cm-is-not-defined.patch removed from -mm tree
Date: Mon, 17 Dec 2007 15:39:10 -0800
Message-ID: <200712172339.lBHNdA87008104@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41235 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758163AbXLQXjn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Dec 2007 18:39:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tony@bakeyournoodle.com, mel@csn.ul.ie, rolandd@cisco.com, mm-commits@vger.kernel.org


The patch titled
     Fix build failure when CONFIG_INFINIBAND_IPOIB_CM is not defined
has been removed from the -mm tree.  Its filename was
     fix-build-failure-when-config_infiniband_ipoib_cm-is-not-defined.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix build failure when CONFIG_INFINIBAND_IPOIB_CM is not defined
From: tony@bakeyournoodle.com (Tony Breeds)

Fixes:
  CC [M]  drivers/infiniband/ulp/ipoib/ipoib_main.o
drivers/infiniband/ulp/ipoib/ipoib_main.c: In function `ipoib_init_module':
drivers/infiniband/ulp/ipoib/ipoib_main.c:1269: error: invalid lvalue in assignment

In the case where CONFIG_INFINIBAND_IPOIB_CM is not defined ipoib_max_conn_qp is #defined to 0.

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/ulp/ipoib/ipoib_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/infiniband/ulp/ipoib/ipoib_main.c~fix-build-failure-when-config_infiniband_ipoib_cm-is-not-defined drivers/infiniband/ulp/ipoib/ipoib_main.c
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c~fix-build-failure-when-config_infiniband_ipoib_cm-is-not-defined
+++ a/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1268,8 +1268,9 @@ static int __init ipoib_init_module(void
 	ipoib_sendq_size = roundup_pow_of_two(ipoib_sendq_size);
 	ipoib_sendq_size = min(ipoib_sendq_size, IPOIB_MAX_QUEUE_SIZE);
 	ipoib_sendq_size = max(ipoib_sendq_size, IPOIB_MIN_QUEUE_SIZE);
-
+#ifdef CONFIG_INFINIBAND_IPOIB_CM
 	ipoib_max_conn_qp = min(ipoib_max_conn_qp, IPOIB_CM_MAX_CONN_QP);
+#endif
 
 	ret = ipoib_register_debugfs();
 	if (ret)
_

Patches currently in -mm which might be from tony@bakeyournoodle.com are

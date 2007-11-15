From: akpm@linux-foundation.org
Subject: + fix-build-failure-when-config_infiniband_ipoib_cm-is-not-defined.patch added to -mm tree
Date: Thu, 15 Nov 2007 15:55:49 -0800
Message-ID: <200711152355.lAFNtntA022430@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50501 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752896AbXKOX4G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 18:56:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tony@bakeyournoodle.com, mel@csn.ul.ie, rolandd@cisco.com


The patch titled
     Fix build failure when CONFIG_INFINIBAND_IPOIB_CM is not defined
has been added to the -mm tree.  Its filename is
     fix-build-failure-when-config_infiniband_ipoib_cm-is-not-defined.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1265,8 +1265,9 @@ static int __init ipoib_init_module(void
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

origin.patch
fix-build-failure-when-config_infiniband_ipoib_cm-is-not-defined.patch

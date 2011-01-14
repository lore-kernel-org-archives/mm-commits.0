From: akpm@linux-foundation.org
Subject: [merged] mm-set-correct-numa_zonelist_order-string-when-configured-on-the-kernel-command-line.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:46:08 -0800
Message-ID: <201101142248.p0EMmwAl005248@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752525Ab1ANWtB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:49:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: volodymyrgl@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm: set correct numa_zonelist_order string when configured on the kernel command line
has been removed from the -mm tree.  Its filename was
     mm-set-correct-numa_zonelist_order-string-when-configured-on-the-kernel-command-line.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: set correct numa_zonelist_order string when configured on the kernel command line
From: "Volodymyr G. Lukiianyk" <volodymyrgl@gmail.com>

When numa_zonelist_order parameter is set to "node" or "zone" on the
command line it's still showing as "default" in sysctl.  That's because
early_param parsing function changes only user_zonelist_order variable. 
Fix this by copying user-provided string to numa_zonelist_order if it was
successfully parsed.

Signed-off-by: Volodymyr G Lukiianyk <volodymyrgl@gmail.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-set-correct-numa_zonelist_order-string-when-configured-on-the-kernel-command-line mm/page_alloc.c
--- a/mm/page_alloc.c~mm-set-correct-numa_zonelist_order-string-when-configured-on-the-kernel-command-line
+++ a/mm/page_alloc.c
@@ -2631,9 +2631,16 @@ static int __parse_numa_zonelist_order(c
 
 static __init int setup_numa_zonelist_order(char *s)
 {
-	if (s)
-		return __parse_numa_zonelist_order(s);
-	return 0;
+	int ret;
+
+	if (!s)
+		return 0;
+
+	ret = __parse_numa_zonelist_order(s);
+	if (ret == 0)
+		strlcpy(numa_zonelist_order, s, NUMA_ZONELIST_ORDER_LEN);
+
+	return ret;
 }
 early_param("numa_zonelist_order", setup_numa_zonelist_order);
 
_

Patches currently in -mm which might be from volodymyrgl@gmail.com are

origin.patch


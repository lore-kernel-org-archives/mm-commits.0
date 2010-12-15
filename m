From: akpm@linux-foundation.org
Subject: + mm-set-correct-numa_zonelist_order-string-when-configured-on-the-kernel-command-line.patch added to -mm tree
Date: Wed, 15 Dec 2010 14:20:07 -0800
Message-ID: <201012152220.oBFMK7op009018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751969Ab0LOWU6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Dec 2010 17:20:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: volodymyrgl@gmail.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     mm: set correct numa_zonelist_order string when configured on the kernel command line
has been added to the -mm tree.  Its filename is
     mm-set-correct-numa_zonelist_order-string-when-configured-on-the-kernel-command-line.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-set-correct-numa_zonelist_order-string-when-configured-on-the-kernel-command-line mm/page_alloc.c
--- a/mm/page_alloc.c~mm-set-correct-numa_zonelist_order-string-when-configured-on-the-kernel-command-line
+++ a/mm/page_alloc.c
@@ -2628,9 +2628,16 @@ static int __parse_numa_zonelist_order(c
 
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

mm-set-correct-numa_zonelist_order-string-when-configured-on-the-kernel-command-line.patch


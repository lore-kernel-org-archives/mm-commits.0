From: akpm@linux-foundation.org
Subject: [merged]
 mm-zswap-deletion-of-an-unnecessary-check-before-the-function-call-free_percpu.patch removed from -mm tree
Date: Sat, 13 Dec 2014 20:09:07 -0800
Message-ID: <548d0d63./nJhXaQZVOeRbJPh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47798 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbaLNEI7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:08:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elfring@users.sourceforge.net, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zswap: delete unnecessary check before calling free_percpu()
has been removed from the -mm tree.  Its filename was
     mm-zswap-deletion-of-an-unnecessary-check-before-the-function-call-free_percpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Markus Elfring <elfring@users.sourceforge.net>
Subject: mm/zswap: delete unnecessary check before calling free_percpu()

free_percpu() tests whether its argument is NULL and then returns
immediately.  Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Cc: Seth Jennings <sjennings@variantweb.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/zswap.c~mm-zswap-deletion-of-an-unnecessary-check-before-the-function-call-free_percpu mm/zswap.c
--- a/mm/zswap.c~mm-zswap-deletion-of-an-unnecessary-check-before-the-function-call-free_percpu
+++ a/mm/zswap.c
@@ -152,8 +152,7 @@ static int __init zswap_comp_init(void)
 static void __init zswap_comp_exit(void)
 {
 	/* free percpu transforms */
-	if (zswap_comp_pcpu_tfms)
-		free_percpu(zswap_comp_pcpu_tfms);
+	free_percpu(zswap_comp_pcpu_tfms);
 }
 
 /*********************************
_

Patches currently in -mm which might be from elfring@users.sourceforge.net are

origin.patch
linux-next.patch


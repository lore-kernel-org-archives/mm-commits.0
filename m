From: akpm@linux-foundation.org
Subject: [merged]
 arch-x86-mm-kmemcheck-kmemcheckc-use-kstrtoint-instead-of-sscanf.patch
 removed from -mm tree
Date: Wed, 09 Apr 2014 10:55:35 -0700
Message-ID: <53458997.Akq2Ka8LPe7voarP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36943 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933291AbaDIRzg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Apr 2014 13:55:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vegardno@ifi.uio.no, penberg@kernel.org, rientjes@google.com

Subject: [merged] arch-x86-mm-kmemcheck-kmemcheckc-use-kstrtoint-instead-of-sscanf.patch removed from -mm tree
To: rientjes@google.com,penberg@kernel.org,vegardno@ifi.uio.no,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 09 Apr 2014 10:55:35 -0700


The patch titled
     Subject: arch/x86/mm/kmemcheck/kmemcheck.c: use kstrtoint() instead of sscanf()
has been removed from the -mm tree.  Its filename was
     arch-x86-mm-kmemcheck-kmemcheckc-use-kstrtoint-instead-of-sscanf.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: arch/x86/mm/kmemcheck/kmemcheck.c: use kstrtoint() instead of sscanf()

Kmemcheck should use the preferred interface for parsing command line
arguments, kstrto*(), rather than sscanf() itself.  Use it appropriately.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Vegard Nossum <vegardno@ifi.uio.no>
Acked-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/kmemcheck/kmemcheck.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN arch/x86/mm/kmemcheck/kmemcheck.c~arch-x86-mm-kmemcheck-kmemcheckc-use-kstrtoint-instead-of-sscanf arch/x86/mm/kmemcheck/kmemcheck.c
--- a/arch/x86/mm/kmemcheck/kmemcheck.c~arch-x86-mm-kmemcheck-kmemcheckc-use-kstrtoint-instead-of-sscanf
+++ a/arch/x86/mm/kmemcheck/kmemcheck.c
@@ -78,10 +78,16 @@ early_initcall(kmemcheck_init);
  */
 static int __init param_kmemcheck(char *str)
 {
+	int val;
+	int ret;
+
 	if (!str)
 		return -EINVAL;
 
-	sscanf(str, "%d", &kmemcheck_enabled);
+	ret = kstrtoint(str, 0, &val);
+	if (ret)
+		return ret;
+	kmemcheck_enabled = val;
 	return 0;
 }
 
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
mm-slab-slub-use-page-list-consistently-instead-of-page-lru.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch


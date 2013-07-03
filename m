From: akpm@linux-foundation.org
Subject: [folded-merged] aoe-perform-i-o-completions-in-parallel-v2.patch
 removed from -mm tree
Date: Wed, 03 Jul 2013 14:43:25 -0700
Message-ID: <51d49afd.J5aoFb07nV9Aw+IS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40292 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab3GCVn0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jul 2013 17:43:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ecashin@coraid.com

Subject: [folded-merged] aoe-perform-i-o-completions-in-parallel-v2.patch removed from -mm tree
To: ecashin@coraid.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 03 Jul 2013 14:43:25 -0700


The patch titled
     Subject: aoe-perform-i-o-completions-in-parallel-v2
has been removed from the -mm tree.  Its filename was
     aoe-perform-i-o-completions-in-parallel-v2.patch

This patch was dropped because it was folded into aoe-perform-i-o-completions-in-parallel.patch

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe-perform-i-o-completions-in-parallel-v2

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoecmd.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN drivers/block/aoe/aoecmd.c~aoe-perform-i-o-completions-in-parallel-v2 drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-perform-i-o-completions-in-parallel-v2
+++ a/drivers/block/aoe/aoecmd.c
@@ -35,9 +35,12 @@ module_param(aoe_maxout, int, 0644);
 MODULE_PARM_DESC(aoe_maxout,
 	"Only aoe_maxout outstanding packets for every MAC on eX.Y.");
 
-/* The number of online cpus in the system,
- * this dictates the number of ktio threads
- * which will be spawned.
+/* The number of online cpus during module initialization gives us a
+ * convenient heuristic cap on the parallelism used for ktio threads
+ * doing I/O completion.  It is not important that the cap equal the
+ * actual number of running CPUs at any given time, but because of CPU
+ * hotplug, we take care to use ncpus instead of using
+ * num_online_cpus() after module initialization.
  */
 static int ncpus;
 
@@ -1792,10 +1795,6 @@ aoecmd_init(void)
 		return -ENOMEM;
 	empty_page = virt_to_page(p);
 

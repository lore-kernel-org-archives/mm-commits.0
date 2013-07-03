From: akpm@linux-foundation.org
Subject: + aoe-perform-i-o-completions-in-parallel-v2.patch added to -mm
 tree
Date: Tue, 02 Jul 2013 19:55:02 -0700
Message-ID: <51d39286.o7yYwkGGlpHHo3FM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33029 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab3GCCzE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jul 2013 22:55:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ecashin@coraid.com

Subject: + aoe-perform-i-o-completions-in-parallel-v2.patch added to -mm tree
To: ecashin@coraid.com
From: akpm@linux-foundation.org
Date: Tue, 02 Jul 2013 19:54:59 -0700


The patch titled
     Subject: aoe-perform-i-o-completions-in-parallel-v2
has been added to the -mm tree.  Its filename is
     aoe-perform-i-o-completions-in-parallel-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 

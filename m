From: akpm@linux-foundation.org
Subject: [merged] printk_once-use-bool-for-boolean-flag.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:52:48 -0700
Message-ID: <200909231952.n8NJqmXr029870@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56192 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751782AbZIWTxk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:53:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdreier@cisco.com, rolandd@cisco.com, mm-commits@vger.kernel.org


The patch titled
     printk_once(): use bool for boolean flag
has been removed from the -mm tree.  Its filename was
     printk_once-use-bool-for-boolean-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: printk_once(): use bool for boolean flag
From: Roland Dreier <rdreier@cisco.com>

Using the type bool (instead of int) for the __print_once flag in the
printk_once() macro matches the intent of the code better, and allows the
compiler to generate smaller code; eg a typical callsite with gcc 4.3.3 on
i386:

add/remove: 0/0 grow/shrink: 0/2 up/down: 0/-6 (-6)
function                                     old     new   delta
static.__print_once                            4       1      -3
get_cpu_vendor                               146     143      -3

Saving 6 bytes of object size per callsite by slightly improving the
readability of the source seems like a win to me.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/kernel.h~printk_once-use-bool-for-boolean-flag include/linux/kernel.h
--- a/include/linux/kernel.h~printk_once-use-bool-for-boolean-flag
+++ a/include/linux/kernel.h
@@ -252,10 +252,10 @@ extern int printk_delay_msec;
  * Print a one-time message (analogous to WARN_ONCE() et al):
  */
 #define printk_once(x...) ({			\
-	static int __print_once = 1;		\
+	static bool __print_once = true;	\
 						\
 	if (__print_once) {			\
-		__print_once = 0;		\
+		__print_once = false;		\
 		printk(x);			\
 	}					\
 })
_

Patches currently in -mm which might be from rdreier@cisco.com are

origin.patch
linux-next.patch
ecryptfs-another-lockdep-issue.patch


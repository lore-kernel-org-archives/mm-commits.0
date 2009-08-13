From: akpm@linux-foundation.org
Subject: + printk_once-use-bool-for-boolean-flag.patch added to -mm tree
Date: Thu, 13 Aug 2009 14:21:54 -0700
Message-ID: <200908132121.n7DLLsCe030440@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53231 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751192AbZHMVWp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Aug 2009 17:22:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdreier@cisco.com, rolandd@cisco.com


The patch titled
     printk_once(): use bool for boolean flag
has been added to the -mm tree.  Its filename is
     printk_once-use-bool-for-boolean-flag.patch

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
@@ -342,10 +342,10 @@ extern bool printk_timed_ratelimit(unsig
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
printk_once-use-bool-for-boolean-flag.patch


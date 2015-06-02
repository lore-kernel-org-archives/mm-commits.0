From: akpm@linux-foundation.org
Subject: + zswap-runtime-enable-disable.patch added to -mm tree
Date: Tue, 02 Jun 2015 15:53:54 -0700
Message-ID: <556e3402.DUeqRoc+1J6l2T0Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46871 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbbFBWxz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jun 2015 18:53:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: zswap: runtime enable/disable
has been added to the -mm tree.  Its filename is
     zswap-runtime-enable-disable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zswap-runtime-enable-disable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zswap-runtime-enable-disable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Streetman <ddstreet@ieee.org>
Subject: zswap: runtime enable/disable

Change the "enabled" parameter to be configurable at runtime.  Remove the
enabled check from init(), and move it to the frontswap store() function;
when enabled, pages will be stored, and when disabled, pages won't be
stored.

This is almost identical to Seth's patch from 2 years ago:
http://lkml.iu.edu/hypermail/linux/kernel/1307.2/04289.html

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Suggested-by: Seth Jennings <sjennings@variantweb.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/zswap.txt |   18 ++++++++++++++++--
 mm/zswap.c                 |   12 +++++-------
 2 files changed, 21 insertions(+), 9 deletions(-)

diff -puN Documentation/vm/zswap.txt~zswap-runtime-enable-disable Documentation/vm/zswap.txt
--- a/Documentation/vm/zswap.txt~zswap-runtime-enable-disable
+++ a/Documentation/vm/zswap.txt
@@ -26,8 +26,22 @@ Zswap evicts pages from compressed cache
 device when the compressed pool reaches its size limit.  This requirement had
 been identified in prior community discussions.
 
-To enabled zswap, the "enabled" attribute must be set to 1 at boot time.  e.g.
-zswap.enabled=1
+Zswap is disabled by default but can be enabled at boot time by setting
+the "enabled" attribute to 1 at boot time. e.g. zswap.enabled=1. Zswap
+can also be enabled and disabled at runtime using the sysfs interface.
+An exmaple command to enable zswap at runtime, assuming sysfs is mounted
+at /sys, is:
+
+echo 1 > /sys/modules/zswap/parameters/enabled
+
+When zswap is disabled at runtime, it will stop storing pages that are
+being swapped out. However, it will _not_ immediately write out or
+fault back into memory all of the pages stored in the compressed pool.
+The pages stored in zswap will continue to remain in the compressed pool
+until they are either invalidated or faulted back into memory. In order
+to force all pages out of the compressed pool, a swapoff on the swap
+device(s) will fault all swapped out pages, included those in the
+compressed pool, back into memory.
 
 Design:
 
diff -puN mm/zswap.c~zswap-runtime-enable-disable mm/zswap.c
--- a/mm/zswap.c~zswap-runtime-enable-disable
+++ a/mm/zswap.c
@@ -75,9 +75,10 @@ static u64 zswap_duplicate_entry;
 /*********************************
 * tunables
 **********************************/
-/* Enable/disable zswap (disabled by default, fixed at boot for now) */
-static bool zswap_enabled __read_mostly;
-module_param_named(enabled, zswap_enabled, bool, 0444);
+
+/* Enable/disable zswap (disabled by default) */
+static bool zswap_enabled;
+module_param_named(enabled, zswap_enabled, bool, 0644);
 
 /* Compressor to be used by zswap (fixed at boot for now) */
 #define ZSWAP_COMPRESSOR_DEFAULT "lzo"
@@ -648,7 +649,7 @@ static int zswap_frontswap_store(unsigne
 	u8 *src, *dst;
 	struct zswap_header *zhdr;
 
-	if (!tree) {
+	if (!zswap_enabled || !tree) {
 		ret = -ENODEV;
 		goto reject;
 	}
@@ -901,9 +902,6 @@ static int __init init_zswap(void)
 {
 	gfp_t gfp = __GFP_NORETRY | __GFP_NOWARN;
 
-	if (!zswap_enabled)
-		return 0;

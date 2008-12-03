From: akpm@linux-foundation.org
Subject: + generic-swap-ath9k-rename-swap-to-swap_array.patch added to -mm tree
Date: Wed, 03 Dec 2008 00:19:04 -0800
Message-ID: <200812030819.mB38J4XA010203@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56611 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751509AbYLCITZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 03:19:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, Sujith.Manoharan@atheros.com, jouni.malinen@atheros.com, linville@tuxdriver.com, lrodriguez@atheros.com, senthilkumar@atheros.com, vasanth@atheros.com


The patch titled
     generic swap(): ath9k: rename swap() to swap_array()
has been added to the -mm tree.  Its filename is
     generic-swap-ath9k-rename-swap-to-swap_array.patch

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
Subject: generic swap(): ath9k: rename swap() to swap_array()
From: Wu Fengguang <fengguang.wu@intel.com>

In preparation for the introduction of a generic swap() macro.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Sujith Manoharan <Sujith.Manoharan@atheros.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Luis R. Rodriguez <lrodriguez@atheros.com>
Cc: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: Senthil Balasubramanian <senthilkumar@atheros.com>
Cc: Jouni Malinen <jouni.malinen@atheros.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ath9k/regd.c |    2 +-
 drivers/net/wireless/ath9k/regd.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/wireless/ath9k/regd.c~generic-swap-ath9k-rename-swap-to-swap_array drivers/net/wireless/ath9k/regd.c
--- a/drivers/net/wireless/ath9k/regd.c~generic-swap-ath9k-rename-swap-to-swap_array
+++ a/drivers/net/wireless/ath9k/regd.c
@@ -42,7 +42,7 @@ ath9k_regd_sort(void *a, u32 n, u32 size
 			u8 *u = t - size;
 			if (cmp(u, t) <= 0)
 				break;
-			swap(u, t, size);
+			swap_array(u, t, size);
 		}
 }
 
diff -puN drivers/net/wireless/ath9k/regd.h~generic-swap-ath9k-rename-swap-to-swap_array drivers/net/wireless/ath9k/regd.h
--- a/drivers/net/wireless/ath9k/regd.h~generic-swap-ath9k-rename-swap-to-swap_array
+++ a/drivers/net/wireless/ath9k/regd.h
@@ -125,7 +125,7 @@
 
 #define CHAN_FLAGS      (CHANNEL_ALL|CHANNEL_HALF|CHANNEL_QUARTER)
 
-#define swap(_a, _b, _size) {                   \
+#define swap_array(_a, _b, _size) {                   \
 	u8 *s = _b;                       \
 	int i = _size;                          \
 	do {                                    \
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
9p-convert-d_iname-references-to-d_namename.patch
nfs-remove-redundant-tests-on-reading-new-pages.patch
generic-swap-ath9k-rename-swap-to-swap_array.patch
generic-swap-sparc-rename-swap-to-swap_ulong.patch
generic-swap-iphase-rename-swap-to-swap_byte_order.patch
generic-swap-lib-sortc-rename-swap-to-swap_func.patch
generic-swap-introduce-global-macro-swapa-b.patch
generic-swap-ext3-remove-local-swap-macro.patch
generic-swap-ext4-remove-local-swap-macro.patch
generic-swap-sched-remove-local-swap-macro.patch
generic-swap-dcache-use-swap-instead-of-private-do_switch.patch


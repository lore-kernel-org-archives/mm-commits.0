From: akpm@linux-foundation.org
Subject: + drivers-staging-wlan-ng-p80211wextc-use-array_size.patch added to -mm tree
Date: Wed, 12 Nov 2008 15:37:08 -0800
Message-ID: <200811122337.mACNb8gP027265@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40157 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756890AbYKLXha (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 18:37:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, greg@kroah.com


The patch titled
     drivers/staging/wlan-ng/p80211wext.c: use ARRAY_SIZE
has been added to the -mm tree.  Its filename is
     drivers-staging-wlan-ng-p80211wextc-use-array_size.patch

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
Subject: drivers/staging/wlan-ng/p80211wext.c: use ARRAY_SIZE
From: Julia Lawall <julia@diku.dk>

ARRAY_SIZE is more concise to use when the size of an array is divided by
the size of its type or the size of its first element.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@i@
@@

#include <linux/kernel.h>

@depends on i using "paren.iso"@
type T;
T[] E;
@@

- (sizeof(E)/sizeof(E[...]))
+ ARRAY_SIZE(E)

@depends on i using "paren.iso"@
type T;
T[] E;
@@

- (sizeof(E)/sizeof(T))
+ ARRAY_SIZE(E)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/wlan-ng/p80211wext.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/staging/wlan-ng/p80211wext.c~drivers-staging-wlan-ng-p80211wextc-use-array_size drivers/staging/wlan-ng/p80211wext.c
--- a/drivers/staging/wlan-ng/p80211wext.c~drivers-staging-wlan-ng-p80211wextc-use-array_size
+++ a/drivers/staging/wlan-ng/p80211wext.c
@@ -128,7 +128,7 @@ static const long p80211wext_channel_fre
 	2412, 2417, 2422, 2427, 2432, 2437, 2442,
 	2447, 2452, 2457, 2462, 2467, 2472, 2484
 };
-#define NUM_CHANNELS (sizeof(p80211wext_channel_freq) / sizeof(p80211wext_channel_freq[0]))
+#define NUM_CHANNELS ARRAY_SIZE(p80211wext_channel_freq)
 
 /* steal a spare bit to store the shared/opensystems state. should default to open if not set */
 #define HOSTWEP_SHAREDKEY BIT3
@@ -1852,7 +1852,7 @@ static iw_handler p80211wext_handlers[] 
 };
 
 struct iw_handler_def p80211wext_handler_def = {
-	.num_standard = sizeof(p80211wext_handlers) / sizeof(iw_handler),
+	.num_standard = ARRAY_SIZE(p80211wext_handlers),
 	.num_private = 0,
 	.num_private_args = 0,
         .standard = p80211wext_handlers,
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-media-use-array_size.patch
drivers-mtd-maps-nettelc-use-array_size.patch
drivers-isdn-misdn-use-array_size.patch
drivers-message-fusion-use-array_size.patch
drivers-staging-wlan-ng-p80211wextc-use-array_size.patch
fs-namespacec-drop-code-after-return.patch
drivers-net-wireless-ath9k-rcc-use-array_size.patch
crypto-md4c-use-array_size.patch


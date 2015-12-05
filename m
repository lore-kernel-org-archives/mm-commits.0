From: akpm@linux-foundation.org
Subject: + mac80211-prevent-build-failure-with-config_ubsan=y.patch added
 to -mm tree
Date: Fri, 04 Dec 2015 16:40:31 -0800
Message-ID: <5662327f.d3uLL6JLseqS3ttv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48783 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235AbbLEAkc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Dec 2015 19:40:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, davem@davemloft.net, johannes@sipsolutions.net, mm-commits@vger.kernel.org


The patch titled
     Subject: net/mac80211/debugfs.c: prevent build failure with CONFIG_UBSAN=y
has been added to the -mm tree.  Its filename is
     mac80211-prevent-build-failure-with-config_ubsan=y.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mac80211-prevent-build-failure-with-config_ubsan%3Dy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mac80211-prevent-build-failure-with-config_ubsan%3Dy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: net/mac80211/debugfs.c: prevent build failure with CONFIG_UBSAN=y

With upcoming CONFIG_UBSAN the following BUILD_BUG_ON in
net/mac80211/debugfs.c starts to trigger:
	BUILD_BUG_ON(hw_flag_names[NUM_IEEE80211_HW_FLAGS] != (void *)0x1);

It seems, that compiler instrumentation causes some code deoptimizations.
Because of that GCC is not being able to resolve condition in BUILD_BUG_ON()
at compile time.

We could make size of hw_flag_names array unspecified and replace the
condition in BUILD_BUG_ON() with following:
	ARRAY_SIZE(hw_flag_names) != NUM_IEEE80211_HW_FLAGS

That will have the same effect as before (adding new flag without updating
array will trigger build failure) except it doesn't fail with CONFIG_UBSAN.
As a bonus this patch slightly decreases size of hw_flag_names array.

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/debugfs.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN net/mac80211/debugfs.c~mac80211-prevent-build-failure-with-config_ubsan=y net/mac80211/debugfs.c
--- a/net/mac80211/debugfs.c~mac80211-prevent-build-failure-with-config_ubsan=y
+++ a/net/mac80211/debugfs.c
@@ -91,7 +91,7 @@ static const struct file_operations rese
 };
 #endif
 
-static const char *hw_flag_names[NUM_IEEE80211_HW_FLAGS + 1] = {
+static const char *hw_flag_names[] = {
 #define FLAG(F)	[IEEE80211_HW_##F] = #F
 	FLAG(HAS_RATE_CONTROL),
 	FLAG(RX_INCLUDES_FCS),
@@ -125,9 +125,6 @@ static const char *hw_flag_names[NUM_IEE
 	FLAG(TDLS_WIDER_BW),
 	FLAG(SUPPORTS_AMSDU_IN_AMPDU),
 	FLAG(BEACON_TX_STATUS),

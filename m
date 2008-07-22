From: akpm@linux-foundation.org
Subject: + mac80211-tx-use-dev_kfree_skb_any-for-beacon_get.patch added to -mm tree
Date: Tue, 22 Jul 2008 01:28:52 -0700
Message-ID: <200807220828.m6M8SqDc018648@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58221 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751669AbYGVIa1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 04:30:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, flamingice@sourmilk.net, johannes@sipsolutions.net, linville@tuxdriver.com


The patch titled
     mac80211: tx, use dev_kfree_skb_any for beacon_get
has been added to the -mm tree.  Its filename is
     mac80211-tx-use-dev_kfree_skb_any-for-beacon_get.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mac80211: tx, use dev_kfree_skb_any for beacon_get
From: Jiri Slaby <jirislaby@gmail.com>

Use dev_kfree_skb_any(); instead of dev_kfree_skb();, since
ieee80211_beacon_get function might be called from atomic.  (It's in a
fail path.)

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Wu <flamingice@sourmilk.net>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/mac80211/tx.c~mac80211-tx-use-dev_kfree_skb_any-for-beacon_get net/mac80211/tx.c
--- a/net/mac80211/tx.c~mac80211-tx-use-dev_kfree_skb_any-for-beacon_get
+++ a/net/mac80211/tx.c
@@ -1931,7 +1931,7 @@ struct sk_buff *ieee80211_beacon_get(str
 			       "no rate found\n",
 			       wiphy_name(local->hw.wiphy));
 		}
-		dev_kfree_skb(skb);
+		dev_kfree_skb_any(skb);
 		skb = NULL;
 		goto out;
 	}
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
linux-next.patch
ath5k-fix-memory-corruption.patch
ath5k-kill-tasklets-on-shutdown.patch
ath5k-flush-work.patch
ath5k-fix-dma-operation.patch
ath5k-suspend-resume-fixes.patch
mac80211-tx-use-dev_kfree_skb_any-for-beacon_get.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
serial-z85c30-avoid-a-hang-at-console-switch-over.patch
serial-dz11-avoid-a-hang-at-console-switch-over.patch
vt-hold-console_sem-across-sysfs-operations.patch
ip2-push-bkl-down-for-the-firmware-interface.patch
rio-push-down-the-bkl-into-the-firmware-ioctl-handler.patch
sx-push-bkl-down-into-the-firmware-ioctl-handler.patch
ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down.patch
dsp56k-bkl-pushdown.patch
char-mxser-ioctl-cleanup.patch
char-mxser-globals-cleanup.patch
char-mxser-update-documentation.patch
char-mxser-prints-cleanup.patch
char-mxser-remove-predefined-isa-support.patch
char-mxser-various-cleanups.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
drivers-misc-phantom-note-pci.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch


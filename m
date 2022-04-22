Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47089C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 22 Apr 2022 21:36:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbiDVVjK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Apr 2022 17:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbiDVVjF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2022 17:39:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDCD304112
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 13:44:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37C36B83267
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 20:37:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6698C385A0;
        Fri, 22 Apr 2022 20:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650659849;
        bh=+P5vnZa/BM2Yf/02o6e3JC/5/WOcaY7NBlMUZwR3tyE=;
        h=Date:To:From:Subject:From;
        b=x+zqIT3rpVZzBYQX//7lB63XI6y29JkwAbMcnmnfk6QfjLtb42+oysz19GMr61GF2
         gTLFiK/BzR+dvAVa2NPoQBC/EI/DsHZHtEuv8yufTIOa7EFTJCeIWfG8uoquK9uyOT
         1yF+Np4fVhEhR6NqM/qtHv2DtUovN8No/nP0p00s=
Date:   Fri, 22 Apr 2022 13:37:28 -0700
To:     mm-commits@vger.kernel.org, zheyuma97@gmail.com,
        sharvari.harisangam@nxp.com, pabeni@redhat.com, kvalo@kernel.org,
        kuba@kernel.org, keescook@chromium.org, huxinming820@gmail.com,
        ganapathi017@gmail.com, davem@davemloft.net,
        buytenh@wantstofly.org, amitkarwar@gmail.com, wangqing@vivo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + net-wireless-marvell-use-time_is_before_jiffies-instead-of-open-coding-it.patch added to -mm tree
Message-Id: <20220422203728.E6698C385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: net: wireless: marvell: use time_is_before_jiffies() instead of open coding it
has been added to the -mm tree.  Its filename is
     net-wireless-marvell-use-time_is_before_jiffies-instead-of-open-coding-it.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/net-wireless-marvell-use-time_is_before_jiffies-instead-of-open-coding-it.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/net-wireless-marvell-use-time_is_before_jiffies-instead-of-open-coding-it.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wang Qing <wangqing@vivo.com>
Subject: net: wireless: marvell: use time_is_before_jiffies() instead of open coding it

Use the helper function time_is_{before,after}_jiffies() to improve code
readability.

Link: https://lkml.kernel.org/r/1650621172-66967-8-git-send-email-wangqing@vivo.com
Signed-off-by: Wang Qing <wangqing@vivo.com>
Cc: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: Ganapathi Bhat <ganapathi017@gmail.com>
Cc: Sharvari Harisangam <sharvari.harisangam@nxp.com>
Cc: Xinming Hu <huxinming820@gmail.com>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/marvell/mwifiex/tdls.c |    4 ++--
 drivers/net/wireless/marvell/mwl8k.c        |    3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/marvell/mwifiex/tdls.c~net-wireless-marvell-use-time_is_before_jiffies-instead-of-open-coding-it
+++ a/drivers/net/wireless/marvell/mwifiex/tdls.c
@@ -1436,8 +1436,8 @@ void mwifiex_check_auto_tdls(struct time
 
 	spin_lock_bh(&priv->auto_tdls_lock);
 	list_for_each_entry(tdls_peer, &priv->auto_tdls_list, list) {
-		if ((jiffies - tdls_peer->rssi_jiffies) >
-		    (MWIFIEX_AUTO_TDLS_IDLE_TIME * HZ)) {
+		if (time_is_before_jiffies(tdls_peer->rssi_jiffies +
+		    (MWIFIEX_AUTO_TDLS_IDLE_TIME * HZ))) {
 			tdls_peer->rssi = 0;
 			tdls_peer->do_discover = true;
 			priv->check_tdls_tx = true;
--- a/drivers/net/wireless/marvell/mwl8k.c~net-wireless-marvell-use-time_is_before_jiffies-instead-of-open-coding-it
+++ a/drivers/net/wireless/marvell/mwl8k.c
@@ -24,6 +24,7 @@
 #include <linux/moduleparam.h>
 #include <linux/firmware.h>
 #include <linux/workqueue.h>
+#include <linux/jiffies.h>
 
 #define MWL8K_DESC	"Marvell TOPDOG(R) 802.11 Wireless Network Driver"
 #define MWL8K_NAME	KBUILD_MODNAME
@@ -1880,7 +1881,7 @@ static inline void mwl8k_tx_count_packet
 	 * packets ever exceeds the ampdu_min_traffic threshold, we will allow
 	 * an ampdu stream to be started.
 	 */
-	if (jiffies - tx_stats->start_time > HZ) {
+	if (time_is_before_jiffies(tx_stats->start_time + HZ)) {
 		tx_stats->pkts = 0;
 		tx_stats->start_time = 0;
 	} else
_

Patches currently in -mm which might be from wangqing@vivo.com are

block-xen-use-time_is_before_eq_jiffies-instead-of-open-coding-it.patch
gpu-drm-i915-use-time_is_after_jiffies-instead-of-open-coding-it.patch
gpu-drm-radeon-use-time_is_before_jiffies-instead-of-open-coding-it.patch
hid-use-time_is_after_jiffies-instead-of-open-coding-it.patch
md-use-time_is_before_eq_jiffies-instead-of-open-coding-it.patch
net-wireless-marvell-use-time_is_before_jiffies-instead-of-open-coding-it.patch
scsi-bfa-use-time_is_before_jiffies-instead-of-open-coding-it.patch
timekeeping-use-time_is_before_jiffies-instead-of-open-coding-it.patch
net-decnet-use-time_is_before_jiffies-instead-of-open-coding-it.patch


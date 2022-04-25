Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A306AC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 25 Apr 2022 23:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234977AbiDZACj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Apr 2022 20:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiDZACh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Apr 2022 20:02:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D704113C89
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 16:59:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5CB86162D
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 23:59:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0696DC385A7;
        Mon, 25 Apr 2022 23:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650931161;
        bh=jDd9ggb7MvzVhjmLfnJmL2EbnYs2f10PmDiIN9TC2ns=;
        h=Date:To:From:Subject:From;
        b=Xzkrwf91+rN1puGokgxPorYcssdAD0/R+Y6GufNTtxsTAzHANb8PnqkAkJDuFXddQ
         n6mH4zd3ydM9XhHjgOm1KQb34O19ieKs42PqiXqBO6eHxWiGcj4EQKTELDbmvl+Oqx
         RmUwzwi2ix4E+9uNnPW9+Ke+LuMtvfleJA5ijdlM=
Date:   Mon, 25 Apr 2022 16:59:20 -0700
To:     mm-commits@vger.kernel.org, zheyuma97@gmail.com,
        sharvari.harisangam@nxp.com, pabeni@redhat.com, kvalo@kernel.org,
        kuba@kernel.org, keescook@chromium.org, huxinming820@gmail.com,
        ganapathi017@gmail.com, davem@davemloft.net,
        buytenh@wantstofly.org, amitkarwar@gmail.com, wangqing@vivo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] net-wireless-marvell-use-time_is_before_jiffies-instead-of-open-coding-it.patch removed from -mm tree
Message-Id: <20220425235921.0696DC385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: net: wireless: marvell: use time_is_before_jiffies() instead of open coding it
has been removed from the -mm tree.  Its filename was
     net-wireless-marvell-use-time_is_before_jiffies-instead-of-open-coding-it.patch

This patch was dropped because it had testing failures

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

scsi-bfa-use-time_is_before_jiffies-instead-of-open-coding-it.patch
net-decnet-use-time_is_before_jiffies-instead-of-open-coding-it.patch


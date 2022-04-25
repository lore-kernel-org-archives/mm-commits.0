Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EC5AC433F5
	for <mm-commits@archiver.kernel.org>; Mon, 25 Apr 2022 23:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbiDZACi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Apr 2022 20:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238970AbiDZAC0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Apr 2022 20:02:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14309120118
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 16:59:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59B53615BB
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 23:59:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC08C385B1;
        Mon, 25 Apr 2022 23:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650931158;
        bh=utdmh3RSLUp4Fqt4Yzo+ediT4gwaLl7uenlmbJJTzdY=;
        h=Date:To:From:Subject:From;
        b=Sl11eIFFfd70BDl6nWozhUs93LpPCk/brtqe3yc289ytWB7LtGTih+fRuifGAOaYB
         XKt1ogBn9prTN7CYXhwpjlnhl4Sdpp5sBLxeS0JUwlSxq8ySibA8a+p9I9N5SpZEmL
         yYMsk67w6QCL/HFuOgpqqBoimIPTjLMOpbAtjbQ0=
Date:   Mon, 25 Apr 2022 16:59:18 -0700
To:     mm-commits@vger.kernel.org, snitzer@kernel.org, agk@redhat.com,
        wangqing@vivo.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] md-use-time_is_before_eq_jiffies-instead-of-open-coding-it.patch removed from -mm tree
Message-Id: <20220425235918.AEC08C385B1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: md: use time_is_before_eq_jiffies() instead of open coding it
has been removed from the -mm tree.  Its filename was
     md-use-time_is_before_eq_jiffies-instead-of-open-coding-it.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Wang Qing <wangqing@vivo.com>
Subject: md: use time_is_before_eq_jiffies() instead of open coding it

Use the helper function time_is_{before,after}_jiffies() to improve code
readability.

Link: https://lkml.kernel.org/r/1650621172-66967-7-git-send-email-wangqing@vivo.com
Signed-off-by: Wang Qing <wangqing@vivo.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-writecache.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-writecache.c~md-use-time_is_before_eq_jiffies-instead-of-open-coding-it
+++ a/drivers/md/dm-writecache.c
@@ -16,6 +16,7 @@
 #include <linux/pfn_t.h>
 #include <linux/libnvdimm.h>
 #include <linux/delay.h>
+#include <linux/jiffies.h>
 #include "dm-io-tracker.h"
 
 #define DM_MSG_PREFIX "writecache"
@@ -1971,8 +1972,8 @@ restart:
 	while (!list_empty(&wc->lru) &&
 	       (wc->writeback_all ||
 		wc->freelist_size + wc->writeback_size <= wc->freelist_low_watermark ||
-		(jiffies - container_of(wc->lru.prev, struct wc_entry, lru)->age >=
-		 wc->max_age - wc->max_age / MAX_AGE_DIV))) {
+		time_is_before_eq_jiffies(container_of(wc->lru.prev, struct wc_entry,
+		lru)->age + wc->max_age - wc->max_age / MAX_AGE_DIV)) {
 
 		n_walked++;
 		if (unlikely(n_walked > WRITEBACK_LATENCY) &&
_

Patches currently in -mm which might be from wangqing@vivo.com are

net-wireless-marvell-use-time_is_before_jiffies-instead-of-open-coding-it.patch
scsi-bfa-use-time_is_before_jiffies-instead-of-open-coding-it.patch
net-decnet-use-time_is_before_jiffies-instead-of-open-coding-it.patch


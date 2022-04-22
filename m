Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 952ECC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 22 Apr 2022 21:35:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbiDVVh5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Apr 2022 17:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbiDVVhs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2022 17:37:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6694A11D952
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 13:38:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0A15FCE2D26
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 20:37:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40FECC385A0;
        Fri, 22 Apr 2022 20:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650659845;
        bh=fw3K7F2bHIwmRKqBtpPYteBTfi2HlWCF5fPslv4hThI=;
        h=Date:To:From:Subject:From;
        b=jLg0MlPUPgiqy7RiTE6m29iPEEla6nAyszjchtkNyEV6NxaoQmkISRo3T4JGTqaKx
         sLss6KcIMGWtr/KB9Ser9pk9KXXy3a7ylwl8GMk0MeUBrJHzhR5XOM85qMxlk7apxH
         2GoAixfpZCu8zEBtmcPTiGDiYsSdDvr3voVysAG4=
Date:   Fri, 22 Apr 2022 13:37:24 -0700
To:     mm-commits@vger.kernel.org, xiang.ye@intel.com,
        srinivas.pandruvada@linux.intel.com, srinivas.pandruvada@intel.com,
        jikos@kernel.org, even.xu@intel.com, benjamin.tissoires@redhat.com,
        wangqing@vivo.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hid-use-time_is_after_jiffies-instead-of-open-coding-it.patch added to -mm tree
Message-Id: <20220422203725.40FECC385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hid: use time_is_after_jiffies() instead of open coding it
has been added to the -mm tree.  Its filename is
     hid-use-time_is_after_jiffies-instead-of-open-coding-it.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hid-use-time_is_after_jiffies-instead-of-open-coding-it.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hid-use-time_is_after_jiffies-instead-of-open-coding-it.patch

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
Subject: hid: use time_is_after_jiffies() instead of open coding it

Use the helper function time_is_{before,after}_jiffies() to improve code
readability.

Link: https://lkml.kernel.org/r/1650621172-66967-5-git-send-email-wangqing@vivo.com
Signed-off-by: Wang Qing <wangqing@vivo.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Even Xu <even.xu@intel.com>
Cc: "Pandruvada, Srinivas" <srinivas.pandruvada@intel.com>
Cc: Ye Xiang <xiang.ye@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/intel-ish-hid/ipc/ipc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/intel-ish-hid/ipc/ipc.c~hid-use-time_is_after_jiffies-instead-of-open-coding-it
+++ a/drivers/hid/intel-ish-hid/ipc/ipc.c
@@ -578,7 +578,7 @@ static void _ish_sync_fw_clock(struct is
 	static unsigned long	prev_sync;
 	uint64_t	usec;
 
-	if (prev_sync && jiffies - prev_sync < 20 * HZ)
+	if (prev_sync && time_is_after_jiffies(prev_sync + 20 * HZ))
 		return;
 
 	prev_sync = jiffies;
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


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B383CC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 22 Apr 2022 21:36:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiDVVjH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Apr 2022 17:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbiDVVjF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2022 17:39:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AAE5303F7D
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 13:44:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B4A4B8326B
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 20:37:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76E7C385A0;
        Fri, 22 Apr 2022 20:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650659852;
        bh=5zTe2fgnSZpXWyW/mLQrhHX0kEfSdeZOSfXeIDgqsOE=;
        h=Date:To:From:Subject:From;
        b=uQCBICYyv54peLdMMi6oX0xHAfdrjxW5gbjF7GCBF+pD/YoRNGOJHbkj8aEvE4WaM
         wAX0c8mAQR7iGtlB72W05Bdpwh9DeowB3lwMvPdx7BOZdeJtZJ/6pylmAayRUol0JO
         Bjd0bNilXDvjlpZXlpcr5tv1jF377lesC2jrvGs8=
Date:   Fri, 22 Apr 2022 13:37:32 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de, sboyd@kernel.org,
        john.stultz@linaro.org, wangqing@vivo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + timekeeping-use-time_is_before_jiffies-instead-of-open-coding-it.patch added to -mm tree
Message-Id: <20220422203732.C76E7C385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: timekeeping: use time_is_before_jiffies() instead of open coding it
has been added to the -mm tree.  Its filename is
     timekeeping-use-time_is_before_jiffies-instead-of-open-coding-it.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/timekeeping-use-time_is_before_jiffies-instead-of-open-coding-it.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/timekeeping-use-time_is_before_jiffies-instead-of-open-coding-it.patch

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
Subject: timekeeping: use time_is_before_jiffies() instead of open coding it

Use the helper function time_is_{before,after}_jiffies() to improve code
readability.

Link: https://lkml.kernel.org/r/1650621172-66967-10-git-send-email-wangqing@vivo.com
Signed-off-by: Wang Qing <wangqing@vivo.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/timekeeping.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/time/timekeeping.c~timekeeping-use-time_is_before_jiffies-instead-of-open-coding-it
+++ a/kernel/time/timekeeping.c
@@ -216,7 +216,7 @@ static void timekeeping_check_update(str
 	}
 
 	if (tk->underflow_seen) {
-		if (jiffies - tk->last_warning > WARNING_FREQ) {
+		if (time_is_before_jiffies(tk->last_warning + WARNING_FREQ)) {
 			printk_deferred("WARNING: Underflow in clocksource '%s' observed, time update ignored.\n", name);
 			printk_deferred("         Please report this, consider using a different clocksource, if possible.\n");
 			printk_deferred("         Your kernel is probably still fine.\n");
@@ -226,7 +226,7 @@ static void timekeeping_check_update(str
 	}
 
 	if (tk->overflow_seen) {
-		if (jiffies - tk->last_warning > WARNING_FREQ) {
+		if (time_is_before_jiffies(tk->last_warning + WARNING_FREQ)) {
 			printk_deferred("WARNING: Overflow in clocksource '%s' observed, time update capped.\n", name);
 			printk_deferred("         Please report this, consider using a different clocksource, if possible.\n");
 			printk_deferred("         Your kernel is probably still fine.\n");
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


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4DD0C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 25 Apr 2022 19:11:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244883AbiDYTOh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Apr 2022 15:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244887AbiDYTOg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Apr 2022 15:14:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC202ED7C
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 12:11:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B4B66172B
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 19:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD55C385A7;
        Mon, 25 Apr 2022 19:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650913890;
        bh=hCQxsREvf1uR0MiGr3QjFYHHhDAkquYEEH1qwabynbg=;
        h=Date:To:From:Subject:From;
        b=qsQCCaQRi3LTlS2+YR8rNoezUiEmg3bxbmhGsPjSOkiWkMTXbjBdF5HANW/gEKQLy
         wefwIio32so+dEak8sXJ+wSfMW+bt3u8x2p9Smdqdwyoh4wbcp3pF8i8sanLWYHPba
         tNXyB1jx1malgnjOfPt6ZMe4MTNLnjcQjhuHuv3Q=
Date:   Mon, 25 Apr 2022 12:11:29 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de, sboyd@kernel.org,
        john.stultz@linaro.org, wangqing@vivo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] timekeeping-use-time_is_before_jiffies-instead-of-open-coding-it.patch removed from -mm tree
Message-Id: <20220425191130.7CD55C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: timekeeping: use time_is_before_jiffies() instead of open coding it
has been removed from the -mm tree.  Its filename was
     timekeeping-use-time_is_before_jiffies-instead-of-open-coding-it.patch

This patch was dropped because it was nacked

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
net-decnet-use-time_is_before_jiffies-instead-of-open-coding-it.patch


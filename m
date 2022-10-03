Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BBC6C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:30:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbiJCVaO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiJCV3u (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:29:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD79057557
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:22:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69946601D7
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:22:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47EEC433C1;
        Mon,  3 Oct 2022 21:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664832153;
        bh=AwO13V0IRnIN1d6wlJLhb7cHy0kwBKRm+9NIg0Q0aoI=;
        h=Date:To:From:Subject:From;
        b=RZoTdHvHKDfyF0jhCfrsdzox6iM00/QbCN1dKsw+tdj3g1/2ZUZRqwPhxOrF1Wvkc
         8/LGdK3lbI4EZexlq1oRyD08faeJ68wQUA84lXcz2lvFh6tYep+sI2/jtOGGrrHDBB
         bwJQdqUdKAkTahiBDmjDz6dMBNctpKts8xJL+G5A=
Date:   Mon, 03 Oct 2022 14:22:33 -0700
To:     mm-commits@vger.kernel.org, pmladek@suse.com, jwerner@chromium.org,
        gregkh@linuxfoundation.org, evgreen@chromium.org,
        davidgow@google.com, ardb@kernel.org, gpiccoli@igalia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] firmware-google-test-spinlock-on-panic-path-to-avoid-lockups.patch removed from -mm tree
Message-Id: <20221003212233.B47EEC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: firmware: google: test spinlock on panic path to avoid lockups
has been removed from the -mm tree.  Its filename was
     firmware-google-test-spinlock-on-panic-path-to-avoid-lockups.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Subject: firmware: google: test spinlock on panic path to avoid lockups
Date: Fri, 9 Sep 2022 17:07:55 -0300

Currently the gsmi driver registers a panic notifier as well as reboot and
die notifiers.  The callbacks registered are called in atomic and very
limited context - for instance, panic disables preemption and local IRQs,
also all secondary CPUs (not executing the panic path) are shutdown.

With that said, taking a spinlock in this scenario is a dangerous
invitation for lockup scenarios.  So, fix that by checking if the spinlock
is free to acquire in the panic notifier callback - if not, bail-out and
avoid a potential hang.

Link: https://lkml.kernel.org/r/20220909200755.189679-1-gpiccoli@igalia.com
Fixes: 74c5b31c6618 ("driver: Google EFI SMI")
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Reviewed-by: Evan Green <evgreen@chromium.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: David Gow <davidgow@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Julius Werner <jwerner@chromium.org>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/google/gsmi.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/firmware/google/gsmi.c~firmware-google-test-spinlock-on-panic-path-to-avoid-lockups
+++ a/drivers/firmware/google/gsmi.c
@@ -681,6 +681,15 @@ static struct notifier_block gsmi_die_no
 static int gsmi_panic_callback(struct notifier_block *nb,
 			       unsigned long reason, void *arg)
 {
+
+	/*
+	 * Panic callbacks are executed with all other CPUs stopped,
+	 * so we must not attempt to spin waiting for gsmi_dev.lock
+	 * to be released.
+	 */
+	if (spin_is_locked(&gsmi_dev.lock))
+		return NOTIFY_DONE;
+
 	gsmi_shutdown_reason(GSMI_SHUTDOWN_PANIC);
 	return NOTIFY_DONE;
 }
_

Patches currently in -mm which might be from gpiccoli@igalia.com are



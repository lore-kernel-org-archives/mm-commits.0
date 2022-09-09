Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5889ECAAD3
	for <mm-commits@archiver.kernel.org>; Fri,  9 Sep 2022 20:20:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbiIIUUr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Sep 2022 16:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbiIIUUp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2022 16:20:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 837B792F6F
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 13:20:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2278BB8262E
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 20:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC6AFC433D6;
        Fri,  9 Sep 2022 20:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662754840;
        bh=UQ4tZnky0H2y93L7yrhbiLfUBVAkUCC6CC7uHfNKu0k=;
        h=Date:To:From:Subject:From;
        b=r7HCRrpCuYAPK+3dgDeFPlJ1Ubn0ws2hXImHRAzu2iu1kq4Z9hCSmascyD5arLN+8
         rX7Btg1CdKQtz+cbpAvptd8IlWtHwhTfpDQqWR2V9/bep2u+SkyhPihs3hNgRIxN4+
         XUsGDFhVF/kkX7zFYfVQ/7KPYhr6GiYKGSrKuDuc=
Date:   Fri, 09 Sep 2022 13:20:39 -0700
To:     mm-commits@vger.kernel.org, pmladek@suse.com, jwerner@chromium.org,
        gregkh@linuxfoundation.org, evgreen@chromium.org,
        davidgow@google.com, ardb@kernel.org, gpiccoli@igalia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + firmware-google-test-spinlock-on-panic-path-to-avoid-lockups.patch added to mm-nonmm-unstable branch
Message-Id: <20220909202040.BC6AFC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: firmware: google: test spinlock on panic path to avoid lockups
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     firmware-google-test-spinlock-on-panic-path-to-avoid-lockups.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/firmware-google-test-spinlock-on-panic-path-to-avoid-lockups.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

firmware-google-test-spinlock-on-panic-path-to-avoid-lockups.patch


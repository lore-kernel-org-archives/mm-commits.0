Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5296C4167B
	for <mm-commits@archiver.kernel.org>; Mon,  4 Dec 2023 18:59:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbjLDS7U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Dec 2023 13:59:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjLDS7U (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Dec 2023 13:59:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D7DAF
        for <mm-commits@vger.kernel.org>; Mon,  4 Dec 2023 10:59:26 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CFC6C433C7;
        Mon,  4 Dec 2023 18:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701716366;
        bh=WKdqJHUGePbDRfuW3PaoB3mworjmWycZd5pEJJxPxf0=;
        h=Date:To:From:Subject:From;
        b=epNIeNaGPo6XE2KXoz3uJHDv/wAFk7MAf4N1vUuHofOqFfpjT/3TyxrBHdjYSvhzw
         0IGR0YRTAEWJXWu9N6gbk2GpqB502218nBtv0kCv4rdpgp7VHoI5Xn6CFZ/13xJ4WP
         54dbQcUfk5EpjALOkS1AUVva8Aljwz7qa3gQ7f+Q=
Date:   Mon, 04 Dec 2023 10:59:25 -0800
To:     mm-commits@vger.kernel.org, dvyukov@google.com, bp@alien8.de,
        andreyknvl@gmail.com, alex.popov@linux.com, mark.rutland@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kcov-remove-stale-randomize_base-text.patch added to mm-nonmm-unstable branch
Message-Id: <20231204185926.0CFC6C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kcov: remove stale RANDOMIZE_BASE text
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kcov-remove-stale-randomize_base-text.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kcov-remove-stale-randomize_base-text.patch

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
From: Mark Rutland <mark.rutland@arm.com>
Subject: kcov: remove stale RANDOMIZE_BASE text
Date: Mon, 4 Dec 2023 17:18:07 +0000

The Kconfig help text for CONFIG_KCOV describes that recorded PC values
will not be stable across machines or reboots when RANDOMIZE_BASE is
selected.  This was the case when KCOV was introduced in commit:

  5c9a8750a6409c63 ("kernel: add kcov code coverage")

However, this changed in commit:

  4983f0ab7ffaad1e ("kcov: make kcov work properly with KASLR enabled")

Since that commit KCOV always subtracts the KASLR offset from PC values,
which ensures that these are stable across machines and across reboots
even when RANDOMIZE_BASE is selected.

Unfortunately, that commit failed to update the Kconfig help text, which
still suggests disabling RANDOMIZE_BASE even though this is no longer
necessary.

Remove the stale Kconfig text.

Link: https://lkml.kernel.org/r/20231204171807.3313022-1-mark.rutland@arm.com
Reported-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Popov <alex.popov@linux.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    4 ----
 1 file changed, 4 deletions(-)

--- a/lib/Kconfig.debug~kcov-remove-stale-randomize_base-text
+++ a/lib/Kconfig.debug
@@ -2103,10 +2103,6 @@ config KCOV
 	  KCOV exposes kernel code coverage information in a form suitable
 	  for coverage-guided fuzzing (randomized testing).
 
-	  If RANDOMIZE_BASE is enabled, PC values will not be stable across
-	  different machines and across reboots. If you need stable PC values,
-	  disable RANDOMIZE_BASE.
-
 	  For more details, see Documentation/dev-tools/kcov.rst.
 
 config KCOV_ENABLE_COMPARISONS
_

Patches currently in -mm which might be from mark.rutland@arm.com are

kcov-remove-stale-randomize_base-text.patch


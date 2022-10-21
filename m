Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0808C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 04:52:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiJUEwt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Oct 2022 00:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiJUEwt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2022 00:52:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2550A21A873
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 21:52:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCFC7B82A64
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 04:52:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99636C433C1;
        Fri, 21 Oct 2022 04:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666327965;
        bh=9W7zf6IoYtpwQTu/uUmXulH7uLlbOjAm5wRtDMPbT5s=;
        h=Date:To:From:Subject:From;
        b=qjP+XQatny6go1ej7lN5E+0CVjMk/Q596iD5IcJLpX2YCkZHuvAqpbhnUcZwgf0wH
         gE5s1cYsSt7WwpIK6dVNehEA3P2tzs/mUjcjOj6o81qUeWusa6tFVEY/ysVVOLTzVa
         kVyku5t5Nq/kcH2z0r5bVJ61GPMlPhqLWM0nEUjM=
Date:   Thu, 20 Oct 2022 21:52:44 -0700
To:     mm-commits@vger.kernel.org, bhelgaas@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ia64-remove-unused-__slow_down_io-and-slow_down_io-definitions.patch added to mm-nonmm-unstable branch
Message-Id: <20221021045245.99636C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: remove unused __SLOW_DOWN_IO and SLOW_DOWN_IO definitions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ia64-remove-unused-__slow_down_io-and-slow_down_io-definitions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ia64-remove-unused-__slow_down_io-and-slow_down_io-definitions.patch

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
From: Bjorn Helgaas <bhelgaas@google.com>
Subject: ia64: remove unused __SLOW_DOWN_IO and SLOW_DOWN_IO definitions
Date: Thu, 13 Oct 2022 19:19:10 -0500

Remove unused __SLOW_DOWN_IO and SLOW_DOWN_IO definitions.

Link: https://lkml.kernel.org/r/20221014001911.3342485-3-helgaas@kernel.org
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/io.h |    4 ----
 1 file changed, 4 deletions(-)

--- a/arch/ia64/include/asm/io.h~ia64-remove-unused-__slow_down_io-and-slow_down_io-definitions
+++ a/arch/ia64/include/asm/io.h
@@ -23,10 +23,6 @@
 #include <asm/unaligned.h>
 #include <asm/early_ioremap.h>
 
-/* We don't use IO slowdowns on the ia64, but.. */
-#define __SLOW_DOWN_IO	do { } while (0)
-#define SLOW_DOWN_IO	do { } while (0)
-
 #define __IA64_UNCACHED_OFFSET	RGN_BASE(RGN_UNCACHED)
 
 /*
_

Patches currently in -mm which might be from bhelgaas@google.com are

checkpatch-add-warning-for-non-lore-mailing-list-urls.patch
ia64-remove-unused-__slow_down_io-and-slow_down_io-definitions.patch


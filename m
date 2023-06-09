Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCC52C7EE2E
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:39:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbjFIXjx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbjFIXjs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:39:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1179BB
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:39:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85DFC63385
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1338C433D2;
        Fri,  9 Jun 2023 23:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353986;
        bh=MOQuOkhv8e/ls5TniNN/HcbsZIzCUtmI+OsaInuEZWs=;
        h=Date:To:From:Subject:From;
        b=hA4qrcqaWsYkjdm1pubsv/Mg5HytLeQBX2UH2SsQZlFwhVYl6kdrTY+5K8PJbeVJf
         r285iOTnmEYoWwhah5Jew4LYtklbeIoYUnYcPSM3tS+onciHMQ7aYL3C2pgrHknqik
         SjL8tGvo6fNOE55lDxr3T0F3GvanhHCLaHvSQ7rQ=
Date:   Fri, 09 Jun 2023 16:39:46 -0700
To:     mm-commits@vger.kernel.org, pmladek@suse.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-hardlockup-add-comments-to-touch_nmi_watchdog-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20230609233946.D1338C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog-hardlockup-add-comments-to-touch_nmi_watchdog-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-hardlockup-add-comments-to-touch_nmi_watchdog-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-hardlockup-add-comments-to-touch_nmi_watchdog-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: watchdog-hardlockup-add-comments-to-touch_nmi_watchdog-fix
Date: Fri Jun  9 04:37:30 PM PDT 2023

comment changes, per Petr

Link: https://lkml.kernel.org/r/ZGyONWPXpE1DcxA5@alley
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nmi.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/nmi.h~watchdog-hardlockup-add-comments-to-touch_nmi_watchdog-fix
+++ a/include/linux/nmi.h
@@ -125,7 +125,7 @@ void watchdog_nmi_disable(unsigned int c
 void lockup_detector_reconfigure(void);
 
 /**
- * touch_nmi_watchdog - manually pet the hardlockup watchdog.
+ * touch_nmi_watchdog - manually reset the hardlockup watchdog timeout.
  *
  * If we support detecting hardlockups, touch_nmi_watchdog() may be
  * used to pet the watchdog (reset the timeout) - for code which
@@ -146,7 +146,7 @@ static inline void touch_nmi_watchdog(vo
 	arch_touch_nmi_watchdog();
 
 	/*
-	 * Touching the hardlock detector implcitily pets the
+	 * Touching the hardlock detector implicitly resets the
 	 * softlockup detector too
 	 */
 	touch_softlockup_watchdog();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix-fix.patch
mmpage_owner-filter-out-stacks-by-a-threshold-counter-fix.patch
mm-page_isolation-write-proper-kerneldoc-fix.patch
mm-hugetlb-use-a-folio-in-hugetlb_fault-fix.patch
fork-optimize-memcg_charge_kernel_stack-a-bit-fix.patch
squashfs-cache-partial-compressed-blocks-fix.patch
squashfs-cache-partial-compressed-blocks-fix-3-fix.patch
init-add-bdev-fs-printk-if-mount_block_root-failed-fix.patch
watchdog-hardlockup-add-comments-to-touch_nmi_watchdog-fix.patch
kexec-add-helper-__crash_shrink_memory-fix.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2EA4C7EE29
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:31:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbjFJAbL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbjFJAbK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:31:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77CE93A87
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:31:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FE0164A91
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:31:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1D6C433D2;
        Sat, 10 Jun 2023 00:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686357065;
        bh=t/stBabVr4hasM/UPF45BSZY/2wYYtblgC6IdMzSTkE=;
        h=Date:To:From:Subject:From;
        b=hs+7qlQZ+brkP4A/HkLL8pRoc4xApJMI9Bis4p7MsFeLUFbPPXlzhFaHzK2juPbBg
         Lu5MTC+65muPuSxG1GkqqtaTxVlQK4gqgN3pC0oIlUpSjzlFcODsjcfXRgJV54ZM5L
         lsXAJ0pUwYZIsC/EKUNcjgT3srDLc9lbJwJ0rkFo=
Date:   Fri, 09 Jun 2023 17:31:04 -0700
To:     mm-commits@vger.kernel.org, pmladek@suse.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] watchdog-hardlockup-add-comments-to-touch_nmi_watchdog-fix.patch removed from -mm tree
Message-Id: <20230610003105.6B1D6C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: watchdog-hardlockup-add-comments-to-touch_nmi_watchdog-fix
has been removed from the -mm tree.  Its filename was
     watchdog-hardlockup-add-comments-to-touch_nmi_watchdog-fix.patch

This patch was dropped because it was folded into watchdog-hardlockup-add-comments-to-touch_nmi_watchdog.patch

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
watchdog-hardlockup-add-comments-to-touch_nmi_watchdog.patch
kexec-add-helper-__crash_shrink_memory-fix.patch


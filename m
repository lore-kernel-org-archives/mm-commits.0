Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45143C072A2
	for <mm-commits@archiver.kernel.org>; Wed, 15 Nov 2023 22:00:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjKOWAZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Nov 2023 17:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235628AbjKOWAY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2023 17:00:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9479F1A5
        for <mm-commits@vger.kernel.org>; Wed, 15 Nov 2023 14:00:20 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30333C433C8;
        Wed, 15 Nov 2023 22:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700085620;
        bh=SPOb8iOc3uzeqKZ7WlqZhpJabMdoT187LGUTZw8zld4=;
        h=Date:To:From:Subject:From;
        b=v8+d+ebnyWECqDAfXQeufGmCjJlVcA+FJqUlnHt6U+v6hGSOQ5gliB08Wz0Xk6X3F
         5K7bJgX8M61cIOzDsi9EHJGxS/9mMNepvOxbZ/aEiqeph9B9TDOQhENmgKwSp8KyJA
         cd1GXpFGvcCXSvhf2PtYgxCDoKyeiN6m70I41CPQ=
Date:   Wed, 15 Nov 2023 14:00:19 -0800
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memoryc-zap_pte_range-print-bad-swap-entry.patch added to mm-hotfixes-unstable branch
Message-Id: <20231115220020.30333C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c:zap_pte_range() print bad swap entry
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memoryc-zap_pte_range-print-bad-swap-entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memoryc-zap_pte_range-print-bad-swap-entry.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm/memory.c:zap_pte_range() print bad swap entry
Date: Wed Nov 15 01:54:18 PM PST 2023

We have a report of this WARN() triggering.  Let's print the offending
swp_entry_t to help diagnosis.

Link: https://lkml.kernel.org/r/000000000000b0e576060a30ee3b@google.com
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memory.c~mm-memoryc-zap_pte_range-print-bad-swap-entry
+++ a/mm/memory.c
@@ -1517,6 +1517,7 @@ static unsigned long zap_pte_range(struc
 				continue;
 		} else {
 			/* We should have covered all the swap entry types */
+			pr_alert("unrecognized swap entry 0x%lx\n", entry.val);
 			WARN_ON_ONCE(1);
 		}
 		pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-fix-for-negative-counter-nr_file_hugepages-fix.patch
maintainers-add-andrew-morton-for-lib.patch
mm-memoryc-zap_pte_range-print-bad-swap-entry.patch
mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-add-folio_zero_tail-and-use-it-in-ext4-fix.patch
mm-add-folio_fill_tail-and-use-it-in-iomap-fix.patch
kernel-reboot-explicitly-notify-if-halt-occurred-instead-of-power-off-fix.patch


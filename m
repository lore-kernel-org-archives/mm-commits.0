Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9EAAC10F05
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 00:13:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235152AbjLGANM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 19:13:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235171AbjLGANL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 19:13:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53EACA
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 16:13:17 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 719F5C433CA;
        Thu,  7 Dec 2023 00:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701907997;
        bh=M02zAQaZ9tA71sLMxlTnFU7zCEF57bVU5gKXKlW2jQg=;
        h=Date:To:From:Subject:From;
        b=su76Ubffekqkl566lEyXvSFMo5B+Nrldbvq1iqqvpzMtxSAUvZzuhF7AcMXfttmdx
         /WEriHcaJuIsQHlWG9YULE4d+PUdHuqVFfLgf3dOuvuel6tygUmtuixJa0vL+FIoq1
         2Qsots3XQrgMk5Xh+sFShnSBmHEQhl/PWf6UqIic=
Date:   Wed, 06 Dec 2023 16:13:16 -0800
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memoryc-zap_pte_range-print-bad-swap-entry.patch removed from -mm tree
Message-Id: <20231207001317.719F5C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory.c:zap_pte_range() print bad swap entry
has been removed from the -mm tree.  Its filename was
     mm-memoryc-zap_pte_range-print-bad-swap-entry.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-add-folio_zero_tail-and-use-it-in-ext4-fix.patch
mm-add-folio_fill_tail-and-use-it-in-iomap-fix.patch
mm-memcg-restore-subtree-stats-flushing-fix.patch
kernel-reboot-explicitly-notify-if-halt-occurred-instead-of-power-off-fix.patch


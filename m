Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41B86C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:19:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbjHKWTk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjHKWTj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:19:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD4B171D
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:19:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12D5A67A39
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:19:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B3FC433C7;
        Fri, 11 Aug 2023 22:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691792378;
        bh=4egURZEdWEX8o8FQLuHYK6qNOAhLmcr3YCetlbq4KvU=;
        h=Date:To:From:Subject:From;
        b=jGbsf9pAWKgftLRjXoTAQZ42jmQpYBVd1ucYF0JwQJ7xd0cXM52wnbZC4AWgy4VlH
         pZzrYZvhe7rA7mGaI40/KoTkyfiKvVFmlNpVaHHjbboGsn7BV+uP9pL0XsbBQMgArY
         59qq7rD48N6420ZGjLqjK5iR8RClE/yMta0GV/64=
Date:   Fri, 11 Aug 2023 15:19:37 -0700
To:     mm-commits@vger.kernel.org, mawupeng1@huawei.com, hughd@google.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] swap-stop-add-to-avail-list-is-swap-is-full-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20230811221938.63B3FC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: swap-stop-add-to-avail-list-is-swap-is-full-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     swap-stop-add-to-avail-list-is-swap-is-full-checkpatch-fixes.patch

This patch was dropped because it was folded into swap-stop-add-to-avail-list-is-swap-is-full.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: swap-stop-add-to-avail-list-is-swap-is-full-checkpatch-fixes
Date: Tue Jun 27 12:28:53 PM PDT 2023

fix typo in comment

WARNING: 'avaliable' may be misspelled - perhaps 'available'?
#60: FILE: mm/swapfile.c:2332:
+	/* add to avaliable list iff swap device is not full */
 	          ^^^^^^^^^

total: 0 errors, 1 warnings, 11 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/swap-stop-add-to-avail-list-is-swap-is-full.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Hugh Dickins <hughd@google.com>
Cc: Ma Wupeng <mawupeng1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~swap-stop-add-to-avail-list-is-swap-is-full-checkpatch-fixes
+++ a/mm/swapfile.c
@@ -2329,7 +2329,7 @@ static void _enable_swap_info(struct swa
 	 */
 	plist_add(&p->list, &swap_active_head);
 
-	/* add to avaliable list iff swap device is not full */
+	/* add to available list iff swap device is not full */
 	if (p->highest_bit)
 		add_to_avail_list(p);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
swap-stop-add-to-avail-list-is-swap-is-full.patch
fs-buffer-clean-up-block_commit_write-fix.patch
mm-page_alloc-avoid-false-page-outside-zone-error-info-fix.patch
mm-make-pte_marker_swapin_error-more-general-fix.patch
mm-kfence-allocate-kfence_metadata-at-runtime-fix.patch
acpi-hmat-calculate-abstract-distance-with-hmat-checkpatch-fixes.patch
mm-remove-redundant-k-macro-definition-fix.patch
signal-print-comm-and-exe-name-on-fatal-signals-fix.patch
drm-i915-move-abs_diff-to-mathh-fix-fix.patch
nmi_backtrace-allow-excluding-an-arbitrary-cpu-fix.patch


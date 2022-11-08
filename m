Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21E20C433FE
	for <mm-commits@archiver.kernel.org>; Tue,  8 Nov 2022 23:53:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiKHXxy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 18:53:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiKHXxs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 18:53:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11A3D45
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 15:53:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A83F617AF
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 23:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5877C433D6;
        Tue,  8 Nov 2022 23:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667951626;
        bh=bilXTJSQyK9JCmfH4DBIw4rMxzUCqKHg7YeD+Hjh5CY=;
        h=Date:To:From:Subject:From;
        b=tWLfUzfqEZmCRhJIFTjHKeE5BrJ05hsV4nhpKD+EEbrvVqX/7SqaTUfTF5zAjJi0M
         B/qUxSNHw50K6bNwKyW3rEvNIcMGdbvZeJ7ijs6356wzfYMeKHsNcgRLMIsBg0w471
         YNYObMkpLnRaKXFEaMUftjkWUsTE1KRPf4FPSyr0=
Date:   Tue, 08 Nov 2022 15:53:46 -0800
To:     mm-commits@vger.kernel.org, liam.howlett@oracle.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] maple_tree-reorganize-testing-to-restore-module-testing-fix-2.patch removed from -mm tree
Message-Id: <20221108235346.C5877C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree-reorganize-testing-to-restore-module-testing-fix-2
has been removed from the -mm tree.  Its filename was
     maple_tree-reorganize-testing-to-restore-module-testing-fix-2.patch

This patch was dropped because it was folded into maple_tree-reorganize-testing-to-restore-module-testing.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: maple_tree-reorganize-testing-to-restore-module-testing-fix-2
Date: Fri Oct 28 03:42:53 PM PDT 2022

fix it some more

Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/maple_tree.c~maple_tree-reorganize-testing-to-restore-module-testing-fix-2
+++ a/lib/maple_tree.c
@@ -6013,6 +6013,7 @@ void *mas_find(struct ma_state *mas, uns
 	/* Retries on dead nodes handled by mas_next_entry */
 	return mas_next_entry(mas, max);
 }
+EXPORT_SYMBOL_GPL(mas_find);
 
 /**
  * mas_find_rev: On the first call, find the first non-null entry at or below
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maple_tree-reorganize-testing-to-restore-module-testing.patch
mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch
vmalloc-add-reviewers-for-vmalloc-code-checkpatch-fixes.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2.patch
mm-gup-remove-foll_migration-fix.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-checkpatch-fixes.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-fix.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-v3-fix.patch
kasan-allow-sampling-page_alloc-allocations-for-hw_tags-fix.patch
mm-hugetlb-convert-move_hugetlb_state-to-folios-fix.patch
powerpc-ptrace-user_regset_copyin_ignore-always-returns-0-fix.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes-fix.patch
proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3-fix.patch


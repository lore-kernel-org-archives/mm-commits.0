Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 613EAC4332F
	for <mm-commits@archiver.kernel.org>; Tue,  8 Nov 2022 23:53:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiKHXxr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 18:53:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiKHXxq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 18:53:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64152DFAE
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 15:53:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0338E617E0
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 23:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A62AC433C1;
        Tue,  8 Nov 2022 23:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667951624;
        bh=yuRNuZMBdOiGhjnHnjsgbByORamMf3ZhP8fVWd03sFY=;
        h=Date:To:From:Subject:From;
        b=KfFleGIB4ebHdilsPpqMwOgsXir2aA/pICKsG60Me4/tmfEsNKOedhGrkIF8eFGvn
         t61xIu7kVqyF7rVIxvjM9ZdjfdiTJ168pjtHYGfRlygD6xqC+MMkL44txRBJ+1Sr8X
         j1Ar8EhSCjPQunQhJirTorUHmBspLhaYDiyanuyE=
Date:   Tue, 08 Nov 2022 15:53:43 -0800
To:     mm-commits@vger.kernel.org, liam.howlett@oracle.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] maple_tree-reorganize-testing-to-restore-module-testing-fix.patch removed from -mm tree
Message-Id: <20221108235344.5A62AC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree-reorganize-testing-to-restore-module-testing-fix
has been removed from the -mm tree.  Its filename was
     maple_tree-reorganize-testing-to-restore-module-testing-fix.patch

This patch was dropped because it was folded into maple_tree-reorganize-testing-to-restore-module-testing.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: maple_tree-reorganize-testing-to-restore-module-testing-fix
Date: Fri Oct 28 02:54:27 PM PDT 2022

fix module export

ERROR: modpost: "mas_find_rev" [lib/test_maple_tree.ko] undefined!

Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-reorganize-testing-to-restore-module-testing-fix
+++ a/lib/maple_tree.c
@@ -6059,7 +6059,7 @@ void *mas_find_rev(struct ma_state *mas,
 	/* Retries on dead nodes handled by mas_next_entry */
 	return mas_prev_entry(mas, min);
 }
-EXPORT_SYMBOL_GPL(mas_find);
+EXPORT_SYMBOL_GPL(mas_find_rev);
 
 /**
  * mas_erase() - Find the range in which index resides and erase the entire
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maple_tree-reorganize-testing-to-restore-module-testing.patch
maple_tree-reorganize-testing-to-restore-module-testing-fix-2.patch
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


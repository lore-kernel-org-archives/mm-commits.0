Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99FE6C43219
	for <mm-commits@archiver.kernel.org>; Fri, 27 May 2022 16:39:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349694AbiE0Qjj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 27 May 2022 12:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350272AbiE0Qjg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2022 12:39:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9927DB227C
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 09:39:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 298C761DFE
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 16:39:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82081C34113;
        Fri, 27 May 2022 16:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653669574;
        bh=8sfwpxwXPwf01YNW3woEuRwVCMUdX95KsATQheoSxN8=;
        h=Date:To:From:Subject:From;
        b=eqqwvxziAym435d5847SlTQHeAktVqb1CWXlnm59jFU381S7ysix+/GqGPdtjleGn
         zWMUBn0qGUoS/f4joiDv4Y0EGjs5pdzhwK/HVXJfToaAf7o5T5EMjldblZduh8hQ/s
         bxh09O6ynaOVDu0Sdkf3PooL7nlypDlrlPFb6Q0o=
Date:   Fri, 27 May 2022 09:39:33 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        willy@infradead.org, rientjes@google.com,
        pasha.tatashin@soleen.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-page_table_check-fix-accessing-unmapped-ptep-fix.patch removed from -mm tree
Message-Id: <20220527163934.82081C34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-page_table_check-fix-accessing-unmapped-ptep-fix
has been removed from the -mm tree.  Its filename was
     mm-page_table_check-fix-accessing-unmapped-ptep-fix.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_table_check-fix-accessing-unmapped-ptep-fix
Date: Thu May 26 11:12:12 AM PDT 2022

account for ptep alteration, per Matthew

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_table_check.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_table_check.c~mm-page_table_check-fix-accessing-unmapped-ptep-fix
+++ a/mm/page_table_check.c
@@ -256,6 +256,6 @@ void __page_table_check_pte_clear_range(
 			addr += PAGE_SIZE;
 			ptep++;
 		}
-		pte_unmap(ptep);
+		pte_unmap(ptep - PTRS_PER_PTE);
 	}
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
mm-shmemc-suppress-shift-warning.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch


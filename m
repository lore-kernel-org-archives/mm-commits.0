Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C644C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 26 May 2022 18:16:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbiEZSQh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 May 2022 14:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237702AbiEZSQg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 May 2022 14:16:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74FCBE0A
        for <mm-commits@vger.kernel.org>; Thu, 26 May 2022 11:16:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37962615A3
        for <mm-commits@vger.kernel.org>; Thu, 26 May 2022 18:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6285AC385A9;
        Thu, 26 May 2022 18:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653588993;
        bh=TEoPFvWXecwBYCrSOfcxPUnLSsVQl4eqgque4PhMWxo=;
        h=Date:To:From:Subject:From;
        b=sJLWoIiJBF0myKWgEwnNKQ3a8N0ItE4lori0P2uAW536tUQ1MI4s+rWFIFBh7/ULe
         gUipE3w8TCGessSqwYAUW1WkJw3vai8KKxfYmcBA+OLFaVqfJLCmrRwkDsG88dIrH/
         aq13mmTSi9fmQDoasxtjszs8aozf5GRKm4DBQQl8=
Date:   Thu, 26 May 2022 11:16:32 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        willy@infradead.org, rientjes@google.com,
        pasha.tatashin@soleen.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_table_check-fix-accessing-unmapped-ptep-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20220526181633.6285AC385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_table_check-fix-accessing-unmapped-ptep-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_table_check-fix-accessing-unmapped-ptep-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_table_check-fix-accessing-unmapped-ptep-fix.patch

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

kexec_file-drop-weak-attribute-from-arch_kexec_apply_relocations-fix.patch
mm-page_table_check-fix-accessing-unmapped-ptep-fix.patch
mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
mm-shmemc-suppress-shift-warning.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch


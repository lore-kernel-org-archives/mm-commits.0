Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCF39C678D4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Mar 2023 02:11:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbjCCCL5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Mar 2023 21:11:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCCCL5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Mar 2023 21:11:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486733B64E
        for <mm-commits@vger.kernel.org>; Thu,  2 Mar 2023 18:11:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0075DB81642
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 02:11:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990E6C433D2;
        Fri,  3 Mar 2023 02:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677809513;
        bh=IRNxFJIbrn1fr8DnE6UJWO/xH7JLLBhbBcxnaBWIlr8=;
        h=Date:To:From:Subject:From;
        b=Bgk4tABlesS7MWVc2zkyu0s0VpLR4GUPsbSUtC7to2wuRNKF/hfCnnpXp/Q6mV9U7
         FnbkgmkMgAfSRseUd9tgYzzLQuIMBWq2cvrSVIxPJaSAdxlfQE70fy9pcK0St/wKXT
         /1InpJ7v2lznCKINhjGmkKneRq3IrZW10xkVSAlo=
Date:   Thu, 02 Mar 2023 18:11:53 -0800
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        david@redhat.com, christophe.leroy@csgroup.eu,
        anshuman.khandual@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-drop-pte_mkhuge-in-remove_migration_pte.patch added to mm-unstable branch
Message-Id: <20230303021153.990E6C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: drop pte_mkhuge() in remove_migration_pte()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-drop-pte_mkhuge-in-remove_migration_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-drop-pte_mkhuge-in-remove_migration_pte.patch

This patch will later appear in the mm-unstable branch at
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
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/migrate: drop pte_mkhuge() in remove_migration_pte()
Date: Thu, 2 Mar 2023 08:23:49 +0530

Since the following commit, arch_make_huge_pte() should be used directly
in generic memory subsystem as a platform provided page table helper,
instead of pte_mkhuge().  This just drops pte_mkhuge() from
remove_migration_pte(), which has now become redundant.

'commit 16785bd77431 ("mm: merge pte_mkhuge() call into arch_make_huge_pte()")'

Link: https://lkml.kernel.org/r/20230302025349.358341-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reported-by: Christophe Leroy <christophe.leroy@csgroup.eu>
  Link: https://lore.kernel.org/all/1ea45095-0926-a56a-a273-816709e9075e@csgroup.eu/
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/migrate.c~mm-migrate-drop-pte_mkhuge-in-remove_migration_pte
+++ a/mm/migrate.c
@@ -249,7 +249,6 @@ static bool remove_migration_pte(struct
 		if (folio_test_hugetlb(folio)) {
 			unsigned int shift = huge_page_shift(hstate_vma(vma));
 
-			pte = pte_mkhuge(pte);
 			pte = arch_make_huge_pte(pte, shift, vma->vm_flags);
 			if (folio_test_anon(folio))
 				hugepage_add_anon_rmap(new, vma, pvmw.address,
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-migrate-drop-pte_mkhuge-in-remove_migration_pte.patch
mm-debug_vm_pgtable-replace-pte_mkhuge-with-arch_make_huge_pte.patch


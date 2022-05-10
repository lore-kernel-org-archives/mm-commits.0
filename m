Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 972CAC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 19:13:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349106AbiEJTN5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 15:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245139AbiEJTNt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 15:13:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF77B4B439
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 12:13:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49F4A61143
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 19:13:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B95EC385C8;
        Tue, 10 May 2022 19:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652210027;
        bh=9Guoha0r5JV5ZfPv8XZTQvDHHakXx3XiRj4O7TE4sE0=;
        h=Date:To:From:Subject:From;
        b=FeVgQpkMEiYbVNvMfnhH3k3Pfw6ILcwXJOf+xVZUfi7PSD+QQvZ+Rld9dYTMshf17
         aUUbme9Eqb0B0C+pI4dSpa3UK5TcYb44r2AEpka4bGty0PZk+C59XAWYXt6Z2xtKiv
         BWX5R0JYW4U0ROoK2eL+X/D8Gr4uGW3s7UCPXCWE=
Date:   Tue, 10 May 2022 12:13:47 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        vbabka@suse.cz, sj@kernel.org, Liam.Howlett@Oracle.com,
        dhowells@redhat.com, dave@stgolabs.net, catalin.marinas@arm.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix.patch added to mm-unstable branch
Message-Id: <20220510191347.9B95EC385C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix
has been added to the -mm mm-unstable branch.  Its filename is
     damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix

vaddr-test.h no longer needs internal.h

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr-test.h |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/damon/vaddr-test.h~damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix
+++ a/mm/damon/vaddr-test.h
@@ -13,7 +13,6 @@
 #define _DAMON_VADDR_TEST_H
 
 #include <kunit/test.h>
-#include "../../mm/internal.h"
 
 static void __link_vmas(struct maple_tree *mt, struct vm_area_struct *vmas,
 			ssize_t nr_vmas)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch
lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix.patch
mm-start-tracking-vmas-with-maple-tree-fix.patch
damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FEBCC6FD1D
	for <mm-commits@archiver.kernel.org>; Fri,  7 Apr 2023 21:43:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjDGVnm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Apr 2023 17:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjDGVnl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Apr 2023 17:43:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9387EBBA6
        for <mm-commits@vger.kernel.org>; Fri,  7 Apr 2023 14:43:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E04AF654D8
        for <mm-commits@vger.kernel.org>; Fri,  7 Apr 2023 21:43:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D55EC433D2;
        Fri,  7 Apr 2023 21:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680903819;
        bh=48d+Ojnn0lHdXcJvqOUVgdUsvgBiKX1+hQ8970ITVcg=;
        h=Date:To:From:Subject:From;
        b=jtuyVyIG0SaBB8EVFhw1EhBr5KxeqhwG2uqEmKFL3LFrqv2IeL/N0SQo/eTvsw2bp
         hQbNuHZoIXAyjDaOvKiPeIT8Bsf6yxY23IxSck8m/ekPKLzuO/et+Ah3CC1j8ho/iu
         MgFFluk/bh6sgm+O3RBVE/hPs1B1pbGkCHDbkkdU=
Date:   Fri, 07 Apr 2023 14:43:38 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, linux@roeck-us.net,
        kirill@shutemov.name, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-treewide-redefine-max_order-sanely-fix-fix-fix.patch added to mm-unstable branch
Message-Id: <20230407214339.3D55EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-treewide-redefine-max_order-sanely-fix-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-treewide-redefine-max_order-sanely-fix-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-treewide-redefine-max_order-sanely-fix-fix-fix.patch

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
Subject: mm-treewide-redefine-max_order-sanely-fix-fix-fix
Date: Fri Apr  7 02:42:27 PM PDT 2023

fix comment, per Mike

Link: https://lkml.kernel.org/r/ZDBa7HWZK69dKKzH@kernel.org
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memblock.c~mm-treewide-redefine-max_order-sanely-fix-fix-fix
+++ a/mm/memblock.c
@@ -2047,7 +2047,7 @@ static void __init __free_pages_memory(u
 		 * Free the pages in the largest chunks alignment allows.
 		 *
 		 * __ffs() behaviour is undefined for 0. start == 0 is
-		 * MAX_ORDER-aligned, Set order to MAX_ORDER for the case.
+		 * MAX_ORDER-aligned, set order to MAX_ORDER for the case.
 		 */
 		if (start)
 			order = min_t(int, MAX_ORDER, __ffs(start));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-khugepaged-fix-kernel-bug-in-hpage_collapse_scan_file-fix.patch
mm-treewide-redefine-max_order-sanely-fix-fix-fix.patch
memcg-do-not-drain-charge-pcp-caches-on-remote-isolated-cpus-fix.patch
vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold-fix.patch
lib-test_vmallocc-add-vm_map_ram-vm_unmap_ram-test-case-fix.patch
mm-add-new-api-to-enable-ksm-per-process-fix.patch


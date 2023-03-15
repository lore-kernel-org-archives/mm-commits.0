Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52843C7619A
	for <mm-commits@archiver.kernel.org>; Wed, 15 Mar 2023 19:39:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232516AbjCOTjb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Mar 2023 15:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232894AbjCOTj0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Mar 2023 15:39:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9A665C6C
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 12:39:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F0F0B81F20
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 19:39:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDDC2C4339E;
        Wed, 15 Mar 2023 19:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678909156;
        bh=w+7C/tR/ClVJyzVINf89UNzX2b/D+ETbSSmOMJmnfQs=;
        h=Date:To:From:Subject:From;
        b=XN1f3KDAnwEfs4CjzsbWxG5xy38oJ0KGx/iI7O7kpj6mc1ADt7XEDuMvHIi2OGcds
         nDDXdvpC6N6f7TiV6vOrs9zjHKIpoR4PBFKNhkUXlc9CKLwaDoAMASPS7ITB33HtXA
         8n15OlSTukCC6ml3q0q0j26px4/z5dUohaeL1wFU=
Date:   Wed, 15 Mar 2023 12:39:15 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com, kirill@shutemov.name,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-treewide-redefine-max_order-sanely-fix.patch added to mm-unstable branch
Message-Id: <20230315193915.DDDC2C4339E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-treewide-redefine-max_order-sanely-fix.txt
has been added to the -mm mm-unstable branch.  Its filename is
     mm-treewide-redefine-max_order-sanely-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-treewide-redefine-max_order-sanely-fix.patch

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
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: mm-treewide-redefine-max_order-sanely-fix.txt
Date: Wed, 15 Mar 2023 18:38:00 +0300

fix min() warning

Link: https://lkml.kernel.org/r/20230315153800.32wib3n5rickolvh@box
Reported-by: kernel test robot <lkp@intel.com>
  Link: https://lore.kernel.org/oe-kbuild-all/202303152343.D93IbJmn-lkp@intel.com/
Signed-off-by: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memblock.c~mm-treewide-redefine-max_order-sanely-fix
+++ a/mm/memblock.c
@@ -2043,7 +2043,7 @@ static void __init __free_pages_memory(u
 	int order;
 
 	while (start < end) {
-		order = min(MAX_ORDER, __ffs(start));
+		order = min_t(int, MAX_ORDER, __ffs(start));
 
 		while (start + (1UL << order) > end)
 			order--;
_

Patches currently in -mm which might be from kirill@shutemov.name are

mm-treewide-redefine-max_order-sanely-fix.patch


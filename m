Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C38CEC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 21 Nov 2022 21:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbiKUV6P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Nov 2022 16:58:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiKUV6O (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Nov 2022 16:58:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1BFB19C16
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2022 13:58:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9782B81618
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2022 21:58:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A688C433D7;
        Mon, 21 Nov 2022 21:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669067881;
        bh=XTqLDIX82kxOvBUPMWqZlk81zA97e+PUHkAVuedcuDk=;
        h=Date:To:From:Subject:From;
        b=uYbDeRkg1dxpHZU8leEKgxgluONW1t5j791cYZSU2EZ/ohKHSgG7FsVw7vaf1MZCL
         0sc7Jn6LcZLdKJB3fffA8cj2K1Qny0W6mN2EXM6snTx3n2J4bIYg5lMH52yuC4Ox6F
         bl6mqlJWOdrDCUEzSuGB8kvKsrj/Kn4+VRbznzeE=
Date:   Mon, 21 Nov 2022 13:58:00 -0800
To:     mm-commits@vger.kernel.org, lkp@intel.com, liam.howlett@oracle.com,
        geert@linux-m68k.org, rdunlap@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-allow-test_maple_tree-only-when-debug_kernel-is-set.patch added to mm-unstable branch
Message-Id: <20221121215801.4A688C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: allow TEST_MAPLE_TREE only when DEBUG_KERNEL is set
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-allow-test_maple_tree-only-when-debug_kernel-is-set.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-allow-test_maple_tree-only-when-debug_kernel-is-set.patch

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
From: Randy Dunlap <rdunlap@infradead.org>
Subject: maple_tree: allow TEST_MAPLE_TREE only when DEBUG_KERNEL is set
Date: Fri, 18 Nov 2022 21:51:17 -0800

Prevent a kconfig warning that is caused by TEST_MAPLE_TREE by adding a
"depends on" clause for TEST_MAPLE_TREE since 'select' does not follow any
kconfig dependencies.

WARNING: unmet direct dependencies detected for DEBUG_MAPLE_TREE
  Depends on [n]: DEBUG_KERNEL [=n]
  Selected by [y]:
  - TEST_MAPLE_TREE [=y] && RUNTIME_TESTING_MENU [=y]

Link: https://lkml.kernel.org/r/20221119055117.14094-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reported-by: kernel test robot <lkp@intel.com>
Fixes: 120b116208a0 ("maple_tree: reorganize testing to restore module testing")
Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/Kconfig.debug~maple_tree-allow-test_maple_tree-only-when-debug_kernel-is-set
+++ a/lib/Kconfig.debug
@@ -2249,6 +2249,7 @@ config TEST_XARRAY
 	tristate "Test the XArray code at runtime"
 
 config TEST_MAPLE_TREE
+	depends on DEBUG_KERNEL
 	select DEBUG_MAPLE_TREE
 	tristate "Test the Maple Tree code at runtime"
 
_

Patches currently in -mm which might be from rdunlap@infradead.org are

maple_tree-allow-test_maple_tree-only-when-debug_kernel-is-set.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32ADEC47088
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiLAAIn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:08:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbiLAAGn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:06:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B5FBC1C
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC79CB81D86
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE58C433D7;
        Thu,  1 Dec 2022 00:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852962;
        bh=6LckcOIvzFj63FBkvPluPSMkQxB8HuRIycR6QWVmCgM=;
        h=Date:To:From:Subject:From;
        b=c+K4keCq7pxLYfKQjC+dAo4J1DZpvbuKGhcPVae5J67AT50Nv2bFFLJ98eLfWrh/u
         RmPa75zxpKrB9Tq0rb19TfRFGlmpr1zEhJq7xp0zeui+ijFwDS8YpZPKQO+IoA9yyr
         HTYSDG4Lc9ibY2MwY4pVwbDvZy7ToQvPHPRUyqBo=
Date:   Wed, 30 Nov 2022 16:02:41 -0800
To:     mm-commits@vger.kernel.org, lkp@intel.com, Liam.Howlett@oracle.com,
        geert@linux-m68k.org, rdunlap@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-allow-test_maple_tree-only-when-debug_kernel-is-set.patch removed from -mm tree
Message-Id: <20221201000242.8BE58C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: allow TEST_MAPLE_TREE only when DEBUG_KERNEL is set
has been removed from the -mm tree.  Its filename was
     maple_tree-allow-test_maple_tree-only-when-debug_kernel-is-set.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Fixes: 120b116208a0 ("maple_tree: reorganize testing to restore module testing")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/Kconfig.debug~maple_tree-allow-test_maple_tree-only-when-debug_kernel-is-set
+++ a/lib/Kconfig.debug
@@ -2244,6 +2244,7 @@ config TEST_XARRAY
 	tristate "Test the XArray code at runtime"
 
 config TEST_MAPLE_TREE
+	depends on DEBUG_KERNEL
 	select DEBUG_MAPLE_TREE
 	tristate "Test the Maple Tree code at runtime"
 
_

Patches currently in -mm which might be from rdunlap@infradead.org are



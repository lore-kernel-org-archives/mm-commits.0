Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85F39C04A94
	for <mm-commits@archiver.kernel.org>; Wed,  2 Aug 2023 19:16:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232542AbjHBTQu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Aug 2023 15:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233034AbjHBTQp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2023 15:16:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289E12726
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 12:16:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9064361AB8
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 19:16:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD08C433C8;
        Wed,  2 Aug 2023 19:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691003800;
        bh=W7wpCAh/M7gtcixCGMiL+rmYll5QAc5lOJbz9nMJxKc=;
        h=Date:To:From:Subject:From;
        b=YYkaBj2B8aI7njK8Q/OgII57ICfdQkNQ/xuM0aDosXRn5q8S+g+79YF0nB0Z3GDxV
         Ey3E2PJN1cmZVVYnZKCc1FvuOCcFgmyx+s6qZDynC7SjDh5c9eFWp4B/8pOADWk/pc
         pp7ZuAMcvkN39W0MEHZKHk68LClZgj6wNXGATHss=
Date:   Wed, 02 Aug 2023 12:16:39 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, ppbuk5246@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_init-ignore-kernelcore=mirror-boot-option-when-no-mirror-memory-presents.patch added to mm-unstable branch
Message-Id: <20230802191639.DAD08C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mm_init: ignore kernelcore=mirror boot option when no mirror memory presents.
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_init-ignore-kernelcore=mirror-boot-option-when-no-mirror-memory-presents.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_init-ignore-kernelcore=mirror-boot-option-when-no-mirror-memory-presents.patch

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
From: Levi Yun <ppbuk5246@gmail.com>
Subject: mm/mm_init: ignore kernelcore=mirror boot option when no mirror memory presents.
Date: Wed, 2 Aug 2023 19:36:14 +0100

In a machine where no mirror memory is set, All memory region in
ZONE_NORMAL is used as ZONE_MOVABLE when kernelcore=mirror boot option is
used.  So, ZONE_NORMAL couldn't be populated properly because all of
ZONE_NORMAL pages is absent.

To avoid this abnormal situation,
ignore disable kernelcore=mirror option when no mirror memory is found.

Link: https://lkml.kernel.org/r/20230802183614.15520-1-ppbuk5246@gmail.com
Signed-off-by: Levi Yun <ppbuk5246@gmail.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/mm/mm_init.c~mm-mm_init-ignore-kernelcore=mirror-boot-option-when-no-mirror-memory-presents
+++ a/mm/mm_init.c
@@ -376,10 +376,13 @@ static void __init find_zone_movable_pfn
 	 */
 	if (mirrored_kernelcore) {
 		bool mem_below_4gb_not_mirrored = false;
+		bool no_mirror_mem = true;
 
 		for_each_mem_region(r) {
-			if (memblock_is_mirror(r))
+			if (memblock_is_mirror(r)) {
+				no_mirror_mem = false;
 				continue;
+			}
 
 			nid = memblock_get_region_node(r);
 
@@ -398,6 +401,12 @@ static void __init find_zone_movable_pfn
 		if (mem_below_4gb_not_mirrored)
 			pr_warn("This configuration results in unmirrored kernel memory.\n");
 
+		if (no_mirror_mem) {
+			pr_warn("There is no mirrored memory. Ignore kernelcore=mirror.\n");
+			mirrored_kernelcore = false;
+			memset(zone_movable_pfn, 0x00, sizeof(zone_movable_pfn));
+		}
+
 		goto out2;
 	}
 
_

Patches currently in -mm which might be from ppbuk5246@gmail.com are

damon-use-pmdp_get-instead-of-drectly-dereferencing-pmd.patch
mm-mm_init-ignore-kernelcore=mirror-boot-option-when-no-mirror-memory-presents.patch


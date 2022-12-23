Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0380BC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 23 Dec 2022 18:33:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbiLWSdf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Dec 2022 13:33:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbiLWSde (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Dec 2022 13:33:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BFA5192BF
        for <mm-commits@vger.kernel.org>; Fri, 23 Dec 2022 10:33:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12952B820F0
        for <mm-commits@vger.kernel.org>; Fri, 23 Dec 2022 18:33:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA9CAC433EF;
        Fri, 23 Dec 2022 18:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671820410;
        bh=ofpH/lGE2xwqrlXd1IxAqRLxOVC8nxT16JSe1opa3Bs=;
        h=Date:To:From:Subject:From;
        b=vA3+Usp0IC7k6II85HJZGLCpjxviH3kzW4vo9lQfhAqLaC+3fe0JKuECv9wQVmCiU
         2PQkn/QeEe1ROyO+T59QsRm2zNzGc0Kx80HLzdEC9VYnexLIyQ+fLxUD53CHfKP7f7
         pmw7eAcVwa9+q6ezRK76GrIL959E/7LOxgZY1nb8=
Date:   Fri, 23 Dec 2022 10:33:30 -0800
To:     mm-commits@vger.kernel.org, xu.xin16@zte.com.cn, david@redhat.com,
        xu.panda@zte.com.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-ksm_functional_tests-fix-a-typo-in-comment.patch added to mm-unstable branch
Message-Id: <20221223183330.BA9CAC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: ksm_functional_tests: fix a typo in comment
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-ksm_functional_tests-fix-a-typo-in-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-ksm_functional_tests-fix-a-typo-in-comment.patch

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
From: Xu Panda <xu.panda@zte.com.cn>
Subject: selftests/vm: ksm_functional_tests: fix a typo in comment
Date: Fri, 23 Dec 2022 10:50:24 +0800 (CST)

Fix a typo of "comaring" which should be "comparing".

Link: https://lkml.kernel.org/r/202212231050245952617@zte.com.cn
Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/tools/testing/selftests/vm/ksm_functional_tests.c~selftests-vm-ksm_functional_tests-fix-a-typo-in-comment
+++ a/tools/testing/selftests/vm/ksm_functional_tests.c
@@ -37,7 +37,7 @@ static bool range_maps_duplicates(char *
 	/*
 	 * There is no easy way to check if there are KSM pages mapped into
 	 * this range. We only check that the range does not map the same PFN
-	 * twice by comaring each pair of mapped pages.
+	 * twice by comparing each pair of mapped pages.
 	 */
 	for (offs_a = 0; offs_a < size; offs_a += pagesize) {
 		pfn_a = pagemap_get_pfn(pagemap_fd, addr + offs_a);
_

Patches currently in -mm which might be from xu.panda@zte.com.cn are

selftests-vm-ksm_functional_tests-fix-a-typo-in-comment.patch


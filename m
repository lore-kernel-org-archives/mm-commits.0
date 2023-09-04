Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E70FC83F2C
	for <mm-commits@archiver.kernel.org>; Mon,  4 Sep 2023 23:46:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233221AbjIDXqg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Sep 2023 19:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbjIDXqg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Sep 2023 19:46:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095B2CC5
        for <mm-commits@vger.kernel.org>; Mon,  4 Sep 2023 16:46:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE84BB80D1A
        for <mm-commits@vger.kernel.org>; Mon,  4 Sep 2023 23:46:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505B5C433C8;
        Mon,  4 Sep 2023 23:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693871190;
        bh=EckpInGuRyWyPghAmaubaxYqo1ni1WOG/Ll0zHykoi0=;
        h=Date:To:From:Subject:From;
        b=uvmMLD/m+RxYSNPhp3VWCWHfJgmmqO0mjTSxrXjkjxPvyDaSNOIdlnq3MLTX+6G52
         sfad62ph2i1i6LvQs2xPXm75mcXkH1+M44BAYSWgWAZpje64H3vojVgsuBbBGSGMZ+
         sZVN9nmzGMA6C0mIj1KMhykNsZiGY6eEq7xCPb0I=
Date:   Mon, 04 Sep 2023 16:46:29 -0700
To:     mm-commits@vger.kernel.org, mikhail.v.gavrilov@gmail.com,
        dave.hansen@linux.intel.com, bagasdotme@gmail.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-pagewalk-fix-bootstopping-regression-from-extra-pte_unmap.patch removed from -mm tree
Message-Id: <20230904234630.505B5C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/pagewalk: fix bootstopping regression from extra pte_unmap()
has been removed from the -mm tree.  Its filename was
     mm-pagewalk-fix-bootstopping-regression-from-extra-pte_unmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/pagewalk: fix bootstopping regression from extra pte_unmap()
Date: Sat, 2 Sep 2023 08:29:30 -0700 (PDT)

Mikhail reports early-6.6-based Fedora Rawhide not booting: "rcu_preempt
detected expedited stalls", minutes wait, and then hung_task splat while
kworker trying to synchronize_rcu_expedited().  Nothing logged to disk.

He bisected to my 6.6 a349d72fd9ef ("mm/pgtable: add rcu_read_lock() and
rcu_read_unlock()s"): but the one to blame is my 6.5 commit to fix the
espfix "bad pmd" warnings when booting x86_64 with CONFIG_EFI_PGT_DUMP=y.

Gaah, that added an "addr >= TASK_SIZE" check to avoid pte_offset_map(),
but failed to add the equivalent check when choosing to pte_unmap().

It's not a problem on 6.5 (for different reasons, it's harmless on both
64-bit and 32-bit), but becomes a bootstopper on 6.6 with the unbalanced
rcu_read_unlock() - RCU has a WARN_ON_ONCE for that, but it would have
scrolled off Mikhail's console too quickly.

Link: https://lkml.kernel.org/r/8321a347-4a38-526c-97fb-5999ceaf6dd@google.com
Fixes: 8b1cb4a2e819 ("mm/pagewalk: fix EFI_PGT_DUMP of espfix area")
Fixes: a349d72fd9ef ("mm/pgtable: add rcu_read_lock() and rcu_read_unlock()s")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Closes: https://lore.kernel.org/linux-mm/CABXGCsNi8Tiv5zUPNXr6UJw6qV1VdaBEfGqEAMkkXE3QPvZuAQ@mail.gmail.com/
Tested-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pagewalk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/pagewalk.c~mm-pagewalk-fix-bootstopping-regression-from-extra-pte_unmap
+++ a/mm/pagewalk.c
@@ -58,7 +58,7 @@ static int walk_pte_range(pmd_t *pmd, un
 			pte = pte_offset_map(pmd, addr);
 		if (pte) {
 			err = walk_pte_range_inner(pte, addr, end, walk);
-			if (walk->mm != &init_mm)
+			if (walk->mm != &init_mm && addr < TASK_SIZE)
 				pte_unmap(pte);
 		}
 	} else {
_

Patches currently in -mm which might be from hughd@google.com are



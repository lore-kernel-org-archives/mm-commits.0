Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E0A9EB64DD
	for <mm-commits@archiver.kernel.org>; Mon, 14 Aug 2023 20:19:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbjHNUSi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Aug 2023 16:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232348AbjHNUSH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Aug 2023 16:18:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0600C13E
        for <mm-commits@vger.kernel.org>; Mon, 14 Aug 2023 13:18:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E82061708
        for <mm-commits@vger.kernel.org>; Mon, 14 Aug 2023 20:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1ADBC433C7;
        Mon, 14 Aug 2023 20:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692044286;
        bh=c0lvKr6CIIOVDx7LQ6OYjLV9q4olySP+ysWGxAyF/ys=;
        h=Date:To:From:Subject:From;
        b=tTfVSAPBjT5U8WLahbODkPVOyH0P0r7Um6SQoBjfm0ynTGvthUS5McrDNJAw9owdn
         vCRAqrqPKF5kA/7zy4GO1O3NOjJK3Yp/5vuxElu1fvyjnby/V1YYSFjpfGM4wVsKKz
         Q/yty/tVD0YCDg8Bi0Z8pkJslR/1ws8TUy9TBSRs=
Date:   Mon, 14 Aug 2023 13:18:05 -0700
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmthp-fix-smaps-thpeligible-output-alignment.patch added to mm-unstable branch
Message-Id: <20230814201805.E1ADBC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,thp: fix smaps THPeligible output alignment
has been added to the -mm mm-unstable branch.  Its filename is
     mmthp-fix-smaps-thpeligible-output-alignment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmthp-fix-smaps-thpeligible-output-alignment.patch

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
From: Hugh Dickins <hughd@google.com>
Subject: mm,thp: fix smaps THPeligible output alignment
Date: Mon, 14 Aug 2023 13:02:08 -0700 (PDT)

Extract from current /proc/self/smaps output:

Swap:                  0 kB
SwapPss:               0 kB
Locked:                0 kB
THPeligible:    0
ProtectionKey:         0

That's not the alignment shown in Documentation/filesystems/proc.rst: it's
an ugly artifact from missing out the %8 other fields are using; but
there's even one selftest which expects it to look that way.  Hoping no
other smaps parsers depend on THPeligible to look so ugly, fix these.

Link: https://lkml.kernel.org/r/cfb81f7a-f448-5bc2-b0e1-8136fcd1dd8c@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c                           |    2 +-
 tools/testing/selftests/proc/proc-empty-vm.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/fs/proc/task_mmu.c~mmthp-fix-smaps-thpeligible-output-alignment
+++ a/fs/proc/task_mmu.c
@@ -860,7 +860,7 @@ static int show_smap(struct seq_file *m,
 
 	__show_smap(m, &mss, false);
 
-	seq_printf(m, "THPeligible:    %d\n",
+	seq_printf(m, "THPeligible:    %8u\n",
 		   hugepage_vma_check(vma, vma->vm_flags, true, false, true));
 
 	if (arch_pkeys_enabled())
--- a/tools/testing/selftests/proc/proc-empty-vm.c~mmthp-fix-smaps-thpeligible-output-alignment
+++ a/tools/testing/selftests/proc/proc-empty-vm.c
@@ -77,7 +77,7 @@ static const char proc_pid_smaps_vsyscal
 "Swap:                  0 kB\n"
 "SwapPss:               0 kB\n"
 "Locked:                0 kB\n"
-"THPeligible:    0\n"
+"THPeligible:           0\n"
 /*
  * "ProtectionKey:" field is conditional. It is possible to check it as well,
  * but I don't have such machine.
@@ -107,7 +107,7 @@ static const char proc_pid_smaps_vsyscal
 "Swap:                  0 kB\n"
 "SwapPss:               0 kB\n"
 "Locked:                0 kB\n"
-"THPeligible:    0\n"
+"THPeligible:           0\n"
 /*
  * "ProtectionKey:" field is conditional. It is possible to check it as well,
  * but I'm too tired.
_

Patches currently in -mm which might be from hughd@google.com are

arm-include-asm-cacheflushh-in-asm-hugetlbh.patch
arm64-include-asm-cacheflushh-in-asm-hugetlbh.patch
riscv-include-asm-cacheflushh-in-asm-hugetlbh.patch
mmthp-no-space-after-colon-in-mem-info-fields.patch
mmthp-fix-noden-meminfo-output-alignment.patch
mmthp-fix-smaps-thpeligible-output-alignment.patch


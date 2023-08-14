Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DA69EB64DD
	for <mm-commits@archiver.kernel.org>; Mon, 14 Aug 2023 20:18:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232347AbjHNUSH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Aug 2023 16:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232373AbjHNUSG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Aug 2023 16:18:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 411F8BC
        for <mm-commits@vger.kernel.org>; Mon, 14 Aug 2023 13:18:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D34EB61708
        for <mm-commits@vger.kernel.org>; Mon, 14 Aug 2023 20:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 343D0C433C8;
        Mon, 14 Aug 2023 20:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692044284;
        bh=cBmTTh5aPZfrBWEEDfK3hmIMZjJJISjyGLrff/TzWXU=;
        h=Date:To:From:Subject:From;
        b=t7jmZXfRs03m3RIENXEEzLKJXLxntom5G6KWDKRbPdKuidbLpFEHOxabfSBhrR1xe
         OGU8wR7U+9wJXnLhXHZfNVH+QOeIo++tK/c615QjurOdZhIxpVfu9hQpWIKNkvye2r
         4tjPJcgmbMHcL0IUi86YUv8qnFKA6YKncHtGzwAQ=
Date:   Mon, 14 Aug 2023 13:18:03 -0700
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmthp-fix-noden-meminfo-output-alignment.patch added to mm-unstable branch
Message-Id: <20230814201804.343D0C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,thp: fix nodeN/meminfo output alignment
has been added to the -mm mm-unstable branch.  Its filename is
     mmthp-fix-noden-meminfo-output-alignment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmthp-fix-noden-meminfo-output-alignment.patch

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
Subject: mm,thp: fix nodeN/meminfo output alignment
Date: Mon, 14 Aug 2023 13:01:12 -0700 (PDT)

Add one more space to FileHugePages and FilePmdMapped, so the output is
aligned with other rows in /sys/devices/system/node/nodeN/meminfo.

Link: https://lkml.kernel.org/r/be861b50-a790-e041-bcb0-2a987dcfd1a@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/base/node.c~mmthp-fix-noden-meminfo-output-alignment
+++ a/drivers/base/node.c
@@ -446,8 +446,8 @@ static ssize_t node_read_meminfo(struct
 			     "Node %d AnonHugePages:  %8lu kB\n"
 			     "Node %d ShmemHugePages: %8lu kB\n"
 			     "Node %d ShmemPmdMapped: %8lu kB\n"
-			     "Node %d FileHugePages: %8lu kB\n"
-			     "Node %d FilePmdMapped: %8lu kB\n"
+			     "Node %d FileHugePages:  %8lu kB\n"
+			     "Node %d FilePmdMapped:  %8lu kB\n"
 #endif
 #ifdef CONFIG_UNACCEPTED_MEMORY
 			     "Node %d Unaccepted:     %8lu kB\n"
_

Patches currently in -mm which might be from hughd@google.com are

arm-include-asm-cacheflushh-in-asm-hugetlbh.patch
arm64-include-asm-cacheflushh-in-asm-hugetlbh.patch
riscv-include-asm-cacheflushh-in-asm-hugetlbh.patch
mmthp-no-space-after-colon-in-mem-info-fields.patch
mmthp-fix-noden-meminfo-output-alignment.patch
mmthp-fix-smaps-thpeligible-output-alignment.patch


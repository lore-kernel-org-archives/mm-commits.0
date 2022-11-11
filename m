Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE11AC43217
	for <mm-commits@archiver.kernel.org>; Fri, 11 Nov 2022 22:42:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232979AbiKKWm3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Nov 2022 17:42:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232943AbiKKWm3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Nov 2022 17:42:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE21BF4C
        for <mm-commits@vger.kernel.org>; Fri, 11 Nov 2022 14:42:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0730662117
        for <mm-commits@vger.kernel.org>; Fri, 11 Nov 2022 22:42:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58590C433C1;
        Fri, 11 Nov 2022 22:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668206547;
        bh=WfY6c8gE3Yan0XgpMQg8ngDHIIX4LtQjWZMgOoTrxv0=;
        h=Date:To:From:Subject:From;
        b=yV4h+X3WnsO/w3ewndPinG1GTjdnJkK9NtgeBqtaSZGfk0uYq/Shg6Jz/+KFGoswa
         cY2PcjZbo8Gv7AsxVTWnJavlBcTfRRA/NFMZ/h9YhYhgTtwgAu4S2Pe5PxlQMHiepP
         OfhmtSqchDSGcR+iC4BwJWiAmKHrkPvqGbkKJ7AM=
Date:   Fri, 11 Nov 2022 14:42:26 -0800
To:     mm-commits@vger.kernel.org, wenjian1@xiaomi.com,
        wenjianhn@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-cgroup-v1-update-description-of-inactive_file.patch added to mm-unstable branch
Message-Id: <20221111224227.58590C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: docs: admin-guide: cgroup-v1: update description of inactive_file
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-cgroup-v1-update-description-of-inactive_file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-cgroup-v1-update-description-of-inactive_file.patch

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
From: Jian Wen <wenjianhn@gmail.com>
Subject: docs: admin-guide: cgroup-v1: update description of inactive_file
Date: Fri, 11 Nov 2022 11:46:39 +0800

MADV_FREE pages have been moved into the LRU_INACTIVE_FILE list by commit
f7ad2a6cb9f7 ("mm: move MADV_FREE pages into LRU_INACTIVE_FILE list").

Link: https://lkml.kernel.org/r/20221111034639.3593380-1-wenjian1@xiaomi.com
Signed-off-by: Jian Wen <wenjian1@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v1/memory.rst |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/cgroup-v1/memory.rst~docs-admin-guide-cgroup-v1-update-description-of-inactive_file
+++ a/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -543,7 +543,8 @@ inactive_anon	# of bytes of anonymous an
 		LRU list.
 active_anon	# of bytes of anonymous and swap cache memory on active
 		LRU list.
-inactive_file	# of bytes of file-backed memory on inactive LRU list.
+inactive_file	# of bytes of file-backed memory and MADV_FREE anonymous memory(
+                LazyFree pages) on inactive LRU list.
 active_file	# of bytes of file-backed memory on active LRU list.
 unevictable	# of bytes of memory that cannot be reclaimed (mlocked etc).
 =============== ===============================================================
_

Patches currently in -mm which might be from wenjianhn@gmail.com are

docs-admin-guide-cgroup-v1-update-description-of-inactive_file.patch


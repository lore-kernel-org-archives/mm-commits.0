Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E64FEC4167B
	for <mm-commits@archiver.kernel.org>; Tue,  7 Nov 2023 17:33:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343831AbjKGRd3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Nov 2023 12:33:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343901AbjKGRd1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Nov 2023 12:33:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B61129
        for <mm-commits@vger.kernel.org>; Tue,  7 Nov 2023 09:33:25 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBAE2C433C7;
        Tue,  7 Nov 2023 17:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699378405;
        bh=k2AIRF9LKstKXKJs+pfL1eqEgTmedx8oSi+PIOOIBGI=;
        h=Date:To:From:Subject:From;
        b=jrwJvlJICRrymPpeC7aTACgswcVMjgWjwDZ8WXu2quEB6YTWZAw8H8YNheUVMuaSg
         F9x4OKnYaPMC9TAjg5d8Nv4js5IY1uu2m+WqIaouqHyrCi41MukM7TsOU4pu9krFQC
         LAn5Qg16SX2yz0QB7EVRJw7Gh7qD+Vb6LGZOGd2M=
Date:   Tue, 07 Nov 2023 09:33:24 -0800
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        mirq-linux@rere.qmqm.pl, avagin@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-report-soft_dirty-bits-through-the-pagemap_scan-ioctl-v3.patch added to mm-unstable branch
Message-Id: <20231107173324.EBAE2C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs-proc-task_mmu-report-soft_dirty-bits-through-the-pagemap_scan-ioctl-v3
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-task_mmu-report-soft_dirty-bits-through-the-pagemap_scan-ioctl-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-report-soft_dirty-bits-through-the-pagemap_scan-ioctl-v3.patch

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
From: Andrei Vagin <avagin@google.com>
Subject: fs-proc-task_mmu-report-soft_dirty-bits-through-the-pagemap_scan-ioctl-v3
Date: Tue, 7 Nov 2023 08:41:37 -0800

update tools/include/uapi/linux/fs.h

Link: https://lkml.kernel.org/r/20231107164139.576046-1-avagin@google.com
Signed-off-by: Andrei Vagin <avagin@google.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/include/uapi/linux/fs.h |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/include/uapi/linux/fs.h~fs-proc-task_mmu-report-soft_dirty-bits-through-the-pagemap_scan-ioctl-v3
+++ a/tools/include/uapi/linux/fs.h
@@ -316,6 +316,7 @@ typedef int __bitwise __kernel_rwf_t;
 #define PAGE_IS_SWAPPED		(1 << 4)
 #define PAGE_IS_PFNZERO		(1 << 5)
 #define PAGE_IS_HUGE		(1 << 6)
+#define PAGE_IS_SOFT_DIRTY	(1 << 7)
 
 /*
  * struct page_region - Page region with flags
_

Patches currently in -mm which might be from avagin@google.com are

fs-proc-task_mmu-report-soft_dirty-bits-through-the-pagemap_scan-ioctl.patch
fs-proc-task_mmu-report-soft_dirty-bits-through-the-pagemap_scan-ioctl-v3.patch
selftests-mm-check-that-pagemap_scan-returns-correct-categories.patch


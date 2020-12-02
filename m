Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5A24C64E7B
	for <mm-commits@archiver.kernel.org>; Wed,  2 Dec 2020 23:12:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93F56221FB
	for <mm-commits@archiver.kernel.org>; Wed,  2 Dec 2020 23:12:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbgLBXMe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Dec 2020 18:12:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:41416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726253AbgLBXMe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 2 Dec 2020 18:12:34 -0500
Date:   Wed, 02 Dec 2020 15:11:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606950713;
        bh=B4zdjPIKcUclIghFe8A/eHB3vFICMx5pXWnlVtEXq1Q=;
        h=From:To:Subject:From;
        b=imrZ6H4Dn9jcK9JQYR//SN9lpe3itHYVIaX9dZsfXrg8XRrJ6heV4k3f3ZInXp8Yu
         o2/7RURcIa0DtbUbJGN8VUibLmYZ8m25ZrNUhJSVGsT65Mhex8gvh0koV1CgkJrmn2
         CVnUNwI2XcTSV6KTWmn5eb6SQhfeDG51UI+CXb9s=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, carver4lio@163.com,
        liu.hailong6@zte.com.cn, mm-commits@vger.kernel.org
Subject:  +
 mm-remove-the-unuseful-else-after-a-return-checkpatch-fixes.patch added to
 -mm tree
Message-ID: <20201202231152.YpvdK2_Zu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-remove-the-unuseful-else-after-a-return-fix
has been added to the -mm tree.  Its filename is
     mm-remove-the-unuseful-else-after-a-return-checkpatch-fixes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-the-unuseful-else-after-a-return-checkpatch-fixes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-the-unuseful-else-after-a-return-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-remove-the-unuseful-else-after-a-return-fix

fix coding style while we're in there

Cc: Hailong Liu <carver4lio@163.com>
Cc: Hailong Liu<liu.hailong6@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/filemap.c~mm-remove-the-unuseful-else-after-a-return-checkpatch-fixes
+++ a/mm/filemap.c
@@ -1592,8 +1592,9 @@ int __lock_page_or_retry(struct page *pa
 			mmap_read_unlock(mm);
 			return 0;
 		}
-	} else
+	} else {
 		__lock_page(page);
+	}
 	return 1;
 
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kthread_worker-document-cpu-hotplug-handling-fix.patch
mm.patch
mm-remove-the-unuseful-else-after-a-return-checkpatch-fixes.patch
mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
mm-truncateshmem-handle-truncates-that-split-thps-fix-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix.patch
ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
resource-fix-kernel-doc-markups-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85400C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 02:14:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 341E9206E9
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 02:14:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgLOCNx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 21:13:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:40274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726348AbgLOCNo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 21:13:44 -0500
Date:   Mon, 14 Dec 2020 18:12:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607998377;
        bh=D1tKDmyrwOooXSeePGtkErXLOtMYjKdCcuxSR40G0UQ=;
        h=From:To:Subject:From;
        b=jhQoq+6mBSEyyxYY02SRgXRyOzkYOkdQgYVlC/zlhSL+Sd866I7XBu1exM68FvK5U
         Cx8/0+asBdXHW5DTxfa5No3QBZFFDIK8t8sJIHOcF5AjXeV6roldGPsAr/38u3exmq
         Y2KxMiIhq2C6p9OSTE3FKnxyDMaYxKjUWRwAuktw=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, carver4lio@163.com,
        liu.hailong6@zte.com.cn, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 mm-remove-the-unuseful-else-after-a-return-checkpatch-fixes.patch removed
 from -mm tree
Message-ID: <20201215021257.uND46KPfE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-remove-the-unuseful-else-after-a-return-fix
has been removed from the -mm tree.  Its filename was
     mm-remove-the-unuseful-else-after-a-return-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-remove-the-unuseful-else-after-a-return.patch

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

mm-remove-the-unuseful-else-after-a-return.patch
mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-memcontrol-account-pagetables-per-node-fix.patch
mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
mm-cma-improve-pr_debug-log-in-cma_release-fix.patch
mm.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix.patch
ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
checkpatch-fix-typo_spelling-check-for-words-with-apostrophe-fix.patch
resource-fix-kernel-doc-markups-checkpatch-fixes.patch
lib-ubsanc-mark-type_check_kinds-with-static-keyword-fix.patch
linux-next-rejects.patch
kmap-stupid-hacks-to-make-it-compile.patch
epoll-wire-up-syscall-epoll_pwait2-fix.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch


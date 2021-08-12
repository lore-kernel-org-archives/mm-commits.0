Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21245C4338F
	for <mm-commits@archiver.kernel.org>; Thu, 12 Aug 2021 21:11:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2F1560F57
	for <mm-commits@archiver.kernel.org>; Thu, 12 Aug 2021 21:11:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233214AbhHLVLq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Aug 2021 17:11:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231270AbhHLVLq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Aug 2021 17:11:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A23BF6101E;
        Thu, 12 Aug 2021 21:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628802680;
        bh=MrEubSSE0CsC7QSdZ3xi4m2RJGLbc+69PLB862Rk/7o=;
        h=Date:From:To:Subject:From;
        b=PCLOVUubdFrCIuvb5S3KJyQI0jrvg0din0IJEUXvn5OnQeIGlttVhfRlc7dZ89XMr
         U/QZH3Cvu2KLcA25nuKiglkri+d2P9hMIJOTQ4r128+d770UUXvJagPgqnqdOMrgkp
         IQUSvFXrwUUrIwQ2zQ2RNsDkhFuwlsEjBeLdY4DI=
Date:   Thu, 12 Aug 2021 14:11:20 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, hughd@google.com, linmiaohe@huawei.com
Subject:  + shmem-remove-unneeded-variable-ret.patch added to -mm
 tree
Message-ID: <20210812211120.ZSVZv%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: remove unneeded variable ret
has been added to the -mm tree.  Its filename is
     shmem-remove-unneeded-variable-ret.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/shmem-remove-unneeded-variable-ret.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/shmem-remove-unneeded-variable-ret.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: shmem: remove unneeded variable ret

Patch series "Cleanups for shmem".

This series contains cleanups to remove unneeded variable, header file,
function forward declaration and so on.  More details can be found in the
respective changelogs.


This patch (of 4):

The local variable ret is always equal to -ENOMEM and never touched.  So
remove it and return -ENOMEM directly to simplify the code.

Link: https://lkml.kernel.org/r/20210812120350.49801-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210812120350.49801-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/shmem.c~shmem-remove-unneeded-variable-ret
+++ a/mm/shmem.c
@@ -3616,7 +3616,6 @@ static int shmem_fill_super(struct super
 	struct shmem_options *ctx = fc->fs_private;
 	struct inode *inode;
 	struct shmem_sb_info *sbinfo;
-	int err = -ENOMEM;
 
 	/* Round up to L1_CACHE_BYTES to resist false sharing */
 	sbinfo = kzalloc(max((int)sizeof(struct shmem_sb_info),
@@ -3694,7 +3693,7 @@ static int shmem_fill_super(struct super
 
 failed:
 	shmem_put_super(sb);
-	return err;
+	return -ENOMEM;
 }
 
 static int shmem_get_tree(struct fs_context *fc)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-gup-remove-set-but-unused-local-variable-major.patch
mm-gup-remove-unneed-local-variable-orig_refs.patch
mm-gup-remove-useless-bug_on-in-__get_user_pages.patch
mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge.patch
mm-gup-use-helper-page_aligned-in-populate_vma_page_range.patch
shmem-remove-unneeded-variable-ret.patch
shmem-remove-unneeded-header-file.patch
shmem-remove-unneeded-function-forward-declaration.patch
shmem-include-header-file-to-declare-swap_info.patch
mm-memcg-remove-unused-functions.patch
mm-memcg-save-some-atomic-ops-when-flush-is-already-true.patch
mm-vmscan-remove-the-pagedirty-check-after-madv_free-pages-are-page_ref_freezed.patch
mm-vmscan-remove-misleading-setting-to-sc-priority.patch
mm-vmscan-remove-unneeded-return-value-of-kswapd_run.patch
mm-vmscan-add-else-to-remove-check_pending-label.patch
mm-vmstat-correct-some-wrong-comments.patch
mm-vmstat-simplify-the-array-size-calculation.patch
mm-vmstat-remove-unneeded-return-value.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch


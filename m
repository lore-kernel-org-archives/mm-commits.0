Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C5F6C00140
	for <mm-commits@archiver.kernel.org>; Wed, 10 Aug 2022 23:40:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbiHJXkf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Aug 2022 19:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiHJXke (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 10 Aug 2022 19:40:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6EDB21
        for <mm-commits@vger.kernel.org>; Wed, 10 Aug 2022 16:40:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 440D4B81D92
        for <mm-commits@vger.kernel.org>; Wed, 10 Aug 2022 23:40:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02DD8C433D6;
        Wed, 10 Aug 2022 23:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660174830;
        bh=oP2JQQeAygKilKppCVXRYZ30HKba+wO2h5gnCUd/jTk=;
        h=Date:To:From:Subject:From;
        b=Q1HqnUq1jR4ZS5RW4cbpWPJmuLhogE4bmahZcQj5faioY8HQxMcEDJa94FDROJ//x
         5ee2VuHc1/LJancjZ/3bZeeCjbVVQM3VUCgElAB23IcuzqkL8ehs021VAX6FIKIH0C
         mtLRLMAeOUQ5wehoP/wxU7k9rVBcoofu7JNvO/eU=
Date:   Wed, 10 Aug 2022 16:40:29 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, slava@dubeyko.com, keescook@chromium.org,
        ira.weiny@intel.com, bvanassche@acm.org, axboe@kernel.dk,
        fmdefrancesco@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hfsplus-unmap-the-page-in-the-fail_page-label.patch added to mm-nonmm-unstable branch
Message-Id: <20220810234030.02DD8C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus: unmap the page in the "fail_page" label
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hfsplus-unmap-the-page-in-the-fail_page-label.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hfsplus-unmap-the-page-in-the-fail_page-label.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Subject: hfsplus: unmap the page in the "fail_page" label
Date: Tue, 9 Aug 2022 22:31:02 +0200

Patch series "hfsplus: Replace kmap() with kmap_local_page()".

kmap() is being deprecated in favor of kmap_local_page().

There are two main problems with kmap(): (1) It comes with an overhead as
mapping space is restricted and protected by a global lock for
synchronization and (2) it also requires global TLB invalidation when the
kmap’s pool wraps and it might block when the mapping space is fully
utilized until a slot becomes available.

With kmap_local_page() the mappings are per thread, CPU local, can take
page faults, and can be called from any context (including interrupts). 
It is faster than kmap() in kernels with HIGHMEM enabled.  Furthermore,
the tasks can be preempted and, when they are scheduled to run again, the
kernel virtual addresses are restored and still valid.

Since its use in fs/hfsplus is safe everywhere, it should be preferred.

Therefore, replace kmap() with kmap_local_page() in fs/hfsplus.  Where
possible, use the suited standard helpers (memzero_page(), memcpy_page())
instead of open coding kmap_local_page() plus memset() or memcpy().

Fix a bug due to a page being not unmapped if the code jumps to the
"fail_page" label (1/4).

Tested in a QEMU/KVM x86_32 VM, 6GB RAM, booting a kernel with
HIGHMEM64GB enabled.


This patch (of 4):

Several paths within hfs_btree_open() jump to the "fail_page" label where
put_page() is called while the page is still mapped.

Call kunmap() to unmap the page soon before put_page().

Link: https://lkml.kernel.org/r/20220809203105.26183-1-fmdefrancesco@gmail.com
Link: https://lkml.kernel.org/r/20220809203105.26183-2-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/btree.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/hfsplus/btree.c~hfsplus-unmap-the-page-in-the-fail_page-label
+++ a/fs/hfsplus/btree.c
@@ -245,6 +245,7 @@ struct hfs_btree *hfs_btree_open(struct
 	return tree;
 
  fail_page:
+	kunmap(page);
 	put_page(page);
  free_inode:
 	tree->inode->i_mapping->a_ops = &hfsplus_aops;
_

Patches currently in -mm which might be from fmdefrancesco@gmail.com are

hfsplus-unmap-the-page-in-the-fail_page-label.patch
hfsplus-convert-kmap-to-kmap_local_page-in-bnodec.patch
hfsplus-convert-kmap-to-kmap_local_page-in-bitmapc.patch
hfsplus-convert-kmap-to-kmap_local_page-in-btreec.patch


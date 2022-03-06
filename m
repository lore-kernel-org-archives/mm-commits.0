Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BF3AC433EF
	for <mm-commits@archiver.kernel.org>; Sun,  6 Mar 2022 23:55:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbiCFX4Q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 6 Mar 2022 18:56:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiCFX4P (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 6 Mar 2022 18:56:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C7958E7A
        for <mm-commits@vger.kernel.org>; Sun,  6 Mar 2022 15:55:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30A59610A3
        for <mm-commits@vger.kernel.org>; Sun,  6 Mar 2022 23:55:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE91C340EF;
        Sun,  6 Mar 2022 23:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646610921;
        bh=CXwNo0FE8AWRu+jTqeYK+ZPuJ8Lbu137g1qOedFF0AA=;
        h=Date:To:From:Subject:From;
        b=Da9EP7okIUQMabvUOrRlin/3LY+wfI7sAIKo1MBHjghweBUAnqX0XPrZ3wMRxqX80
         SDsoJebrm68Wy51ptRo9tz2dU6QwSYY2nemJLYp8qvrru4F3WpLaucEBzQGfkIzF2R
         wHV+MTwyDU6NrXo5EXeea3UFNDWIMFlfp0ja86gs=
Date:   Sun, 06 Mar 2022 15:55:20 -0800
To:     mm-commits@vger.kernel.org, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-mapping_set_exiting-to-help-mapped-resilience.patch added to -mm tree
Message-Id: <20220306235521.8BE91C340EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: mapping_set_exiting() to help mapped resilience
has been added to the -mm tree.  Its filename is
     shmem-mapping_set_exiting-to-help-mapped-resilience.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/shmem-mapping_set_exiting-to-help-mapped-resilience.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/shmem-mapping_set_exiting-to-help-mapped-resilience.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: shmem: mapping_set_exiting() to help mapped resilience

When I added page_mapped() resilience in __delete_from_page_cache() for
the mapping_exiting() case, I missed that mapping_set_exiting() is done in
truncate_inode_pages_final(), which is not actually called for shmem. 
(Today, it is folio_mapped() resilience in filemap_unaccount_folio().)

So the fixup to avoid a memory leak in this case never worked on shmem:
add a mapping_set_exiting() in shmem_evict_inode() at last.  But this is
hardly a candidate for stable, since it's only useful if "Bad page".

Link: https://lkml.kernel.org/r/beefffda-6326-e36d-2d41-ed15b51af872@google.com
Fixes: 06b241f32c71 ("mm: __delete_from_page_cache show Bad page if mapped")
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/shmem.c~shmem-mapping_set_exiting-to-help-mapped-resilience
+++ a/mm/shmem.c
@@ -1129,6 +1129,7 @@ static void shmem_evict_inode(struct ino
 	if (shmem_mapping(inode->i_mapping)) {
 		shmem_unacct_size(info->flags, inode->i_size);
 		inode->i_size = 0;
+		mapping_set_exiting(inode->i_mapping);
 		shmem_truncate_range(inode, 0, (loff_t)-1);
 		if (!list_empty(&info->shrinklist)) {
 			spin_lock(&sbinfo->shrinklist_lock);
_

Patches currently in -mm which might be from hughd@google.com are

mm-fs-delete-pf_swapwrite.patch
mm-delete-__clearpagewaiters.patch
tmpfs-support-for-file-creation-time-fix.patch
shmem-mapping_set_exiting-to-help-mapped-resilience.patch
mm-_install_special_mapping-apply-vm_locked_clear_mask.patch
mm-thp-refix-__split_huge_pmd_locked-for-migration-pmd.patch
mm-thp-clearpagedoublemap-in-first-page_add_file_rmap.patch
mm-thp-fix-nr_file_mapped-accounting-in-page__file_rmap.patch


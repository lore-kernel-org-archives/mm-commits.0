Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3F37C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:30:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357334AbiCYBb5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357343AbiCYBbt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:31:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BEB937BE8
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:30:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 519BBB82726
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:30:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14BA8C340ED;
        Fri, 25 Mar 2022 01:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171808;
        bh=xuKwwhjLSgc3j9wAIymm1DxGhnhRxR6JCOGVvz6i3dc=;
        h=Date:To:From:Subject:From;
        b=R0pqSd6pHRa8vwhOL9jT9R9fPE5agjyu1ezjX+9ZNTJagXNYJhlMASl5bCGAPB/SN
         aPcmZbreNgXLp8HOebwxPbreVASRqFC45wJHmjc0aBnI6HucnMfxX/zox9OZpM3SZ/
         gcXDIuLS19YULu4o324WFXVLUHOaDMNh14F8grgI=
Date:   Thu, 24 Mar 2022 18:30:07 -0700
To:     mm-commits@vger.kernel.org, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] shmem-mapping_set_exiting-to-help-mapped-resilience.patch removed from -mm tree
Message-Id: <20220325013008.14BA8C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: mapping_set_exiting() to help mapped resilience
has been removed from the -mm tree.  Its filename was
     shmem-mapping_set_exiting-to-help-mapped-resilience.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm-delete-__clearpagewaiters.patch
mm-filemap_unaccount_folio-large-skip-mapcount-fixup.patch
mm-thp-fix-nr_file_mapped-accounting-in-page__file_rmap.patch
mm-warn-on-deleting-redirtied-only-if-accounted.patch
mm-unmap_mapping_range_tree-with-i_mmap_rwsem-shared.patch


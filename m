Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90D96C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:40:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235861AbiCVVle (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236071AbiCVVlc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:41:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 269EA5E77C
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:40:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF3B7B81D9E
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:40:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C97C340EC;
        Tue, 22 Mar 2022 21:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985199;
        bh=WwkNuOjD3DZPNyweqoSPUm+7FixY1iuGDWC8FvdWHQE=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=S8WEkbVc++ytJtd8t6sAEtqoJLZlKhwLjg5pm0/AFmTKXWS46OX8rc4qbNO76X5Xs
         mNMT5oOLF+GA3mWPhFP1fWfM+xcxSozwxJl6m75pqGMgpOxwT+/gO/u/Yikl2GSf+u
         jK3PxN4Oo/sot7853ON+MWMPLl/qFqwdaDGTObk4=
Date:   Tue, 22 Mar 2022 14:39:58 -0700
To:     hughd@google.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 029/227] shmem: mapping_set_exiting() to help mapped resilience
Message-Id: <20220322213959.80C97C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3389CEE49AF
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:42:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbjHUUmH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbjHUUlE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:41:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259E4CF5
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06EA46156C
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D30C433C7;
        Mon, 21 Aug 2023 20:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650445;
        bh=TPbdEfQtXT3aF+4qgob7eh1J+B9un71y4ao2qRMXgqA=;
        h=Date:To:From:Subject:From;
        b=eBskeF2HD3XqRTOs5YPWa5q8PJaYtnDUZqDCiAbbJczq9hSj0exUYFpwaRaVLY8fr
         CW1RcBwBUo3A4mGk4lSTqesDbSs6ejoRE0cJzaIj+kQNY0HeiVjmc50549E6+imswg
         oFOJrFlRTiHrr/1gQDZytKKUtaysSr4n4HTOiJs0=
Date:   Mon, 21 Aug 2023 13:40:44 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        nphamcs@gmail.com, xiujianfeng@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-update-comment-for-struct-zswap_entry.patch removed from -mm tree
Message-Id: <20230821204045.59D30C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: zswap: update comment for struct zswap_entry
has been removed from the -mm tree.  Its filename was
     mm-zswap-update-comment-for-struct-zswap_entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xiu Jianfeng <xiujianfeng@huawei.com>
Subject: mm: zswap: update comment for struct zswap_entry
Date: Tue, 8 Aug 2023 06:20:56 +0000

Since commit 0bb488498c98 ("mm: zswap: remove zswap_header"), the 'offset'
has been replaced by swpentry, update the comment for it, and also add
comment for 'objcg'.

Link: https://lkml.kernel.org/r/20230808062056.292950-1-xiujianfeng@huaweicloud.com
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-update-comment-for-struct-zswap_entry
+++ a/mm/zswap.c
@@ -182,7 +182,7 @@ struct zswap_pool {
  * page within zswap.
  *
  * rbnode - links the entry into red-black tree for the appropriate swap type
- * offset - the swap offset for the entry.  Index into the red-black tree.
+ * swpentry - associated swap entry, the offset indexes into the red-black tree
  * refcount - the number of outstanding reference to the entry. This is needed
  *            to protect against premature freeing of the entry by code
  *            concurrent calls to load, invalidate, and writeback.  The lock
@@ -195,6 +195,7 @@ struct zswap_pool {
  * pool - the zswap_pool the entry's data is in
  * handle - zpool allocation handle that stores the compressed page data
  * value - value of the same-value filled pages which have same content
+ * objcg - the obj_cgroup that the compressed memory is charged to
  * lru - handle to the pool's lru used to evict pages.
  */
 struct zswap_entry {
_

Patches currently in -mm which might be from xiujianfeng@huawei.com are



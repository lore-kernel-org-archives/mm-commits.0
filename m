Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11022C001B0
	for <mm-commits@archiver.kernel.org>; Tue,  8 Aug 2023 19:57:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjHHT5p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Aug 2023 15:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234586AbjHHT5C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Aug 2023 15:57:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A40E61BAD9
        for <mm-commits@vger.kernel.org>; Tue,  8 Aug 2023 11:11:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4468162992
        for <mm-commits@vger.kernel.org>; Tue,  8 Aug 2023 18:11:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943ACC433C8;
        Tue,  8 Aug 2023 18:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691518265;
        bh=sv86/piTUaY8zD74RzSNN2RprWemKplrHNuMAtcWKPs=;
        h=Date:To:From:Subject:From;
        b=qOTEiyO7ot6Yerxuijw8VenNAFXJTODXvar2NLSDAUjYGGl+xG/v//p0ZoZsPKIyZ
         qb3t7dnzwyRHoafPepe/kTvPHhhFsUTe4StxFIl1x0PA0QRwoFsZuELCsA5Lzabkw6
         M2UqxvHXjVKBUQBvH/hD6EQOnyEpRLSbjHHFyPvE=
Date:   Tue, 08 Aug 2023 11:11:04 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        nphamcs@gmail.com, xiujianfeng@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-update-comment-for-struct-zswap_entry.patch added to mm-unstable branch
Message-Id: <20230808181105.943ACC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: zswap: update comment for struct zswap_entry
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-update-comment-for-struct-zswap_entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-update-comment-for-struct-zswap_entry.patch

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

mm-zswap-update-comment-for-struct-zswap_entry.patch


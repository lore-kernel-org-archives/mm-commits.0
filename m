Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F823EE49AF
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:44:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbjHUUoQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbjHUUn3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:43:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C35180
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:42:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B666A64B13
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:42:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17281C433C7;
        Mon, 21 Aug 2023 20:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650525;
        bh=jDaZEOFf/Q74BVHPWPIKAr6K4v56VQ5dXu/210OAqP0=;
        h=Date:To:From:Subject:From;
        b=rKbSTu6c62As1Ao/kZX2WcLHzmL8ELliBPvWUnepL6ztAYKS+eDRgQkkkaUXggIPG
         y+1Scg/5TW6QKLCWJv4NS7Z33cdFgROgf5K3YayLfv5mvHxgdSCy7+m7XJ+JA235FK
         gwDDzgKaPu1tPHvYpIyA3+lN42dorqR+yjFCisf8=
Date:   Mon, 21 Aug 2023 13:42:04 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, shr@devkernel.io,
        xiujianfeng@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] writeback-remove-unused-delaration-of-bdi_async_bio_wq.patch removed from -mm tree
Message-Id: <20230821204205.17281C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: writeback: remove unused delaration of bdi_async_bio_wq
has been removed from the -mm tree.  Its filename was
     writeback-remove-unused-delaration-of-bdi_async_bio_wq.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xiu Jianfeng <xiujianfeng@huawei.com>
Subject: writeback: remove unused delaration of bdi_async_bio_wq
Date: Sat, 12 Aug 2023 11:01:28 +0000

It seems it was introduced by commit d3f77dfdc718 ("blkcg: implement
REQ_CGROUP_PUNT") unintentionally, but the definition does not exist,
remove it.

Link: https://lkml.kernel.org/r/20230812110128.482650-1-xiujianfeng@huaweicloud.com
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Stefan Roesch <shr@devkernel.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/backing-dev.h~writeback-remove-unused-delaration-of-bdi_async_bio_wq
+++ a/include/linux/backing-dev.h
@@ -46,7 +46,6 @@ extern spinlock_t bdi_lock;
 extern struct list_head bdi_list;
 
 extern struct workqueue_struct *bdi_wq;
-extern struct workqueue_struct *bdi_async_bio_wq;
 
 static inline bool wb_has_dirty_io(struct bdi_writeback *wb)
 {
_

Patches currently in -mm which might be from xiujianfeng@huawei.com are



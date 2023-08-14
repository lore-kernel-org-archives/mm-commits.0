Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EFC8EB64DD
	for <mm-commits@archiver.kernel.org>; Mon, 14 Aug 2023 20:22:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbjHNUWW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Aug 2023 16:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232138AbjHNUVy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Aug 2023 16:21:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B9711D
        for <mm-commits@vger.kernel.org>; Mon, 14 Aug 2023 13:21:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EFDD626BE
        for <mm-commits@vger.kernel.org>; Mon, 14 Aug 2023 20:21:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A5DC433C8;
        Mon, 14 Aug 2023 20:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692044512;
        bh=uwY627XoTEimvU0KQ5rrjr1aC/3eVxaFEoJZMuxZ7uU=;
        h=Date:To:From:Subject:From;
        b=goWRBHeEgESuZZFG/Q5GYeQgb+VIirWvQdJmAYgt0KTbRPhli5itvVngAdiCX7Xb0
         d4GbT3OkQ5Fog1Wu2pcyWhQDAVb43bXOY6Smao7OVr87kJFL0p+k6ZgdPsmjwzq9+v
         2f9m0gbP+aog3Gbh7pasKWTbSrj61D8/Kjmj14wg=
Date:   Mon, 14 Aug 2023 13:21:51 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, shr@devkernel.io,
        xiujianfeng@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-remove-unused-delaration-of-bdi_async_bio_wq.patch added to mm-unstable branch
Message-Id: <20230814202152.81A5DC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: writeback: remove unused delaration of bdi_async_bio_wq
has been added to the -mm mm-unstable branch.  Its filename is
     writeback-remove-unused-delaration-of-bdi_async_bio_wq.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-remove-unused-delaration-of-bdi_async_bio_wq.patch

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
Subject: writeback: remove unused delaration of bdi_async_bio_wq
Date: Sat, 12 Aug 2023 11:01:28 +0000

It seems it was introduced by commit d3f77dfdc718 ("blkcg: implement
REQ_CGROUP_PUNT") unintentionally, but the definition does not exist,
remove it.

Link: https://lkml.kernel.org/r/20230812110128.482650-1-xiujianfeng@huaweicloud.com
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Cc: Stefan Roesch <shr@devkernel.io>
Cc: Tejun Heo <tj@kernel.org>
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

mm-zswap-update-comment-for-struct-zswap_entry.patch
mm-z3fold-remove-obsolete-comment-for-struct-z3fold_pool.patch
writeback-remove-unused-delaration-of-bdi_async_bio_wq.patch


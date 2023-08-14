Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A9F3EB64DD
	for <mm-commits@archiver.kernel.org>; Mon, 14 Aug 2023 18:33:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbjHNSc7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Aug 2023 14:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbjHNSco (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Aug 2023 14:32:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C9310F
        for <mm-commits@vger.kernel.org>; Mon, 14 Aug 2023 11:32:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95D2561210
        for <mm-commits@vger.kernel.org>; Mon, 14 Aug 2023 18:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE20C433C7;
        Mon, 14 Aug 2023 18:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692037963;
        bh=7C8TRSks5xRYnMrpHIu5f96q1jVxmd0wps3ke1Xfugk=;
        h=Date:To:From:Subject:From;
        b=H3u7J4N1zUUhzYDS/hR9MXAaFi92YApTTUaosZb3aXsClww6moG2ibNmnTHKe1+4f
         NkFBvCGUyQnIBt7AokAcR8gTMpUNA9ZwNEFW4daZXyYPkjQRx14bB2Ykmp7HP17ilC
         3r3qJ1gqQyJAOkS9vAF1U6ZquZiLII1UuKPzg+Zw=
Date:   Mon, 14 Aug 2023 11:32:42 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        linmiaohe@huawei.com, xiujianfeng@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-z3fold-remove-obsolete-comment-for-struct-z3fold_pool.patch added to mm-unstable branch
Message-Id: <20230814183242.EBE20C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/z3fold: remove obsolete comment for struct z3fold_pool
has been added to the -mm mm-unstable branch.  Its filename is
     mm-z3fold-remove-obsolete-comment-for-struct-z3fold_pool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-z3fold-remove-obsolete-comment-for-struct-z3fold_pool.patch

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
Subject: mm/z3fold: remove obsolete comment for struct z3fold_pool
Date: Mon, 14 Aug 2023 22:11:42 +0000

Since commit e774a7bc7f0a ("mm: zswap: remove page reclaim logic from
z3fold"), zpool and zpool_ops have been removed, so also remove the
corresponding comments.

Link: https://lkml.kernel.org/r/20230814221142.486548-1-xiujianfeng@huaweicloud.com
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/z3fold.c~mm-z3fold-remove-obsolete-comment-for-struct-z3fold_pool
+++ a/mm/z3fold.c
@@ -133,8 +133,6 @@ struct z3fold_header {
  * @stale:	list of pages marked for freeing
  * @pages_nr:	number of z3fold pages in the pool.
  * @c_handle:	cache for z3fold_buddy_slots allocation
- * @zpool:	zpool driver
- * @zpool_ops:	zpool operations structure with an evict callback
  * @compact_wq:	workqueue for page layout background optimization
  * @release_wq:	workqueue for safe page release
  * @work:	work_struct for safe page release
_

Patches currently in -mm which might be from xiujianfeng@huawei.com are

mm-zswap-update-comment-for-struct-zswap_entry.patch
mm-z3fold-remove-obsolete-comment-for-struct-z3fold_pool.patch


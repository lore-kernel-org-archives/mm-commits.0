Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CE90C001DB
	for <mm-commits@archiver.kernel.org>; Fri,  4 Aug 2023 19:47:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjHDTru (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Aug 2023 15:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjHDTrt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2023 15:47:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5CFFE7
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 12:47:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71D336211E
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 19:47:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D31C433C8;
        Fri,  4 Aug 2023 19:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691178467;
        bh=zEzMB+EBUvScQhSEVfIkgsbcwH8CWRPLrvygr3wKV40=;
        h=Date:To:From:Subject:From;
        b=FT/0gyzG4W/zv1IRrWKoI3LcP+9k3e+UHAuXrCWtabViTQlAjP/koktNh3aXRUDdx
         nd3kJ4b0/lly3t0IddWYqlPcuhLdIGOZ273fJ2rvPJ8tF0V30yZJVNOPpEvI6xA3vp
         cjcNtOJoLMSSo8xHy4CK0QlPEb22h7uKaSO//1Ws=
Date:   Fri, 04 Aug 2023 12:47:47 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        wangkefeng.wang@huawei.com, viro@zeniv.linux.org.uk,
        urezki@gmail.com, regressions@leemhuis.info, olsajiri@gmail.com,
        liushixin2@huawei.com, jolsa@kernel.org, efault@gmx.de,
        david@redhat.com, catalin.marinas@arm.com, bhe@redhat.com,
        axboe@kernel.dk, ardb@kernel.org, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] fs-proc-kcore-reinstate-bounce-buffer-for-kcore_text-regions-fix.patch removed from -mm tree
Message-Id: <20230804194747.C4D31C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs/proc/kcore: correct comment
has been removed from the -mm tree.  Its filename was
     fs-proc-kcore-reinstate-bounce-buffer-for-kcore_text-regions-fix.patch

This patch was dropped because it was folded into fs-proc-kcore-reinstate-bounce-buffer-for-kcore_text-regions.patch

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: fs/proc/kcore: correct comment
Date: Tue, 1 Aug 2023 17:36:08 +0100

Correct comment to be strictly correct about reasoning.

Link: https://lkml.kernel.org/r/525a3f14-74fa-4c22-9fca-9dab4de8a0c3@lucifer.local
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Jiri Olsa <olsajiri@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/proc/kcore.c~fs-proc-kcore-reinstate-bounce-buffer-for-kcore_text-regions-fix
+++ a/fs/proc/kcore.c
@@ -568,8 +568,8 @@ static ssize_t read_kcore_iter(struct ki
 					goto out;
 				}
 			/*
-			 * We use _copy_to_iter() to bypass usermode hardening
-			 * which would otherwise prevent this operation.
+			 * We know the bounce buffer is safe to copy from, so
+			 * use _copy_to_iter() directly.
 			 */
 			} else if (_copy_to_iter(buf, tsz, iter) != tsz) {
 				ret = -EFAULT;
_

Patches currently in -mm which might be from lstoakes@gmail.com are

fs-proc-kcore-reinstate-bounce-buffer-for-kcore_text-regions.patch


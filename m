Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB206C0015E
	for <mm-commits@archiver.kernel.org>; Tue,  1 Aug 2023 18:03:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjHASDi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Aug 2023 14:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbjHASDe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Aug 2023 14:03:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6FF103
        for <mm-commits@vger.kernel.org>; Tue,  1 Aug 2023 11:03:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9ABC86165E
        for <mm-commits@vger.kernel.org>; Tue,  1 Aug 2023 18:03:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6CDCC433C7;
        Tue,  1 Aug 2023 18:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690913011;
        bh=X9PpI1jUmOBcplSP1mCB40CDLGovtyNIxV8BLgBRbnk=;
        h=Date:To:From:Subject:From;
        b=hGwOVUDvLHx5mzdWmVT6v2YSqKv40ApG6LyzKBgXERZBU5yFoyuLT12Nv/YsEpMXv
         WuAaG//xdT97adwHd8XFpUzOsh062Uzrs8jiP4fKFUbrzQUwoU7c23v+CebwXNttYQ
         qwlir2VE8NNLiJbRLYVdA9kxNj40qhHu49PqjKoU=
Date:   Tue, 01 Aug 2023 11:03:30 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        wangkefeng.wang@huawei.com, viro@zeniv.linux.org.uk,
        urezki@gmail.com, regressions@leemhuis.info, olsajiri@gmail.com,
        liushixin2@huawei.com, jolsa@kernel.org, efault@gmx.de,
        david@redhat.com, catalin.marinas@arm.com, bhe@redhat.com,
        axboe@kernel.dk, ardb@kernel.org, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-kcore-reinstate-bounce-buffer-for-kcore_text-regions-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20230801180330.E6CDCC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/kcore: correct comment
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fs-proc-kcore-reinstate-bounce-buffer-for-kcore_text-regions-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-kcore-reinstate-bounce-buffer-for-kcore_text-regions-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
fs-proc-kcore-reinstate-bounce-buffer-for-kcore_text-regions-fix.patch


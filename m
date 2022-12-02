Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C8C6C4332F
	for <mm-commits@archiver.kernel.org>; Fri,  2 Dec 2022 00:39:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbiLBAjx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Dec 2022 19:39:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231735AbiLBAjw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Dec 2022 19:39:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98ED1CB21F
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 16:39:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29F11621B8
        for <mm-commits@vger.kernel.org>; Fri,  2 Dec 2022 00:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F199C433D6;
        Fri,  2 Dec 2022 00:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669941586;
        bh=y16EwL8Wh4UsBxePhFJfpFot8KtA7X4OKVVN2Y+zT+k=;
        h=Date:To:From:Subject:From;
        b=Gb+UZI5eQVSAmjauZE3BFogMkXZFlmp2fhJK8TQif4kcmuvYFfuXC39PL1i7TXRhF
         QxbJZgUuhqdy0ItXUczNrjunUm6VMhEfQ5gipntiGDUGVBOT83+YIMesu/10d+r8KX
         IcwaptHrjcZ87vrmYlxhp5nVOutD3JT0esdFjCzY=
Date:   Thu, 01 Dec 2022 16:39:45 -0800
To:     mm-commits@vger.kernel.org, ruansy.fnst@fujitsu.com,
        jhubbard@nvidia.com, jgg@nvidia.com, djwong@kernel.org,
        david@fromorbit.com, dan.j.williams@intel.com, apopple@nvidia.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fsdax-zero-the-edges-if-source-is-hole-or-unwritten-fix.patch added to mm-unstable branch
Message-Id: <20221202003946.7F199C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fsdax-zero-the-edges-if-source-is-hole-or-unwritten-fix
has been added to the -mm mm-unstable branch.  Its filename is
     fsdax-zero-the-edges-if-source-is-hole-or-unwritten-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fsdax-zero-the-edges-if-source-is-hole-or-unwritten-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fsdax-zero-the-edges-if-source-is-hole-or-unwritten-fix
Date: Thu Dec  1 04:37:42 PM PST 2022

update dax_iomap_copy_around() kerneldoc, per Darrick

Cc: Alistair Popple <apopple@nvidia.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/dax.c~fsdax-zero-the-edges-if-source-is-hole-or-unwritten-fix
+++ a/fs/dax.c
@@ -1092,7 +1092,8 @@ out:
 }
 
 /**
- * dax_iomap_copy_around - Copy the data from source to destination before write
+ * dax_iomap_copy_around - Prepare for an unaligned write to a shared/cow page
+ * by copying the data before and after the range to be written.
  * @pos:	address to do copy from.
  * @length:	size of copy operation.
  * @align_size:	aligned w.r.t align_size (either PMD_SIZE or PAGE_SIZE)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-mm-align-larger-anonymous-mappings-on-thp-boundaries.patch
mm-gup-remove-foll_migration-fix.patch
fsdax-zero-the-edges-if-source-is-hole-or-unwritten-fix.patch


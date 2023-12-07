Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFF16C4167B
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 21:44:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbjLGVof (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Dec 2023 16:44:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbjLGVoO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Dec 2023 16:44:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4CDC30DF
        for <mm-commits@vger.kernel.org>; Thu,  7 Dec 2023 13:29:49 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69552C433C9;
        Thu,  7 Dec 2023 21:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701984589;
        bh=iAmXHP2qV6U5hBVFSph+LszHLUUyj/qA9feUA6uZDDU=;
        h=Date:To:From:Subject:From;
        b=oOes6ndk478gwfJ8CxVJok/HQWjHQP4vfAuevKThxboe6o+E4oo+NdOv4cZqjwngj
         HMp5vXiJE01xT1yaHEk3PsLo4Qwf3ESvj7Vr7kzy3sO7Ke9tMv6HjNE+aQHdK5koWc
         /y7p3E2te+KdoUfsRGuvCqYZjDSUlmqeQekYReF8=
Date:   Thu, 07 Dec 2023 13:29:48 -0800
To:     mm-commits@vger.kernel.org, hch@infradead.org,
        rdunlap@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + freevxfs-lookup-fix-function-params-kernel-doc.patch added to mm-nonmm-unstable branch
Message-Id: <20231207212949.69552C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: freevxfs: lookup: fix function params kernel-doc
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     freevxfs-lookup-fix-function-params-kernel-doc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/freevxfs-lookup-fix-function-params-kernel-doc.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Randy Dunlap <rdunlap@infradead.org>
Subject: freevxfs: lookup: fix function params kernel-doc
Date: Thu, 7 Dec 2023 13:20:35 -0800

Correct the function parameter kernel-doc notation to prevent warnings:

vxfs_lookup.c:192: warning: Function parameter or member 'ctx' not described in 'vxfs_readdir'
vxfs_lookup.c:192: warning: Excess function parameter 'retp' description in 'vxfs_readdir'
vxfs_lookup.c:192: warning: Excess function parameter 'filler' description in 'vxfs_readdir'

Link: https://lkml.kernel.org/r/20231207212035.25345-3-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/freevxfs/vxfs_lookup.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/freevxfs/vxfs_lookup.c~freevxfs-lookup-fix-function-params-kernel-doc
+++ a/fs/freevxfs/vxfs_lookup.c
@@ -177,8 +177,7 @@ vxfs_lookup(struct inode *dip, struct de
 /**
  * vxfs_readdir - read a directory
  * @fp:		the directory to read
- * @retp:	return buffer
- * @filler:	filldir callback
+ * @ctx:	dir_context for filldir/readdir
  *
  * Description:
  *   vxfs_readdir fills @retp with directory entries from @fp
_

Patches currently in -mm which might be from rdunlap@infradead.org are

rapidio-tsi721-fix-kernel-doc-warnings.patch
freevxfs-bmap-fix-kernel-doc-warnings.patch
freevxfs-immed-fix-kernel-doc-param-name.patch
freevxfs-lookup-fix-function-params-kernel-doc.patch


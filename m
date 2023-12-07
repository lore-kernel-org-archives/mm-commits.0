Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57D3DC4167B
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 21:43:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235643AbjLGVnY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Dec 2023 16:43:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235318AbjLGVnL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Dec 2023 16:43:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 104ED46BE
        for <mm-commits@vger.kernel.org>; Thu,  7 Dec 2023 13:29:48 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6065DC433C8;
        Thu,  7 Dec 2023 21:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701984588;
        bh=5MjxWkG+drK2lD5EZa8K8NO04nzPwNox0fIsWRe+Dog=;
        h=Date:To:From:Subject:From;
        b=NlmdbZCi74V7TKRnzixrFpBVs+DH8T84D8sT36TWbJzBNoWtEXnDiu5zRgO8YINBk
         XKlAyfqMi+ULCE1+tcSN+U8msam87fsGUdTU1ja/XShCXM6Xxs9LcsnBENpeq1HVAz
         wGMS0XO0N91ilZfpfkILMkS8nQjFK1NbCwWGKPwc=
Date:   Thu, 07 Dec 2023 13:29:47 -0800
To:     mm-commits@vger.kernel.org, hch@infradead.org,
        rdunlap@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + freevxfs-immed-fix-kernel-doc-param-name.patch added to mm-nonmm-unstable branch
Message-Id: <20231207212948.6065DC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: freevxfs: immed: fix kernel-doc param name
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     freevxfs-immed-fix-kernel-doc-param-name.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/freevxfs-immed-fix-kernel-doc-param-name.patch

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
Subject: freevxfs: immed: fix kernel-doc param name
Date: Thu, 7 Dec 2023 13:20:34 -0800

Correct the function parameter name to prevent kernel-doc warnings:

vxfs_immed.c:32: warning: Function parameter or member 'fp' not described in 'vxfs_immed_read_folio'
vxfs_immed.c:32: warning: Excess function parameter 'file' description in 'vxfs_immed_read_folio'

Link: https://lkml.kernel.org/r/20231207212035.25345-2-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/freevxfs/vxfs_immed.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/freevxfs/vxfs_immed.c~freevxfs-immed-fix-kernel-doc-param-name
+++ a/fs/freevxfs/vxfs_immed.c
@@ -15,7 +15,7 @@
 
 /**
  * vxfs_immed_read_folio - read part of an immed inode into pagecache
- * @file:	file context (unused)
+ * @fp:		file context (unused)
  * @folio:	folio to fill in.
  *
  * Description:
_

Patches currently in -mm which might be from rdunlap@infradead.org are

rapidio-tsi721-fix-kernel-doc-warnings.patch
freevxfs-bmap-fix-kernel-doc-warnings.patch
freevxfs-immed-fix-kernel-doc-param-name.patch
freevxfs-lookup-fix-function-params-kernel-doc.patch


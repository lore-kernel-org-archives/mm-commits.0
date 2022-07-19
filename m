Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01C11C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jul 2022 23:19:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232470AbiGSXTP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Jul 2022 19:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiGSXTO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jul 2022 19:19:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F7561DB9
        for <mm-commits@vger.kernel.org>; Tue, 19 Jul 2022 16:19:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5D6CB81DA0
        for <mm-commits@vger.kernel.org>; Tue, 19 Jul 2022 23:19:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81704C341C6;
        Tue, 19 Jul 2022 23:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658272751;
        bh=ZcK1ax/Sm0LNjLxcMyier6ZbP7FdwijjCOlevJqcSh4=;
        h=Date:To:From:Subject:From;
        b=MXQJ1aYBYM8TSibSHU9dc80G9hhxwXxA2+INE133n93mzKqm1FWue/spcNuUywOBc
         +AfiZn+kW5znaEQ0cgJzP5jpETBXH2jtm8HCz1DFtQUEQ9gyHFXdOs+v4zCbRfWZ07
         D30mDCXRJCrHKVWlH7SwrE6VDeyUriXiNRcixGfU=
Date:   Tue, 19 Jul 2022 16:19:10 -0700
To:     mm-commits@vger.kernel.org, sashal@kernel.org, minchan@kernel.org,
        iamjoonsoo.kim@lge.com, quic_yingangl@quicinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma_debugc-align-the-name-buffer-length-as-struct-cma.patch added to mm-unstable branch
Message-Id: <20220719231911.81704C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma_debug.c: align the name buffer length as struct cma
has been added to the -mm mm-unstable branch.  Its filename is
     mm-cma_debugc-align-the-name-buffer-length-as-struct-cma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma_debugc-align-the-name-buffer-length-as-struct-cma.patch

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
From: Kassey Li <quic_yingangl@quicinc.com>
Subject: mm/cma_debug.c: align the name buffer length as struct cma
Date: Tue, 19 Jul 2022 17:15:54 +0800

Link: https://lkml.kernel.org/r/20220719091554.27864-1-quic_yingangl@quicinc.com
Signed-off-by: Kassey Li <quic_yingangl@quicinc.com>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma_debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/cma_debug.c~mm-cma_debugc-align-the-name-buffer-length-as-struct-cma
+++ a/mm/cma_debug.c
@@ -163,7 +163,7 @@ DEFINE_DEBUGFS_ATTRIBUTE(cma_alloc_fops,
 static void cma_debugfs_add_one(struct cma *cma, struct dentry *root_dentry)
 {
 	struct dentry *tmp;
-	char name[16];
+	char name[CMA_MAX_NAME];
 
 	scnprintf(name, sizeof(name), "cma-%s", cma->name);
 
_

Patches currently in -mm which might be from quic_yingangl@quicinc.com are

mm-cma_debugc-align-the-name-buffer-length-as-struct-cma.patch


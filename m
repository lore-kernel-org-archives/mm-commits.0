Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 826F0C00144
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:09:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239608AbiG3BJE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239620AbiG3BIk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:08:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B8C986885
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:08:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC84161C5B
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:08:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17419C433D6;
        Sat, 30 Jul 2022 01:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143313;
        bh=uPvqsi1d/c1SWUBi5+7fwN0EBgeRzlSv8CY4FXkOS8c=;
        h=Date:To:From:Subject:From;
        b=clnYxYXWF6PpQ36adCUEPRBw90p83UDWpxiro0GYjYg0AuJHt9dpvCoiYvlxDuWAJ
         2xRXUPdOgsRNjpsQAjsEvE867arqiASIJSBDt0NLULWjU3cv95n8Mopx9oQZCkdJ6A
         S/iBiwzM2HHKzn3E5xiD1vTqjGykADL67kYKBJS4=
Date:   Fri, 29 Jul 2022 18:08:32 -0700
To:     mm-commits@vger.kernel.org, sashal@kernel.org, minchan@kernel.org,
        iamjoonsoo.kim@lge.com, quic_yingangl@quicinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-cma_debugc-align-the-name-buffer-length-as-struct-cma.patch removed from -mm tree
Message-Id: <20220730010833.17419C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/cma_debug.c: align the name buffer length as struct cma
has been removed from the -mm tree.  Its filename was
     mm-cma_debugc-align-the-name-buffer-length-as-struct-cma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kassey Li <quic_yingangl@quicinc.com>
Subject: mm/cma_debug.c: align the name buffer length as struct cma
Date: Tue, 19 Jul 2022 17:15:54 +0800

Avoids truncating the debugfs output to 16 chars.  Potentially alters
the userspace output, but this is a debugfs interface and there are no
stability guarantees.

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



Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C170C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:42:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbjBCGmV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:42:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232466AbjBCGku (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:40:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D088FB5B
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:37:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3C9B61DA5
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:37:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C93C433D2;
        Fri,  3 Feb 2023 06:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406266;
        bh=0AX/iT8fCusqm3VN02uF/f75xSqCsGioIUbHKp65l2Y=;
        h=Date:To:From:Subject:From;
        b=mI1Y59VRPt8Dfvlf/zf5l2PpuOC3jXl9OonwzK7MN88+fnMbrbKwCoTAWscciPV4Q
         0Dm6w6FNI6Myy8CD8L1fP6iuzhliL3JC/TF/QxQWML3oeTPsXypXa51jla7XS91a86
         7cY/xFaGUS6Fnk2dZkrndZnUf6xWHkAAaVQpbt+0=
Date:   Thu, 02 Feb 2023 22:37:45 -0800
To:     mm-commits@vger.kernel.org, rppt@kernel.org,
        akpm@linux-foudation.org, colin.i.king@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-secretmem-remove-redundant-initiialization-of-pointer-file.patch removed from -mm tree
Message-Id: <20230203063746.43C93C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/secretmem: remove redundant initiialization of pointer file
has been removed from the -mm tree.  Its filename was
     mm-secretmem-remove-redundant-initiialization-of-pointer-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Colin Ian King <colin.i.king@gmail.com>
Subject: mm/secretmem: remove redundant initiialization of pointer file
Date: Mon, 16 Jan 2023 16:43:32 +0000

The pointer file is being initialized with a value that is never read, it
is being re-assigned later on.  Clean up code by removing the redundant
initialization.

Link: https://lkml.kernel.org/r/20230116164332.79500-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foudation.org>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/secretmem.c~mm-secretmem-remove-redundant-initiialization-of-pointer-file
+++ a/mm/secretmem.c
@@ -190,7 +190,7 @@ static struct vfsmount *secretmem_mnt;
 
 static struct file *secretmem_file_create(unsigned long flags)
 {
-	struct file *file = ERR_PTR(-ENOMEM);
+	struct file *file;
 	struct inode *inode;
 	const char *anon_name = "[secretmem]";
 	const struct qstr qname = QSTR_INIT(anon_name, strlen(anon_name));
_

Patches currently in -mm which might be from colin.i.king@gmail.com are



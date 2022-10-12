Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC3C9C43217
	for <mm-commits@archiver.kernel.org>; Wed, 12 Oct 2022 22:57:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiJLW5U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Oct 2022 18:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiJLW5T (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2022 18:57:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498DB11C247
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 15:57:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 068F1B81BE0
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 22:57:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7F8C433C1;
        Wed, 12 Oct 2022 22:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665615435;
        bh=ZD8tgyG+toeJzaKvluQcR56lmYYqc0TCJ7VGqB3XWNc=;
        h=Date:To:From:Subject:From;
        b=0Pg8gCPAaeAX/JQ8fRjF2U8+ZQZhPcLj2LZ2VE5pfWoLnwo7XkH81u7eO5EEVLUKc
         XqpPqMhrnbNXXa3tkHy/pG+2CzuvFCHkXqu4/kJa9vliONxJFcm/Dh3ZAcsHISPs3l
         Q0wO3tlxWBUOuk6J47RfAmca2cB7R32QdWXi4tCg=
Date:   Wed, 12 Oct 2022 15:57:14 -0700
To:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        Liam.Howlett@oracle.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmap-fix-copy_vma-failure-path.patch removed from -mm tree
Message-Id: <20221012225715.AF7F8C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mmap: fix copy_vma() failure path
has been removed from the -mm tree.  Its filename was
     mmap-fix-copy_vma-failure-path.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: mmap: fix copy_vma() failure path
Date: Tue, 11 Oct 2022 20:36:51 +0000

The anon vma was not unlinked and the file was not closed in the failure
path when the machine runs out of memory during the maple tree
modification.  This caused a memory leak of the anon vma chain and vma
since neither would be freed.

Link: https://lkml.kernel.org/r/20221011203621.1446507-1-Liam.Howlett@oracle.com
Fixes: 524e00b36e8c ("mm: remove rb tree")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Tested-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/mmap.c~mmap-fix-copy_vma-failure-path
+++ a/mm/mmap.c
@@ -3240,6 +3240,11 @@ struct vm_area_struct *copy_vma(struct v
 out_vma_link:
 	if (new_vma->vm_ops && new_vma->vm_ops->close)
 		new_vma->vm_ops->close(new_vma);
+
+	if (new_vma->vm_file)
+		fput(new_vma->vm_file);
+
+	unlink_anon_vmas(new_vma);
 out_free_mempol:
 	mpol_put(vma_policy(new_vma));
 out_free_vma:
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

mm-mmap-preallocate-maple-nodes-for-brk-vma-expansion.patch


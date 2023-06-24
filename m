Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10F88EB64D7
	for <mm-commits@archiver.kernel.org>; Sat, 24 Jun 2023 00:01:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbjFXABf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 20:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232350AbjFXAAk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 20:00:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A23294B
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 17:00:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7039B61671
        for <mm-commits@vger.kernel.org>; Sat, 24 Jun 2023 00:00:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C915DC433CB;
        Sat, 24 Jun 2023 00:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687564837;
        bh=BG76hR29L41fGEqDfIyW0aDtjpsky2fxbqYRQR8TTI4=;
        h=Date:To:From:Subject:From;
        b=DMCWJHg4Vzbf9OC2cIFsL6G390s2acVAx+PBlQJR7v9bPesw2xfRhmc6joZOZLSwx
         h443kIU3c5iHoeOzV3C771lQafnSVq+HGtUlVNptExx8VpPLlzo/jEUGdpNg+yrTZG
         bZErRkoNPgbJfck5//PeADnWEd93kyvTGRRbXzmI=
Date:   Fri, 23 Jun 2023 17:00:37 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        Liam.Howlett@oracle.com, david@redhat.com, lipeifeng@oppo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-nommu-correct-the-range-of-mmap_sem_read_lock-in-task_mem.patch removed from -mm tree
Message-Id: <20230624000037.C915DC433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: nommu: correct the range of mmap_sem_read_lock in task_mem()
has been removed from the -mm tree.  Its filename was
     mm-nommu-correct-the-range-of-mmap_sem_read_lock-in-task_mem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: lipeifeng <lipeifeng@oppo.com>
Subject: mm: nommu: correct the range of mmap_sem_read_lock in task_mem()
Date: Thu, 22 Jun 2023 12:01:52 +0800

During the seq_printf,the mmap_sem_read_lock protection is not
required.

Link: https://lkml.kernel.org/r/20230622040152.1173-1-lipeifeng@oppo.com
Signed-off-by: lipeifeng <lipeifeng@oppo.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_nommu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/proc/task_nommu.c~mm-nommu-correct-the-range-of-mmap_sem_read_lock-in-task_mem
+++ a/fs/proc/task_nommu.c
@@ -51,7 +51,7 @@ void task_mem(struct seq_file *m, struct
 		sbytes += kobjsize(mm);
 	else
 		bytes += kobjsize(mm);
-	
+
 	if (current->fs && current->fs->users > 1)
 		sbytes += kobjsize(current->fs);
 	else
@@ -69,13 +69,13 @@ void task_mem(struct seq_file *m, struct
 
 	bytes += kobjsize(current); /* includes kernel stack */
 
+	mmap_read_unlock(mm);
+
 	seq_printf(m,
 		"Mem:\t%8lu bytes\n"
 		"Slack:\t%8lu bytes\n"
 		"Shared:\t%8lu bytes\n",
 		bytes, slack, sbytes);
-
-	mmap_read_unlock(mm);
 }
 
 unsigned long task_vsize(struct mm_struct *mm)
_

Patches currently in -mm which might be from lipeifeng@oppo.com are



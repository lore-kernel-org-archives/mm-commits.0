Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51446EB64DA
	for <mm-commits@archiver.kernel.org>; Thu, 22 Jun 2023 20:06:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbjFVUGs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Jun 2023 16:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbjFVUGq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 22 Jun 2023 16:06:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 913431BF0
        for <mm-commits@vger.kernel.org>; Thu, 22 Jun 2023 13:06:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07676618DB
        for <mm-commits@vger.kernel.org>; Thu, 22 Jun 2023 20:06:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590C7C433C0;
        Thu, 22 Jun 2023 20:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687464401;
        bh=Y/uSpgM/sUeDpQWrv1ndaf0VV69YZgsllAkNS2jp0bs=;
        h=Date:To:From:Subject:From;
        b=bYXKOldKwts7F22oJDMJZhYZyHKsMWtL6BjL54RZw+UVJ4YLLW02RvsmdoOyoNRsB
         XlDMPjVEqmmKyuKXhdd+qVFEzfWgIWK/g52QYQ60/H99I4/8Js/30165xBp2LE2TAN
         SYYaZb0HGViA1Is7MDaqCMbTNEYGKrKGO0YESMuM=
Date:   Thu, 22 Jun 2023 13:06:40 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        Liam.Howlett@oracle.com, david@redhat.com, lipeifeng@oppo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-nommu-correct-the-range-of-mmap_sem_read_lock-in-task_mem.patch added to mm-unstable branch
Message-Id: <20230622200641.590C7C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: nommu: correct the range of mmap_sem_read_lock in task_mem()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-nommu-correct-the-range-of-mmap_sem_read_lock-in-task_mem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-nommu-correct-the-range-of-mmap_sem_read_lock-in-task_mem.patch

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

mm-nommu-correct-the-range-of-mmap_sem_read_lock-in-task_mem.patch


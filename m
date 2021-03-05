Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 555B9C433DB
	for <mm-commits@archiver.kernel.org>; Fri,  5 Mar 2021 01:47:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28A146500C
	for <mm-commits@archiver.kernel.org>; Fri,  5 Mar 2021 01:47:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbhCEBrf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 4 Mar 2021 20:47:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:53756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229601AbhCEBrf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Mar 2021 20:47:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADFD465005;
        Fri,  5 Mar 2021 01:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614908853;
        bh=N4r7RpR2NTiLXQ9Ou9nSbiVO//c3Tgz37fjG5bajchI=;
        h=Date:From:To:Subject:From;
        b=Zq7KFJFrtYQUbpQigiGvobita+8y+Kos6i/78AYpgD921xCak+OWC2xoj6ykYUKSV
         Cbrps0Z6BewvDlVhfc1kx5ojRsZjEMcaQTWS5Fq4dXkg3gUnh2mGUn2zJhC2RWTvL1
         nNL5+xBPsuOlmoMg5mBZ6w/Pynh8SAo7uH7YKOl0=
Date:   Thu, 04 Mar 2021 17:47:33 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, pintu.ping@gmail.com,
        pintu@codeaurora.org, vbabka@suse.cz
Subject:  +
 mm-compaction-remove-unused-variable-sysctl_compact_memory.patch added to
 -mm tree
Message-ID: <20210305014733.AV2eSkrxP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: remove unused variable sysctl_compact_memory
has been added to the -mm tree.  Its filename is
     mm-compaction-remove-unused-variable-sysctl_compact_memory.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-remove-unused-variable-sysctl_compact_memory.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-remove-unused-variable-sysctl_compact_memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pintu Kumar <pintu@codeaurora.org>
Subject: mm/compaction: remove unused variable sysctl_compact_memory

The sysctl_compact_memory is mostly unused in mm/compaction.c
It just acts as a place holder for sysctl to store .data.

But the .data itself is not needed here.
So we can get ride of this variable completely and make .data as NULL.
This will also eliminate the extern declaration from header file.
No functionality is broken or changed this way.

Link: https://lkml.kernel.org/r/1614852224-14671-1-git-send-email-pintu@codeaurora.org
Signed-off-by: Pintu Kumar <pintu@codeaurora.org>
Signed-off-by: Pintu Agarwal <pintu.ping@gmail.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |    1 -
 kernel/sysctl.c            |    2 +-
 mm/compaction.c            |    3 ---
 3 files changed, 1 insertion(+), 5 deletions(-)

--- a/include/linux/compaction.h~mm-compaction-remove-unused-variable-sysctl_compact_memory
+++ a/include/linux/compaction.h
@@ -81,7 +81,6 @@ static inline unsigned long compact_gap(
 }
 
 #ifdef CONFIG_COMPACTION
-extern int sysctl_compact_memory;
 extern unsigned int sysctl_compaction_proactiveness;
 extern int sysctl_compaction_handler(struct ctl_table *table, int write,
 			void *buffer, size_t *length, loff_t *ppos);
--- a/kernel/sysctl.c~mm-compaction-remove-unused-variable-sysctl_compact_memory
+++ a/kernel/sysctl.c
@@ -2856,7 +2856,7 @@ static struct ctl_table vm_table[] = {
 #ifdef CONFIG_COMPACTION
 	{
 		.procname	= "compact_memory",
-		.data		= &sysctl_compact_memory,
+		.data		= NULL,
 		.maxlen		= sizeof(int),
 		.mode		= 0200,
 		.proc_handler	= sysctl_compaction_handler,
--- a/mm/compaction.c~mm-compaction-remove-unused-variable-sysctl_compact_memory
+++ a/mm/compaction.c
@@ -2657,9 +2657,6 @@ static void compact_nodes(void)
 		compact_node(nid);
 }
 
-/* The written value is actually unused, all memory is compacted */
-int sysctl_compact_memory;
-
 /*
  * Tunable for proactive compaction. It determines how
  * aggressively the kernel should compact memory in the
_

Patches currently in -mm which might be from pintu@codeaurora.org are

mm-compaction-remove-unused-variable-sysctl_compact_memory.patch


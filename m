Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E961C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 17 Nov 2022 19:58:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234747AbiKQT6u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Nov 2022 14:58:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234246AbiKQT6t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2022 14:58:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53230391EE
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2022 11:58:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08FB0B821DD
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2022 19:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE36C433C1;
        Thu, 17 Nov 2022 19:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668715125;
        bh=LRH3GCOEgFNt7gubaehnz9Jt1aPcmTNIGzJJse7NyUQ=;
        h=Date:To:From:Subject:From;
        b=yythKPNCklhyCdmXSO9Xd/nhEDHb4tO8XMTFlw7Olt/Hp3Jb4hR327y0klhJm95jW
         3RM8+nweiRg47oVQd7yKV7PEkfYFAgOrDYbuV17oz+lLd5l8AAb6khcHUZwMb1UOR7
         qMMulDzkcOCeh+Rsr+0N84ev2Wctux5RDhqXfjms=
Date:   Thu, 17 Nov 2022 11:58:45 -0800
To:     mm-commits@vger.kernel.org, shakeelb@google.com, seanjc@google.com,
        maz@kernel.org, hannes@cmpxchg.org, david@redhat.com,
        yosryahmed@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-meminfo-fix-spacing-in-secpagetables.patch added to mm-hotfixes-unstable branch
Message-Id: <20221117195845.AEE36C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc/meminfo: fix spacing in SecPageTables
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     proc-meminfo-fix-spacing-in-secpagetables.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-meminfo-fix-spacing-in-secpagetables.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Yosry Ahmed <yosryahmed@google.com>
Subject: proc/meminfo: fix spacing in SecPageTables
Date: Thu, 17 Nov 2022 04:32:47 +0000

SecPageTables has a tab after it instead of a space, this can break
fragile parsers that depend on spaces after the stat names.

Link: https://lkml.kernel.org/r/20221117043247.133294-1-yosryahmed@google.com
Fixes: ebc97a ("mm: add NR_SECONDARY_PAGETABLE to count secondary page table uses.")
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/meminfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/meminfo.c~proc-meminfo-fix-spacing-in-secpagetables
+++ a/fs/proc/meminfo.c
@@ -115,7 +115,7 @@ static int meminfo_proc_show(struct seq_
 #endif
 	show_val_kb(m, "PageTables:     ",
 		    global_node_page_state(NR_PAGETABLE));
-	show_val_kb(m, "SecPageTables:	",
+	show_val_kb(m, "SecPageTables:  ",
 		    global_node_page_state(NR_SECONDARY_PAGETABLE));
 
 	show_val_kb(m, "NFS_Unstable:   ", 0);
_

Patches currently in -mm which might be from yosryahmed@google.com are

proc-meminfo-fix-spacing-in-secpagetables.patch


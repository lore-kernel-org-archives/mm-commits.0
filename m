Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B167FC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 12 Apr 2022 21:36:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiDLViU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Apr 2022 17:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiDLViS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Apr 2022 17:38:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2C0F47FD
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 14:17:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBAF661CB3
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 21:13:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32585C385A1;
        Tue, 12 Apr 2022 21:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649798029;
        bh=UfqdaaTKxN4oOhHMQUpuystEfN8wNOEdpq5cPUTQJD4=;
        h=Date:To:From:Subject:From;
        b=JD0CaOyZN9oq0DGUISRRmPY2IPcBf2bym2TokLCixVMdkCE0Jm3J5EWW7ek5Cnpd6
         KyaxroAhoFohzTqYPAugj+ljBSIN/h4Ty+S6C7+iEX4weDk6CIsx0qKWnlHCY2F4yU
         11jmw6YTRpK0MeZuzU6hEKlsljEfv1ActLw4WYDw=
Date:   Tue, 12 Apr 2022 14:13:48 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com, rppt@linux.ibm.com,
        rientjes@google.com, quic_sudaraja@quicinc.com,
        anshuman.khandual@arm.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-check-pfn-is-valid-before-moving-to-freelist-fix.patch added to -mm tree
Message-Id: <20220412211349.32585C385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-check-pfn-is-valid-before-moving-to-freelist-fix
has been added to the -mm tree.  Its filename is
     mm-page_alloc-check-pfn-is-valid-before-moving-to-freelist-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-check-pfn-is-valid-before-moving-to-freelist-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-check-pfn-is-valid-before-moving-to-freelist-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-check-pfn-is-valid-before-moving-to-freelist-fix

add comment, per David

Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Sudarshan Rajagopalan <quic_sudaraja@quicinc.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/page_alloc.c~mm-page_alloc-check-pfn-is-valid-before-moving-to-freelist-fix
+++ a/mm/page_alloc.c
@@ -2522,6 +2522,10 @@ static int move_freepages(struct zone *z
 
 	for (pfn = start_pfn; pfn <= end_pfn;) {
 		if (!pfn_valid(pfn)) {
+			/*
+			 * Pageblock alignment may cause us to try to access
+			 * into a hole
+			 */
 			pfn++;
 			continue;
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-check-pfn-is-valid-before-moving-to-freelist-fix.patch
mm.patch
mm-create-new-mm-swaph-header-file-fix.patch
mm-shmem-make-shmem_init-return-void-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
linux-next-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch


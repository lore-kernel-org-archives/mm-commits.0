Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C148EC6FD20
	for <mm-commits@archiver.kernel.org>; Tue, 21 Mar 2023 21:36:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjCUVgl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Mar 2023 17:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbjCUVgl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Mar 2023 17:36:41 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626FE36FD2
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 14:36:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4ECE7CE18CA
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 21:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE54C433D2;
        Tue, 21 Mar 2023 21:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679434593;
        bh=ROnNRSmyrk6NK3Ck5LqATxWCS+9KZjqhYmzMMmSwD50=;
        h=Date:To:From:Subject:From;
        b=uclGzDirGfBfof1DpEf5BDeR/qThcSBs7q1EePJrBDV1BFfcHNHPlDe11ZlDkwg95
         hSNU0avczhow+uLuiGUWwBPbNX81DtacIb5ZnGXrT2hvMvyYZjIvQkA+iUfdbq/nHV
         79rr7BDV8GvxGdrjz3mOSMcvv/BoWw3Wt3XCHp80=
Date:   Tue, 21 Mar 2023 14:36:32 -0700
To:     mm-commits@vger.kernel.org, lstoakes@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-convert-vread-to-vread_iter-fix.patch added to mm-unstable branch
Message-Id: <20230321213633.7DE54C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmalloc-convert-vread-to-vread_iter-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-convert-vread-to-vread_iter-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-convert-vread-to-vread_iter-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmalloc-convert-vread-to-vread_iter-fix
Date: Tue Mar 21 02:34:51 PM PDT 2023

fix nommu build

Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/nommu.c~mm-vmalloc-convert-vread-to-vread_iter-fix
+++ a/mm/nommu.c
@@ -199,7 +199,7 @@ unsigned long vmalloc_to_pfn(const void
 }
 EXPORT_SYMBOL(vmalloc_to_pfn);
 
-long vread_iter(struct iov_iter *iter, char *addr, size_t count)
+long vread_iter(struct iov_iter *iter, const char *addr, size_t count)
 {
 	/* Don't allow overflow */
 	if ((unsigned long) addr + count < count)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-reduce-page-alloc-free-sanity-checks-checkpatch-fixes.patch
mm-page_alloc-reduce-page-alloc-free-sanity-checks-fix.patch
mm-userfaultfd-support-wp-on-multiple-vmas-fix.patch
mm-add-new-api-to-enable-ksm-per-process-fix.patch
mm-treewide-redefine-max_order-sanely-fix-2.patch
mm-treewide-redefine-max_order-sanely-fix-3-fix.patch
memcg-do-not-drain-charge-pcp-caches-on-remote-isolated-cpus-fix.patch
vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold-fix.patch
mm-vmalloc-convert-vread-to-vread_iter-fix.patch
scripts-link-vmlinuxsh-fix-error-message-presentation.patch
notifiers-add-tracepoints-to-the-notifiers-infrastructure-checkpatch-fixes.patch


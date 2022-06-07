Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDBC9C43334
	for <mm-commits@archiver.kernel.org>; Tue,  7 Jun 2022 20:57:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376983AbiFGU5J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Jun 2022 16:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377403AbiFGUuj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2022 16:50:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF421F98C3
        for <mm-commits@vger.kernel.org>; Tue,  7 Jun 2022 11:40:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70987B82392
        for <mm-commits@vger.kernel.org>; Tue,  7 Jun 2022 18:39:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27368C385A2;
        Tue,  7 Jun 2022 18:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654627195;
        bh=TWXYTLawP81ghSfb3SoFhIegZ1Rfs2ehqMouUKnQe4c=;
        h=Date:To:From:Subject:From;
        b=s4xhNcc7v8DAhP4PeSTIoBD6Wyjrrwo9oNk2OCF3o4iCv0Iww2xAcG/hxXu7KWSHA
         o5HknGMHfUU3u49huk6RUB7FFKEWWQbdzUoVjEX/fGXT1x/3qY1KFNRW2nsFzOpI8M
         PWS8Lt4PNhYQUpVjCMliN5wPs/gmAZxx9us9MTtI=
Date:   Tue, 07 Jun 2022 11:39:54 -0700
To:     mm-commits@vger.kernel.org, riteshh@linux.ibm.com, hch@lst.de,
        djwong@kernel.org, dan.j.williams@intel.com,
        ruansy.fnst@fujitsu.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fsdax-output-address-in-dax_iomap_pfn-and-rename-it-v21.patch added to mm-unstable branch
Message-Id: <20220607183955.27368C385A2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fsdax-output-address-in-dax_iomap_pfn-and-rename-it-v21
has been added to the -mm mm-unstable branch.  Its filename is
     fsdax-output-address-in-dax_iomap_pfn-and-rename-it-v21.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fsdax-output-address-in-dax_iomap_pfn-and-rename-it-v21.patch

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
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Subject: fsdax-output-address-in-dax_iomap_pfn-and-rename-it-v21
Date: Tue, 7 Jun 2022 22:38:37 +0800

initialize `rc', per Dan.

Link: https://lore.kernel.org/linux-fsdevel/Yp8FUZnO64Qvyx5G@kili/
Link: https://lkml.kernel.org/r/20220607143837.161174-1-ruansy.fnst@fujitsu.com
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ritesh Harjani <riteshh@linux.ibm.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/dax.c~fsdax-output-address-in-dax_iomap_pfn-and-rename-it-v21
+++ a/fs/dax.c
@@ -1030,7 +1030,7 @@ static int dax_iomap_direct_access(const
 		size_t size, void **kaddr, pfn_t *pfnp)
 {
 	pgoff_t pgoff = dax_iomap_pgoff(iomap, pos);
-	int id, rc;
+	int id, rc = 0;
 	long length;
 
 	id = dax_read_lock();
_

Patches currently in -mm which might be from ruansy.fnst@fujitsu.com are

dax-introduce-holder-for-dax_device.patch
mm-factor-helpers-for-memory_failure_dev_pagemap.patch
pagemappmem-introduce-memory_failure.patch
fsdax-introduce-dax_lock_mapping_entry.patch
mm-introduce-mf_dax_kill_procs-for-fsdax-case.patch
xfs-implement-notify_failure-for-xfs.patch
fsdax-set-a-cow-flag-when-associate-reflink-mappings.patch
fsdax-output-address-in-dax_iomap_pfn-and-rename-it.patch
fsdax-output-address-in-dax_iomap_pfn-and-rename-it-v21.patch
fsdax-introduce-dax_iomap_cow_copy.patch
fsdax-replace-mmap-entry-in-case-of-cow.patch
fsdax-add-dax_iomap_cow_copy-for-dax-zero.patch
fsdax-dedup-file-range-to-use-a-compare-function.patch
xfs-support-cow-in-fsdax-mode.patch
xfs-add-dax-dedupe-support.patch


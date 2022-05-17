Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A7E0C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 17 May 2022 18:52:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240221AbiEQSwp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 17 May 2022 14:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245048AbiEQSwo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 May 2022 14:52:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9574E31221
        for <mm-commits@vger.kernel.org>; Tue, 17 May 2022 11:52:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D1EE615EF
        for <mm-commits@vger.kernel.org>; Tue, 17 May 2022 18:52:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ECFCC34100;
        Tue, 17 May 2022 18:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652813562;
        bh=mn8s/l1OaJF7FlrglBPkWh7m81ApRtihpFKtgaRe7ko=;
        h=Date:To:From:Subject:From;
        b=EGdg1GWuKvgUnCS4wJSK6xaKARJ59LsmN3Z2tJF+xf/yMM1KvzTNTHZN44gvoNxu7
         75evjVN06CuPU+RQkbOkVZ1eHmH3/KvnX6gxDTCaZ6KZNWe2hzSS9TKwaX21GYbDrL
         n9dRZ6XZJQAbQavHIJnRiEFA2Fz/apysCfXV4QVs=
Date:   Tue, 17 May 2022 11:52:41 -0700
To:     mm-commits@vger.kernel.org, anton@tuxera.com,
        colin.i.king@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-ntfs-remove-redundant-variable-idx.patch added to mm-nonmm-unstable branch
Message-Id: <20220517185242.7ECFCC34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ntfs: remove redundant variable idx
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fs-ntfs-remove-redundant-variable-idx.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-ntfs-remove-redundant-variable-idx.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Colin Ian King <colin.i.king@gmail.com>
Subject: fs/ntfs: remove redundant variable idx
Date: Tue, 17 May 2022 10:36:46 +0100

The variable idx is assigned a value and is never read.  The variable is
not used and is redundant, remove it.

Cleans up clang scan build warning:
warning: Although the value stored to 'idx' is used in the enclosing
expression, the value is never actually read from 'idx'
[deadcode.DeadStores]

Link: https://lkml.kernel.org/r/20220517093646.93628-2-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Reviewed-by: Anton Altaparmakov <anton@tuxera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ntfs/file.c~fs-ntfs-remove-redundant-variable-idx
+++ a/fs/ntfs/file.c
@@ -1772,11 +1772,11 @@ static ssize_t ntfs_perform_write(struct
 	last_vcn = -1;
 	do {
 		VCN vcn;
-		pgoff_t idx, start_idx;
+		pgoff_t start_idx;
 		unsigned ofs, do_pages, u;
 		size_t copied;
 
-		start_idx = idx = pos >> PAGE_SHIFT;
+		start_idx = pos >> PAGE_SHIFT;
 		ofs = pos & ~PAGE_MASK;
 		bytes = PAGE_SIZE - ofs;
 		do_pages = 1;
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

fs-ntfs-remove-redundant-variable-idx.patch


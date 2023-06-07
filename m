Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB0DBC7EE23
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 17:23:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbjFGRX2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jun 2023 13:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbjFGRXX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jun 2023 13:23:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756A71BF3;
        Wed,  7 Jun 2023 10:23:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 126D363BCC;
        Wed,  7 Jun 2023 17:23:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 604D4C433EF;
        Wed,  7 Jun 2023 17:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686158601;
        bh=1m0Tk+ctM0cE1KOrvLtrPd6EwtDWeQa+7BFaRexity0=;
        h=Date:To:From:Subject:From;
        b=ww465uNtw9I8tTLBJ/9YenVuX5bJHp+pFrVU9a+NgbclD6QmeMDeOE4I+9dnqbRwt
         fKytA3cB4RM6gUcdLPLfhCfVJ+LP9KnnuSqPBybsh4Cu4wwk/lMv5ehPQce2CsayGZ
         dhwXvVDSHJh3PJamS1yDdItm+L8Pe9vTe6zBScP4=
Date:   Wed, 07 Jun 2023 10:23:20 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        mike.kravetz@oracle.com, marcandre.lureau@redhat.com,
        roberto.sassu@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memfd-check-for-non-null-file_seals-in-memfd_create-syscall.patch added to mm-hotfixes-unstable branch
Message-Id: <20230607172321.604D4C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memfd: check for non-NULL file_seals in memfd_create() syscall
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     memfd-check-for-non-null-file_seals-in-memfd_create-syscall.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memfd-check-for-non-null-file_seals-in-memfd_create-syscall.patch

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
From: Roberto Sassu <roberto.sassu@huawei.com>
Subject: memfd: check for non-NULL file_seals in memfd_create() syscall
Date: Wed, 7 Jun 2023 15:24:27 +0200

Ensure that file_seals is non-NULL before using it in the memfd_create()
syscall.  One situation in which memfd_file_seals_ptr() could return a
NULL pointer is when CONFIG_SHMEM=n.

Link: https://lkml.kernel.org/r/20230607132427.2867435-1-roberto.sassu@huaweicloud.com
Fixes: 47b9012ecdc7 ("shmem: add sealing support to hugetlb-backed memfd")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Cc: Marc-Andr Lureau <marcandre.lureau@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/memfd.c~memfd-check-for-non-null-file_seals-in-memfd_create-syscall
+++ a/mm/memfd.c
@@ -371,12 +371,15 @@ SYSCALL_DEFINE2(memfd_create,
 
 		inode->i_mode &= ~0111;
 		file_seals = memfd_file_seals_ptr(file);
-		*file_seals &= ~F_SEAL_SEAL;
-		*file_seals |= F_SEAL_EXEC;
+		if (file_seals) {
+			*file_seals &= ~F_SEAL_SEAL;
+			*file_seals |= F_SEAL_EXEC;
+		}
 	} else if (flags & MFD_ALLOW_SEALING) {
 		/* MFD_EXEC and MFD_ALLOW_SEALING are set */
 		file_seals = memfd_file_seals_ptr(file);
-		*file_seals &= ~F_SEAL_SEAL;
+		if (file_seals)
+			*file_seals &= ~F_SEAL_SEAL;
 	}
 
 	fd_install(fd, file);
_

Patches currently in -mm which might be from roberto.sassu@huawei.com are

memfd-check-for-non-null-file_seals-in-memfd_create-syscall.patch


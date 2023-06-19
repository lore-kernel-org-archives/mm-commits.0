Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31FA4EB64DB
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 20:20:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbjFSUUU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 16:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjFSUUK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 16:20:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D178199;
        Mon, 19 Jun 2023 13:20:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 272C360C96;
        Mon, 19 Jun 2023 20:20:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8096AC433C0;
        Mon, 19 Jun 2023 20:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687206008;
        bh=BnTTsonXDCFaDO3hpoYOOMVwChJ5TEBN7H4Y60zt26U=;
        h=Date:To:From:Subject:From;
        b=ZWfFBBLNqGHmYSnyKSXSibmH2CIt46WPKcmf3HX9AL0zqmymVqL+u3Yp+5sEvopws
         quH5tgOAqYgm5A0jdPbXhXxUJ0LoghC1XGSC44nnzp2JIXmHDGTdTOqDhwQBtGVr/H
         OuACS37xYiPBMDdZUWYpCeTWNh3N9GbNWLW9rq14=
Date:   Mon, 19 Jun 2023 13:20:07 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        mike.kravetz@oracle.com, marcandre.lureau@redhat.com,
        roberto.sassu@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] memfd-check-for-non-null-file_seals-in-memfd_create-syscall.patch removed from -mm tree
Message-Id: <20230619202008.8096AC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memfd: check for non-NULL file_seals in memfd_create() syscall
has been removed from the -mm tree.  Its filename was
     memfd-check-for-non-null-file_seals-in-memfd_create-syscall.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Roberto Sassu <roberto.sassu@huawei.com>
Subject: memfd: check for non-NULL file_seals in memfd_create() syscall
Date: Wed, 7 Jun 2023 15:24:27 +0200

Ensure that file_seals is non-NULL before using it in the memfd_create()
syscall.  One situation in which memfd_file_seals_ptr() could return a
NULL pointer when CONFIG_SHMEM=n, oopsing the kernel.

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

shmem-use-ramfs_kill_sb-for-kill_sb-method-of-ramfs-based-tmpfs.patch


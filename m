Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E51C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 03:53:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFDF460F3A
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 03:53:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236217AbhIODyk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Sep 2021 23:54:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:40924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236431AbhIODyZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Sep 2021 23:54:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 883BD60F25;
        Wed, 15 Sep 2021 03:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631677987;
        bh=k8mO4zY+saysO66sn8fucFzET3udxBRNzqij2Qc7WAA=;
        h=Date:From:To:Subject:From;
        b=dUAft9dYcd7T4y06FUzB1WnuXVVgqJ5+k4fx3c6o0o3eAVqfctumatGIDhoSY8TU7
         f/amV1rHO9C5coUVFY2EeJOoZI/kq9XiHLpqG4d+ytNnCpizlBkRRLOgPaAqRP53yr
         QekJP+J38bfP2hcLNpGuv/4fppv0mdiSBwgonDKU=
Date:   Tue, 14 Sep 2021 20:53:07 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ran.xiaokai@zte.com.cn
Subject:  + unshare-use-swap-to-make-code-cleaner.patch added to
 -mm tree
Message-ID: <20210915035307.D-pqFSGqK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/fork.c: unshare(): use swap() to make code cleaner
has been added to the -mm tree.  Its filename is
     unshare-use-swap-to-make-code-cleaner.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/unshare-use-swap-to-make-code-cleaner.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/unshare-use-swap-to-make-code-cleaner.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Subject: kernel/fork.c: unshare(): use swap() to make code cleaner

Use swap() instead of reimplementing it.

Link: https://lkml.kernel.org/r/20210909022046.8151-1-ran.xiaokai@zte.com.cn
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/kernel/fork.c~unshare-use-swap-to-make-code-cleaner
+++ a/kernel/fork.c
@@ -3078,7 +3078,7 @@ int unshare_fd(unsigned long unshare_fla
 int ksys_unshare(unsigned long unshare_flags)
 {
 	struct fs_struct *fs, *new_fs = NULL;
-	struct files_struct *fd, *new_fd = NULL;
+	struct files_struct *new_fd = NULL;
 	struct cred *new_cred = NULL;
 	struct nsproxy *new_nsproxy = NULL;
 	int do_sysvsem = 0;
@@ -3165,11 +3165,8 @@ int ksys_unshare(unsigned long unshare_f
 			spin_unlock(&fs->lock);
 		}
 
-		if (new_fd) {
-			fd = current->files;
-			current->files = new_fd;
-			new_fd = fd;
-		}
+		if (new_fd)
+			swap(current->files, new_fd);
 
 		task_unlock(current);
 
_

Patches currently in -mm which might be from ran.xiaokai@zte.com.cn are

unshare-use-swap-to-make-code-cleaner.patch


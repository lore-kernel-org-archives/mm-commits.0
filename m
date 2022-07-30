Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C703EC00144
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 00:54:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239475AbiG3Ayw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 20:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiG3Ayv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 20:54:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8398B72EF0
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 17:54:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D3CDB829FD
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 00:54:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB85FC433D6;
        Sat, 30 Jul 2022 00:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659142485;
        bh=8gU947xz3A+bL+0QENzmFfXDfRwKDrnaI2I2n08Gv34=;
        h=Date:To:From:Subject:From;
        b=WGkU2ppZLOZnmLxZnJvGaXY9dcholj8XNLei8R0OuT5+c0Uk4eCUiSyxMJK0eX0y9
         bFMCcVbaHHhY0bauSEvyXm5bHhPfTL1I/G7vDbFQ1WRzMGYwseV9kpZ+smIM4ItXu7
         iEQaP/mEQu85Dnr8MVCMMv1yKq6SWcwE47Gd3oG8=
Date:   Fri, 29 Jul 2022 17:54:44 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, tkjos@android.com,
        surenb@google.com, minchan@kernel.org, maco@android.com,
        Liam.Howlett@oracle.com, joel@joelfernandes.org, hridya@google.com,
        gregkh@linuxfoundation.org, brauner@kernel.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] android-binder-stop-saving-a-pointer-to-the-vma-fix.patch removed from -mm tree
Message-Id: <20220730005445.AB85FC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: android-binder-stop-saving-a-pointer-to-the-vma-fix
has been removed from the -mm tree.  Its filename was
     android-binder-stop-saving-a-pointer-to-the-vma-fix.patch

This patch was dropped because it was folded into android-binder-stop-saving-a-pointer-to-the-vma.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: android-binder-stop-saving-a-pointer-to-the-vma-fix
Date: Tue Jun 21 07:16:17 PM PDT 2022

fix drivers/android/binder_alloc_selftest.c

drivers/android/binder_alloc_selftest.c: In function 'binder_selftest_alloc':
drivers/android/binder_alloc_selftest.c:290:43: error: 'struct binder_alloc' has no member named 'vma'
  290 |         if (!binder_selftest_run || !alloc->vma)


Cc: Christian Brauner (Microsoft) <brauner@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hridya Valsaraju <hridya@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Martijn Coenen <maco@android.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Todd Kjos <tkjos@android.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/android/binder_alloc_selftest.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/android/binder_alloc_selftest.c~android-binder-stop-saving-a-pointer-to-the-vma-fix
+++ a/drivers/android/binder_alloc_selftest.c
@@ -287,7 +287,7 @@ void binder_selftest_alloc(struct binder
 	if (!binder_selftest_run)
 		return;
 	mutex_lock(&binder_selftest_lock);
-	if (!binder_selftest_run || !alloc->vma)
+	if (!binder_selftest_run || !alloc->vma_addr)
 		goto done;
 	pr_info("STARTED\n");
 	binder_selftest_alloc_offset(alloc, end_offset, 0);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

android-binder-stop-saving-a-pointer-to-the-vma.patch
mm-shmem-support-fs_ioc_etflags-in-tmpfs-fix.patch


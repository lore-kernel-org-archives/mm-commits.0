Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1B80C19F2B
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:08:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239596AbiG3BIU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239548AbiG3BIQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:08:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB0C78221
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:08:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B194EB82929
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:08:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AEC7C433D6;
        Sat, 30 Jul 2022 01:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143292;
        bh=eGfcghgWFgulq2rt7PANymauvzTPLDgHyc+YMKKB0Q8=;
        h=Date:To:From:Subject:From;
        b=U3yiVT1DPbsm7jid4ksKAi2Wyj2T4nuUXZLDhYpwgxsGF0tDaKc2wrfirq6u+2TRP
         ty47oYp1GEq7l3lBdJA1ZvzVJ68VjHBCjHQ0WzM8gFdFO7ufw97jori63uJCTsxZol
         lPoem6s7lsSSJMX7prYJ2RBYwsUyVmfl8aJPSL+I=
Date:   Fri, 29 Jul 2022 18:08:11 -0700
To:     mm-commits@vger.kernel.org, tkjos@google.com, surenb@google.com,
        maco@android.com, Liam.Howlett@oracle.com, joel@joelfernandes.org,
        hridya@google.com, gregkh@linuxfoundation.org, brauner@kernel.org,
        arve@android.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] android-binder-fix-lockdep-check-on-clearing-vma.patch removed from -mm tree
Message-Id: <20220730010812.6AEC7C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: android: binder: fix lockdep check on clearing vma
has been removed from the -mm tree.  Its filename was
     android-binder-fix-lockdep-check-on-clearing-vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: android: binder: fix lockdep check on clearing vma
Date: Mon, 27 Jun 2022 15:18:59 +0000

When munmapping a vma, the mmap_lock can be degraded to a write before
calling close() on the file handle.  The binder close() function calls
binder_alloc_set_vma() to clear the vma address, which now has a lock dep
check for writing on the mmap_lock.  Change the lockdep check to ensure
the reading lock is held while clearing and keep the write check while
writing.

Link: https://lkml.kernel.org/r/20220627151857.2316964-1-Liam.Howlett@oracle.com
Fixes: 472a68df605b ("android: binder: stop saving a pointer to the VMA")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: syzbot+da54fa8d793ca89c741f@syzkaller.appspotmail.com
Acked-by: Todd Kjos <tkjos@google.com>
Cc: "Arve Hjønnevåg" <arve@android.com>
Cc: Christian Brauner (Microsoft) <brauner@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hridya Valsaraju <hridya@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Martijn Coenen <maco@android.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/android/binder_alloc.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/android/binder_alloc.c~android-binder-fix-lockdep-check-on-clearing-vma
+++ a/drivers/android/binder_alloc.c
@@ -315,12 +315,19 @@ static inline void binder_alloc_set_vma(
 {
 	unsigned long vm_start = 0;
 
+	/*
+	 * Allow clearing the vma with holding just the read lock to allow
+	 * munmapping downgrade of the write lock before freeing and closing the
+	 * file using binder_alloc_vma_close().
+	 */
 	if (vma) {
 		vm_start = vma->vm_start;
 		alloc->vma_vm_mm = vma->vm_mm;
+		mmap_assert_write_locked(alloc->vma_vm_mm);
+	} else {
+		mmap_assert_locked(alloc->vma_vm_mm);
 	}
 
-	mmap_assert_write_locked(alloc->vma_vm_mm);
 	alloc->vma_addr = vm_start;
 }
 
_

Patches currently in -mm which might be from liam.howlett@oracle.com are



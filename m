Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2BABC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jun 2022 19:06:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238517AbiF0TGE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Jun 2022 15:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237731AbiF0TGC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Jun 2022 15:06:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37DFB21B1
        for <mm-commits@vger.kernel.org>; Mon, 27 Jun 2022 12:06:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD0ACB81A96
        for <mm-commits@vger.kernel.org>; Mon, 27 Jun 2022 19:05:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70BC6C3411D;
        Mon, 27 Jun 2022 19:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656356757;
        bh=Muv00RZTeYqQloAph16A1HTf9SvjHOHOq90UPv81t0I=;
        h=Date:To:From:Subject:From;
        b=gFRzdFdIdpV7nK/R0HmcbmrY64WXuMxT14DC6uWr+HRV1+ERLMChDtZLzxPARdyYK
         QkVxsmHMkl5Ndb5YvObB5Vd37UvTk4vR+Q4lbwwNU6OQpbI4ye/M0O1kE2f4X1zOxW
         prxIDCP1N4DqJTc9NGGHxy3BYMerO+Mo4nv1hStw=
Date:   Mon, 27 Jun 2022 12:05:56 -0700
To:     mm-commits@vger.kernel.org, tkjos@google.com, surenb@google.com,
        maco@android.com, Liam.Howlett@oracle.com, joel@joelfernandes.org,
        hridya@google.com, gregkh@linuxfoundation.org, brauner@kernel.org,
        arve@android.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + android-binder-fix-lockdep-check-on-clearing-vma.patch added to mm-unstable branch
Message-Id: <20220627190557.70BC6C3411D@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: android: binder: fix lockdep check on clearing vma
has been added to the -mm mm-unstable branch.  Its filename is
     android-binder-fix-lockdep-check-on-clearing-vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/android-binder-fix-lockdep-check-on-clearing-vma.patch

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

android-binder-fix-lockdep-check-on-clearing-vma.patch
maple-tree-add-new-data-structure-fix.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix.patch
mm-mlock-drop-dead-code-in-count_mm_mlocked_page_nr.patch


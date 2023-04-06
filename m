Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BBA9C761A6
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 03:03:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234983AbjDFDDy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 23:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234895AbjDFDDi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 23:03:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C0807EEA
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 20:03:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC95E62D65
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 03:03:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E8AC433D2;
        Thu,  6 Apr 2023 03:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680750216;
        bh=oGmjZT84jliSD/qrTU+41yMEKRghuhyjDeLdWQGPvyk=;
        h=Date:To:From:Subject:From;
        b=aX1B+x21tJ1+c7mxApz6EgLZNvsA710uDpIe4z5Ev4xfZBvlCI6RmrJQ9UIacasIi
         oApsCiP1LGnQtU7Iy2FmO5bGvyHYsPnsc1oIZ2hswOQVom1rZo7Ip7jTsamRQ5gmeL
         VlfyQbnNC2H82SDNrmbJpiOjX/bSYeV+qLW4W7pg=
Date:   Wed, 05 Apr 2023 20:03:35 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mark-vma-as-being-written-when-changing-vm_flags.patch removed from -mm tree
Message-Id: <20230406030336.32E8AC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: mark VMA as being written when changing vm_flags
has been removed from the -mm tree.  Its filename was
     mm-mark-vma-as-being-written-when-changing-vm_flags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: mark VMA as being written when changing vm_flags
Date: Mon, 27 Feb 2023 09:36:12 -0800

Updates to vm_flags have to be done with VMA marked as being written for
preventing concurrent page faults or other modifications.

Link: https://lkml.kernel.org/r/20230227173632.3292573-14-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/mm.h~mm-mark-vma-as-being-written-when-changing-vm_flags
+++ a/include/linux/mm.h
@@ -727,28 +727,28 @@ static inline void vm_flags_init(struct
 static inline void vm_flags_reset(struct vm_area_struct *vma,
 				  vm_flags_t flags)
 {
-	mmap_assert_write_locked(vma->vm_mm);
+	vma_start_write(vma);
 	vm_flags_init(vma, flags);
 }
 
 static inline void vm_flags_reset_once(struct vm_area_struct *vma,
 				       vm_flags_t flags)
 {
-	mmap_assert_write_locked(vma->vm_mm);
+	vma_start_write(vma);
 	WRITE_ONCE(ACCESS_PRIVATE(vma, __vm_flags), flags);
 }
 
 static inline void vm_flags_set(struct vm_area_struct *vma,
 				vm_flags_t flags)
 {
-	mmap_assert_write_locked(vma->vm_mm);
+	vma_start_write(vma);
 	ACCESS_PRIVATE(vma, __vm_flags) |= flags;
 }
 
 static inline void vm_flags_clear(struct vm_area_struct *vma,
 				  vm_flags_t flags)
 {
-	mmap_assert_write_locked(vma->vm_mm);
+	vma_start_write(vma);
 	ACCESS_PRIVATE(vma, __vm_flags) &= ~flags;
 }
 
@@ -769,7 +769,7 @@ static inline void __vm_flags_mod(struct
 static inline void vm_flags_mod(struct vm_area_struct *vma,
 				vm_flags_t set, vm_flags_t clear)
 {
-	mmap_assert_write_locked(vma->vm_mm);
+	vma_start_write(vma);
 	__vm_flags_mod(vma, set, clear);
 }
 
_

Patches currently in -mm which might be from surenb@google.com are



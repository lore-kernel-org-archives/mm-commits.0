Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2505FC6FD1D
	for <mm-commits@archiver.kernel.org>; Fri,  7 Apr 2023 22:20:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjDGWUF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Apr 2023 18:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjDGWUE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Apr 2023 18:20:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA347ECB
        for <mm-commits@vger.kernel.org>; Fri,  7 Apr 2023 15:19:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4413265492
        for <mm-commits@vger.kernel.org>; Fri,  7 Apr 2023 22:19:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2BFC433EF;
        Fri,  7 Apr 2023 22:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680905991;
        bh=iPR7aCFreFmuxLzsVZYpDcdaom13kdXQa7Kj5UjuMb0=;
        h=Date:To:From:Subject:From;
        b=sjOe+qJjh7BR4QgMuvlNcI30kWIAyJgBcsaT0JobvwIOPjiw7OxxQdvshMq523Mno
         t+aMbnfCbO061aDEm7lu6+lQ12EWZpF7KbCqwtTJlaSiTO5UzPJnom7epF7t3uHxbE
         UBu1dsufiXeontAtOAhIGNW5EsPnMeE/kWiH7HJE=
Date:   Fri, 07 Apr 2023 15:19:51 -0700
To:     mm-commits@vger.kernel.org, shr@devkernel.io,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-new-api-to-enable-ksm-per-process-fix-2.patch added to mm-unstable branch
Message-Id: <20230407221951.9C2BFC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix: remove ksm_add_mm and ksm_add_vmas
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-new-api-to-enable-ksm-per-process-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-new-api-to-enable-ksm-per-process-fix-2.patch

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
From: Stefan Roesch <shr@devkernel.io>
Subject: mm: fix: remove ksm_add_mm and ksm_add_vmas
Date: Thu, 6 Apr 2023 21:24:54 -0700

The function ksm_add_mm() and ksm_add_vmas() don't need to be defined
when CONFIG_KSM is not defined.

Link: https://lkml.kernel.org/r/20230407042454.1449599-1-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ksm.h |    8 --------
 1 file changed, 8 deletions(-)

--- a/include/linux/ksm.h~mm-add-new-api-to-enable-ksm-per-process-fix-2
+++ a/include/linux/ksm.h
@@ -62,18 +62,10 @@ void folio_migrate_ksm(struct folio *new
 
 #else  /* !CONFIG_KSM */
 
-static inline int ksm_add_mm(struct mm_struct *mm)
-{
-}
-
 static inline void ksm_add_vma(struct vm_area_struct *vma)
 {
 }
 
-static inline void ksm_add_vmas(struct mm_struct *mm)
-{
-}
-
 static inline int ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 {
 	return 0;
_

Patches currently in -mm which might be from shr@devkernel.io are

mm-add-new-api-to-enable-ksm-per-process.patch
mm-add-new-api-to-enable-ksm-per-process-fix-2.patch
mm-add-new-ksm-process-and-sysfs-knobs.patch
selftests-mm-add-new-selftests-for-ksm.patch


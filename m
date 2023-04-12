Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03110C76196
	for <mm-commits@archiver.kernel.org>; Wed, 12 Apr 2023 00:29:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbjDLA3Q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Apr 2023 20:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjDLA3P (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Apr 2023 20:29:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915061FD2
        for <mm-commits@vger.kernel.org>; Tue, 11 Apr 2023 17:29:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BFC962CE5
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 00:29:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8102CC433EF;
        Wed, 12 Apr 2023 00:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681259353;
        bh=dN9lQ+Q83bZBargD9YQ0fmijAKljzWlAhUFgU/4N86Y=;
        h=Date:To:From:Subject:From;
        b=TwFNg/45T3vrTaX2PiCbnjktRr+mtcdenU3NhYGTNDyT8QOdvMSqkb7NmhAyfz24f
         gUgYdqNgVIDjQ19s87TtgsWMSEopVtqb9pwikMjsS+khv34AXdtRNEfa0KPTsDdYaQ
         LMkjuKRsQgeXnTacDpVgLuYw1FG2KG0nk5XQ5MZQ=
Date:   Tue, 11 Apr 2023 17:29:12 -0700
To:     mm-commits@vger.kernel.org, shr@devkernel.io,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-add-new-api-to-enable-ksm-per-process-fix-2.patch removed from -mm tree
Message-Id: <20230412002913.8102CC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: fix: remove ksm_add_mm and ksm_add_vmas
has been removed from the -mm tree.  Its filename was
     mm-add-new-api-to-enable-ksm-per-process-fix-2.patch

This patch was dropped because an updated version will be merged

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

mm-add-new-ksm-process-and-sysfs-knobs.patch
selftests-mm-add-new-selftests-for-ksm.patch


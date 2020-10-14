Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EA21C2D0A1
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 538792224D
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709316;
	bh=2dSzsaruAzMB9zkgysLN5Yk3p3ctUSzYtejPtWCDMlM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=DZ70uXqn4lPGduDghdNyFxOBbQdZTDLWVXNUNAx7z8BezGMvJDg0M4z3O/sA2TqkS
	 EMGkSDOCa5x0caZgH8TYtUwHRMX2JpYOig7qvCjcqzq88SppQZPGgm0NxGzqlBpSzz
	 8D3Ol/JmA37nr6s4ZPUI65ByKbdXsvyxZyIZVmio=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730559AbgJNVBp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:01:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:51546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730477AbgJNVBo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:01:44 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A38B122258;
        Wed, 14 Oct 2020 21:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709291;
        bh=2dSzsaruAzMB9zkgysLN5Yk3p3ctUSzYtejPtWCDMlM=;
        h=Date:From:To:Subject:From;
        b=r8nHMsthYLFUkMyrhIRa/7tRuf1fwECpVfI6LahSji5co5vgqvus7FPoyODPolUU7
         +ZrknTGnO2jV3oEkHBzOK99JI9+Ihxm6dBdllNW/LnQ9rbX5Ng7WjbNwNUOhvbT2AQ
         aE0iv8rVi8L+2ZirOtt5Bk43zYDcFiOA4SwLKDoY=
Date:   Wed, 14 Oct 2020 14:01:31 -0700
From:   akpm@linux-foundation.org
To:     liao.pingfang@zte.com.cn, mm-commits@vger.kernel.org,
        wang.yi59@zte.com.cn
Subject:  [merged]
 =?US-ASCII?Q?mm-mmapc-replace-do=5Fbrk-with-do=5Fbrk=5Fflags-in-comment-o?=
 =?US-ASCII?Q?f-insert=5Fvm=5Fstruct.patch?= removed from -mm tree
Message-ID: <20201014210131.czbBQWRr9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: replace do_brk with do_brk_flags in comment of insert_vm_struct()
has been removed from the -mm tree.  Its filename was
     mm-mmapc-replace-do_brk-with-do_brk_flags-in-comment-of-insert_vm_struct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Liao Pingfang <liao.pingfang@zte.com.cn>
Subject: mm/mmap.c: replace do_brk with do_brk_flags in comment of insert_vm_struct()

Replace do_brk with do_brk_flags in comment of insert_vm_struct(), since
do_brk was removed in following commit.

Link: https://lkml.kernel.org/r/1600650778-43230-1-git-send-email-wang.yi59@zte.com.cn
Fixes: bb177a732c4369 ("mm: do not bug_on on incorrect length in __mm_populate()")
Signed-off-by: Liao Pingfang <liao.pingfang@zte.com.cn>
Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mmap.c~mm-mmapc-replace-do_brk-with-do_brk_flags-in-comment-of-insert_vm_struct
+++ a/mm/mmap.c
@@ -3233,7 +3233,7 @@ int insert_vm_struct(struct mm_struct *m
 	 * By setting it to reflect the virtual start address of the
 	 * vma, merges and splits can happen in a seamless way, just
 	 * using the existing file pgoff checks and manipulations.
-	 * Similarly in do_mmap and in do_brk.
+	 * Similarly in do_mmap and in do_brk_flags.
 	 */
 	if (vma_is_anonymous(vma)) {
 		BUG_ON(vma->anon_vma);
_

Patches currently in -mm which might be from liao.pingfang@zte.com.cn are

kernel-sysc-replace-do_brk-with-do_brk_flags-in-comment-of-prctl_set_mm_map.patch


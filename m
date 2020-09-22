Return-Path: <SRS0=iiPm=C7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABB1AC4363D
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 18:16:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A48220773
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 18:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600798569;
	bh=4yJaMH6J56Y8JJIy6KoLUhdThWDcB0d4M9EaStzbEQ4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=fyqR4dN+NWkAGueSWdlnIXgZ/tFnXpmZvUY/bu49kBZUNYzLb++jL7BPC4RNa7+hv
	 8oKPcK0dpkVQKq6/76O5j5ZPqdjU9QixU0OdCh4iwzQx2+gSGCwgJBY0og4cFmkjuM
	 9TX59UVcRe5iopXZy1LmpOBIIPA0GGhATUON+g8c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgIVSQI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Sep 2020 14:16:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbgIVSQI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Sep 2020 14:16:08 -0400
Received: from X1 (unknown [216.241.194.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1BD820739;
        Tue, 22 Sep 2020 18:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600798568;
        bh=4yJaMH6J56Y8JJIy6KoLUhdThWDcB0d4M9EaStzbEQ4=;
        h=Date:From:To:Subject:From;
        b=MmhNOic+uSgPElsjFOvbRxUe8VtHKNfpXImMBZGPXWNbUT3CAa1sfp/d6c7Ce1FA7
         GrgKCwPotzKTson6hEN48qnJkBavEPjU+UzscAS85/QjJ8R0D4QFtf7oy92wh22a8g
         Ub7sqeuccPDjC4uPn6xe3WkULMjv0jVaDBngzZeM=
Date:   Tue, 22 Sep 2020 11:16:07 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, wang.yi59@zte.com.cn,
        liao.pingfang@zte.com.cn
Subject:  +
 mm-mmapc-replace-do_brk-with-do_brk_flags-in-comment-of-insert_vm_struct.patch
 added to -mm tree
Message-ID: <20200922181607.PPgeT%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: replace do_brk with do_brk_flags in comment of insert_vm_struct()
has been added to the -mm tree.  Its filename is
     mm-mmapc-replace-do_brk-with-do_brk_flags-in-comment-of-insert_vm_struct.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mmapc-replace-do_brk-with-do_brk_flags-in-comment-of-insert_vm_struct.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mmapc-replace-do_brk-with-do_brk_flags-in-comment-of-insert_vm_struct.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -3235,7 +3235,7 @@ int insert_vm_struct(struct mm_struct *m
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

mm-mmapc-replace-do_brk-with-do_brk_flags-in-comment-of-insert_vm_struct.patch
kernel-sysc-replace-do_brk-with-do_brk_flags-in-comment-of-prctl_set_mm_map.patch


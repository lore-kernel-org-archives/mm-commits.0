Return-Path: <SRS0=vJaG=CJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6021EC433E6
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 00:36:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 420952083E
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 00:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598834192;
	bh=OHzqcGX7YjQPao1Rww8BxiZX7JUvc6knADVNUTVEc8k=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=hpreuxU4FwIjVZS7q1QoPDoMpRpX7abU8mTRX7FQh/hUKRmmIhqkxG9363+UAAFF3
	 Kx7vWx7P10w4y7Z0Iv1dpuICpeKhNOFPUn0v080gYqqmNZ6wArX9U6Zl5CTnwreHOn
	 sTMpSjykwHMNiXKSmMvvmfWbx4kZoVdNNMKS9AW4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgHaAg3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 30 Aug 2020 20:36:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbgHaAg3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 30 Aug 2020 20:36:29 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05FE4207BB;
        Mon, 31 Aug 2020 00:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598834187;
        bh=OHzqcGX7YjQPao1Rww8BxiZX7JUvc6knADVNUTVEc8k=;
        h=Date:From:To:Subject:From;
        b=GVpsrz0q8pxD+HcwqXUijRTkOAwr1vsBCtHtDSYH8DREEV+6UovSu1jhxIgMwyPu4
         3rQPZc0qpdv4KehdCVtdRaFpal/sEUFeRxcBaTdJszVbBryGzba4H3ZG8TBuk070vC
         oVPjCBtoAuBxgh/AWnpjQK4AxCBn++T7qX9DQLaE=
Date:   Sun, 30 Aug 2020 17:36:26 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, oleg@redhat.com, hch@lst.de,
        ebiederm@xmission.com, jannh@google.com
Subject:  + coredump-let-dump_emit-bail-out-on-short-writes.patch
 added to -mm tree
Message-ID: <20200831003626.jD5Bt%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: let dump_emit() bail out on short writes
has been added to the -mm tree.  Its filename is
     coredump-let-dump_emit-bail-out-on-short-writes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/coredump-let-dump_emit-bail-out-on-short-writes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/coredump-let-dump_emit-bail-out-on-short-writes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: coredump: let dump_emit() bail out on short writes

dump_emit() has a retry loop, but there seems to be no way for that retry
logic to actually be used; and it was also buggy, writing the same data
repeatedly after a short write.

Let's just bail out on a short write.

Link: http://lkml.kernel.org/r/20200827114932.3572699-3-jannh@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/fs/coredump.c~coredump-let-dump_emit-bail-out-on-short-writes
+++ a/fs/coredump.c
@@ -840,17 +840,17 @@ int dump_emit(struct coredump_params *cp
 	ssize_t n;
 	if (cprm->written + nr > cprm->limit)
 		return 0;
-	while (nr) {
-		if (dump_interrupted())
-			return 0;
-		n = __kernel_write(file, addr, nr, &pos);
-		if (n <= 0)
-			return 0;
-		file->f_pos = pos;
-		cprm->written += n;
-		cprm->pos += n;
-		nr -= n;
-	}
+
+
+	if (dump_interrupted())
+		return 0;
+	n = __kernel_write(file, addr, nr, &pos);
+	if (n != nr)
+		return 0;
+	file->f_pos = pos;
+	cprm->written += n;
+	cprm->pos += n;
+
 	return 1;
 }
 EXPORT_SYMBOL(dump_emit);
_

Patches currently in -mm which might be from jannh@google.com are

binfmt_elf_fdpic-stop-using-dump_emit-on-user-pointers-on-mmu.patch
coredump-let-dump_emit-bail-out-on-short-writes.patch
coredump-refactor-page-range-dumping-into-common-helper.patch
coredump-rework-elf-elf_fdpic-vma_dump_size-into-common-helper.patch
binfmt_elf-binfmt_elf_fdpic-use-a-vma-list-snapshot.patch
mm-gup-take-mmap_lock-in-get_dump_page.patch
mm-remove-the-now-unnecessary-mmget_still_valid-hack.patch


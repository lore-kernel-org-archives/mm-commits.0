Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0C64C43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:54:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E15121775
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881674;
	bh=T9j6ZZNxF+B2rpS38H6myr4AJHgP1bs4hJ0m2m4wuTQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=z6N5oVBwlROA3tbP4tmU2r+IZkjRBUhbRyXGmM4cQaYRdvSh8d9Xivmkj94iPdVZi
	 xtI1Z2oU+PXI1OgSUntQWkpa6twXHxJaPzjDCREYuhlRlqEkdntDATUy74G+orzypF
	 uO0EveHTQ4777D7QmUrlGbngaqg6OChybTKmp25g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409413AbgJPUye (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:54:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391502AbgJPUyd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:54:33 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C415F2076C;
        Fri, 16 Oct 2020 20:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881673;
        bh=T9j6ZZNxF+B2rpS38H6myr4AJHgP1bs4hJ0m2m4wuTQ=;
        h=Date:From:To:Subject:From;
        b=sydZljoUFSrI8wVpgWZSxwbmJRfToOlRQdHBzc/rLV8+AuxsKaaoVlb7sY7piHabB
         +cXI4l//TzHnidq+bjEYdcPyvHSKDBIcbHlPEvHokJS0uXaorwKBDdBz92JSyuSt9w
         6iQMwts7ZKDJa+P+1fK1wQd54iGUjL2kCNEb/UrA=
Date:   Fri, 16 Oct 2020 13:54:32 -0700
From:   akpm@linux-foundation.org
To:     ebiederm@xmission.com, hch@lst.de, hughd@google.com,
        jannh@google.com, mm-commits@vger.kernel.org, oleg@redhat.com,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject:  [merged]
 coredump-let-dump_emit-bail-out-on-short-writes.patch removed from -mm tree
Message-ID: <20201016205432.UqBKJHOu5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: let dump_emit() bail out on short writes
has been removed from the -mm tree.  Its filename was
     coredump-let-dump_emit-bail-out-on-short-writes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: Hugh Dickins <hughd@google.com>
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

mm-gup_benchmark-take-the-mmap-lock-around-gup.patch
binfmt_elf-take-the-mmap-lock-around-find_extend_vma.patch
mmap-locking-api-dont-check-locking-if-the-mm-isnt-live-yet.patch
mm-gup-assert-that-the-mmap-lock-is-held-in-__get_user_pages.patch


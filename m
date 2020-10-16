Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76A53C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:49:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A0D320897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816582;
	bh=QH3J1yTdWGVTZhRpQWrYWeY+CtuYpjMq5hwuWm6wRdM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=c6cgQzyXhNUCbinZYDiK/dE2rEEXkMtmRUiWxI3HCn4LM8VLpwMzhFs/6YbugQnP0
	 BS9XZ4LqhlKiud3x4ymEjVwm2WEfaV730gMKMaQk5LhP989C8IAI65Etx3gl4/ZRmZ
	 dJmXDj7220MAQbJbUfKbcy46ZYi1qaxkSniNe5OE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404390AbgJPCtl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:49:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:37298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404388AbgJPCtk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:49:40 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1585C208C7;
        Fri, 16 Oct 2020 02:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816579;
        bh=QH3J1yTdWGVTZhRpQWrYWeY+CtuYpjMq5hwuWm6wRdM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=iNxPEa8G43LkKzTZyFNb5RToTVbhd+Qw8qu05zRr0udytyhnxm4R3DN81lT63jLO+
         tCaa0D1BsM7qaB7VPGd5XJJMJqy7I7aMIOkFI9m2th1JeFux98CtIQU3jkMfY1blcc
         Td+wqyFRWe7gS7+XpqGbbXRoMXunhH06uqSm6bjU=
Date:   Thu, 15 Oct 2020 19:49:38 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ebiederm@xmission.com, hch@lst.de,
        hughd@google.com, jannh@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, oleg@redhat.com,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject:  [patch 137/156] coredump: let dump_emit() bail out on
 short writes
Message-ID: <20201016024938.1zaQbvIF0%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

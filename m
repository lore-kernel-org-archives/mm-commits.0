Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FA30C43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:12:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4584120878
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817965;
	bh=QH3J1yTdWGVTZhRpQWrYWeY+CtuYpjMq5hwuWm6wRdM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=uTf3NRscKeTg87ApEjrA44Uv/x1tQgZz3YKtASTlU6+jYYcKJ7hNy67RKTmVVz9Xl
	 MoCqIOXOZwBnbU3YAmnQwSsYkGhA/kIKJxWrek5MRXPWy9l9MxgUzhkulPOKVkJmwz
	 Zw4y1EdzTEq2huTxv1jLKBwvUj5JpbUHV9kB/Tk8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390134AbgJPDMp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:12:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:48684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389908AbgJPDMo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:12:44 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E70D32078A;
        Fri, 16 Oct 2020 03:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817964;
        bh=QH3J1yTdWGVTZhRpQWrYWeY+CtuYpjMq5hwuWm6wRdM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=2GGGch2GwKmyPIiBRN1uWPRVVFGRKTDnY974I5AhRiQvBjqD1c0xbpCfXh0Lgpk0q
         LufRVJ4zGl/uI3T+hCO0JWJ3aEE2HYWZYoJt7y+sp+vc4xnkZg4UAXWE3Q0AwFnXbI
         c/Kuc7H6Ga8+JmX97eFKyt+znRhF1pWvYJ2h0o78=
Date:   Thu, 15 Oct 2020 20:12:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ebiederm@xmission.com, hch@lst.de,
        hughd@google.com, jannh@google.com, mm-commits@vger.kernel.org,
        oleg@redhat.com, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject:  [patch 137/156] coredump: let dump_emit() bail out on
 short writes
Message-ID: <20201016031243.daSAejNL7%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
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

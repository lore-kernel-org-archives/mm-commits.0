Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 323ABC07E9E
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:21:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 177AB61CA7
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:21:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhGFTYd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:24:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230032AbhGFTYd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:24:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3B0461CA3;
        Tue,  6 Jul 2021 19:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599314;
        bh=yr2MeFa8PXzKXkMMDyIkIVhq4JssOdkly/QESVe+ozk=;
        h=Date:From:To:Subject:From;
        b=OzOXzdW/FucdtuZQxG4gKj7tkVmpAHpfrB0sJOcTVCxUtjwDhn4C6bIEcOcCnFDgX
         if9+evgvQoKRoNp+sr3U421P3Zfr4GfsLWvZ/JEwdLDyZhx/1E3qCb6BiGNFzhXiNr
         uIsVzAXhvz//8eO44dJS+gzG1ZzhUGsaq0Q8h+1Y=
Date:   Tue, 06 Jul 2021 12:21:53 -0700
From:   akpm@linux-foundation.org
To:     abaci@linux.alibaba.com, andrii@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, jiapeng.chong@linux.alibaba.com,
        john.fastabend@gmail.com, kafai@fb.com, keescook@chromium.org,
        kpsingh@kernel.org, mcgrof@kernel.org, mm-commits@vger.kernel.org,
        songliubraving@fb.com, yhs@fb.com, yzaikin@google.com
Subject:  [merged]
 sysctl-remove-redundant-assignment-to-first.patch removed from -mm tree
Message-ID: <20210706192153.6oeZSu8ql%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: remove redundant assignment to first
has been removed from the -mm tree.  Its filename was
     sysctl-remove-redundant-assignment-to-first.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: sysctl: remove redundant assignment to first

Variable first is set to '0', but this value is never read as it is not
used later on, hence it is a redundant assignment and can be removed.

Clean up the following clang-analyzer warning:

kernel/sysctl.c:1562:4: warning: Value stored to 'first' is never read
[clang-analyzer-deadcode.DeadStores].

Link: https://lkml.kernel.org/r/1620469990-22182-1-git-send-email-jiapeng.chong@linux.alibaba.com
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/sysctl.c~sysctl-remove-redundant-assignment-to-first
+++ a/kernel/sysctl.c
@@ -1494,7 +1494,6 @@ int proc_do_large_bitmap(struct ctl_tabl
 			 void *buffer, size_t *lenp, loff_t *ppos)
 {
 	int err = 0;
-	bool first = 1;
 	size_t left = *lenp;
 	unsigned long bitmap_len = table->maxlen;
 	unsigned long *bitmap = *(unsigned long **) table->data;
@@ -1579,12 +1578,12 @@ int proc_do_large_bitmap(struct ctl_tabl
 			}
 
 			bitmap_set(tmp_bitmap, val_a, val_b - val_a + 1);
-			first = 0;
 			proc_skip_char(&p, &left, '\n');
 		}
 		left += skipped;
 	} else {
 		unsigned long bit_a, bit_b = 0;
+		bool first = 1;
 
 		while (left) {
 			bit_a = find_next_bit(bitmap, bitmap_len, bit_b);
_

Patches currently in -mm which might be from jiapeng.chong@linux.alibaba.com are



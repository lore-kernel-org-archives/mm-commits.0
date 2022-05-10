Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA6C3C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:20:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236411AbiEJEYv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236452AbiEJEXL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:23:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E13571CA37D
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:17:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61C046176C
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:17:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9676C385C5;
        Tue, 10 May 2022 04:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156272;
        bh=/6aNwnuDsUcZ9/spt/OInyLfxdfHIAVMPAtBGfgI04Q=;
        h=Date:To:From:Subject:From;
        b=PAnxmTrAmoaqYeUJWnczRn9fwNUlzoUZ9lAb4Lhm0vhtZx1XbslEgVJTneAWHoYBz
         EbfPY5JUBRNYblUFEkEHvi/SJcttnr1aaJoitZAMTuLqdmqaTnRqCqRj211NgkA5DC
         kN2XLgzc+nJ36uiMlvBfGJ71zgpVhN3toImn878s=
Date:   Mon, 09 May 2022 21:17:52 -0700
To:     mm-commits@vger.kernel.org, oleg@redhat.com,
        yangtiezhu@loongson.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ptrace-fix-wrong-comment-of-pt_dtrace.patch removed from -mm tree
Message-Id: <20220510041752.B9676C385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ptrace: fix wrong comment of PT_DTRACE
has been removed from the -mm tree.  Its filename was
     ptrace-fix-wrong-comment-of-pt_dtrace.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: ptrace: fix wrong comment of PT_DTRACE

PT_DTRACE is only used on um now, fix the wrong comment.

Link: https://lkml.kernel.org/r/1649240981-11024-3-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ptrace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/ptrace.h~ptrace-fix-wrong-comment-of-pt_dtrace
+++ a/include/linux/ptrace.h
@@ -30,7 +30,7 @@ extern int ptrace_access_vm(struct task_
 
 #define PT_SEIZED	0x00010000	/* SEIZE used, enable new behavior */
 #define PT_PTRACED	0x00000001
-#define PT_DTRACE	0x00000002	/* delayed trace (used on m68k, i386) */
+#define PT_DTRACE	0x00000002	/* delayed trace (used on um) */
 
 #define PT_OPT_FLAG_SHIFT	3
 /* PT_TRACE_* event enable flags */
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are



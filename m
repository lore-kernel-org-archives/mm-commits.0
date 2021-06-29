Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C115C11F68
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:34:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4007661D07
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:34:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbhF2Cgm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:36:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231743AbhF2Cgm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:36:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB6DE61CCA;
        Tue, 29 Jun 2021 02:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934055;
        bh=6EC+qcZ0ow07gRuQ9Jrn9yk8c1EbnByJyZNd8jj5f3k=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GcGpEMnw61SG522F5CqRA7g/u2+flf+cnUV9vUTB8H4PhVQL5HoPn7NTrcKMBKaH9
         IxE5+fvWMpb44Q0TmlBU3RKsyS3UD2Mujh7Y0B6eaSV4FU5KvqrNmJYAL8jN8BLY4C
         EPUK8IVIKMZdsVDYhJuPdclhTUOvoxnURh8KOS+M=
Date:   Mon, 28 Jun 2021 19:34:14 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, colin.king@canonical.com,
        gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        linux-mm@kvack.org, mark@fasheh.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com, torvalds@linux-foundation.org
Subject:  [patch 018/192] ocfs2: remove redundant initialization of
 variable ret
Message-ID: <20210629023414.ik31tsh9F%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>
Subject: ocfs2: remove redundant initialization of variable ret

The variable ret is being initialized with a value that is never read, the
assignment is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Link: https://lkml.kernel.org/r/20210613135148.74658-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/nodemanager.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/cluster/nodemanager.c~ocfs2-remove-redundant-initialization-of-variable-ret
+++ a/fs/ocfs2/cluster/nodemanager.c
@@ -824,7 +824,7 @@ static void __exit exit_o2nm(void)
 
 static int __init init_o2nm(void)
 {
-	int ret = -1;
+	int ret;
 
 	o2hb_init();
 
_

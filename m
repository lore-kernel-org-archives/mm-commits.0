Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7384FC43457
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:48:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 374E021D81
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602632906;
	bh=WG6RJR3LvCoHRzH7Dq9f09MsmcaQW5HmmLvDloLu08g=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=b5cmer0Q5TCr+KJuzDYcbh0dlSGboNmVsswGm+7+ptfQTwdHMooiZ5rT0w6a6tPri
	 X7dj8KkO/kD+04tEAA665tcPaOaIj8GdNUHdoclGXUYjNGjqyTnp4zx6WTB4CBW+N8
	 U9Z4TJg9QJIjO5fAfu/VX0u62gTQXAVtRow87nn8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389162AbgJMXs0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:48:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:59804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389017AbgJMXsZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:48:25 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15CE821D7B;
        Tue, 13 Oct 2020 23:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602632905;
        bh=WG6RJR3LvCoHRzH7Dq9f09MsmcaQW5HmmLvDloLu08g=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Dt3mXQSBZOpYeQmYfKpuhhq8Zpurma8I7e6F6+m8QIILnC1mwlE31QBq28UC92kzm
         lgp/YWfmyU0IbeTaNZ+QNSX5sBAm7Syzoi1Cf+MGqqJL0xxBiie8VF4aln8YoRDF1a
         omj4FW3a8P0c9d422HVtPCpsXLRK/9wICl0aoAlQ=
Date:   Tue, 13 Oct 2020 16:48:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, linux-mm@kvack.org, mark@fasheh.com,
        mm-commits@vger.kernel.org, piaojun@huawei.com,
        torvalds@linux-foundation.org
Subject:  [patch 016/181] ocfs2: fix potential soft lockup during
 fstrim
Message-ID: <20201013234824.U65EF3eQo%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Gang He <ghe@suse.com>
Subject: ocfs2: fix potential soft lockup during fstrim

When we discard unused blocks on a mounted ocfs2 filesystem, fstrim
handles each block goup with locking/unlocking global bitmap meta-file
repeatedly. we should let fstrim thread take a break(if need) between
unlock and lock, this will avoid the potential soft lockup problem,
and also gives the upper applications more IO opportunities, these
applications are not blocked for too long at writing files.

Link: https://lkml.kernel.org/r/20200927015815.14904-1-ghe@suse.com
Signed-off-by: Gang He <ghe@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/alloc.c~ocfs2-fix-potential-soft-lockup-during-fstrim
+++ a/fs/ocfs2/alloc.c
@@ -7654,8 +7654,10 @@ out_mutex:
 	 * main_bm related locks for avoiding the current IO starve, then go to
 	 * trim the next group
 	 */
-	if (ret >= 0 && group <= last_group)
+	if (ret >= 0 && group <= last_group) {
+		cond_resched();
 		goto next_group;
+	}
 out:
 	range->len = trimmed * sb->s_blocksize;
 	return ret;
_

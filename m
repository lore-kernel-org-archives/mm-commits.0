Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9396AC43457
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:56:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4447E22250
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602708969;
	bh=lxbdD3PhLc7bT8brWtyCB5nWUyFQSiIKlzz3T9SYGTw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=uHHBuF9TEi9Ucl0wvNrbCibp7Xj7N3VFxQgPJT80ErgRfYnelXgN6/vhZ+mj641FT
	 u6t8cmQSaAvgFxJhsnSTQOcKQ53gzHuBFF+zmE2M887oFFrvhULiZP40m0nKYKnfib
	 F/P7tcY3ZhGGGqXOkxWTEXqmXK/GIVSr4DADpRvA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730445AbgJNU4I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:56:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727788AbgJNU4I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:56:08 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A88A422254;
        Wed, 14 Oct 2020 20:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602708968;
        bh=lxbdD3PhLc7bT8brWtyCB5nWUyFQSiIKlzz3T9SYGTw=;
        h=Date:From:To:Subject:From;
        b=LlAkDRon3VHkgY4PG9YuuYaFtTmkKyNqu91/lZkmWPEXYO7HxPpLfwdwYBD6yJ7j6
         d2ounDAoFgsX44Re2wr0ga3vGcFH6Hn4jhO9UwG5j3SV8ayS8fHxYDN9L8I6CoyWOB
         Tc13PC/aq3TdrUWUErGi+Mg+Nhr5L0bCh5QuRx1A=
Date:   Wed, 14 Oct 2020 13:56:07 -0700
From:   akpm@linux-foundation.org
To:     gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com
Subject:  [merged]
 ocfs2-fix-potential-soft-lockup-during-fstrim.patch removed from -mm tree
Message-ID: <20201014205607.26gTfWifd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix potential soft lockup during fstrim
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-potential-soft-lockup-during-fstrim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from ghe@suse.com are



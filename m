Return-Path: <SRS0=qjDH=DG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EEE9C2D0A8
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 00:44:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D3E52193E
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 00:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601340249;
	bh=LfUxGOK4U0n4qCIWFF7X11cbF0eKpMU5Pg6eVNeHDJk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=JHX4C9R3lHxK+aOmBGuLdOsLI1/y0xcss8fwUxpGJF5Qm5Ip1zPC6KYQl0p6WrRD1
	 pMLawYEMHRWVInxK0zdemBtfaUHBHeYEE2bwzEVzsBcCTmYBo3rmT5eor9It0xdOft
	 a+XTyiioA6tB670je7vQIJHJwja+jRZdp7LTDZW4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgI2AoI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Sep 2020 20:44:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:48848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725272AbgI2AoI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Sep 2020 20:44:08 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D37AC21734;
        Tue, 29 Sep 2020 00:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601340248;
        bh=LfUxGOK4U0n4qCIWFF7X11cbF0eKpMU5Pg6eVNeHDJk=;
        h=Date:From:To:Subject:From;
        b=0LRW+SFKBh/7HozPKTpxa8U0cblaqoaaeJ3GNd7eFVLXf3Fz497zzCVVVDuHI/aQ0
         pkyP+HKdphRWwAXIQtzyySywRZTidAgGACnEFgf/7bFRrsW6lvbtsW3x8qNlgTv8lv
         VaWrNISaUtUSJ493/EiqS3evmKZcpWp8cUmbJW8U=
Date:   Mon, 28 Sep 2020 17:44:07 -0700
From:   akpm@linux-foundation.org
To:     gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com
Subject:  + ocfs2-fix-potential-soft-lockup-during-fstrim.patch
 added to -mm tree
Message-ID: <20200929004407.gG5HhK5yT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix potential soft lockup during fstrim
has been added to the -mm tree.  Its filename is
     ocfs2-fix-potential-soft-lockup-during-fstrim.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-potential-soft-lockup-during-fstrim.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-potential-soft-lockup-during-fstrim.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-fix-potential-soft-lockup-during-fstrim.patch


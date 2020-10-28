Return-Path: <SRS0=6wtZ=ED=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88806C55179
	for <mm-commits@archiver.kernel.org>; Wed, 28 Oct 2020 23:43:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FA3D2080D
	for <mm-commits@archiver.kernel.org>; Wed, 28 Oct 2020 23:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603928585;
	bh=9IOdrJ/0gZUWGmThHGfqBXxs+QH40dQS66SxERbHDYc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=zSQuQ4EBE4tefFEu/OuDCze20ZMfy2MYPoV7wobB9n49YzKoeYkNaXCych6YARDPL
	 ujnsF/xFCfJsqjlzS+WaxHCmJlvXbDj4eifBLuAcO5qdhZrJv1rakRVT5Thvog9VH9
	 OTK9LpVk5LfVX8PuUOHzX3QxKcWkoEPcZjC9WUeM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728382AbgJ1XnE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Oct 2020 19:43:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:54262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730722AbgJ1XnC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 28 Oct 2020 19:43:02 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90277207BC;
        Wed, 28 Oct 2020 23:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603928582;
        bh=9IOdrJ/0gZUWGmThHGfqBXxs+QH40dQS66SxERbHDYc=;
        h=Date:From:To:Subject:From;
        b=nCOdpXyUdPRWqpdakrTSrI6CS02fnrCOcZFDTciuMqi20FMv8T8//czE8qamwrUSJ
         CJO6xPJwhiGgRhQnGXBhbVuL2ovZzQE3FcvZk05sTiz7VHZtTx+UWJcCnU3nx46KMB
         XDq7sjPisE7l7jPx5HkzeZnqtlBAldOjxY1iMBZg=
Date:   Wed, 28 Oct 2020 16:43:00 -0700
From:   akpm@linux-foundation.org
To:     gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        mark@fasheh.com, mfo@canonical.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com
Subject:  +
 ocfs2-ratelimit-the-max-lookup-times-reached-notice.patch added to -mm tree
Message-ID: <20201028234300.FVhvNGS2i%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: ratelimit the 'max lookup times reached' notice
has been added to the -mm tree.  Its filename is
     ocfs2-ratelimit-the-max-lookup-times-reached-notice.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-ratelimit-the-max-lookup-times-reached-notice.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-ratelimit-the-max-lookup-times-reached-notice.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mauricio Faria de Oliveira <mfo@canonical.com>
Subject: ocfs2: ratelimit the 'max lookup times reached' notice

Running stress-ng on ocfs2 completely fills the kernel log with 'max
lookup times reached, filesystem may have nested directories.'

Let's ratelimit this message as done with others in the code.

Test-case:

  # mkfs.ocfs2 --mount local $DEV
  # mount $DEV $MNT
  # cd $MNT

  # dmesg -C
  # stress-ng --dirdeep 1 --dirdeep-ops 1000
  # dmesg | grep -c 'max lookup times reached'

Before:

  # dmesg -C
  # stress-ng --dirdeep 1 --dirdeep-ops 1000
  ...
  stress-ng: info:  [11116] successful run completed in 3.03s

  # dmesg | grep -c 'max lookup times reached'
  967

After:

  # dmesg -C
  # stress-ng --dirdeep 1 --dirdeep-ops 1000
  ...
  stress-ng: info:  [739] successful run completed in 0.96s

  # dmesg | grep -c 'max lookup times reached'
  10

  # dmesg
  [  259.086086] ocfs2_check_if_ancestor: 1990 callbacks suppressed
  [  259.086092] (stress-ng-dirde,740,1):ocfs2_check_if_ancestor:1091 max lookup times reached, filesystem may have nested directories, src inode: 18007, dest inode: 17940.
  ...

Link: https://lkml.kernel.org/r/20201001224417.478263-1-mfo@canonical.com
Signed-off-by: Mauricio Faria de Oliveira <mfo@canonical.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/namei.c~ocfs2-ratelimit-the-max-lookup-times-reached-notice
+++ a/fs/ocfs2/namei.c
@@ -1088,8 +1088,8 @@ static int ocfs2_check_if_ancestor(struc
 		child_inode_no = parent_inode_no;
 
 		if (++i >= MAX_LOOKUP_TIMES) {
-			mlog(ML_NOTICE, "max lookup times reached, filesystem "
-					"may have nested directories, "
+			mlog_ratelimited(ML_NOTICE, "max lookup times reached, "
+					"filesystem may have nested directories, "
 					"src inode: %llu, dest inode: %llu.\n",
 					(unsigned long long)src_inode_no,
 					(unsigned long long)dest_inode_no);
_

Patches currently in -mm which might be from mfo@canonical.com are

ocfs2-ratelimit-the-max-lookup-times-reached-notice.patch


Return-Path: <SRS0=ColI=A4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36BCEC433E2
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jul 2020 22:00:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1174B20656
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jul 2020 22:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595023239;
	bh=Rbl74+krlJIRx1Q7fvRJfF3CN/1BucANyJDfS6FfnLE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=DK6cjdke4Z/FvfFmTPy+hxWmHUMQGaTuJBsQjDGFc6AhcJh7tE3Df/VNZPWG2wcha
	 TYbO3RLq39kr72iwyVFoz/+P8ZdQMwo7IXDAbSn2dNiM7kS20sx1jvDqDs1jlcMtPz
	 qN0sDByzTscC8MOJiDmZ3N3/3mk//E6hvNeSgOUg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgGQWAi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Jul 2020 18:00:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:50960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727780AbgGQWAi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 17 Jul 2020 18:00:38 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFF772070A;
        Fri, 17 Jul 2020 22:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595023238;
        bh=Rbl74+krlJIRx1Q7fvRJfF3CN/1BucANyJDfS6FfnLE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0n7WUvFxQaHDYFb+BH2TzTd6NTpBk6/2FPWuvjSP9SJsoon7VuBPxY01WXskloN3y
         4gadc+y9/X9aHVd3pxCDO9F79+I1vSYcp7LMMUmtJi2G+8VP+3cj2RC/0oZTRAOp6V
         6xzWXABwYnVCkfBcms6g8gLnBOTCMulu5nYu7ats=
Date:   Fri, 17 Jul 2020 15:00:37 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     gechangwei@live.cn, ghe@suse.com, jiangqi903@gmail.com,
        jlbec@evilplan.org, junxiao.bi@oracle.com, mark@fasheh.com,
        mm-commits@vger.kernel.org, piaojun@huawei.com
Subject:  + ocfs2-fix-remounting-needed-after-setfacl-command.patch
 added to -mm tree
Message-ID: <20200717220037.Rt9uKxi7S%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix remounting needed after setfacl command
has been added to the -mm tree.  Its filename is
     ocfs2-fix-remounting-needed-after-setfacl-command.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-remounting-needed-after-setfacl-command.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-remounting-needed-after-setfacl-command.patch

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
Subject: ocfs2: fix remounting needed after setfacl command

When use setfacl command to change a file's acl, the user cannot get the
latest acl information from the file via getfacl command, until remounting
the file system.

e.g.
setfacl -m u:ivan:rw /ocfs2/ivan
getfacl /ocfs2/ivan
getfacl: Removing leading '/' from absolute path names
file: ocfs2/ivan
owner: root
group: root
user::rw-
group::r--
mask::r--
other::r--

The latest acl record("u:ivan:rw") cannot be returned via getfacl
command until remounting.

Link: http://lkml.kernel.org/r/20200717023751.9922-1-ghe@suse.com
Signed-off-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/acl.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ocfs2/acl.c~ocfs2-fix-remounting-needed-after-setfacl-command
+++ a/fs/ocfs2/acl.c
@@ -256,6 +256,8 @@ static int ocfs2_set_acl(handle_t *handl
 		ret = ocfs2_xattr_set(inode, name_index, "", value, size, 0);
 
 	kfree(value);
+	if (!ret)
+		set_cached_acl(inode, type, acl);
 
 	return ret;
 }
_

Patches currently in -mm which might be from ghe@suse.com are

ocfs2-fix-remounting-needed-after-setfacl-command.patch


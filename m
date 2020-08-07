Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CE48C433E1
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:17:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A2BF22CF6
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781078;
	bh=pnN8QFT/hiZ+CQ+boSDBciJdH/VWXkOF1ATLoWC62xA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=zVOg30009CIj3FX+m7seyFS1OPAEdXKFE0ZwCbxKGvuvZnt+jfX89VJBOVhPJCArI
	 T0NqFZtR1IWMs7YJHJlQNQfwtP0sKX/tuSi+sU8AQlvWVAZRszPUR8WV+z71qS4xb/
	 9mjBnnQZFv6UueDLLZEbPVgEhsmzQ1MAMYLURIko=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbgHGGR5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:17:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:53078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGR5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:17:57 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEC15221E5;
        Fri,  7 Aug 2020 06:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781077;
        bh=pnN8QFT/hiZ+CQ+boSDBciJdH/VWXkOF1ATLoWC62xA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=UigfX3xljNhcXG8NsD1KBsjCWv9n+BM7bRQmx7EZ28HCRs/uD86ZBsqw4B35i0GFR
         pB2XBZSaY9Pdwd0cPBKk7VZrlM7Cq0LYfXqutsFvP3SJf/lrcPc0GK8o2oo+Wht5wN
         wdMHSfPGb27IjdDEUGudwpsp2+3QyVmu0ZWATkW4=
Date:   Thu, 06 Aug 2020 23:17:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, linux-mm@kvack.org, mark@fasheh.com,
        mm-commits@vger.kernel.org, piaojun@huawei.com,
        torvalds@linux-foundation.org
Subject:  [patch 017/163] ocfs2: fix remounting needed after
 setfacl command
Message-ID: <20200807061756.lkEFtWo3s%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
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

Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98880C433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B549206E9
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026862;
	bh=iLpc6w/qrLA5F3CT12Ywr7VWcYawfPwPiMry8rMVL7c=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=yQQ3OHbSCdJC4O662tsKlNVvt9hzxYs7FTwCEdIpipNqwJqBa9wUO30Ml+LOVllN5
	 zXft+jcrAn2fnT4xiBs3EH9ziE8aQ/p6LwWGJq/r29u6XaBLiJG1PkyeKUh2qkYDMG
	 Kog4XB266kKqbxdE9P3OIWTJ4H8ab7PN9c1xslJ8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgHJCeW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:34:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCeW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:34:22 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78A34206CD;
        Mon, 10 Aug 2020 02:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026861;
        bh=iLpc6w/qrLA5F3CT12Ywr7VWcYawfPwPiMry8rMVL7c=;
        h=Date:From:To:Subject:From;
        b=imxoAF+u8wvU4quUHRM8VFCH7s1hQOhCDLA7wZ07PqvXRVlUUsgJGWcx1O72lQuHn
         jzl/3a1CCW7pcUjAKuQ8/M54ffnZzo0Y8JU3rD3pFL/Y8T9k3OI8O+cB3IWoMOT5PP
         vgyh7dQ34lMnXa8Wd9dYgyLO8zFePRbaYd3ooZJo=
Date:   Sun, 09 Aug 2020 19:34:21 -0700
From:   akpm@linux-foundation.org
To:     gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com
Subject:  [merged]
 ocfs2-fix-remounting-needed-after-setfacl-command.patch removed from -mm
 tree
Message-ID: <20200810023421.WdovsWtgd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix remounting needed after setfacl command
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-remounting-needed-after-setfacl-command.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from ghe@suse.com are



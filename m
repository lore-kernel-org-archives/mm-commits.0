Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A0B4C43217
	for <mm-commits@archiver.kernel.org>; Mon, 28 Nov 2022 22:51:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233866AbiK1WvK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Nov 2022 17:51:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233972AbiK1WvJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2022 17:51:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D3FD2B1A4
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2022 14:51:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEF6D6120C
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2022 22:51:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC5AC433D7;
        Mon, 28 Nov 2022 22:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669675863;
        bh=8Xm0q+afoQVIy3YsxD11l6q2fwq5qgx2NP6c1QhnxRY=;
        h=Date:To:From:Subject:From;
        b=p7oTg3LT4AExTiR3L082w1NaeAYPmoZQ1TscsJnR5CxsAWrMPQc546yk7L4c7vfDW
         WkI8QqiYmdPaPDOrRZEnazKy+KP5sb2NLG92/yd4PxVCPqkbWNsT6WgSFSSFViTDp/
         2mDUu1RqSMv/7JDLx2VA1Wv3PlD/UN7Gm21YzHc4=
Date:   Mon, 28 Nov 2022 14:51:02 -0800
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
        alex@alex-at.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-always-read-both-high-and-low-parts-of-dinode-link-count.patch added to mm-nonmm-unstable branch
Message-Id: <20221128225103.2FC5AC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: [PATCH] ocfs2: always read both high and low parts of dinode link count
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-always-read-both-high-and-low-parts-of-dinode-link-count.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-always-read-both-high-and-low-parts-of-dinode-link-count.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Alexey Asemov <alex@alex-at.net>
Subject: [PATCH] ocfs2: always read both high and low parts of dinode link count
Date: Sun, 27 Nov 2022 09:46:38 +0300

When filesystem is using indexed-dirs feature, maximum link count values
can spill over to i_links_count_hi, up to OCFS2_DX_LINK_MAX links. 
ocfs2_read_links_count() checks for OCFS2_INDEXED_DIR_FL flag in dinode,
but this flag is only valid for directories so for files the check causes
high part of the link count not being read back from file dinodes
resulting in wrong link count value when file has >65535 links.

As ocfs2_set_links_count() always writes both high and low parts of link
count, the flag check on reading may be removed.

Link: https://lkml.kernel.org/r/cbfca02b-b39f-89de-e1a8-904a6c60407e@alex-at.net
Signed-off-by: Alexey Asemov <alex@alex-at.net>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ocfs2.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/ocfs2/ocfs2.h~ocfs2-always-read-both-high-and-low-parts-of-dinode-link-count
+++ a/fs/ocfs2/ocfs2.h
@@ -560,8 +560,7 @@ static inline unsigned int ocfs2_read_li
 	u32 nlink = le16_to_cpu(di->i_links_count);
 	u32 hi = le16_to_cpu(di->i_links_count_hi);
 
-	if (di->i_dyn_features & cpu_to_le16(OCFS2_INDEXED_DIR_FL))
-		nlink |= (hi << OCFS2_LINKS_HI_SHIFT);
+	nlink |= (hi << OCFS2_LINKS_HI_SHIFT);
 
 	return nlink;
 }
_

Patches currently in -mm which might be from alex@alex-at.net are

ocfs2-always-read-both-high-and-low-parts-of-dinode-link-count.patch


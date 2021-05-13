Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB6C1C433ED
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 19:45:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACBF561420
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 19:45:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbhEMTqt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 May 2021 15:46:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:35602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230135AbhEMTqt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 May 2021 15:46:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD10361408;
        Thu, 13 May 2021 19:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620935138;
        bh=EzfpTOkuYXCMWTETmWWxcXLCR5YRx7AgV83081+B7o0=;
        h=Date:From:To:Subject:From;
        b=NpiWqh9H+fxEhLCoi7/+3hSMaFrtrC7EH2a9BpuP+v47BYWQS6ccwaRaK/+6y2Tqk
         9Zu5rHL/f5bRN4/TWAoFk0d3Fs29/ikzbZirfDXeZ6KVuiWiazKG5fG1jg8/BIrBsH
         IhCho0NiALYiSPQLEqqXpub25eThedjUDLfX7tQ4=
Date:   Thu, 13 May 2021 12:45:37 -0700
From:   akpm@linux-foundation.org
To:     gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com,
        wanjiabing@vivo.com
Subject:  + ocfs2-remove-repeated-uptodate-check-for-buffer.patch
 added to -mm tree
Message-ID: <20210513194537.zDmwP_oxj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove repeated uptodate check for buffer
has been added to the -mm tree.  Its filename is
     ocfs2-remove-repeated-uptodate-check-for-buffer.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-remove-repeated-uptodate-check-for-buffer.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-remove-repeated-uptodate-check-for-buffer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wan Jiabing <wanjiabing@vivo.com>
Subject: ocfs2: remove repeated uptodate check for buffer

In commit 60f91826ca62 ("buffer: Avoid setting buffer bits that are
already set"), function set_buffer_##name was added a test_bit() to check
buffer, which is the same as function buffer_##name.  The
!buffer_uptodate(bh) here is a repeated check.  Remove it.

Link: https://lkml.kernel.org/r/20210425025702.13628-1-wanjiabing@vivo.com
Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/ocfs2/aops.c~ocfs2-remove-repeated-uptodate-check-for-buffer
+++ a/fs/ocfs2/aops.c
@@ -632,8 +632,7 @@ int ocfs2_map_page_blocks(struct page *p
 		}
 
 		if (PageUptodate(page)) {
-			if (!buffer_uptodate(bh))
-				set_buffer_uptodate(bh);
+			set_buffer_uptodate(bh);
 		} else if (!buffer_uptodate(bh) && !buffer_delay(bh) &&
 			   !buffer_new(bh) &&
 			   ocfs2_should_read_blk(inode, page, block_start) &&
_

Patches currently in -mm which might be from wanjiabing@vivo.com are

ocfs2-remove-repeated-uptodate-check-for-buffer.patch


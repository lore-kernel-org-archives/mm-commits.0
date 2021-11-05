Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5115C4332F
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:34:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDA7861242
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:34:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbhKEUhd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:37:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:60542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231288AbhKEUhd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:37:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD8DB611C0;
        Fri,  5 Nov 2021 20:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144493;
        bh=5thybw1wSxumef2TYW475T3X2CO6HWfi9biq1yI7RbY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=KcO+dbqGdPTjAngV7jDh7QHTAaH3ERXuBl7dQr7PitnCK4FBB48DhniyYI0W3/SUO
         Fbd2u5ToKcroXbi/fXApWUgFTpiYRDA4ir5gLDIJhnhUA+2v+hVDK5xrhRzm6JOU4T
         9jCRToQFjL8BLQtR/+8SkRmMrIFDN2b4hmIVOHx0=
Date:   Fri, 05 Nov 2021 13:34:52 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, colin.king@canonical.com,
        gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        linux-mm@kvack.org, mark@fasheh.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com, torvalds@linux-foundation.org
Subject:  [patch 006/262] ocfs2/dlm: remove redundant assignment of
 variable ret
Message-ID: <20211105203452.W9C94pmyD%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>
Subject: ocfs2/dlm: remove redundant assignment of variable ret

The variable ret is being assigned a value that is never read, it is
updated later on with a different value.  The assignment is redundant and
can be removed.

Addresses-Coverity: ("Unused value")
Link: https://lkml.kernel.org/r/20211007233452.30815-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-remove-redundant-assignment-of-variable-ret
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -2698,7 +2698,6 @@ static int dlm_send_begin_reco_message(s
 			continue;
 		}
 retry:
-		ret = -EINVAL;
 		mlog(0, "attempting to send begin reco msg to %d\n",
 			  nodenum);
 		ret = o2net_send_message(DLM_BEGIN_RECO_MSG, dlm->key,
_

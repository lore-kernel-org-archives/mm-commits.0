Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 051FBC7EE25
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:46:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbjFJAqy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232210AbjFJAqB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:46:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C15E3A9A
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:46:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A21C7651C9
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:45:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A69C433EF;
        Sat, 10 Jun 2023 00:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686357959;
        bh=y4wO2aKY8JDfnLRHMlWlzWoATn9sC4mJPUNEy5Ft5GU=;
        h=Date:To:From:Subject:From;
        b=a54AjDX08xXxjTZYl9DyFEXHd7cj5y3TDxeS0nQTGNU6lDhsCNKSQkzfG7/n+SKy4
         HyH1SjKUbmbIoBJgayK711uxIac95NVXvWK6lDli+KoBsqvoigwkjg2RyX/tNpjfp+
         LJWep5OJarcSU3yHUcVO6Sq8T71SupuZb4ghvJwY=
Date:   Fri, 09 Jun 2023 17:45:58 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        piaojun@huawei.com, mark@fasheh.com, junxiao.bi@oracle.com,
        jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
        joseph.qi@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-cleanup-trace-events.patch removed from -mm tree
Message-Id: <20230610004559.06A69C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ocfs2: cleanup trace events
has been removed from the -mm tree.  Its filename was
     ocfs2-cleanup-trace-events.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: cleanup trace events
Date: Sun, 28 May 2023 21:20:33 +0800

After commit 6dc8bc0fb300 ("ocfs2: switch to iter_file_splice_write()"),
ocfs2 has switched from ocfs2_file_splice_write() to
iter_file_splice_write(), so cleanup the corresponding trace event as
well.

Link: https://lkml.kernel.org/r/20230528132033.217664-2-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ocfs2_trace.h |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/ocfs2/ocfs2_trace.h~ocfs2-cleanup-trace-events
+++ a/fs/ocfs2/ocfs2_trace.h
@@ -1315,8 +1315,6 @@ DEFINE_OCFS2_FILE_OPS(ocfs2_sync_file);
 
 DEFINE_OCFS2_FILE_OPS(ocfs2_file_write_iter);
 
-DEFINE_OCFS2_FILE_OPS(ocfs2_file_splice_write);
-
 DEFINE_OCFS2_FILE_OPS(ocfs2_file_read_iter);
 
 DEFINE_OCFS2_ULL_ULL_ULL_EVENT(ocfs2_truncate_file);
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are



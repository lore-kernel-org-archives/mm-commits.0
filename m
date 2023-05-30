Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C31FC7EE23
	for <mm-commits@archiver.kernel.org>; Tue, 30 May 2023 21:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233563AbjE3Vmi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 May 2023 17:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233576AbjE3Vmg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 May 2023 17:42:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E0CC7
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 14:42:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5C6A62ED2
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 21:42:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DB6C433EF;
        Tue, 30 May 2023 21:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685482953;
        bh=9N2J9BpMKcUim3r/umAqtlJiNlzMVaRzW53U5FK4inY=;
        h=Date:To:From:Subject:From;
        b=DCQTOiKS7l3XfR3eqfHNW1kMsLoye+n5xSxv6iPdZ6BVV8m2NfnFBZgPT94cAMqeg
         nvqSP7g9cY+yesQzAhyUohYgsHUkbDoj3A3gTBo/Jqi7JPKaXTd1wO3T6vaVz1jbUk
         5RCkee+4jTr1O5NTPRsiB62JfZGNzsBiX6z5D4SQ=
Date:   Tue, 30 May 2023 14:42:32 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        piaojun@huawei.com, mark@fasheh.com, junxiao.bi@oracle.com,
        jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
        joseph.qi@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-cleanup-trace-events.patch added to mm-nonmm-unstable branch
Message-Id: <20230530214233.15DB6C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: cleanup trace events
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-cleanup-trace-events.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-cleanup-trace-events.patch

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

ocfs2-correct-return-value-of-ocfs2_local_free_info.patch
ocfs2-cleanup-trace-events.patch


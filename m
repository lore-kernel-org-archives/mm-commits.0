Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73C3AE936E0
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:25:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244664AbjJDUZI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245133AbjJDUYJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:24:09 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F421B10D7
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:23:51 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA1BC433C7;
        Wed,  4 Oct 2023 20:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696451031;
        bh=HrhGl49a7j/zJIW0Gr5q2/qY3KimOvCon0pUqj4kUQQ=;
        h=Date:To:From:Subject:From;
        b=zmVAFD3K3Mh4DrK4eVkZczIqPEVw4ySeNqsUIDeoWWM90C86AtqjLe/rFoOYmA/B0
         QIJj46HhaaHScL6UvV0OBVM0XSHCM+dGp3L1+WpuK02AQ+fN36EgoUCbH/WiLebZmo
         clz+XbTPoYfa71LdOt8DaRmTin7mkPzb2H5QPGVU=
Date:   Wed, 04 Oct 2023 13:23:49 -0700
To:     mm-commits@vger.kernel.org, mcgrof@kernel.org,
        keescook@chromium.org, jeffxu@google.com, frederic@kernel.org,
        cyphar@cyphar.com, brauner@kernel.org, rongtao@cestc.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] pid-pid_ns_ctl_handler-remove-useless-comment.patch removed from -mm tree
Message-Id: <20231004202351.4DA1BC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: pid: pid_ns_ctl_handler: remove useless comment
has been removed from the -mm tree.  Its filename was
     pid-pid_ns_ctl_handler-remove-useless-comment.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Rong Tao <rongtao@cestc.cn>
Subject: pid: pid_ns_ctl_handler: remove useless comment
Date: Mon, 11 Sep 2023 22:55:09 +0800

commit 95846ecf9dac("pid: replace pid bitmap implementation with IDR API")
removes 'last_pid' element, and use the idr_get_cursor-idr_set_cursor pair
to set the value of idr, so useless comments should be removed.

Link: https://lkml.kernel.org/r/tencent_157A2A1CAF19A3F5885F0687426159A19708@qq.com
Signed-off-by: Rong Tao <rongtao@cestc.cn>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Jeff Xu <jeffxu@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid_namespace.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/kernel/pid_namespace.c~pid-pid_ns_ctl_handler-remove-useless-comment
+++ a/kernel/pid_namespace.c
@@ -286,12 +286,6 @@ static int pid_ns_ctl_handler(struct ctl
 	if (write && !checkpoint_restore_ns_capable(pid_ns->user_ns))
 		return -EPERM;
 
-	/*
-	 * Writing directly to ns' last_pid field is OK, since this field
-	 * is volatile in a living namespace anyway and a code writing to
-	 * it should synchronize its usage with external means.
-	 */
-
 	next = idr_get_cursor(&pid_ns->idr) - 1;
 
 	tmp.data = &next;
_

Patches currently in -mm which might be from rongtao@cestc.cn are



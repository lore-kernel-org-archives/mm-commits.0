Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50F8FCE79AA
	for <mm-commits@archiver.kernel.org>; Tue, 19 Sep 2023 20:22:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbjISUWn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Sep 2023 16:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbjISUWS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Sep 2023 16:22:18 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50DFAC0
        for <mm-commits@vger.kernel.org>; Tue, 19 Sep 2023 13:22:12 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE54FC433C7;
        Tue, 19 Sep 2023 20:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695154932;
        bh=VULDh7Ebkx1XnlihT2N3+l/5YcIs6r0Hov1Im1DL5Qc=;
        h=Date:To:From:Subject:From;
        b=pu0lgYeNWJE4tWrV+hFC9W10kz1oH8MyAl+N0RRTGmf91nXMP9olOLEq50NyJJ6u5
         TIeQq1f6qXihKj4U8MljhJ/kzKWLSXLNDgNTJGrfIG2w+HYPTrjQrQtXpPQu8CqGD0
         ziYy6XxVZN5RWl4kULsVvVRDFKRdXeoQm/fBRAro=
Date:   Tue, 19 Sep 2023 13:22:11 -0700
To:     mm-commits@vger.kernel.org, brauner@kernel.org,
        rdunlap@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] pidfd-prevent-a-kernel-doc-warning.patch removed from -mm tree
Message-Id: <20230919202211.DE54FC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: pidfd: prevent a kernel-doc warning
has been removed from the -mm tree.  Its filename was
     pidfd-prevent-a-kernel-doc-warning.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: pidfd: prevent a kernel-doc warning
Date: Mon, 11 Sep 2023 23:08:22 -0700

Change the comment to match the function name that the SYSCALL_DEFINE()
macros generate to prevent a kernel-doc warning.

kernel/pid.c:628: warning: expecting prototype for pidfd_open(). Prototype was for sys_pidfd_open() instead

Link: https://lkml.kernel.org/r/20230912060822.2500-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/pid.c~pidfd-prevent-a-kernel-doc-warning
+++ a/kernel/pid.c
@@ -609,7 +609,7 @@ int pidfd_create(struct pid *pid, unsign
 }
 
 /**
- * pidfd_open() - Open new pid file descriptor.
+ * sys_pidfd_open() - Open new pid file descriptor.
  *
  * @pid:   pid for which to retrieve a pidfd
  * @flags: flags to pass
_

Patches currently in -mm which might be from rdunlap@infradead.org are



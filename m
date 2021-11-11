Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D44C8C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:53:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD3C4610A2
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:53:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234586AbhKKC4A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:56:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:59576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234509AbhKKC4A (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:56:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C18761872;
        Thu, 11 Nov 2021 02:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599191;
        bh=2W8iPbB0ko6DoH+0wPekOgFj7mQzU2iFy3A2aKaq3OA=;
        h=Date:From:To:Subject:From;
        b=y53xy9VSaqZkfxiz8hpC95YVzEkZQZ5pCnQVXG+0BWkob11x9mRoZflCeXhc9yhoL
         5c759newqCg6yF7rebA69fVCD1dDD/hFmiC52oXk7R6He6YDbEaSAWjQyO9lY5uL0K
         wubYdS9pfeT0Wro0HRC+cdEiTcPm6ZGZmGGQe3m0=
Date:   Wed, 10 Nov 2021 18:53:11 -0800
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, jaharkes@cs.cmu.edu,
        jing.yangyang@zte.com.cn, mm-commits@vger.kernel.org,
        tanxin.ctf@gmail.com, xiyuyang19@fudan.edu.cn, zealci@zte.com.cn
Subject:  [merged]
 coda-avoid-null-pointer-dereference-from-a-bad-inode.patch removed from -mm
 tree
Message-ID: <20211111025311.AXiJnvISx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: coda: avoid NULL pointer dereference from a bad inode
has been removed from the -mm tree.  Its filename was
     coda-avoid-null-pointer-dereference-from-a-bad-inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Harkes <jaharkes@cs.cmu.edu>
Subject: coda: avoid NULL pointer dereference from a bad inode

Patch series "Coda updates for -next".

The following patch series contains some fixes for the Coda kernel module
I've had sitting around and were tested extensively in a development
version of the Coda kernel module that lives outside of the main kernel.


This patch (of 9):

Avoid accessing coda_inode_info from a dentry with a bad inode.

Link: https://lkml.kernel.org/r/20210908140308.18491-1-jaharkes@cs.cmu.edu
Link: https://lkml.kernel.org/r/20210908140308.18491-2-jaharkes@cs.cmu.edu
Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Jing Yangyang <jing.yangyang@zte.com.cn>
Cc: Xin Tan <tanxin.ctf@gmail.com>
Cc: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/dir.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/fs/coda/dir.c~coda-avoid-null-pointer-dereference-from-a-bad-inode
+++ a/fs/coda/dir.c
@@ -499,15 +499,20 @@ out:
  */
 static int coda_dentry_delete(const struct dentry * dentry)
 {
-	int flags;
+	struct inode *inode;
+	struct coda_inode_info *cii;
 
 	if (d_really_is_negative(dentry)) 
 		return 0;
 
-	flags = (ITOC(d_inode(dentry))->c_flags) & C_PURGE;
-	if (is_bad_inode(d_inode(dentry)) || flags) {
+	inode = d_inode(dentry);
+	if (!inode || is_bad_inode(inode))
 		return 1;
-	}
+
+	cii = ITOC(inode);
+	if (cii->c_flags & C_PURGE)
+		return 1;
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from jaharkes@cs.cmu.edu are



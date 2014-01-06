From: akpm@linux-foundation.org
Subject: [failures] fs-execc-call-arch_pick_mmap_layout-only-once.patch
 removed from -mm tree
Date: Mon, 06 Jan 2014 12:50:28 -0800
Message-ID: <52cb1714.TLRzaVHr1KgbhsZy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45627 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979AbaAFUu3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jan 2014 15:50:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, richard@nod.at

Subject: [failures] fs-execc-call-arch_pick_mmap_layout-only-once.patch removed from -mm tree
To: richard@nod.at,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 06 Jan 2014 12:50:28 -0800


The patch titled
     Subject: fs/exec.c: call arch_pick_mmap_layout() only once
has been removed from the -mm tree.  Its filename was
     fs-execc-call-arch_pick_mmap_layout-only-once.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Richard Weinberger <richard@nod.at>
Subject: fs/exec.c: call arch_pick_mmap_layout() only once

Currently both setup_new_exec() and flush_old_exec() issue a call to
arch_pick_mmap_layout().  As setup_new_exec() and flush_old_exec() are
always called pairwise arch_pick_mmap_layout() is called twice.

This patch removes one call from setup_new_exec() to have it only called
once.

Signed-off-by: Richard Weinberger <richard@nod.at>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/exec.c~fs-execc-call-arch_pick_mmap_layout-only-once fs/exec.c
--- a/fs/exec.c~fs-execc-call-arch_pick_mmap_layout-only-once
+++ a/fs/exec.c
@@ -1108,8 +1108,6 @@ EXPORT_SYMBOL(would_dump);
 
 void setup_new_exec(struct linux_binprm * bprm)
 {
-	arch_pick_mmap_layout(current->mm);

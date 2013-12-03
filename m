From: akpm@linux-foundation.org
Subject: + fs-execc-call-arch_pick_mmap_layout-only-once.patch added to
 -mm tree
Date: Mon, 02 Dec 2013 16:36:17 -0800
Message-ID: <529d2781.nBNOBuwR3XUj9lqy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43535 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab3LCAgS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Dec 2013 19:36:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, richard@nod.at

Subject: + fs-execc-call-arch_pick_mmap_layout-only-once.patch added to -mm tree
To: richard@nod.at,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Mon, 02 Dec 2013 16:36:17 -0800


The patch titled
     Subject: fs/exec.c: call arch_pick_mmap_layout() only once
has been added to the -mm tree.  Its filename is
     fs-execc-call-arch_pick_mmap_layout-only-once.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-execc-call-arch_pick_mmap_layout-only-once.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-execc-call-arch_pick_mmap_layout-only-once.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

From: akpm@linux-foundation.org
Subject: + mm-trivial-simplify-flag-check.patch added to -mm tree
Date: Tue, 31 Mar 2015 16:40:15 -0700
Message-ID: <551b305f.xYsIdwDwOlVYdTj5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55061 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbbCaXkQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Mar 2015 19:40:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bp@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/mm.h: simplify flag check
has been added to the -mm tree.  Its filename is
     mm-trivial-simplify-flag-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-trivial-simplify-flag-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-trivial-simplify-flag-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Borislav Petkov <bp@suse.de>
Subject: include/linux/mm.h: simplify flag check

Flip the flag test so that it is the simplest.  No functional change, just
a small readability improvement:

No code changed:

  # arch/x86/kernel/sys_x86_64.o:

   text    data     bss     dec     hex filename
   1551      24       0    1575     627 sys_x86_64.o.before
   1551      24       0    1575     627 sys_x86_64.o.after

md5:
   70708d1b1ad35cc891118a69dc1a63f9  sys_x86_64.o.before.asm
   70708d1b1ad35cc891118a69dc1a63f9  sys_x86_64.o.after.asm

Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/mm.h~mm-trivial-simplify-flag-check include/linux/mm.h
--- a/include/linux/mm.h~mm-trivial-simplify-flag-check
+++ a/include/linux/mm.h
@@ -1855,10 +1855,10 @@ extern unsigned long unmapped_area_topdo
 static inline unsigned long
 vm_unmapped_area(struct vm_unmapped_area_info *info)
 {
-	if (!(info->flags & VM_UNMAPPED_AREA_TOPDOWN))
-		return unmapped_area(info);
-	else
+	if (info->flags & VM_UNMAPPED_AREA_TOPDOWN)
 		return unmapped_area_topdown(info);
+	else
+		return unmapped_area(info);
 }
 
 /* truncate.c */
_

Patches currently in -mm which might be from bp@suse.de are

maintainers-change-x86-microcode-loader-maintainer.patch
mm-trivial-simplify-flag-check.patch
printk-comment-pr_cont-stating-it-is-only-to-continue-a-line.patch
linux-next.patch


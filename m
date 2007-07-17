From: akpm@linux-foundation.org
Subject: - fix-sparse-false-positives-re-bug_onptr.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:02:35 -0700
Message-ID: <200707172302.l6HN2ZPk011584@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56621 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935463AbXGQXQX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, josh@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Fix sparse false positives re BUG_ON(ptr)
has been removed from the -mm tree.  Its filename was
     fix-sparse-false-positives-re-bug_onptr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix sparse false positives re BUG_ON(ptr)
From: Alexey Dobriyan <adobriyan@sw.ru>

sparse now warns if one compares pointers with integers. However, there are
false positives, like:

	fs/filesystems.c:72:2: warning: Using plain integer as NULL pointer

Every time BUG_ON(ptr) is used, ptr is checked against integer zero.  Avoid
that and save ~70 false positives from allyesconfig run.

mentioned by Al.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Josh Triplett <josh@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bug.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-generic/bug.h~fix-sparse-false-positives-re-bug_onptr include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~fix-sparse-false-positives-re-bug_onptr
+++ a/include/asm-generic/bug.h
@@ -28,7 +28,7 @@ struct bug_entry {
 #endif
 
 #ifndef HAVE_ARCH_BUG_ON
-#define BUG_ON(condition) do { if (unlikely((condition)!=0)) BUG(); } while(0)
+#define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while(0)
 #endif
 
 #ifndef HAVE_ARCH_WARN_ON
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
use-list_head-in-binfmt-handling.patch
make-unregister_binfmt-return-void.patch

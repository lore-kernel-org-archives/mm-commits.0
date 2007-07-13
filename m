From: akpm@linux-foundation.org
Subject: + fix-sparse-false-positives-re-bug_onptr.patch added to -mm tree
Date: Fri, 13 Jul 2007 12:24:19 -0700
Message-ID: <200707131924.l6DJOJtu014211@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60449 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758316AbXGMTZN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 15:25:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru, josh@kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Fix sparse false positives re BUG_ON(ptr)
has been added to the -mm tree.  Its filename is
     fix-sparse-false-positives-re-bug_onptr.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Josh Triplett <josh@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bug.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-generic/bug.h~fix-sparse-false-positives-re-bug_onptr include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~fix-sparse-false-positives-re-bug_onptr
+++ a/include/asm-generic/bug.h
@@ -29,7 +29,7 @@ struct bug_entry {
 #endif
 
 #ifndef HAVE_ARCH_BUG_ON
-#define BUG_ON(condition) do { if (unlikely((condition)!=0)) BUG(); } while(0)
+#define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while(0)
 #endif
 
 #ifndef HAVE_ARCH_WARN_ON
_

Patches currently in -mm which might be from adobriyan@sw.ru are

git-netdev-all.patch
make-proc-slabinfo-use-seq_list_xxx-helpers.patch
fix-rmmod-read-write-races-in-proc-entries.patch
proc-environ-wrong-placing-of-ptrace_may_attach-check.patch
mutex_unlock-later-in-seq_lseek.patch
seq_file-more-atomicity-in-traverse.patch
gitignore-update.patch
fix-sparse-false-positives-re-bug_onptr.patch

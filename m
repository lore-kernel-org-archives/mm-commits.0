From: akpm@linux-foundation.org
Subject: [patch 076/102] mm/madvise: move up the behavior parameter
 validation
Date: Wed, 03 May 2017 14:55:28 -0700
Message-ID: <20170503215528.6VnroatUj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51458 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752513AbdECV4a (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:56:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, khandual@linux.vnet.ibm.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, rientjes@google.com, torvalds@linux-foundation.org

From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: mm/madvise: move up the behavior parameter validation

madvise_behavior_valid() should be called before acting upon the behavior
parameter.  Hence move up the function.  This also includes
MADV_SOFT_OFFLINE and MADV_HWPOISON options as valid behavior parameter
for the system call madvise().

Link: http://lkml.kernel.org/r/20170418052844.24891-1-khandual@linux.vnet.ibm.com
Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN mm/madvise.c~mm-madvise-move-up-the-behavior-parameter-validation mm/madvise.c
--- a/mm/madvise.c~mm-madvise-move-up-the-behavior-parameter-validation
+++ a/mm/madvise.c
@@ -687,6 +687,10 @@ madvise_behavior_valid(int behavior)
 #endif
 	case MADV_DONTDUMP:
 	case MADV_DODUMP:
+#ifdef CONFIG_MEMORY_FAILURE
+	case MADV_SOFT_OFFLINE:
+	case MADV_HWPOISON:
+#endif
 		return true;
 
 	default:
@@ -760,10 +764,6 @@ SYSCALL_DEFINE3(madvise, unsigned long,
 	size_t len;
 	struct blk_plug plug;
 
-#ifdef CONFIG_MEMORY_FAILURE
-	if (behavior == MADV_HWPOISON || behavior == MADV_SOFT_OFFLINE)
-		return madvise_inject_error(behavior, start, start + len_in);
-#endif
 	if (!madvise_behavior_valid(behavior))
 		return error;
 
@@ -783,6 +783,11 @@ SYSCALL_DEFINE3(madvise, unsigned long,
 	if (end == start)
 		return error;
 
+#ifdef CONFIG_MEMORY_FAILURE
+	if (behavior == MADV_HWPOISON || behavior == MADV_SOFT_OFFLINE)
+		return madvise_inject_error(behavior, start, start + len_in);
+#endif
+
 	write = madvise_need_mmap_write(behavior);
 	if (write) {
 		if (down_write_killable(&current->mm->mmap_sem))
_

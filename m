From: akpm@linux-foundation.org
Subject: + mm-madvise-move-up-the-behavior-parameter-validation.patch
 added to -mm tree
Date: Tue, 18 Apr 2017 15:00:06 -0700
Message-ID: <58f68c66.Jr9FETDIb3y6KpsL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39948 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750954AbdDRWAH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2017 18:00:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khandual@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/madvise: move up the behavior parameter validation
has been added to the -mm tree.  Its filename is
     mm-madvise-move-up-the-behavior-parameter-validation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-madvise-move-up-the-behavior-parameter-validation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-madvise-move-up-the-behavior-parameter-validation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: mm/madvise: move up the behavior parameter validation

madvise_behavior_valid() should be called before acting upon the behavior
parameter.  Hence move up the function.  This also includes
MADV_SOFT_OFFLINE and MADV_HWPOISON options as valid behavior parameter
for the system call madvise().

Link: http://lkml.kernel.org/r/20170418052844.24891-1-khandual@linux.vnet.ibm.com
Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
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

Patches currently in -mm which might be from khandual@linux.vnet.ibm.com are

mm-mmap-replace-shm_huge_mask-with-map_huge_mask-inside-mmap_pgoff.patch
mm-madvise-clean-up-madv_soft_offline-and-madv_hwpoison.patch
mm-madvise-move-up-the-behavior-parameter-validation.patch
mm-softoffline-add-page-flag-description-in-error-paths.patch
selftests-vm-add-a-test-for-virtual-address-range-mapping.patch


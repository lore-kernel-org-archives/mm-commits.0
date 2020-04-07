From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-gup-mark-lock-taken-only-after-a-successful-retake.patch added to -mm
 tree
Date: Tue, 07 Apr 2020 15:12:32 -0700
Message-ID: <20200407221232.lVQl8hWdt%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726380AbgDGWMd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 18:12:33 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, peterx@redhat.com


The patch titled
     Subject: mm/gup: mark lock taken only after a successful retake
has been added to the -mm tree.  Its filename is
     mm-gup-mark-lock-taken-only-after-a-successful-retake.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-gup-mark-lock-taken-only-after-a-successful-retake.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-mark-lock-taken-only-after-a-successful-retake.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/gup: mark lock taken only after a successful retake

It's definitely incorrect to mark the lock as taken even if
down_read_killable() failed.  It's overlooked when we switched from
down_read() to down_read_killable() because down_read() won't fail while
down_read_killable() could.

Link: http://lkml.kernel.org/r/20200407204754.GA66033@xz-x1
Fixes: 71335f37c5e8 ("mm/gup: allow to react to fatal signals")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: syzbot+a8c70b7f3579fc0587dc@syzkaller.appspotmail.com
Tested-by: syzbot+a8c70b7f3579fc0587dc@syzkaller.appspotmail.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup.c~mm-gup-mark-lock-taken-only-after-a-successful-retake
+++ a/mm/gup.c
@@ -1329,7 +1329,6 @@ retry:
 		if (fatal_signal_pending(current))
 			break;
 
-		*locked = 1;
 		ret = down_read_killable(&mm->mmap_sem);
 		if (ret) {
 			BUG_ON(ret > 0);
@@ -1338,6 +1337,7 @@ retry:
 			break;
 		}
 
+		*locked = 1;
 		ret = __get_user_pages(tsk, mm, start, 1, flags | FOLL_TRIED,
 				       pages, NULL, locked);
 		if (!*locked) {
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-merge-parameters-for-change_protection.patch
userfaultfd-wp-apply-_page_uffd_wp-bit.patch
userfaultfd-wp-drop-_page_uffd_wp-properly-when-fork.patch
userfaultfd-wp-add-pmd_swp_uffd_wp-helpers.patch
userfaultfd-wp-support-swap-and-page-migration.patch
khugepaged-skip-collapse-if-uffd-wp-detected.patch
userfaultfd-wp-dont-wake-up-when-doing-write-protect.patch
userfaultfd-wp-declare-_uffdio_writeprotect-conditionally.patch
userfaultfd-selftests-refactor-statistics.patch
userfaultfd-selftests-add-write-protect-test.patch
mm-mempolicy-allow-lookup_node-to-handle-fatal-signal.patch
mm-gup-mark-lock-taken-only-after-a-successful-retake.patch

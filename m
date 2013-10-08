From: akpm@linux-foundation.org
Subject: + vsprintf-ignore-%n-again.patch added to -mm tree
Date: Tue, 08 Oct 2013 13:30:41 -0700
Message-ID: <52546b71.lcZdZNYKBsr6BBZ+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44198 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772Ab3JHUam (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Oct 2013 16:30:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, joe@perches.com, davem@davemloft.net, keescook@chromium.org

Subject: + vsprintf-ignore-%n-again.patch added to -mm tree
To: keescook@chromium.org,davem@davemloft.net,joe@perches.com,penguin-kernel@I-love.SAKURA.ne.jp
From: akpm@linux-foundation.org
Date: Tue, 08 Oct 2013 13:30:41 -0700


The patch titled
     Subject: vsprintf: ignore %n again
has been added to the -mm tree.  Its filename is
     vsprintf-ignore-%n-again.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vsprintf-ignore-%n-again.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vsprintf-ignore-%n-again.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: vsprintf: ignore %n again

This ignores %n in printf again, as was originally documented. 
Implementing %n poses a greater security risk than utility, so it should
stay ignored.  To help anyone attempting to use %n, a warning will be
emitted if it is encountered.

Based on an earlier patch by Joe Perches.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Joe Perches <joe@perches.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff -puN lib/vsprintf.c~vsprintf-ignore-%n-again lib/vsprintf.c
--- a/lib/vsprintf.c~vsprintf-ignore-%n-again
+++ a/lib/vsprintf.c
@@ -1685,18 +1685,16 @@ int vsnprintf(char *buf, size_t size, co
 			break;
 
 		case FORMAT_TYPE_NRCHARS: {
-			u8 qualifier = spec.qualifier;
+			/*
+			 * Since %n poses a greater security risk than
+			 * utility, ignore %n and skip its argument.
+			 */
+			void *skip_arg;
 
-			if (qualifier == 'l') {
-				long *ip = va_arg(args, long *);
-				*ip = (str - buf);
-			} else if (_tolower(qualifier) == 'z') {
-				size_t *ip = va_arg(args, size_t *);
-				*ip = (str - buf);
-			} else {
-				int *ip = va_arg(args, int *);
-				*ip = (str - buf);
-			}
+			WARN_ONCE(1, "Please remove ignored %%n in '%s'\n",
+					old_fmt);
+
+			skip_arg = va_arg(args, void *);
 			break;
 		}
 
_

Patches currently in -mm which might be from keescook@chromium.org are

mm-avoid-increase-sizeofstruct-page-due-to-split-page-table-lock.patch
mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks.patch
mm-convert-mm-nr_ptes-to-atomic_long_t.patch
mm-introduce-api-for-split-page-table-lock-for-pmd-level.patch
mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock.patch
mm-thp-move-ptl-taking-inside-page_check_address_pmd.patch
mm-thp-do-not-access-mm-pmd_huge_pte-directly.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch
mm-convert-the-rest-to-new-page-table-lock-api.patch
mm-implement-split-page-table-lock-for-pmd-level.patch
x86-mm-enable-split-page-table-lock-for-pmd-level.patch
printk-report-console-names-during-cut-over.patch
kernel-printk-printkc-convert-to-pr_foo.patch
seq_file-introduce-seq_setwidth-and-seq_pad.patch
seq_file-remove-%n-usage-from-seq_file-users.patch
vsprintf-ignore-%n-again.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
drivers-message-i2o-driverc-add-missing-destroy_workqueue-on-error-in-i2o_driver_register.patch
gcov-move-gcov-structs-definitions-to-a-gcc-version-specific-file.patch
gcov-add-support-for-gcc-47-gcov-format.patch
gcov-compile-specific-gcov-implementation-based-on-gcc-version.patch
kernel-add-support-for-init_array-constructors.patch
kernel-add-support-for-init_array-constructors-fix.patch
kernel-gcov-fsc-use-pr_warn.patch
linux-next.patch


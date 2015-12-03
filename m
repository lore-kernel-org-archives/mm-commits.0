From: akpm@linux-foundation.org
Subject: + lib-test_printfc-dont-bug.patch added to -mm tree
Date: Thu, 03 Dec 2015 15:35:37 -0800
Message-ID: <5660d1c9.FGx82jMvTm1V2E3w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44335 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbbLCXfi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Dec 2015 18:35:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com, joe@perches.com, keescook@chromium.org, mingo@kernel.org, mlombard@redhat.com, tj@kernel.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_printf.c: don't BUG
has been added to the -mm tree.  Its filename is
     lib-test_printfc-dont-bug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-test_printfc-dont-bug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-test_printfc-dont-bug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/test_printf.c: don't BUG

BUG is a completely unnecessarily big hammer, and we're more likely to
get the internal bug reported if we just pr_err() and ensure the test
suite fails.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Joe Perches <joe@perches.com>
Cc: Maurizio Lombardi <mlombard@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_printf.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN lib/test_printf.c~lib-test_printfc-dont-bug lib/test_printf.c
--- a/lib/test_printf.c~lib-test_printfc-dont-bug
+++ a/lib/test_printf.c
@@ -91,7 +91,12 @@ __test(const char *expect, int elen, con
 	int rand;
 	char *p;
 
-	BUG_ON(elen >= BUF_SIZE);
+	if (elen >= BUF_SIZE) {
+		pr_err("error in test suite: expected output length %d too long. Format was '%s'.\n",
+		       elen, fmt);
+		failed_tests++;
+		return;
+	}
 
 	va_start(ap, fmt);
 
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

lib-vsprintfc-pull-out-padding-code-from-dentry_name.patch
lib-vsprintfc-move-string-below-widen_string.patch
lib-vsprintfc-eliminate-potential-race-in-string.patch
lib-vsprintfc-expand-field_width-to-24-bits.patch
lib-vsprintfc-help-gcc-make-number-smaller.patch
lib-vsprintfc-warn-about-too-large-precisions-and-field-widths.patch
lib-kasprintfc-add-sanity-check-to-kvasprintf.patch
lib-test_printfc-dont-bug.patch
lib-test_printfc-check-for-out-of-bound-writes.patch
lib-test_printfc-test-precision-quirks.patch
lib-test_printfc-add-a-few-number-tests.patch
lib-test_printfc-account-for-kvasprintf-tests.patch
lib-test_printfc-add-test-for-large-bitmaps.patch
lib-test_printfc-test-dentry-printing.patch
powerpc-fadump-rename-cpu_online_mask-member-of-struct-fadump_crash_info_header.patch
kernel-cpuc-change-type-of-cpu_possible_bits-and-friends.patch
kernel-cpuc-export-__cpu__mask.patch
drivers-base-cpuc-use-__cpu__mask-directly.patch
kernel-cpuc-eliminate-cpu__mask.patch
kernel-cpuc-make-set_cpu_-static-inlines.patch


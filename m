From: akpm@linux-foundation.org
Subject: [merged] lib-test_printfc-dont-bug.patch removed from -mm tree
Date: Tue, 19 Jan 2016 12:15:08 -0800
Message-ID: <569e994c.XFqd+fXTeh+kLUFc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44611 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933191AbcASUPJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:15:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com, joe@perches.com, keescook@chromium.org, mingo@kernel.org, mlombard@redhat.com, tj@kernel.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_printf.c: don't BUG
has been removed from the -mm tree.  Its filename was
     lib-test_printfc-dont-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

powerpc-fadump-rename-cpu_online_mask-member-of-struct-fadump_crash_info_header.patch
kernel-cpuc-change-type-of-cpu_possible_bits-and-friends.patch
kernel-cpuc-export-__cpu__mask.patch
drivers-base-cpuc-use-__cpu__mask-directly.patch
kernel-cpuc-eliminate-cpu__mask.patch
kernel-cpuc-make-set_cpu_-static-inlines.patch


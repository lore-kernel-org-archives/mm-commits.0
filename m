From: akpm@linux-foundation.org
Subject: [merged] lib-test_printfc-account-for-kvasprintf-tests.patch
 removed from -mm tree
Date: Tue, 19 Jan 2016 12:15:18 -0800
Message-ID: <569e9956.8cCE30N8+pJzGILx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44644 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933194AbcASUPT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:15:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com, joe@perches.com, keescook@chromium.org, mingo@kernel.org, mlombard@redhat.com, tj@kernel.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_printf.c: account for kvasprintf tests
has been removed from the -mm tree.  Its filename was
     lib-test_printfc-account-for-kvasprintf-tests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/test_printf.c: account for kvasprintf tests

These should also count as performed tests.

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

 lib/test_printf.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/test_printf.c~lib-test_printfc-account-for-kvasprintf-tests lib/test_printf.c
--- a/lib/test_printf.c~lib-test_printfc-account-for-kvasprintf-tests
+++ a/lib/test_printf.c
@@ -127,6 +127,7 @@ __test(const char *expect, int elen, con
 
 	p = kvasprintf(GFP_KERNEL, fmt, ap);
 	if (p) {
+		total_tests++;
 		if (memcmp(p, expect, elen+1)) {
 			pr_warn("kvasprintf(..., \"%s\", ...) returned '%s', expected '%s'\n",
 				fmt, p, expect);
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

powerpc-fadump-rename-cpu_online_mask-member-of-struct-fadump_crash_info_header.patch
kernel-cpuc-change-type-of-cpu_possible_bits-and-friends.patch
kernel-cpuc-export-__cpu__mask.patch
drivers-base-cpuc-use-__cpu__mask-directly.patch
kernel-cpuc-eliminate-cpu__mask.patch
kernel-cpuc-make-set_cpu_-static-inlines.patch


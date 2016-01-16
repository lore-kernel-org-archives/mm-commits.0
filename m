From: akpm@linux-foundation.org
Subject: [folded-merged] lib-test_printfc-test-dentry-printing-fix.patch
 removed from -mm tree
Date: Fri, 15 Jan 2016 16:36:19 -0800
Message-ID: <56999083.pf2idaWSWbLth/0c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38194 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbcAPAgU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 19:36:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, joe@perches.com, keescook@chromium.org, linux@rasmusvillemoes.dk, mingo@kernel.org, mlombard@redhat.com, tj@kernel.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-test_printfc-test-dentry-printing-fix
has been removed from the -mm tree.  Its filename was
     lib-test_printfc-test-dentry-printing-fix.patch

This patch was dropped because it was folded into lib-test_printfc-test-dentry-printing.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-test_printfc-test-dentry-printing-fix

Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Joe Perches <joe@perches.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Maurizio Lombardi <mlombard@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_printf.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN lib/test_printf.c~lib-test_printfc-test-dentry-printing-fix lib/test_printf.c
--- a/lib/test_printf.c~lib-test_printfc-test-dentry-printing-fix
+++ a/lib/test_printf.c
@@ -329,16 +329,16 @@ uuid(void)
 
 static struct dentry test_dentry[4] __initdata = {
 	{ .d_parent = &test_dentry[0],
-	  .d_name = { .len = 3, .name = test_dentry[0].d_iname },
+	  .d_name = QSTR_INIT(test_dentry[0].d_iname, 3),
 	  .d_iname = "foo" },
 	{ .d_parent = &test_dentry[0],
-	  .d_name = { .len = 5, .name = test_dentry[1].d_iname },
+	  .d_name = QSTR_INIT(test_dentry[1].d_iname, 5),
 	  .d_iname = "bravo" },
 	{ .d_parent = &test_dentry[1],
-	  .d_name = { .len = 4, .name = test_dentry[2].d_iname },
+	  .d_name = QSTR_INIT(test_dentry[2].d_iname, 4),
 	  .d_iname = "alfa" },
 	{ .d_parent = &test_dentry[2],
-	  .d_name = { .len = 5, .name = test_dentry[3].d_iname },
+	  .d_name = QSTR_INIT(test_dentry[3].d_iname, 5),
 	  .d_iname = "romeo" },
 };
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-define-madv_free-for-some-arches.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures.patch
kernel-stop_machinec-remove-config_smp-dependencies.patch
lib-test_printfc-test-dentry-printing.patch
printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments-fix.patch


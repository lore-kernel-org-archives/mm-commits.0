From: akpm@linux-foundation.org
Subject: [folded-merged]
 lib-vsprintfc-expand-field_width-to-24-bits-fix.patch removed from -mm tree
Date: Fri, 15 Jan 2016 16:35:54 -0800
Message-ID: <5699906a.IdP+vvtY/wOzcesE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38165 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161001AbcAPAfz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 19:35:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, joe@perches.com, keescook@chromium.org, linux@rasmusvillemoes.dk, mingo@kernel.org, mlombard@redhat.com, tj@kernel.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-vsprintfc-expand-field_width-to-24-bits-fix
has been removed from the -mm tree.  Its filename was
     lib-vsprintfc-expand-field_width-to-24-bits-fix.patch

This patch was dropped because it was folded into lib-vsprintfc-expand-field_width-to-24-bits.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-vsprintfc-expand-field_width-to-24-bits-fix

avoid open-coded BUILD_BUG_ON

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

 lib/vsprintf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-expand-field_width-to-24-bits-fix lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-expand-field_width-to-24-bits-fix
+++ a/lib/vsprintf.c
@@ -389,7 +389,6 @@ struct printf_spec {
 	unsigned int	base:8;		/* number base, 8, 10 or 16 only */
 	signed int	precision:16;	/* # of digits/chars */
 } __packed;
-extern char __check_printf_spec[1-2*(sizeof(struct printf_spec) != 8)];
 
 static noinline_for_stack
 char *number(char *buf, char *end, unsigned long long num,
@@ -403,6 +402,8 @@ char *number(char *buf, char *end, unsig
 	int i;
 	bool is_zero = num == 0LL;
 
+	BUILD_BUG_ON(sizeof(struct printf_spec) != 8);
+
 	/* locase = 0 or 0x20. ORing digits or letters with 'locase'
 	 * produces same digits or (maybe lowercased) letters */
 	locase = (spec.flags & SMALL);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-define-madv_free-for-some-arches.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures.patch
kernel-stop_machinec-remove-config_smp-dependencies.patch
lib-vsprintfc-expand-field_width-to-24-bits.patch
lib-test_printfc-test-dentry-printing-fix.patch
printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments-fix.patch


From: akpm@linux-foundation.org
Subject: [to-be-updated] kernelh-add-build_bug_on_not_power_of_2.patch removed from -mm tree
Date: Fri, 08 Jan 2010 13:11:53 -0800
Message-ID: <201001082111.o08LBrSq014250@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41542 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753828Ab0AHVMO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jan 2010 16:12:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdreier@cisco.com, rolandd@cisco.com, mm-commits@vger.kernel.org


The patch titled
     kernel.h: add BUILD_BUG_ON_NOT_POWER_OF_2()
has been removed from the -mm tree.  Its filename was
     kernelh-add-build_bug_on_not_power_of_2.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel.h: add BUILD_BUG_ON_NOT_POWER_OF_2()
From: Roland Dreier <rdreier@cisco.com>

When code relies on a constant being a power of 2:

	#define FOO	512	/* must be a power of 2 */

it would be nice to be able to do:

	BUILD_BUG_ON(!is_power_of_2(FOO));

However applying an inline function does not result in a compile-time
constant that can be used with BUILD_BUG_ON(), so trying that gives
results in:

	error: bit-field '<anonymous>' width not an integer constant

As suggested by akpm, rather than monkeying around with is_power_of_2()
and risking gcc warts about constant expressions, just create a macro
BUILD_BUG_ON_NOT_POWER_OF_2() to encapsulate this common requirement.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN include/linux/kernel.h~kernelh-add-build_bug_on_not_power_of_2 include/linux/kernel.h
--- a/include/linux/kernel.h~kernelh-add-build_bug_on_not_power_of_2
+++ a/include/linux/kernel.h
@@ -703,6 +703,10 @@ static inline void ftrace_dump(void) { }
 struct sysinfo;
 extern int do_sysinfo(struct sysinfo *info);
 
+/* Force a compilation error if expression is not a power of 2 */
+#define BUILD_BUG_ON_NOT_POWER_OF_2(n)			\
+	BUILD_BUG_ON(((n) != 0 && (((n) & ((n) - 1)) == 0)))
+
 /* Force a compilation error if condition is true, but also produce a
    result (of value 0 and type size_t), so the expression can be used
    e.g. in a structure initializer (or where-ever else comma expressions
_

Patches currently in -mm which might be from rdreier@cisco.com are

kfifo-use-void-pointers-for-user-buffers.patch
kfifo-sanitize-_user-error-handling.patch
kfifo-add-kfifo_out_peek.patch
kfifo-add-kfifo_initialized.patch
kfifo-document-everywhere-that-size-has-to-be-power-of-two.patch
kernelh-add-build_bug_on_not_power_of_2.patch
ecryptfs-another-lockdep-issue.patch


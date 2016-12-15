From: akpm@linux-foundation.org
Subject: [merged] coredump-clarify-unsafe-core_pattern-warning.patch
 removed from -mm tree
Date: Thu, 15 Dec 2016 10:45:07 -0800
Message-ID: <5852e4b3./n72t1OKi5rnQr7S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48358 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753929AbcLOSpI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:45:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: clarify "unsafe core_pattern" warning
has been removed from the -mm tree.  Its filename was
     coredump-clarify-unsafe-core_pattern-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: coredump: clarify "unsafe core_pattern" warning

I was amused to find "unsafe core_pattern" warning having these lines in
/etc/sysctl.conf:

	fs.suid_dumpable=2
	kernel.core_pattern=/core/core-%e-%p-%E
	kernel.core_uses_pid=0

Turns out kernel is formally right.  Default core_pattern is just "core",
which doesn't qualify for secure path while setting suid.dumpable.

Hint admins about solution, clarify sysctl names, delete unnecessary '\'
characters (string literals are concatenated regardless) and reformat for
easier grepping.

Link: http://lkml.kernel.org/r/20161029152124.GA1258@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN kernel/sysctl.c~coredump-clarify-unsafe-core_pattern-warning kernel/sysctl.c
--- a/kernel/sysctl.c~coredump-clarify-unsafe-core_pattern-warning
+++ a/kernel/sysctl.c
@@ -2389,9 +2389,11 @@ static void validate_coredump_safety(voi
 #ifdef CONFIG_COREDUMP
 	if (suid_dumpable == SUID_DUMP_ROOT &&
 	    core_pattern[0] != '/' && core_pattern[0] != '|') {
-		printk(KERN_WARNING "Unsafe core_pattern used with "\
-			"suid_dumpable=2. Pipe handler or fully qualified "\
-			"core dump path required.\n");
+		printk(KERN_WARNING
+"Unsafe core_pattern used with fs.suid_dumpable=2.\n"
+"Pipe handler or fully qualified core dump path required.\n"
+"Set kernel.core_pattern before fs.suid_dumpable.\n"
+		);
 	}
 #endif
 }
_

Patches currently in -mm which might be from adobriyan@gmail.com are



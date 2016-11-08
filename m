From: akpm@linux-foundation.org
Subject: + coredump-clarify-unsafe-core_pattern-warning.patch added to -mm tree
Date: Tue, 08 Nov 2016 15:07:05 -0800
Message-ID: <58225a99./7QWp0dZm66wMvfT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50490 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751981AbcKHXHG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2016 18:07:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: clarify "unsafe core_pattern" warning
has been added to the -mm tree.  Its filename is
     coredump-clarify-unsafe-core_pattern-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/coredump-clarify-unsafe-core_pattern-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/coredump-clarify-unsafe-core_pattern-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2403,9 +2403,11 @@ static void validate_coredump_safety(voi
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

scripts-bloat-o-meter-fix-sigpipe.patch
kbuild-simpler-generation-of-assembly-constants.patch
proc-make-struct-pid_entry-len-unsigned.patch
proc-make-struct-struct-map_files_info-len-unsigned-int.patch
proc-just-list_del-struct-pde_opener.patch
proc-fix-type-of-struct-pde_opener-closing-field.patch
proc-kmalloc-struct-pde_opener.patch
proc-tweak-comments-about-2-stage-open-and-everything.patch
coredump-clarify-unsafe-core_pattern-warning.patch


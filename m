From: akpm@linux-foundation.org
Subject: + checkpatchpl-new-instances-of-enosys-are-errors.patch added to
 -mm tree
Date: Fri, 10 Apr 2015 15:48:09 -0700
Message-ID: <55285329.8CEc0QBdbAOpJKES%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51061 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932470AbbDJWsK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Apr 2015 18:48:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@amacapital.net, joe@perches.com, mtk.manpages@gmail.com, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch.pl: new instances of ENOSYS are errors
has been added to the -mm tree.  Its filename is
     checkpatchpl-new-instances-of-enosys-are-errors.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatchpl-new-instances-of-enosys-are-errors.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatchpl-new-instances-of-enosys-are-errors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Lutomirski <luto@amacapital.net>
Subject: checkpatch.pl: new instances of ENOSYS are errors

ENOSYS means that a nonexistent system call was called.  We have a
bad habit of using it for things like invalid operations on
otherwise valid syscalls.  We should avoid this in new code.

Pervasive incorrect usage of ENOSYS came up at the kernel summit ABI
review discussion.  Let's see if checkpatch can help.

I'll submit a separate patch for include/uapi/asm-generic/errno.h.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatchpl-new-instances-of-enosys-are-errors scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatchpl-new-instances-of-enosys-are-errors
+++ a/scripts/checkpatch.pl
@@ -3396,6 +3396,14 @@ sub process {
 			     "Prefer dev_$level(... to dev_printk(KERN_$orig, ...\n" . $herecurr);
 		}
 
+# ENOSYS means "bad syscall nr" and nothing else.  This will have a small
+# number of false positives, but assembly files are not checked, so at
+# least the arch entry code will not trigger this warning.
+		if ($line =~ /\bENOSYS\b/) {
+			WARN("ENOSYS",
+			     "ENOSYS means 'invalid syscall nr' and nothing else\n" . $herecurr);
+		}
+
 # function brace can't be on same line, except for #defines of do while,
 # or if closed on same line
 		if (($line=~/$Type\s*$Ident\(.*\).*\s*{/) and
_

Patches currently in -mm which might be from luto@amacapital.net are

arm-factor-out-mmap-aslr-into-mmap_rnd.patch
x86-standardize-mmap_rnd-usage.patch
mm-expose-arch_mmap_rnd-when-available.patch
mm-split-et_dyn-aslr-from-mmap-aslr.patch
mm-fold-arch_randomize_brk-into-arch_has_elf_randomize.patch
checkpatchpl-new-instances-of-enosys-are-errors.patch
linux-next.patch


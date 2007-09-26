From: akpm@linux-foundation.org
Subject: + extended-crashkernel-command-line-comment-fix.patch added to -mm tree
Date: Wed, 26 Sep 2007 02:12:06 -0700
Message-ID: <200709260912.l8Q9C6tr030070@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43889 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752865AbXIZJMi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 05:12:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de


The patch titled
     extended-crashkernel-command-line comment fix
has been added to the -mm tree.  Its filename is
     extended-crashkernel-command-line-comment-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: extended-crashkernel-command-line comment fix
From: Bernhard Walle <bwalle@suse.de>

Only use 'offset' and not 'base' for the address where the reserved area
starts.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/kexec.c~extended-crashkernel-command-line-comment-fix kernel/kexec.c
--- a/kernel/kexec.c~extended-crashkernel-command-line-comment-fix
+++ a/kernel/kexec.c
@@ -1157,7 +1157,7 @@ module_init(crash_notes_memory_init)
 /*
  * This function parses command lines in the format
  *
- *   crashkernel=<ramsize-range>:<size>[,...][@<base>]
+ *   crashkernel=ramsize-range:size[,...][@offset]
  *
  * The function returns 0 on success and -EINVAL on failure.
  */
@@ -1222,7 +1222,7 @@ static int __init parse_crashkernel_mem(
 /*
  * That function parses "simple" (old) crashkernel command lines like
  *
- * 	crashkernel=size[@base]
+ * 	crashkernel=size[@offset]
  *
  * It returns 0 on success and -EINVAL on failure.
  */
_

Patches currently in -mm which might be from bwalle@suse.de are

ipsc-update-version-information.patch
add-vmcoreinfo.patch
express-relocatability-of-kernel-on-x86_64-in-documentation.patch
express-relocatability-of-kernel-on-x86_64-in.patch
express-new-elf32-mechanisms-in-documentation.patch
add-reset_devices-to-the-recommended-parameters.patch
extended-crashkernel-command-line.patch
extended-crashkernel-command-line-update.patch
extended-crashkernel-command-line-comment-fix.patch
use-extended-crashkernel-command-line-on-i386.patch
use-extended-crashkernel-command-line-on-i386-update.patch
use-extended-crashkernel-command-line-on-x86_64.patch
use-extended-crashkernel-command-line-on-x86_64-update.patch
use-extended-crashkernel-command-line-on-ia64.patch
use-extended-crashkernel-command-line-on-ia64-fix.patch
use-extended-crashkernel-command-line-on-ia64-update.patch
use-extended-crashkernel-command-line-on-ppc64.patch
use-extended-crashkernel-command-line-on-ppc64-update.patch
use-extended-crashkernel-command-line-on-sh.patch
use-extended-crashkernel-command-line-on-sh-update.patch
add-documentation-for-extended-crashkernel-syntax.patch
add-documentation-for-extended-crashkernel-syntax-add-extended-crashkernel-syntax-to-kernel-parameterstxt.patch

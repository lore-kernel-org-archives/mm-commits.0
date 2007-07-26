From: akpm@linux-foundation.org
Subject: + allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-binfmt_flat-fix.patch added to -mm tree
Date: Thu, 26 Jul 2007 00:50:04 -0700
Message-ID: <200707260750.l6Q7o48H020967@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40717 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756667AbXGZHur (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 03:50:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nhorman@tuxdriver.com


The patch titled
     allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe binfmt_flat fix
has been added to the -mm tree.  Its filename is
     allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-binfmt_flat-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe binfmt_flat fix
From: Neil Horman <nhorman@tuxdriver.com>

> SuperH allmodconfig broke:
>
> fs/binfmt_flat.c:83: warning: initialization from incompatible pointer type
> fs/binfmt_flat.c:94: error: conflicting types for 'flat_core_dump'
> fs/binfmt_flat.c:78: error: previous declaration of 'flat_core_dump' was here
> fs/binfmt_flat.c:94: error: conflicting types for 'flat_core_dump'
> fs/binfmt_flat.c:78: error: previous declaration of 'flat_core_dump' was here
> fs/binfmt_flat.c: In function `decompress_exec':
> fs/binfmt_flat.c:293: warning: label `out' defined but not used
> fs/binfmt_flat.c: In function `load_flat_file':
> fs/binfmt_flat.c:462: warning: unsigned int format, long int arg (arg 3)
> fs/binfmt_flat.c:462: warning: unsigned int format, long int arg (arg 4)
> fs/binfmt_flat.c:518: warning: comparison of distinct pointer types lacks a cast
> fs/binfmt_flat.c:549: warning: passing arg 1 of `ksize' makes pointer from integer without a cast
> fs/binfmt_flat.c:601: warning: passing arg 1 of `ksize' makes pointer from integer without a cast
> fs/binfmt_flat.c: At top level:
> fs/binfmt_flat.c:78: warning: 'flat_core_dump' used but never defined
> fs/binfmt_flat.c:94: warning: 'flat_core_dump' defined but not used

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_flat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/binfmt_flat.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-binfmt_flat-fix fs/binfmt_flat.c
--- a/fs/binfmt_flat.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-binfmt_flat-fix
+++ a/fs/binfmt_flat.c
@@ -75,7 +75,7 @@ static int load_flat_shared_library(int 
 #endif
 
 static int load_flat_binary(struct linux_binprm *, struct pt_regs * regs);
-static int flat_core_dump(long signr, struct pt_regs * regs, struct file *file, u32 limit);
+static int flat_core_dump(long signr, struct pt_regs * regs, struct file *file, unsigned long limit);
 
 static struct linux_binfmt flat_format = {
 	.module		= THIS_MODULE,
_

Patches currently in -mm which might be from nhorman@tuxdriver.com are

update-coredump-path-in-kernel-to-not-check-coredump-rlim-if-core_pattern-is-a-pipe.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-sparc64-fix.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2-fix.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2-sparc64-fix.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-binfmt_flat-fix.patch

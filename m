From: akpm@linux-foundation.org
Subject: - elf-loader-crash-while-zero-filling-bss.patch removed from -mm tree
Date: Wed, 13 Feb 2008 10:54:17 -0800
Message-ID: <200802131854.m1DIsH2i007992@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34268 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752094AbYBMS40 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 13:56:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: abelbg@m2grp.com, dan@debian.org, hpa@zytor.com, jkosina@suse.cz, roland@redhat.com, schwab@suse.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Elf loader crash while zero-filling .bss
has been removed from the -mm tree.  Its filename was
     elf-loader-crash-while-zero-filling-bss.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Elf loader crash while zero-filling .bss
From: "Abel Bernabeu" <abelbg@m2grp.com>

I've finally found a solution for the crash in load_binary_elf I
reported last week:

http://lkml.org/lkml/2008/1/30/171

The attached patch solves my problem.

set_brk(start, end) allocs just page aligned regions (by "collapsing" both
extremes to the start of the page in which they lay)...  That means than
even if both pointers are not equal there are still some chances that
set_brk has allocated no space at all because ELF_PAGEALIGN(elf_bss) ==	
ELF_PAGEALIGN(elf_brk).

So the condition was not correct.

Cc: Roland McGrath <roland@redhat.com>
Cc: Daniel Jacobowitz <dan@debian.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andreas Schwab <schwab@suse.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/binfmt_elf.c~elf-loader-crash-while-zero-filling-bss fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~elf-loader-crash-while-zero-filling-bss
+++ a/fs/binfmt_elf.c
@@ -893,7 +893,8 @@ static int load_elf_binary(struct linux_
 		send_sig(SIGKILL, current, 0);
 		goto out_free_dentry;
 	}
-	if (likely(elf_bss != elf_brk) && unlikely(padzero(elf_bss))) {
+	if (likely(ELF_PAGEALIGN(elf_bss) != ELF_PAGEALIGN(elf_brk)) &&
+			unlikely(padzero(elf_bss))) {
 		send_sig(SIGSEGV, current, 0);
 		retval = -EFAULT; /* Nobody gets to see this, but.. */
 		goto out_free_dentry;
_

Patches currently in -mm which might be from abelbg@m2grp.com are

elf-loader-crash-while-zero-filling-bss.patch

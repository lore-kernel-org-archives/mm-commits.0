From: akpm@google.com
Subject: + binfmt_elf-fix-pie-execution-with-randomization-disabled.patch added to -mm tree
Date: Thu, 29 Sep 2011 14:22:09 -0700
Message-ID: <201109292122.p8TLM9Sn027213@wpaz17.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:42915 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756903Ab1I2VXV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Sep 2011 17:23:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hongjiu.lu@intel.com, jkosina@suse.cz, jwboyer@redhat.com, mingo@elte.hu, nicolas.pitre@linaro.org, rmk@arm.linux.org.uk


The patch titled
     Subject: binfmt_elf: fix PIE execution with randomization disabled
has been added to the -mm tree.  Its filename is
     binfmt_elf-fix-pie-execution-with-randomization-disabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: H.J. Lu <hongjiu.lu@intel.com>
Subject: binfmt_elf: fix PIE execution with randomization disabled

We've had a bug report
(https://bugzilla.redhat.com/show_bug.cgi?id=708563) of some PIE programs
getting a SIGKILL upon exec if you disable address randomization with:

	echo 0 > /proc/sys/kernel/randomize_va_space

I tracked this down to get_unmapped_area_prot returning -ENOMEM because
the address being passed in is larger than TASK_SIZE - len for the bss
section of the test executable.  That filters back to set_brk returning an
error to load_elf_binary and the SIGKILL being sent around line 872 of
binfmt_elf.c.

H.J.  submitted an upstream bug report
(http://bugzilla.kernel.org/show_bug.cgi?id=36372) as well, but got no
feedback and we can't view it with kernel.org being down anyway.  He came
up with the patch below as well, which is what I'm sending on for
comments.  The changelog is my addition, so if that is wrong yell at me.

I wanted to get some more eyes on this, because the current code sets
load_bias to 0 unconditionally on CONFIG_X86 or CONFIG_ARM.  I have no
idea why that is.  The original execshield patches had an #ifdef on
__i386__ but the patch that was commited to add PIE support has the
CONFIG_X86 setting.

Set the load_bias for PIE executables to a non-zero address if no virtual
address is specified.  This prevents us from running out of room for all
the various loadable segments when ASLR is disabled.

Signed-off-by: H.J. Lu <hongjiu.lu@intel.com>
Signed-off-by: Josh Boyer <jwboyer@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 fs/binfmt_elf.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN fs/binfmt_elf.c~binfmt_elf-fix-pie-execution-with-randomization-disabled fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~binfmt_elf-fix-pie-execution-with-randomization-disabled
+++ a/fs/binfmt_elf.c
@@ -793,9 +793,14 @@ static int load_elf_binary(struct linux_
 			/* Try and get dynamic programs out of the way of the
 			 * default mmap base, as well as whatever program they
 			 * might try to exec.  This is because the brk will
-			 * follow the loader, and is not movable.  */
+			 * follow the loader, and is not movable.  Don't use
+			 * 0 load address since we may not have room for
+			 * all loadable segements.  */
 #if defined(CONFIG_X86) || defined(CONFIG_ARM)
-			load_bias = 0;
+			if (vaddr)
+				load_bias = 0;
+			else
+				load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE);
 #else
 			load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
 #endif
_
Subject: Subject: binfmt_elf: fix PIE execution with randomization disabled

Patches currently in -mm which might be from hongjiu.lu@intel.com are

binfmt_elf-fix-pie-execution-with-randomization-disabled.patch


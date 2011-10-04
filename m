From: akpm@google.com
Subject: + binfmt_elf-fix-pie-execution-with-randomization-disabled.patch added to -mm tree
Date: Tue, 04 Oct 2011 15:05:05 -0700
Message-ID: <201110042205.p94M55Po032438@hpaq14.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:54996 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820Ab1JDWGX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Oct 2011 18:06:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkosina@suse.cz, hongjiu.lu@intel.com, jwboyer@redhat.com, mingo@elte.hu, nicolas.pitre@linaro.org, rmk@arm.linux.org.uk, stable@kernel.org


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
From: Jiri Kosina <jkosina@suse.cz>
Subject: binfmt_elf: fix PIE execution with randomization disabled

The case of address space randomization being disabled in runtime through
randomize_va_space sysctl is not treated properly in load_elf_binary(),
resulting in SIGKILL coming at exec() time for certain PIE-linked binaries
in case the randomization has been disabled at runtime prior to calling
exec().

Handle the randomize_va_space == 0 case the same way as if we were not
supporting .text randomization at all.

Based on original patch by H.J. Lu and Josh Boyer.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: H.J. Lu <hongjiu.lu@intel.com>
Cc: <stable@kernel.org>
Tested-by: Josh Boyer <jwboyer@redhat.com>
Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 fs/binfmt_elf.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN fs/binfmt_elf.c~binfmt_elf-fix-pie-execution-with-randomization-disabled fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~binfmt_elf-fix-pie-execution-with-randomization-disabled
+++ a/fs/binfmt_elf.c
@@ -795,7 +795,16 @@ static int load_elf_binary(struct linux_
 			 * might try to exec.  This is because the brk will
 			 * follow the loader, and is not movable.  */
 #if defined(CONFIG_X86) || defined(CONFIG_ARM)
-			load_bias = 0;
+			/* Memory randomization might have been switched off
+			 * in runtime via sysctl.
+			 * If that is the case, retain the original non-zero
+			 * load_bias value in order to establish proper
+			 * non-randomized mappings.
+			 */
+			if (current->flags & PF_RANDOMIZE)
+				load_bias = 0;
+			else
+				load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
 #else
 			load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
 #endif
_
Subject: Subject: binfmt_elf: fix PIE execution with randomization disabled

Patches currently in -mm which might be from jkosina@suse.cz are

origin.patch
linux-next.patch
kmod-prevent-kmod_loop_msg-overflow-in-__request_module.patch
binfmt_elf-fix-pie-execution-with-randomization-disabled.patch


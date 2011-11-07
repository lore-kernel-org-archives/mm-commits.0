From: akpm@linux-foundation.org
Subject: [merged] binfmt_elf-fix-pie-execution-with-randomization-disabled.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:25:42 -0800
Message-ID: <201111072025.pA7KPhx5026070@hpaq1.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:47145 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513Ab1KGU0x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:26:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, hongjiu.lu@intel.com, jwboyer@redhat.com, mingo@elte.hu, nicolas.pitre@linaro.org, rmk@arm.linux.org.uk, stable@kernel.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: binfmt_elf: fix PIE execution with randomization disabled
has been removed from the -mm tree.  Its filename was
     binfmt_elf-fix-pie-execution-with-randomization-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

Patches currently in -mm which might be from jkosina@suse.cz are

origin.patch


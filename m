From: akpm@linux-foundation.org
Subject: [merged] binfmt_elf-pie-make-pf_randomize-check-comment-more-accurate.patch removed from -mm tree
Date: Tue, 07 May 2013 10:48:24 -0700
Message-ID: <20130507174824.7775A31C1EC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:37986 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757701Ab3EGRs0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:48:26 -0400
Received: by mail-qe0-f74.google.com with SMTP id 1so85184qec.3
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:48:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: binfmt_elf: PIE: make PF_RANDOMIZE check comment more accurate
has been removed from the -mm tree.  Its filename was
     binfmt_elf-pie-make-pf_randomize-check-comment-more-accurate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiri Kosina <jkosina@suse.cz>
Subject: binfmt_elf: PIE: make PF_RANDOMIZE check comment more accurate

The comment I originally added in a3defbe5c337db ("binfmt_elf: fix PIE
execution with randomization disabled") is not really 100% accurate --
sysctl is not the only way how PF_RANDOMIZE could be forcibly unset in
runtime.

Another option of course is direct modification of personality flags (i.e.
running through setarch wrapper).

Make the comment more explicit and accurate.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/binfmt_elf.c~binfmt_elf-pie-make-pf_randomize-check-comment-more-accurate fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~binfmt_elf-pie-make-pf_randomize-check-comment-more-accurate
+++ a/fs/binfmt_elf.c
@@ -803,7 +803,8 @@ static int load_elf_binary(struct linux_
 			 * follow the loader, and is not movable.  */
 #ifdef CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE
 			/* Memory randomization might have been switched off
-			 * in runtime via sysctl.
+			 * in runtime via sysctl or explicit setting of
+			 * personality flags.
 			 * If that is the case, retain the original non-zero
 			 * load_bias value in order to establish proper
 			 * non-randomized mappings.
_

Patches currently in -mm which might be from jkosina@suse.cz are

origin.patch
linux-next.patch
mwave-fix-info-leak-in-mwave_ioctl.patch
random-fix-accounting-race-condition-with-lockless-irq-entropy_count-update.patch


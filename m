From: akpm@linux-foundation.org
Subject: + binfmt_elf-pie-make-pf_randomize-check-comment-more-accurate.patch added to -mm tree
Date: Wed, 17 Apr 2013 15:04:23 -0700
Message-ID: <20130417220423.75C2631C1FB@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:40886 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965558Ab3DQWEY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Apr 2013 18:04:24 -0400
Received: by mail-gg0-f202.google.com with SMTP id q1so216232ggn.3
        for <mm-commits@vger.kernel.org>; Wed, 17 Apr 2013 15:04:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkosina@suse.cz


The patch titled
     Subject: binfmt_elf: PIE: make PF_RANDOMIZE check comment more accurate
has been added to the -mm tree.  Its filename is
     binfmt_elf-pie-make-pf_randomize-check-comment-more-accurate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -820,7 +820,8 @@ static int load_elf_binary(struct linux_
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

linux-next.patch
binfmt_elf-pie-make-pf_randomize-check-comment-more-accurate.patch
i2o-check-copy_from_user-size-parameter.patch
mwave-fix-info-leak-in-mwave_ioctl.patch
semaphore-give-an-unlikely-for-downs-timeout.patch
semaphore-boolize-semaphore_waiters-up.patch


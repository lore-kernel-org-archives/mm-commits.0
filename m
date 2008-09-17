From: akpm@linux-foundation.org
Subject: + tags-skip-in-filenames.patch added to -mm tree
Date: Wed, 17 Sep 2008 14:20:33 -0700
Message-ID: <200809172120.m8HLKYkm030989@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40442 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752830AbYIQVVK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Sep 2008 17:21:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, sam@ravnborg.org


The patch titled
     tags: skip ./ in filenames
has been added to the -mm tree.  Its filename is
     tags-skip-in-filenames.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tags: skip ./ in filenames
From: Alexey Dobriyan <adobriyan@gmail.com>

This drives size of tags file from 68.9 MB down to 67.7 MB.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Makefile~tags-skip-in-filenames Makefile
--- a/Makefile~tags-skip-in-filenames
+++ a/Makefile
@@ -1451,7 +1451,7 @@ define find-sources
 	       -name $1 -print; \
 	  find $(__srctree) $(RCS_FIND_IGNORE) \
 	       \( -name include -o -name arch -o -name '.tmp_*' \) -prune -o \
-	       -name $1 -print; \
+	       -name $1 -print | sed -e 's#^./##'; \
 	  )
 endef
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-more-debugging-for-already-registered-case.patch
linux-next.patch
itimers-fix-itimer-many-thread-hang.patch
itimers-fix-itimer-many-thread-hang-checkpatch-fixes.patch
tags-skip-in-filenames.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
ext4-fix-11321-create-proc-ext4-stats-et-al-more-carefully.patch
cpuset-use-seq_cpumask-seq_nodemask.patch
compat_binfmt_elf-definition-tweak.patch
proc-move-sysrq-trigger-out-of-fs-proc.patch
proc-fix-return-value-of-proc_reg_open-in-too-late-case.patch
proc-proc_sys_root-tweak.patch
proc-remove-dummy-vmcore_open.patch
proc-remove-unused-get_dma_list.patch
sysctl-simplify-strategy.patch
fs-kconfig-move-ext2-ext3-ext4-jbd-jbd2-out.patch
fs-kconfig-move-cifs-out.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch


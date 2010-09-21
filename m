From: akpm@linux-foundation.org
Subject: + default-config_core_dump_default_elf_headers=y.patch added to -mm tree
Date: Tue, 21 Sep 2010 12:48:06 -0700
Message-ID: <201009211948.o8LJm6QY030597@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754484Ab0IUTss (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Sep 2010 15:48:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com


The patch titled
     coredump: default CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
has been added to the -mm tree.  Its filename is
     default-config_core_dump_default_elf_headers=y.patch

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
Subject: coredump: default CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
From: Roland McGrath <roland@redhat.com>

The userland ELF tools have been coping with partial-segments core files
for a few years now.  Multiple distro builds are now setting this option. 
It behooves everyone who ever deals with core files to have more info
dumped in there, especially as more and more people's compilers are
producing build IDs.  Make it the default.

Anyone using older tools confused by these core files can configure this
option off, or just change /proc/PID/coredump_filter after boot.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig.binfmt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/Kconfig.binfmt~default-config_core_dump_default_elf_headers=y fs/Kconfig.binfmt
--- a/fs/Kconfig.binfmt~default-config_core_dump_default_elf_headers=y
+++ a/fs/Kconfig.binfmt
@@ -42,7 +42,7 @@ config BINFMT_ELF_FDPIC
 
 config CORE_DUMP_DEFAULT_ELF_HEADERS
 	bool "Write ELF core dumps with partial segments"
-	default n
+	default y
 	depends on BINFMT_ELF && ELF_CORE
 	help
 	  ELF core dump files describe each memory mapping of the crashed
@@ -60,7 +60,7 @@ config CORE_DUMP_DEFAULT_ELF_HEADERS
 	  inherited.  See Documentation/filesystems/proc.txt for details.
 
 	  This config option changes the default setting of coredump_filter
-	  seen at boot time.  If unsure, say N.
+	  seen at boot time.  If unsure, say Y.
 
 config BINFMT_FLAT
 	bool "Kernel support for flat binaries"
_

Patches currently in -mm which might be from roland@redhat.com are

core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2.patch
default-config_core_dump_default_elf_headers=y.patch
exit-add-lock-context-annotation-on-find_new_reaper.patch
fs-execc-provide-the-correct-process-pid-to-the-pipe-helper.patch


From: akpm@linux-foundation.org
Subject: + kbuild-rebuild-fix-for-makefilemodbuiltin.patch added to -mm tree
Date: Fri, 04 Sep 2009 16:19:11 -0700
Message-ID: <200909042319.n84NJBCH026654@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934443AbZIDXTa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2009 19:19:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JBeulich@novell.com, mmarek@suse.cz, sam@ravnborg.org


The patch titled
     kbuild: rebuild fix for Makefile.modbuiltin
has been added to the -mm tree.  Its filename is
     kbuild-rebuild-fix-for-makefilemodbuiltin.patch

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
Subject: kbuild: rebuild fix for Makefile.modbuiltin
From: Jan Beulich <JBeulich@novell.com>

This patch addresses an issue with rebuilds failing to re-generate
modules.builtin files after altering config options.

Signed-off-by: Jan Beulich <JBeulich@novell.com>
Signed-off-by: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.modbuiltin |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN scripts/Makefile.modbuiltin~kbuild-rebuild-fix-for-makefilemodbuiltin scripts/Makefile.modbuiltin
--- a/scripts/Makefile.modbuiltin~kbuild-rebuild-fix-for-makefilemodbuiltin
+++ a/scripts/Makefile.modbuiltin
@@ -31,9 +31,13 @@ modbuiltin-cmds =						\
 	for m in $(modbuiltin-mods); do echo kernel/$$m; done;	\
 	cat /dev/null $(modbuiltin-subdirs);
 
-$(modbuiltin-target): $(subdir-ym)
+$(modbuiltin-target): $(subdir-ym) FORCE
 	$(Q)($(modbuiltin-cmds)) > $@
 
+PHONY += FORCE
+
+FORCE:
+
 # Descending
 # ---------------------------------------------------------------------------
 
_

Patches currently in -mm which might be from JBeulich@novell.com are

linux-next.patch
kbuild-generate-modulesbuiltin.patch
kbuild-rebuild-fix-for-makefilemodbuiltin.patch
memory-hotplug-fix-updating-of-num_physpages-for-hot-plugged-memory.patch
mm-replace-various-uses-of-num_physpages-by-totalram_pages.patch
mm-dont-use-alloc_bootmem_low-where-not-strictly-needed.patch
mm-also-use-alloc_large_system_hash-for-the-pid-hash-table.patch
build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it.patch


From: akpm@linux-foundation.org
Subject: [merged] kbuild-rebuild-fix-for-makefilemodbuiltin.patch removed from -mm tree
Date: Tue, 08 Dec 2009 13:05:26 -0800
Message-ID: <200912082105.nB8L5QTa009203@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966123AbZLHVGA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2009 16:06:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: JBeulich@novell.com, anibal@debian.org, mmarek@suse.cz, rostedt@goodmis.org, rusty@rustcorp.com.au, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     kbuild: rebuild fix for Makefile.modbuiltin
has been removed from the -mm tree.  Its filename was
     kbuild-rebuild-fix-for-makefilemodbuiltin.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
mm-vmallocc-dont-use-vmalloc_end.patch
fix-section-mismatch-in-early-ehci-dbgp.patch
vmalloc-adjust-gfp-mask-passed-on-nested-vmalloc-invocation.patch
mm-bootmemc-properly-__init-annotate-helper-functions.patch
dma-mapping-fix-off-by-one-error-in-dma_capable.patch


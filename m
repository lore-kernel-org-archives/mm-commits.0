From: akpm@linux-foundation.org
Subject: [merged] kbuild-make-fix-if_changed-when-command-contains-backslashes.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:11:59 -0700
Message-ID: <20121005201159.C79E71E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:53975 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757251Ab2JEUMB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:12:01 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so235722ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:12:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: s.hauer@pengutronix.de, bernhard@bwalle.de, jlu@pengutronix.de, mmarek@suse.cz, sam@ravnborg.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kbuild: make: fix if_changed when command contains backslashes
has been removed from the -mm tree.  Its filename was
     kbuild-make-fix-if_changed-when-command-contains-backslashes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sascha Hauer <s.hauer@pengutronix.de>
Subject: kbuild: make: fix if_changed when command contains backslashes

The call if_changed mechanism does not work when the command contains
backslashes.  This basically is an issue with lzo and bzip2 compressed
kernels.  The compressed binaries do not contain the uncompressed image
size, so these use size_append to append the size.  This results in
backslashes in the executed command.  With this if_changed always detects
a change in the command and rebuilds the compressed image even if nothing
has changed.

Fix this by escaping backslashes in make-cmd

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Jan Luebbe <jlu@pengutronix.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Bernhard Walle <bernhard@bwalle.de>
Cc: Michal Marek <mmarek@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Kbuild.include |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/Kbuild.include~kbuild-make-fix-if_changed-when-command-contains-backslashes scripts/Kbuild.include
--- a/scripts/Kbuild.include~kbuild-make-fix-if_changed-when-command-contains-backslashes
+++ a/scripts/Kbuild.include
@@ -209,7 +209,7 @@ endif
 # >$< substitution to preserve $ when reloading .cmd file
 # note: when using inline perl scripts [perl -e '...$$t=1;...']
 # in $(cmd_xxx) double $$ your perl vars
-make-cmd = $(subst \#,\\\#,$(subst $$,$$$$,$(call escsq,$(cmd_$(1)))))
+make-cmd = $(subst \\,\\\\,$(subst \#,\\\#,$(subst $$,$$$$,$(call escsq,$(cmd_$(1))))))
 
 # Find any prerequisites that is newer than target or that does not exist.
 # PHONY targets skipped in both cases.
_

Patches currently in -mm which might be from s.hauer@pengutronix.de are

origin.patch
linux-next.patch


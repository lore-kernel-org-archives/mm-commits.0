From: akpm@linux-foundation.org
Subject: + kbuild-make-fix-if_changed-when-command-contains-backslashes.patch added to -mm tree
Date: Tue, 11 Sep 2012 14:52:10 -0700
Message-ID: <20120911215211.25437200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:46372 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278Ab2IKVwO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Sep 2012 17:52:14 -0400
Received: by wgbdt11 with SMTP id dt11so70976wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Sep 2012 14:52:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: s.hauer@pengutronix.de, bernhard@bwalle.de, jlu@pengutronix.de, mmarek@suse.cz, sam@ravnborg.org


The patch titled
     Subject: kbuild: make: fix if_changed when command contains backslashes
has been added to the -mm tree.  Its filename is
     kbuild-make-fix-if_changed-when-command-contains-backslashes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sascha Hauer <s.hauer@pengutronix.de>
Subject: kbuild: make: fix if_changed when command contains backslashes

The call if_changed mechanism does not work when the command
contains backslashes. This basically is an issue with lzo
and bzip2 compressed kernels. The compressed binaries do not
contain the uncompressed image size, so these use size_append
to append the size. This results in backslashes in the executed
command. With this if_changed always detects a change in the
command and rebuilds the compressed image even if nothing
has changed.

Fix this by escaping backslashes in make-cmd

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Jan Luebbe <jlu@pengutronix.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Bernhard Walle <bernhard@bwalle.de>
Cc: Michal Marek <mmarek@suse.cz>
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

linux-next.patch
kbuild-make-fix-if_changed-when-command-contains-backslashes.patch
rtc-snvs-add-freescale-rtc-snvs-driver.patch
rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch
rtc-rtc-mxc-adapt-to-the-new-imx-clock-framework.patch
rtc-rtc-mxc-convert-to-module_platform_driver.patch


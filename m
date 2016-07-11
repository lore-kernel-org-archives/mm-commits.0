From: akpm@linux-foundation.org
Subject: + scripts-gdb-silence-nothing-to-do-message.patch added to -mm
 tree
Date: Mon, 11 Jul 2016 12:51:45 -0700
Message-ID: <5783f8d1.SA2Ka+C9Vlhemx09%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41313 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbcGKTvv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jul 2016 15:51:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kieran@ksquared.org.uk, jan.kiszka@siemens.comkieran@ksquared.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: silence 'nothing to do' message
has been added to the -mm tree.  Its filename is
     scripts-gdb-silence-nothing-to-do-message.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-silence-nothing-to-do-message.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-silence-nothing-to-do-message.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kieran Bingham <kieran@ksquared.org.uk>
Subject: scripts/gdb: silence 'nothing to do' message

The constants.py generation, involves a rule to link into the main
makefile.  This rule has no command and generates a spurious warning
message in the build logs when CONFIG_SCRIPTS_GDB is enabled.

Fix simply by giving a no-op action

Link: http://lkml.kernel.org/r/1467127337-11135-2-git-send-email-kieran@bingham.xyz
Signed-off-by: Kieran Bingham <kieran@bingham.xyz>
Reported-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/Makefile |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/gdb/linux/Makefile~scripts-gdb-silence-nothing-to-do-message scripts/gdb/linux/Makefile
--- a/scripts/gdb/linux/Makefile~scripts-gdb-silence-nothing-to-do-message
+++ a/scripts/gdb/linux/Makefile
@@ -17,5 +17,6 @@ $(obj)/constants.py: $(SRCTREE)/$(obj)/c
 	$(call if_changed,gen_constants_py)
 
 build_constants_py: $(obj)/constants.py
+	@:
 
 clean-files := *.pyc *.pyo $(if $(KBUILD_SRC),*.py) $(obj)/constants.py
_

Patches currently in -mm which might be from kieran@ksquared.org.uk are

scripts-gdb-silence-nothing-to-do-message.patch
scripts-gdb-rebuild-constantspy-on-dependancy-change.patch
revert-scripts-gdb-add-a-radix-tree-parser.patch
revert-scripts-gdb-add-documentation-example-for-radix-tree.patch


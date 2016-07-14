From: akpm@linux-foundation.org
Subject: [patch 03/20] scripts/gdb: silence 'nothing to do' message
Date: Thu, 14 Jul 2016 12:06:55 -0700
Message-ID: <5787e2cf.pFZK37oyQSzv8NnE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40936 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbcGNTG4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jul 2016 15:06:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kieran@ksquared.org.uk, jan.kiszka@siemens.comkieran@ksquared.org.uk

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

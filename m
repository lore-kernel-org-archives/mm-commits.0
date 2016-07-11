From: akpm@linux-foundation.org
Subject: +
 scripts-gdb-perform-path-expansion-to-lx-symbols-arguments.patch added to
 -mm tree
Date: Mon, 11 Jul 2016 12:51:51 -0700
Message-ID: <5783f8d7.NTC3P3Q5sXA94avx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41328 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbcGKTvw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jul 2016 15:51:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n.borisov.lkml@gmail.com, jan.kiszka@siemens.com, kieran@ksquared.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: Perform path expansion to lx-symbol's arguments
has been added to the -mm tree.  Its filename is
     scripts-gdb-perform-path-expansion-to-lx-symbols-arguments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-perform-path-expansion-to-lx-symbols-arguments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-perform-path-expansion-to-lx-symbols-arguments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: scripts/gdb: Perform path expansion to lx-symbol's arguments

Python doesn't do automatic expansion of paths.  In case one passes path
of the from ~/foo/bar the gdb scripts won't automatically expand that and
as a result the symbols files won't be loaded.  Fix this by explicitly
expanding all paths which begin with "~"

Link: http://lkml.kernel.org/r/1467127337-11135-5-git-send-email-kieran@bingham.xyz
Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
Signed-off-by: Kieran Bingham <kieran@bingham.xyz>
Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/symbols.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/gdb/linux/symbols.py~scripts-gdb-perform-path-expansion-to-lx-symbols-arguments scripts/gdb/linux/symbols.py
--- a/scripts/gdb/linux/symbols.py~scripts-gdb-perform-path-expansion-to-lx-symbols-arguments
+++ a/scripts/gdb/linux/symbols.py
@@ -153,7 +153,7 @@ lx-symbols command."""
             saved_state['breakpoint'].enabled = saved_state['enabled']
 
     def invoke(self, arg, from_tty):
-        self.module_paths = arg.split()
+        self.module_paths = [os.path.expanduser(p) for p in arg.split()]
         self.module_paths.append(os.getcwd())
 
         # enforce update
_

Patches currently in -mm which might be from n.borisov.lkml@gmail.com are

scripts-gdb-perform-path-expansion-to-lx-symbols-arguments.patch


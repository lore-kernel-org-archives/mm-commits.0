From: akpm@linux-foundation.org
Subject: [patch 06/20] scripts/gdb: Perform path expansion to lx-symbol's
 arguments
Date: Thu, 14 Jul 2016 12:07:04 -0700
Message-ID: <5787e2d8.2wuvJzBP7zKQPfMC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40968 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbcGNTHF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jul 2016 15:07:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, n.borisov.lkml@gmail.com, jan.kiszka@siemens.com, kieran@ksquared.org.uk

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

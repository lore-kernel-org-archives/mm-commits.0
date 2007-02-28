From: akpm@linux-foundation.org
Subject: + parisc-unbreak-setupc-re-command_line.patch added to -mm tree
Date: Wed, 28 Feb 2007 15:38:21 -0800
Message-ID: <200702282338.l1SNcLh3030593@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47780 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283AbXB1Xi1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:38:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, kyle@mcmartin.ca


The patch titled
     parisc: make command_line[] static
has been added to the -mm tree.  Its filename is
     parisc-unbreak-setupc-re-command_line.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: parisc: make command_line[] static
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/parisc/kernel/setup.c~parisc-unbreak-setupc-re-command_line arch/parisc/kernel/setup.c
--- a/arch/parisc/kernel/setup.c~parisc-unbreak-setupc-re-command_line
+++ a/arch/parisc/kernel/setup.c
@@ -45,7 +45,7 @@
 #include <asm/io.h>
 #include <asm/setup.h>
 
-char	__initdata command_line[COMMAND_LINE_SIZE];
+static char __initdata command_line[COMMAND_LINE_SIZE];
 
 /* Intended for ccio/sba/cpu statistics under /proc/bus/{runway|gsc} */
 struct proc_dir_entry * proc_runway_root __read_mostly = NULL;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

parisc-unbreak-setupc-re-command_line.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
reiserfs-shrink-superblock-if-no-xattrs.patch

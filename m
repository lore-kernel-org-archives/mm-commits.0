From: akpm@linux-foundation.org
Subject: + hwpoison-fix-proc-meminfo-alignment.patch added to -mm tree
Date: Tue, 13 Oct 2009 09:44:07 -0700
Message-ID: <200910131644.n9DGi8CJ005952@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752748AbZJMQsQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 12:48:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, andi@firstfloor.org


The patch titled
     hwpoison: fix/proc/meminfo alignment
has been added to the -mm tree.  Its filename is
     hwpoison-fix-proc-meminfo-alignment.patch

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
Subject: hwpoison: fix/proc/meminfo alignment
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Given such a long name, the kB count in /proc/meminfo's HardwareCorrupted
line is being shown too far right (it does align with x86_64's VmallocChunk
above, but I hope nobody will ever have that much corrupted!).  Align it.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/proc/meminfo.c~hwpoison-fix-proc-meminfo-alignment fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~hwpoison-fix-proc-meminfo-alignment
+++ a/fs/proc/meminfo.c
@@ -99,7 +99,7 @@ static int meminfo_proc_show(struct seq_
 		"VmallocUsed:    %8lu kB\n"
 		"VmallocChunk:   %8lu kB\n"
 #ifdef CONFIG_MEMORY_FAILURE
-		"HardwareCorrupted: %8lu kB\n"
+		"HardwareCorrupted: %5lu kB\n"
 #endif
 		,
 		K(i.totalram),
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

hwpoison-fix-oops-on-ksm-pages.patch
hwpoison-fix-proc-meminfo-alignment.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
elf-kill-use_elf_core_dump.patch
prio_tree-debugging-patch.patch


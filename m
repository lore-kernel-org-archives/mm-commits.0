From: akpm@linux-foundation.org
Subject: [merged] binfmt_elf-uninitialized-variable.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:16:24 -0700
Message-ID: <20121005201625.13E6F20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:34336 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757272Ab2JEUQ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:16:27 -0400
Received: by mail-fa0-f74.google.com with SMTP id t1so138409fae.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:16:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: binfmt_elf: Uninitialized variable
has been removed from the -mm tree.  Its filename was
     binfmt_elf-uninitialized-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alan Cox <alan@linux.intel.com>
Subject: binfmt_elf: Uninitialized variable

load_elf_interp() has interp_map_addr carefully described as
"uninitialized_var" and marked so as to avoid a warning.  However if you
trace the code it is passed into load_elf_interp and then this value is
checked against NULL.

As this return value isn't used this is actually safe but it freaks
various analysis tools that see un-initialized memory addresses being read
before their value is ever defined.

Set it to NULL as a matter of programming good taste if nothing else

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/binfmt_elf.c~binfmt_elf-uninitialized-variable fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~binfmt_elf-uninitialized-variable
+++ a/fs/binfmt_elf.c
@@ -881,7 +881,7 @@ static int load_elf_binary(struct linux_
 	}
 
 	if (elf_interpreter) {
-		unsigned long uninitialized_var(interp_map_addr);
+		unsigned long interp_map_addr = 0;
 
 		elf_entry = load_elf_interp(&loc->interp_elf_ex,
 					    interpreter,
_

Patches currently in -mm which might be from alan@linux.intel.com are

origin.patch
linux-next.patch


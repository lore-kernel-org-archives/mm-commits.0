From: akpm@linux-foundation.org
Subject: + binfmt_elf-uninitialized-variable.patch added to -mm tree
Date: Wed, 26 Sep 2012 16:24:16 -0700
Message-ID: <20120926232416.9AEDD100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:37736 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab2IZXYR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Sep 2012 19:24:17 -0400
Received: by qaea16 with SMTP id a16so245647qae.1
        for <mm-commits@vger.kernel.org>; Wed, 26 Sep 2012 16:24:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@linux.intel.com


The patch titled
     Subject: binfmt_elf: Uninitialized variable
has been added to the -mm tree.  Its filename is
     binfmt_elf-uninitialized-variable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -880,7 +880,7 @@ static int load_elf_binary(struct linux_
 	}
 
 	if (elf_interpreter) {
-		unsigned long uninitialized_var(interp_map_addr);
+		unsigned long interp_map_addr = 0;
 
 		elf_entry = load_elf_interp(&loc->interp_elf_ex,
 					    interpreter,
_

Patches currently in -mm which might be from alan@linux.intel.com are

linux-next.patch
binfmt_elf-uninitialized-variable.patch


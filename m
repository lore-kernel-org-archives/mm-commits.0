From: akpm@linux-foundation.org
Subject: + kernel-kallsymsc-fix-double-return.patch added to -mm tree
Date: Fri, 10 Oct 2008 12:38:18 -0700
Message-ID: <200810101938.m9AJcIDX026901@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35317 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760716AbYJJTi4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Oct 2008 15:38:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wangcong@zeuux.org, rusty@rustcorp.com.au


The patch titled
     kernel/kallsyms.c: fix double return
has been added to the -mm tree.  Its filename is
     kernel-kallsymsc-fix-double-return.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/kallsyms.c: fix double return
From: WANG Cong <wangcong@zeuux.org>

Commit 6dd06c9fbe025f542bce4cdb91790c0f91962722 introduced double returns
in the function kallsyms_lookup(), it's weird.  The second one should be
removed.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kallsyms.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/kallsyms.c~kernel-kallsymsc-fix-double-return kernel/kallsyms.c
--- a/kernel/kallsyms.c~kernel-kallsymsc-fix-double-return
+++ a/kernel/kallsyms.c
@@ -260,7 +260,6 @@ const char *kallsyms_lookup(unsigned lon
 	/* see if it's in a module */
 	return module_address_lookup(addr, symbolsize, offset, modname,
 				     namebuf);
-	return NULL;
 }
 
 int lookup_symbol_name(unsigned long addr, char *symname)
_

Patches currently in -mm which might be from wangcong@zeuux.org are

kernel-kallsymsc-fix-double-return.patch


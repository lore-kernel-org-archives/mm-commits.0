From: akpm@linux-foundation.org
Subject: - kernel-kallsymsc-fix-double-return.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:12:17 -0700
Message-ID: <200810182312.m9INCHGH027966@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46709 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751255AbYJRXMX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:12:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangcong@zeuux.org, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     kernel/kallsyms.c: fix double return
has been removed from the -mm tree.  Its filename was
     kernel-kallsymsc-fix-double-return.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
uml-fix-a-compile-error.patch
kernel-configsc-remove-useless-comments.patch


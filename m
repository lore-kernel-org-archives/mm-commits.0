From: akpm@linux-foundation.org
Subject: + sprint_symbol-use-less-stack.patch added to -mm tree
Date: Fri, 14 Nov 2008 16:41:24 -0800
Message-ID: <200811150041.mAF0fO2m026546@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751215AbYKOAlb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Nov 2008 19:41:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com


The patch titled
     sprint_symbol(): use less stack
has been added to the -mm tree.  Its filename is
     sprint_symbol-use-less-stack.patch

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
Subject: sprint_symbol(): use less stack
From: Hugh Dickins <hugh@veritas.com>

sprint_symbol(), itself used when dumping stacks, has been wasting 128
bytes of stack: lookup the symbol directly into the buffer supplied by the
caller, instead of using a locally declared namebuf.

I believe the name != buffer strcpy() is obsolete: the design here dates
from when module symbol lookup pointed into a supposedly const but sadly
volatile table; nowadays it copies, but an uncalled strcpy() looks better
here than the risk of a recursive BUG_ON().

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kallsyms.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff -puN kernel/kallsyms.c~sprint_symbol-use-less-stack kernel/kallsyms.c
--- a/kernel/kallsyms.c~sprint_symbol-use-less-stack
+++ a/kernel/kallsyms.c
@@ -304,17 +304,24 @@ int sprint_symbol(char *buffer, unsigned
 	char *modname;
 	const char *name;
 	unsigned long offset, size;
-	char namebuf[KSYM_NAME_LEN];
+	int len;
 
-	name = kallsyms_lookup(address, &size, &offset, &modname, namebuf);
+	name = kallsyms_lookup(address, &size, &offset, &modname, buffer);
 	if (!name)
 		return sprintf(buffer, "0x%lx", address);
 
+	if (name != buffer)
+		strcpy(buffer, name);
+	len = strlen(buffer);
+	buffer += len;
+
 	if (modname)
-		return sprintf(buffer, "%s+%#lx/%#lx [%s]", name, offset,
-				size, modname);
+		len += sprintf(buffer, "+%#lx/%#lx [%s]",
+						offset, size, modname);
 	else
-		return sprintf(buffer, "%s+%#lx/%#lx", name, offset, size);
+		len += sprintf(buffer, "+%#lx/%#lx", offset, size);
+
+	return len;
 }
 
 /* Look up a kernel symbol and print it to the kernel messages. */
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
linux-next.patch
sprint_symbol-use-less-stack.patch
migration-fix-writepage-error.patch
vmscan-let-gfp_nofs-go-to-swap-again.patch
dont-unlink-an-active-swapfile.patch
mm-implement-remap_pfn_range-with-apply_to_page_range.patch
mm-apply_to_range-call-pte-function-with-lazy-updates.patch
mm-remap_pfn_range-restore-missing-flush.patch
prio_tree-debugging-patch.patch


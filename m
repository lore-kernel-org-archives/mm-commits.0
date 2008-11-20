From: akpm@linux-foundation.org
Subject: - sprint_symbol-use-less-stack.patch removed from -mm tree
Date: Thu, 20 Nov 2008 12:43:03 -0800
Message-ID: <200811202043.mAKKh39q007284@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755413AbYKTUrP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Nov 2008 15:47:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     sprint_symbol(): use less stack
has been removed from the -mm tree.  Its filename was
     sprint_symbol-use-less-stack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
mm-dont-mark_page_accessed-in-shmem_fault.patch
mm-apply_to_range-call-pte-function-with-lazy-updates.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-swap-cgroup-for-remembering-usage-fix-2.patch
memcg-swap-cgroup-for-remembering-usage-fix-3.patch
memcg-swap-cgroup-for-remembering-usage-fix-4.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
prio_tree-debugging-patch.patch


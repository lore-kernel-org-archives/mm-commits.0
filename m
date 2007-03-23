From: akpm@linux-foundation.org
Subject: + extend-print_symbol-capability-fix.patch added to -mm tree
Date: Thu, 22 Mar 2007 23:57:14 -0800
Message-ID: <200703230757.l2N7vEgs009526@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41482 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422656AbXCWH5s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 Mar 2007 03:57:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, pmarques@grupopie.com, rdunlap@xenotime.net, rpeterso@redhat.com, rusty@rustcorp.com.au, sam@ravnborg.org, zippel@linux-m68k.org


The patch titled
     sprint_symbol should return length of string like sprintf
has been added to the -mm tree.  Its filename is
     extend-print_symbol-capability-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sprint_symbol should return length of string like sprintf
From: Christoph Lameter <clameter@sgi.com>

Make sprint_symbol return the length of the symbol

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Robert Peterson <rpeterso@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Paulo Marques <pmarques@grupopie.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kallsyms.h |    2 +-
 kernel/kallsyms.c        |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/kallsyms.h~extend-print_symbol-capability-fix include/linux/kallsyms.h
--- a/include/linux/kallsyms.h~extend-print_symbol-capability-fix
+++ a/include/linux/kallsyms.h
@@ -25,7 +25,7 @@ const char *kallsyms_lookup(unsigned lon
 			    char **modname, char *namebuf);
 
 /* Look up a kernel symbol and return it in a text buffer. */
-extern void sprint_symbol(char *buffer, unsigned long address);
+extern int sprint_symbol(char *buffer, unsigned long address);
 
 /* Look up a kernel symbol and print it to the kernel messages. */
 extern void __print_symbol(const char *fmt, unsigned long address);
diff -puN kernel/kallsyms.c~extend-print_symbol-capability-fix kernel/kallsyms.c
--- a/kernel/kallsyms.c~extend-print_symbol-capability-fix
+++ a/kernel/kallsyms.c
@@ -268,7 +268,7 @@ const char *kallsyms_lookup(unsigned lon
 }
 
 /* Look up a kernel symbol and return it in a text buffer. */
-void sprint_symbol(char *buffer, unsigned long address)
+int sprint_symbol(char *buffer, unsigned long address)
 {
 	char *modname;
 	const char *name;
@@ -277,13 +277,13 @@ void sprint_symbol(char *buffer, unsigne
 
 	name = kallsyms_lookup(address, &size, &offset, &modname, namebuf);
 	if (!name)
-		sprintf(buffer, "0x%lx", address);
+		return sprintf(buffer, "0x%lx", address);
 	else {
 		if (modname)
-			sprintf(buffer, "%s+%#lx/%#lx [%s]", name, offset,
+			return sprintf(buffer, "%s+%#lx/%#lx [%s]", name, offset,
 				size, modname);
 		else
-			sprintf(buffer, "%s+%#lx/%#lx", name, offset, size);
+			return sprintf(buffer, "%s+%#lx/%#lx", name, offset, size);
 	}
 }
 
_

Patches currently in -mm which might be from clameter@sgi.com are

slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
slab-ensure-cache_alloc_refill-terminates.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
extend-print_symbol-capability-fix.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
readahead-state-based-method-aging-accounting.patch

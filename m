From: akpm@linux-foundation.org
Subject: + frv-work-around-a-possible-compiler-bug.patch added to -mm tree
Date: Wed, 18 Jul 2007 13:10:13 -0700
Message-ID: <200707182010.l6IKADkW026647@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40899 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760678AbXGRUK3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 16:10:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     FRV: work around a possible compiler bug
has been added to the -mm tree.  Its filename is
     frv-work-around-a-possible-compiler-bug.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: FRV: work around a possible compiler bug
From: David Howells <dhowells@redhat.com>

Work around a possible bug in the FRV compiler.

What appears to be happening is that gcc resolves the
__builtin_constant_p() in kmalloc() to true, but then fails to reduce the
therefore constant conditions in the if-statements it guards to constant
results.

When compiling with -O2 or -Os, one single spurious error crops up in
cpuup_callback() in mm/slab.c.  This can be avoided by making the memsize
variable const.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/Makefile |    2 +-
 mm/slab.c         |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/frv/Makefile~frv-work-around-a-possible-compiler-bug arch/frv/Makefile
--- a/arch/frv/Makefile~frv-work-around-a-possible-compiler-bug
+++ a/arch/frv/Makefile
@@ -88,7 +88,7 @@ ASFLAGS		+= -mno-fdpic
 # make sure the .S files get compiled with debug info
 # and disable optimisations that are unhelpful whilst debugging
 ifdef CONFIG_DEBUG_INFO
-CFLAGS		+= -O1
+#CFLAGS		+= -O1
 AFLAGS		+= -Wa,--gdwarf2
 ASFLAGS		+= -Wa,--gdwarf2
 endif
diff -puN mm/slab.c~frv-work-around-a-possible-compiler-bug mm/slab.c
--- a/mm/slab.c~frv-work-around-a-possible-compiler-bug
+++ a/mm/slab.c
@@ -1163,7 +1163,7 @@ static int __cpuinit cpuup_callback(stru
 	struct kmem_cache *cachep;
 	struct kmem_list3 *l3 = NULL;
 	int node = cpu_to_node(cpu);
-	int memsize = sizeof(struct kmem_list3);
+	const int memsize = sizeof(struct kmem_list3);
 
 	switch (action) {
 	case CPU_LOCK_ACQUIRE:
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
document-page_mkwrite-locking.patch
coredump-masking-bound-suid_dumpable-sysctl.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
coredump-masking-add-an-interface-for-core-dump-filter.patch
coredump-masking-elf-enable-core-dump-filtering.patch
coredump-masking-elf-fdpic-remove-an-unused-argument.patch
coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
frv-work-around-a-possible-compiler-bug.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
afs-fix-file-locking.patch
mutex-subsystem-synchro-test-module.patch

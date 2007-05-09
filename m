From: akpm@linux-foundation.org
Subject: - i386-voyager-use-__maybe_unused.patch removed from -mm tree
Date: Wed, 09 May 2007 14:54:36 -0700
Message-ID: <200705092154.l49Lsa60003178@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39189 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754401AbXEIVzB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:55:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     i386: voyager: use __maybe_unused
has been removed from the -mm tree.  Its filename was
     i386-voyager-use-__maybe_unused.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: voyager: use __maybe_unused
From: David Rientjes <rientjes@google.com>

Replace automatic variable instances of __attribute__((unused)) with
__maybe_unused in mca_nmi_hook().

Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/mach-voyager/voyager_basic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/i386/mach-voyager/voyager_basic.c~i386-voyager-use-__maybe_unused arch/i386/mach-voyager/voyager_basic.c
--- a/arch/i386/mach-voyager/voyager_basic.c~i386-voyager-use-__maybe_unused
+++ a/arch/i386/mach-voyager/voyager_basic.c
@@ -292,8 +292,8 @@ machine_emergency_restart(void)
 void
 mca_nmi_hook(void)
 {
-	__u8 dumpval __attribute__((unused)) = inb(0xf823);
-	__u8 swnmi __attribute__((unused)) = inb(0xf813);
+	__u8 dumpval __maybe_unused = inb(0xf823);
+	__u8 swnmi __maybe_unused = inb(0xf813);
 
 	/* FIXME: assume dump switch pressed */
 	/* check to see if the dump switch was pressed */
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
git-alsa.patch
powerpc-ps3-use-__maybe_unused.patch
mips-excite-use-__maybe_unused.patch
mips-tlbex-use-__maybe_unused.patch
scsi-fix-ambiguous-gdthtable-definition.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
frv-gdb-use-__maybe_unused.patch

From: akpm@linux-foundation.org
Subject: - docbooks-fix-fatal-errors-header-files-moved.patch removed from -mm tree
Date: Mon, 27 Oct 2008 17:11:14 -0700
Message-ID: <200810280011.m9S0BEWT026995@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751303AbYJ1AL0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 20:11:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     docbooks: fix fatal errors: header files moved
has been removed from the -mm tree.  Its filename was
     docbooks-fix-fatal-errors-header-files-moved.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: docbooks: fix fatal errors: header files moved
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix docbook fatal errors (file location changed):

docproc: lin2628-rc1/include/asm-x86/io_32.h: No such file or directory
make[1]: *** [Documentation/DocBook/deviceiobook.xml] Error 1

docproc: lin2628-rc1/include/asm-x86/atomic_32.h: No such file or directory
make[1]: *** [Documentation/DocBook/kernel-api.xml] Error 1

docproc: lin2628-rc1/include/asm-x86/mca_dma.h: No such file or directory
make[1]: *** [Documentation/DocBook/mcabook.xml] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/deviceiobook.tmpl   |    2 +-
 Documentation/DocBook/kernel-api.tmpl     |   10 +++++-----
 Documentation/DocBook/kernel-hacking.tmpl |    4 ++--
 Documentation/DocBook/mcabook.tmpl        |    2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

diff -puN Documentation/DocBook/deviceiobook.tmpl~docbooks-fix-fatal-errors-header-files-moved Documentation/DocBook/deviceiobook.tmpl
--- a/Documentation/DocBook/deviceiobook.tmpl~docbooks-fix-fatal-errors-header-files-moved
+++ a/Documentation/DocBook/deviceiobook.tmpl
@@ -316,7 +316,7 @@ CPU B:  spin_unlock_irqrestore(&amp;dev_
 
   <chapter id="pubfunctions">
      <title>Public Functions Provided</title>
-!Iinclude/asm-x86/io_32.h
+!Iarch/x86/include/asm/io_32.h
 !Elib/iomap.c
   </chapter>
 
diff -puN Documentation/DocBook/kernel-api.tmpl~docbooks-fix-fatal-errors-header-files-moved Documentation/DocBook/kernel-api.tmpl
--- a/Documentation/DocBook/kernel-api.tmpl~docbooks-fix-fatal-errors-header-files-moved
+++ a/Documentation/DocBook/kernel-api.tmpl
@@ -45,8 +45,8 @@
      </sect1>
 
      <sect1><title>Atomic and pointer manipulation</title>
-!Iinclude/asm-x86/atomic_32.h
-!Iinclude/asm-x86/unaligned.h
+!Iarch/x86/include/asm/atomic_32.h
+!Iarch/x86/include/asm/unaligned.h
      </sect1>
 
      <sect1><title>Delaying, scheduling, and timer routines</title>
@@ -119,7 +119,7 @@ X!Ilib/string.c
 !Elib/string.c
      </sect1>
      <sect1><title>Bit Operations</title>
-!Iinclude/asm-x86/bitops.h
+!Iarch/x86/include/asm/bitops.h
      </sect1>
   </chapter>
 
@@ -155,7 +155,7 @@ X!Ilib/string.c
 !Emm/slab.c
      </sect1>
      <sect1><title>User Space Memory Access</title>
-!Iinclude/asm-x86/uaccess_32.h
+!Iarch/x86/include/asm/uaccess_32.h
 !Earch/x86/lib/usercopy_32.c
      </sect1>
      <sect1><title>More Memory Management Functions</title>
@@ -265,7 +265,7 @@ X!Earch/x86/kernel/mca_32.c
 -->
 	</sect2>
 	<sect2><title>MCA Bus DMA</title>
-!Iinclude/asm-x86/mca_dma.h
+!Iarch/x86/include/asm/mca_dma.h
 	</sect2>
      </sect1>
   </chapter>
diff -puN Documentation/DocBook/kernel-hacking.tmpl~docbooks-fix-fatal-errors-header-files-moved Documentation/DocBook/kernel-hacking.tmpl
--- a/Documentation/DocBook/kernel-hacking.tmpl~docbooks-fix-fatal-errors-header-files-moved
+++ a/Documentation/DocBook/kernel-hacking.tmpl
@@ -1239,7 +1239,7 @@ static struct block_device_operations op
   </para>
 
   <para>
-   <filename>include/asm-x86/delay_32.h:</filename>
+   <filename>arch/x86/include/asm/delay.h:</filename>
   </para>
   <programlisting>
 #define ndelay(n) (__builtin_constant_p(n) ? \
@@ -1265,7 +1265,7 @@ static struct block_device_operations op
 </programlisting>
 
   <para>
-   <filename>include/asm-x86/uaccess_32.h:</filename>
+   <filename>arch/x86/include/asm/uaccess_32.h:</filename>
   </para>
 
   <programlisting>
diff -puN Documentation/DocBook/mcabook.tmpl~docbooks-fix-fatal-errors-header-files-moved Documentation/DocBook/mcabook.tmpl
--- a/Documentation/DocBook/mcabook.tmpl~docbooks-fix-fatal-errors-header-files-moved
+++ a/Documentation/DocBook/mcabook.tmpl
@@ -101,7 +101,7 @@
 
   <chapter id="dmafunctions">
      <title>DMA Functions Provided</title>
-!Iinclude/asm-x86/mca_dma.h
+!Iarch/x86/include/asm/mca_dma.h
   </chapter>
 
 </book>
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
docbook-fix-command-spacing.patch
docs-fix-managementstyle-book-name.patch
i2o-fix-kernel-doc-warnings.patch
mm-fix-kernel-doc-function-notation.patch
fs-remove-excess-kernel-doc.patch
linux-next.patch
fujitsu-laptop-fix-section-mismatch-warning.patch
acpi-compal-laptop-use-rfkill-switch-subsystem-fix.patch
kgdb-fix-kernel-doc-error.patch
audit-remove-excess-kernel-doc.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
gdth-fix-section-mismatch-warnings.patch
esp-fix-section-mismatch-warning.patch
scsi-ioctl-fix-kernel-doc-warning.patch
block-remove-excess-kernel-doc.patch
fs-fix-inodec-kernel-doc-warnings.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
profile-likely-unlikely-macros.patch


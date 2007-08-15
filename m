From: akpm@linux-foundation.org
Subject: + m68k-dont-include-rodata-into-text-segment.patch added to -mm tree
Date: Wed, 15 Aug 2007 14:18:22 -0700
Message-ID: <200708152118.l7FLIMJc015481@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58603 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933362AbXHOVU4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 17:20:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zippel@linux-m68k.org, geert@linux-m68k.org


The patch titled
     m68k: Dont include RODATA into text segment
has been added to the -mm tree.  Its filename is
     m68k-dont-include-rodata-into-text-segment.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: m68k: Dont include RODATA into text segment
From: Roman Zippel <zippel@linux-m68k.org>

Don't include RODATA into text segment as it includes the kallsyms data and
can cause spurious link failures (layout differences can change the number of
symbols in kallsyms, i.e.  when a symbol is equal to _etext it's not
included).

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/kernel/vmlinux-std.lds |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/m68k/kernel/vmlinux-std.lds~m68k-dont-include-rodata-into-text-segment arch/m68k/kernel/vmlinux-std.lds
--- a/arch/m68k/kernel/vmlinux-std.lds~m68k-dont-include-rodata-into-text-segment
+++ a/arch/m68k/kernel/vmlinux-std.lds
@@ -19,6 +19,8 @@ SECTIONS
 	*(.gnu.warning)
 	} :text = 0x4e75
 
+  _etext = .;			/* End of text section */
+
   . = ALIGN(16);		/* Exception table */
   __start___ex_table = .;
   __ex_table : { *(__ex_table) }
@@ -26,8 +28,6 @@ SECTIONS
 
   RODATA
 
-  _etext = .;			/* End of text section */
-
   .data : {			/* Data */
 	DATA_DATA
 	CONSTRUCTORS
_

Patches currently in -mm which might be from zippel@linux-m68k.org are

m68k-remove-unnecessary-m68k_memoffset-export-and-init.patch
m68k-dont-include-rodata-into-text-segment.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
hfs-convert-to-new-aops.patch
hfsplus-convert-to-new-aops.patch
fs-affs-convert-to-new-aops.patch

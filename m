From: akpm@linux-foundation.org
Subject: + m68k-remove-unnecessary-m68k_memoffset-export-and-init.patch added to -mm tree
Date: Wed, 15 Aug 2007 14:18:11 -0700
Message-ID: <200708152118.l7FLIBS6015469@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58509 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761373AbXHOVSn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 17:18:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zippel@linux-m68k.org, geert@linux-m68k.org


The patch titled
     m68k: Remove unnecessary m68k_memoffset export and init
has been added to the -mm tree.  Its filename is
     m68k-remove-unnecessary-m68k_memoffset-export-and-init.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: m68k: Remove unnecessary m68k_memoffset export and init
From: Roman Zippel <zippel@linux-m68k.org>

Remove an unnecessary m68k_memoffset export and initialization

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/kernel/setup.c |    2 --
 1 files changed, 2 deletions(-)

diff -puN arch/m68k/kernel/setup.c~m68k-remove-unnecessary-m68k_memoffset-export-and-init arch/m68k/kernel/setup.c
--- a/arch/m68k/kernel/setup.c~m68k-remove-unnecessary-m68k_memoffset-export-and-init
+++ a/arch/m68k/kernel/setup.c
@@ -62,7 +62,6 @@ EXPORT_SYMBOL(m68k_num_memory);
 int m68k_realnum_memory;
 EXPORT_SYMBOL(m68k_realnum_memory);
 unsigned long m68k_memoffset;
-EXPORT_SYMBOL(m68k_memoffset);
 struct mem_info m68k_memory[NUM_MEMINFO];
 EXPORT_SYMBOL(m68k_memory);
 
@@ -200,7 +199,6 @@ static void __init m68k_parse_bootinfo(c
 		       (m68k_num_memory - 1));
 		m68k_num_memory = 1;
 	}
-	m68k_memoffset = m68k_memory[0].addr-PAGE_OFFSET;
 #endif
 }
 
_

Patches currently in -mm which might be from zippel@linux-m68k.org are

m68k-remove-unnecessary-m68k_memoffset-export-and-init.patch
m68k-dont-include-rodata-into-text-segment.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
hfs-convert-to-new-aops.patch
hfsplus-convert-to-new-aops.patch
fs-affs-convert-to-new-aops.patch

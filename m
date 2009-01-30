From: akpm@linux-foundation.org
Subject: + eeepc-should-depend-on-input.patch added to -mm tree
Date: Fri, 30 Jan 2009 12:21:49 -0800
Message-ID: <200901302021.n0UKLnOo013996@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754160AbZA3UWI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 15:22:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, lenb@kernel.org, mingo@elte.hu


The patch titled
     eeepc: should depend on INPUT
has been added to the -mm tree.  Its filename is
     eeepc-should-depend-on-input.patch

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
Subject: eeepc: should depend on INPUT
From: Alexey Dobriyan <adobriyan@gmail.com>

Otherwise with INPUT=m, EEEPC_LAPTOP=y one gets

drivers/built-in.o: In function `input_sync':
eeepc-laptop.c:(.text+0x18ce51): undefined reference to `input_event'
drivers/built-in.o: In function `input_report_key':
eeepc-laptop.c:(.text+0x18ce73): undefined reference to `input_event'
drivers/built-in.o: In function `eeepc_hotk_check':
eeepc-laptop.c:(.text+0x18d05f): undefined reference to `input_allocate_device'
eeepc-laptop.c:(.text+0x18d10f): undefined reference to `input_register_device'
eeepc-laptop.c:(.text+0x18d131): undefined reference to `input_free_device'
drivers/built-in.o: In function `eeepc_backlight_exit':
eeepc-laptop.c:(.text+0x18d546): undefined reference to `input_unregister_device'

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/platform/x86/Kconfig~eeepc-should-depend-on-input drivers/platform/x86/Kconfig
--- a/drivers/platform/x86/Kconfig~eeepc-should-depend-on-input
+++ a/drivers/platform/x86/Kconfig
@@ -314,6 +314,7 @@ config INTEL_MENLOW
 config EEEPC_LAPTOP
 	tristate "Eee PC Hotkey Driver (EXPERIMENTAL)"
 	depends on ACPI
+	depends on INPUT
 	depends on EXPERIMENTAL
 	select BACKLIGHT_CLASS_DEVICE
 	select HWMON
_

Patches currently in -mm which might be from adobriyan@gmail.com are

seq_file-move-traverse-so-it-can-be-used-from-seq_read.patch
seq_file-properly-cope-with-pread.patch
linux-next.patch
eeepc-should-depend-on-input.patch
sm501-fix-section-mismatches.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-export-statistics-for-softirq-to-proc-fix.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch


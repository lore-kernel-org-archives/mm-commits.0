From: akpm@linux-foundation.org
Subject: - fix-compilation-with-gcc-42.patch removed from -mm tree
Date: Mon, 13 Aug 2007 22:03:44 -0700
Message-ID: <200708140503.l7E53iJU032085@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48582 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752245AbXHNFLz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 01:11:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peterc@gelato.unsw.edu.au, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, lenb@kernel.org, prasanna@in.ibm.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     fix compilation with gcc 4.2
has been removed from the -mm tree.  Its filename was
     fix-compilation-with-gcc-42.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix compilation with gcc 4.2
From: Peter Chubb <peterc@gelato.unsw.edu.au>

gcc-4.2 is a lot more picky about its symbol handling.  EXPORT_SYMBOL no
longer works on symbols that are undefined or defined with static scope.

For example, with CONFIG_PROFILE off, I see:

  kernel/profile.c:206: error: __ksymtab_profile_event_unregister causes a section type conflict
  kernel/profile.c:205: error: __ksymtab_profile_event_register causes a section type conflict

This patch moves the EXPORTs inside the #ifdef CONFIG_PROFILE, so we
only try to export symbols that are defined.

Also, in kernel/kprobes.c there's an EXPORT_SYMBOL_GPL() for
jprobes_return, which if CONFIG_JPROBES is undefined is a static
inline and gives the same error.

And in drivers/acpi/resources/rsxface.c, there's an
ACPI_EXPORT_SYMBOPL() for a static symbol. If it's static, it's not
accessible from outside the compilation unit, so should bot be exported.

These three changes allow building a zx1_defconfig kernel with gcc 4.2
on IA64.

[akpm@linux-foundation.org: export jpobe_return properly]
Signed-off-by: Peter Chubb <peterc@gelato.unsw.edu.au>
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/resources/rsxface.c |    2 --
 kernel/kprobes.c                 |    5 +++++
 kernel/profile.c                 |    4 ++--
 3 files changed, 7 insertions(+), 4 deletions(-)

diff -puN drivers/acpi/resources/rsxface.c~fix-compilation-with-gcc-42 drivers/acpi/resources/rsxface.c
--- a/drivers/acpi/resources/rsxface.c~fix-compilation-with-gcc-42
+++ a/drivers/acpi/resources/rsxface.c
@@ -474,8 +474,6 @@ acpi_rs_match_vendor_resource(struct acp
 	return (AE_CTRL_TERMINATE);
 }
 
-ACPI_EXPORT_SYMBOL(acpi_rs_match_vendor_resource)
-
 /*******************************************************************************
  *
  * FUNCTION:    acpi_walk_resources
diff -puN kernel/kprobes.c~fix-compilation-with-gcc-42 kernel/kprobes.c
--- a/kernel/kprobes.c~fix-compilation-with-gcc-42
+++ a/kernel/kprobes.c
@@ -1063,6 +1063,11 @@ EXPORT_SYMBOL_GPL(register_kprobe);
 EXPORT_SYMBOL_GPL(unregister_kprobe);
 EXPORT_SYMBOL_GPL(register_jprobe);
 EXPORT_SYMBOL_GPL(unregister_jprobe);
+#ifdef CONFIG_KPROBES
 EXPORT_SYMBOL_GPL(jprobe_return);
+#endif
+
+#ifdef CONFIG_KPROBES
 EXPORT_SYMBOL_GPL(register_kretprobe);
 EXPORT_SYMBOL_GPL(unregister_kretprobe);
+#endif
diff -puN kernel/profile.c~fix-compilation-with-gcc-42 kernel/profile.c
--- a/kernel/profile.c~fix-compilation-with-gcc-42
+++ a/kernel/profile.c
@@ -199,11 +199,11 @@ EXPORT_SYMBOL_GPL(register_timer_hook);
 EXPORT_SYMBOL_GPL(unregister_timer_hook);
 EXPORT_SYMBOL_GPL(task_handoff_register);
 EXPORT_SYMBOL_GPL(task_handoff_unregister);
+EXPORT_SYMBOL_GPL(profile_event_register);
+EXPORT_SYMBOL_GPL(profile_event_unregister);
 
 #endif /* CONFIG_PROFILING */
 
-EXPORT_SYMBOL_GPL(profile_event_register);
-EXPORT_SYMBOL_GPL(profile_event_unregister);
 
 #ifdef CONFIG_SMP
 /*
_

Patches currently in -mm which might be from peterc@gelato.unsw.edu.au are

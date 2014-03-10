From: akpm@linux-foundation.org
Subject: [obsolete]
 bug-use-a-common-definition-of-bug_on-regardless-of-config_bug.patch
 removed from -mm tree
Date: Mon, 10 Mar 2014 12:49:40 -0700
Message-ID: <531e1754.1+6UDRj1GQSk09O+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40555 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbaCJTtm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Mar 2014 15:49:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, arnd@arndb.de, josh@joshtriplett.org

Subject: [obsolete] bug-use-a-common-definition-of-bug_on-regardless-of-config_bug.patch removed from -mm tree
To: josh@joshtriplett.org,arnd@arndb.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 10 Mar 2014 12:49:40 -0700


The patch titled
     Subject: bug: use a common definition of BUG_ON regardless of CONFIG_BUG
has been removed from the -mm tree.  Its filename was
     bug-use-a-common-definition-of-bug_on-regardless-of-config_bug.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Josh Triplett <josh@joshtriplett.org>
Subject: bug: use a common definition of BUG_ON regardless of CONFIG_BUG

include/asm-generic/bug.h defines BUG_ON to call BUG() if CONFIG_BUG=y, or
as a no-op if !CONFIG_BUG.  However, BUG() is already a no-op if
!CONFIG_BUG, making this pointless.  Use a common definition that always
calls BUG().

This does not change the compiled code at all.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bug.h |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN include/asm-generic/bug.h~bug-use-a-common-definition-of-bug_on-regardless-of-config_bug include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~bug-use-a-common-definition-of-bug_on-regardless-of-config_bug
+++ a/include/asm-generic/bug.h
@@ -51,10 +51,6 @@ struct bug_entry {
 } while (0)
 #endif
 
-#ifndef HAVE_ARCH_BUG_ON
-#define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while (0)
-#endif
-
 /*
  * WARN(), WARN_ON(), WARN_ON_ONCE, and so on can be used to report
  * significant issues that need prompt attention if they should ever
@@ -141,10 +137,6 @@ extern void warn_slowpath_null(const cha
 #define BUG() do {} while (0)
 #endif
 
-#ifndef HAVE_ARCH_BUG_ON
-#define BUG_ON(condition) do { if (condition) ; } while (0)
-#endif
-
 #ifndef HAVE_ARCH_WARN_ON
 #define WARN_ON(condition) ({						\
 	int __ret_warn_on = !!(condition);				\
@@ -167,6 +159,10 @@ extern void warn_slowpath_null(const cha
 
 #endif
 
+#ifndef HAVE_ARCH_BUG_ON
+#define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while (0)
+#endif
+
 /*
  * WARN_ON_SMP() is for cases that the warning is either
  * meaningless for !SMP or may even cause failures.
_

Patches currently in -mm which might be from josh@joshtriplett.org are

mm-compactionc-mark-function-as-static.patch
mm-memoryc-mark-functions-as-static.patch
mm-mmapc-mark-function-as-static.patch
mm-process_vm_accessc-mark-function-as-static.patch
mm-process_vm_accessc-mark-function-as-static-fix.patch
mm-page_cgroupc-mark-functions-as-static.patch
mm-nobootmemc-mark-function-as-static.patch
include-linux-mmh-remove-ifdef-condition.patch
include-linux-syscallsh-add-sys32_quotactl-prototype.patch
fs-kernel-permit-disabling-the-uselib-syscall.patch
fs-kernel-permit-disabling-the-uselib-syscall-v2.patch
submittingpatches-add-style-recommendation-to-use-imperative-descriptions.patch
submittingpatches-add-recommendation-for-mailing-list-references.patch
submittingpatches-document-the-use-of-git.patch
lglock-map-to-spinlock-when-config_smp.patch
lib-clz_ctzc-add-prototype-declarations-in-lib-clz_ctzc.patch
lib-decompress_inflatec-include-appropriate-header-file.patch
checkpatch-make-return-is-not-a-function-test-quieter.patch
fs-reiserfs-move-prototype-declaration-to-header-file.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
cris-make-etrax_arch_v10-select-tty-for-use-in-debugport.patch
ia64-select-config_tty-for-use-of-tty_write_message-in-unaligned.patch
ppc-make-ppc_book3s_64-select-irq_work.patch
s390-select-config_tty-for-use-of-tty-in-unconditional-keyboard-driver.patch
kconfig-make-allnoconfig-disable-options-behind-embedded-and-expert.patch
bug-when-config_bug-simplify-warn_on_once-and-family.patch
include-asm-generic-bugh-style-fix-s-while0-while-0.patch
bug-when-config_bug-make-warn-call-no_printk-to-check-format-and-args.patch
bug-make-bug-always-stop-the-machine.patch
x86-always-define-bug-and-have_arch_bug-even-with-config_bug.patch
linux-next.patch


From: akpm@linux-foundation.org
Subject: + bug-when-config_bug-simplify-warn_on_once-and-family.patch
 added to -mm tree
Date: Fri, 28 Feb 2014 15:04:24 -0800
Message-ID: <531115f8.GBzj0Wi5BLyqAQVL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52229 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbaB1XEZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Feb 2014 18:04:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, arnd@arndb.de, josh@joshtriplett.org

Subject: + bug-when-config_bug-simplify-warn_on_once-and-family.patch added to -mm tree
To: josh@joshtriplett.org,arnd@arndb.de
From: akpm@linux-foundation.org
Date: Fri, 28 Feb 2014 15:04:24 -0800


The patch titled
     Subject: bug: when !CONFIG_BUG, simplify WARN_ON_ONCE and family
has been added to the -mm tree.  Its filename is
     bug-when-config_bug-simplify-warn_on_once-and-family.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bug-when-config_bug-simplify-warn_on_once-and-family.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bug-when-config_bug-simplify-warn_on_once-and-family.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Josh Triplett <josh@joshtriplett.org>
Subject: bug: when !CONFIG_BUG, simplify WARN_ON_ONCE and family

When !CONFIG_BUG, WARN_ON and family become simple passthroughs of their
condition argument; however, WARN_ON_ONCE and family still have conditions
and a boolean to detect one-time invocation, even though the warning
they'd emit doesn't exist.  Make the existing definitions conditional on
CONFIG_BUG, and add definitions for !CONFIG_BUG that map to the
passthrough versions of WARN and WARN_ON.

This saves 4.4k on a minimized configuration (smaller than allnoconfig),
and 20.6k with defconfig plus CONFIG_BUG=n.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bug.h |   57 ++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 27 deletions(-)

diff -puN include/asm-generic/bug.h~bug-when-config_bug-simplify-warn_on_once-and-family include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~bug-when-config_bug-simplify-warn_on_once-and-family
+++ a/include/asm-generic/bug.h
@@ -106,33 +106,6 @@ extern void warn_slowpath_null(const cha
 	unlikely(__ret_warn_on);					\
 })
 
-#else /* !CONFIG_BUG */
-#ifndef HAVE_ARCH_BUG
-#define BUG() do {} while(0)
-#endif
-
-#ifndef HAVE_ARCH_BUG_ON
-#define BUG_ON(condition) do { if (condition) ; } while(0)
-#endif
-
-#ifndef HAVE_ARCH_WARN_ON
-#define WARN_ON(condition) ({						\
-	int __ret_warn_on = !!(condition);				\
-	unlikely(__ret_warn_on);					\
-})
-#endif
-
-#ifndef WARN
-#define WARN(condition, format...) ({					\
-	int __ret_warn_on = !!(condition);				\
-	unlikely(__ret_warn_on);					\
-})
-#endif
-
-#define WARN_TAINT(condition, taint, format...) WARN_ON(condition)
-
-#endif
-
 #define WARN_ON_ONCE(condition)	({				\
 	static bool __section(.data.unlikely) __warned;		\
 	int __ret_warn_once = !!(condition);			\
@@ -163,6 +136,36 @@ extern void warn_slowpath_null(const cha
 	unlikely(__ret_warn_once);				\
 })
 
+#else /* !CONFIG_BUG */
+#ifndef HAVE_ARCH_BUG
+#define BUG() do {} while(0)
+#endif
+
+#ifndef HAVE_ARCH_BUG_ON
+#define BUG_ON(condition) do { if (condition) ; } while(0)
+#endif
+
+#ifndef HAVE_ARCH_WARN_ON
+#define WARN_ON(condition) ({						\
+	int __ret_warn_on = !!(condition);				\
+	unlikely(__ret_warn_on);					\
+})
+#endif
+
+#ifndef WARN
+#define WARN(condition, format...) ({					\
+	int __ret_warn_on = !!(condition);				\
+	unlikely(__ret_warn_on);					\
+})
+#endif
+
+#define WARN_ON_ONCE(condition) WARN_ON(condition)
+#define WARN_ONCE(condition, format...) WARN(condition, format)
+#define WARN_TAINT(condition, taint, format...) WARN(condition, format)
+#define WARN_TAINT_ONCE(condition, taint, format...) WARN(condition, format)
+
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
kconfig-make-allnoconfig-disable-options-behind-embedded-and-expert.patch
bug-when-config_bug-simplify-warn_on_once-and-family.patch
include-asm-generic-bugh-style-fix-s-while0-while-0.patch
bug-when-config_bug-make-warn-call-no_printk-to-check-format-and-args.patch
bug-use-a-common-definition-of-bug_on-regardless-of-config_bug.patch
linux-next.patch


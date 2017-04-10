From: akpm@linux-foundation.org
Subject: [failures] module-verify-address-is-read-only.patch removed from
 -mm tree
Date: Mon, 10 Apr 2017 14:09:22 -0700
Message-ID: <58ebf482.P15eHvEsWKUIK0I1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55408 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751434AbdDJVJX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Apr 2017 17:09:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ewk@edkovsky.org, jeyu@redhat.com, keescook@chromium.org, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: module: verify address is read-only
has been removed from the -mm tree.  Its filename was
     module-verify-address-is-read-only.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Eddie Kovsky <ewk@edkovsky.org>
Subject: module: verify address is read-only

Patch series "provide check for ro_after_init memory sections", v5.

Provide a mechanism for other functions to verify that their arguments are
read-only.

This implements the first half of a suggestion made by Kees Cook for the
Kernel Self Protection Project:

    - provide mechanism to check for ro_after_init memory areas, and
      reject structures not marked ro_after_init in vmbus_register()

      http://www.openwall.com/lists/kernel-hardening/2017/02/04/1

The idea is to prevent structures (including modules) that are not
read-only from being passed to functions.  It builds upon the functions in
kernel/extable.c that test if an address is in the text section.

A build failure on the Blackfin architecture led to the discovery of an
incomplete definition of the RO_DATA macro used in this series.  The fixes
are in linux-next:

	commit 906f2a51c941 ("mm: fix section name for .data..ro_after_init")

	commit 939897e2d736 ("vmlinux.lds: add missing VMLINUX_SYMBOL macros")


This patch (of 2):

Implement a mechanism to check if a module's address is in the rodata or
ro_after_init sections.  It mimics the existing functions that test if an
address is inside a module's text section.

Functions that take a module as an argument will be able to verify that
the module address is in a read-only section.  The idea is to prevent
structures (including modules) that are not read-only from being passed to
functions.

This implements the first half of a suggestion made by Kees Cook for the
Kernel Self Protection Project:

    - provide mechanism to check for ro_after_init memory areas, and
      reject structures not marked ro_after_init in vmbus_register()

Link: http://lkml.kernel.org/r/20170406033550.32525-2-ewk@edkovsky.org
Signed-off-by: Eddie Kovsky <ewk@edkovsky.org>
Suggested-by: Kees Cook <keescook@chromium.org>
Acked-by: Jessica Yu <jeyu@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/module.h |   12 ++++++++
 kernel/module.c        |   53 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+)

diff -puN include/linux/module.h~module-verify-address-is-read-only include/linux/module.h
--- a/include/linux/module.h~module-verify-address-is-read-only
+++ a/include/linux/module.h
@@ -492,7 +492,9 @@ static inline int module_is_live(struct
 
 struct module *__module_text_address(unsigned long addr);
 struct module *__module_address(unsigned long addr);
+struct module *__module_rodata_address(unsigned long addr);
 bool is_module_address(unsigned long addr);
+bool is_module_rodata_address(unsigned long addr);
 bool is_module_percpu_address(unsigned long addr);
 bool is_module_text_address(unsigned long addr);
 
@@ -645,6 +647,11 @@ static inline struct module *__module_ad
 	return NULL;
 }
 
+static inline struct module *__module_rodata_address(unsigned long addr)
+{
+	return NULL;
+}
+
 static inline struct module *__module_text_address(unsigned long addr)
 {
 	return NULL;
@@ -654,6 +661,11 @@ static inline bool is_module_address(uns
 {
 	return false;
 }
+
+static inline bool is_module_rodata_address(unsigned long addr)
+{
+	return false;
+}
 
 static inline bool is_module_percpu_address(unsigned long addr)
 {
diff -puN kernel/module.c~module-verify-address-is-read-only kernel/module.c
--- a/kernel/module.c~module-verify-address-is-read-only
+++ a/kernel/module.c
@@ -4275,6 +4275,59 @@ struct module *__module_text_address(uns
 }
 EXPORT_SYMBOL_GPL(__module_text_address);
 
+/**
+ * is_module_rodata_address - is this address inside read-only module data?
+ * @addr: the address to check.
+ *
+ */
+bool is_module_rodata_address(unsigned long addr)
+{
+	bool ret;
+
+	preempt_disable();
+	ret = __module_rodata_address(addr) != NULL;
+	preempt_enable();
+
+	return ret;
+}
+
+/*
+ * __module_rodata_address - get the module whose rodata/ro_after_init sections
+ * contain the given address.
+ * @addr: the address.
+ *
+ * Must be called with preempt disabled or module mutex held so that
+ * module doesn't get freed during this.
+ */
+struct module *__module_rodata_address(unsigned long addr)
+{
+	struct module *mod = __module_address(addr);
+
+	/*
+	 * Make sure module is within the read-only section.
+	 * range(base + text_size, base + ro_after_init_size)
+	 * encompasses both the rodata and ro_after_init regions.
+	 * See comment above frob_text() for the layout diagram.
+	 */
+	if (mod) {
+		void *init_base = mod->init_layout.base;
+		unsigned int init_text_size = mod->init_layout.text_size;
+		unsigned int init_ro_after_init_size = mod->init_layout.ro_after_init_size;
+
+		void *core_base = mod->core_layout.base;
+		unsigned int core_text_size = mod->core_layout.text_size;
+		unsigned int core_ro_after_init_size = mod->core_layout.ro_after_init_size;
+
+		if (!within(addr, init_base + init_text_size,
+			    init_ro_after_init_size - init_text_size)
+		    && !within(addr, core_base + core_text_size,
+			       core_ro_after_init_size - core_text_size))
+			mod = NULL;
+	}
+	return mod;
+}
+EXPORT_SYMBOL_GPL(__module_rodata_address);
+
 /* Don't grab lock, we're oopsing. */
 void print_modules(void)
 {
_

Patches currently in -mm which might be from ewk@edkovsky.org are

extable-verify-address-is-read-only.patch


From: akpm@linux-foundation.org
Subject: + extable-verify-address-is-read-only.patch added to -mm tree
Date: Fri, 07 Apr 2017 15:13:21 -0700
Message-ID: <58e80f01.P/oLdNxKl85h4t/A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55914 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756469AbdDGWNW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Apr 2017 18:13:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ewk@edkovsky.org, jeyu@redhat.com, keescook@chromium.org, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: extable: verify address is read-only
has been added to the -mm tree.  Its filename is
     extable-verify-address-is-read-only.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/extable-verify-address-is-read-only.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/extable-verify-address-is-read-only.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eddie Kovsky <ewk@edkovsky.org>
Subject: extable: verify address is read-only

Provide a mechanism to check if the address of a variable is const or
ro_after_init.  It mimics the existing functions that test if an address
is inside the kernel's text section.

The idea is to prevent structures that are not read-only from being passed
to functions.  Other functions inside the kernel could then use this
capability to verify that their arguments are read-only.

This implements the first half of a suggestion made by Kees Cook for the
Kernel Self Protection Project:

	- provide mechanism to check for ro_after_init memory areas, and
	reject structures not marked ro_after_init in vmbus_register()

Link: http://lkml.kernel.org/r/20170406033550.32525-3-ewk@edkovsky.org
Signed-off-by: Eddie Kovsky <ewk@edkovsky.org>
Suggested-by: Kees Cook <keescook@chromium.org>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Jessica Yu <jeyu@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    2 ++
 kernel/extable.c       |   29 +++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff -puN include/linux/kernel.h~extable-verify-address-is-read-only include/linux/kernel.h
--- a/include/linux/kernel.h~extable-verify-address-is-read-only
+++ a/include/linux/kernel.h
@@ -444,6 +444,8 @@ extern int core_kernel_data(unsigned lon
 extern int __kernel_text_address(unsigned long addr);
 extern int kernel_text_address(unsigned long addr);
 extern int func_ptr_is_kernel_text(void *ptr);
+extern int core_kernel_rodata(unsigned long addr);
+extern int kernel_ro_address(unsigned long addr);
 
 unsigned long int_sqrt(unsigned long);
 
diff -puN kernel/extable.c~extable-verify-address-is-read-only kernel/extable.c
--- a/kernel/extable.c~extable-verify-address-is-read-only
+++ a/kernel/extable.c
@@ -154,3 +154,32 @@ int func_ptr_is_kernel_text(void *ptr)
 		return 1;
 	return is_module_text_address(addr);
 }
+
+/**
+ * core_kernel_rodata - Verify address points to read-only section
+ * @addr: address to test
+ *
+ */
+int core_kernel_rodata(unsigned long addr)
+{
+	if (addr >= (unsigned long)__start_rodata &&
+	    addr < (unsigned long)__end_rodata)
+		return 1;
+
+	if (addr >= (unsigned long)__start_ro_after_init &&
+	    addr < (unsigned long)__end_ro_after_init)
+		return 1;
+
+	return 0;
+}
+
+/* Verify that address is const or ro_after_init. */
+int kernel_ro_address(unsigned long addr)
+{
+	if (core_kernel_rodata(addr))
+		return 1;
+	if (is_module_rodata_address(addr))
+		return 1;
+
+	return 0;
+}
_

Patches currently in -mm which might be from ewk@edkovsky.org are

module-verify-address-is-read-only.patch
extable-verify-address-is-read-only.patch


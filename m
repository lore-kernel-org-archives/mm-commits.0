From: akpm@linux-foundation.org
Subject: + uml-fix-epoll.patch added to -mm tree
Date: Sun, 25 Mar 2007 00:37:43 -0800
Message-ID: <200703250837.l2P8bhUt023887@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36365 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753484AbXCYIi7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 04:38:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, davidel@xmailserver.org, jdike@linux.intel.com, stable@kernel.org


The patch titled
     uml: fix epoll
has been added to the -mm tree.  Its filename is
     uml-fix-epoll.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: fix epoll
From: Jeff Dike <jdike@addtoit.com>

UML/x86_64 needs the same packing of struct epoll_event as x86_64.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/eventpoll.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN include/linux/eventpoll.h~uml-fix-epoll include/linux/eventpoll.h
--- a/include/linux/eventpoll.h~uml-fix-epoll
+++ a/include/linux/eventpoll.h
@@ -31,12 +31,19 @@
 /* 
  * On x86-64 make the 64bit structure have the same alignment as the
  * 32bit structure. This makes 32bit emulation easier.
+ *
+ * UML/x86_64 needs the same packing as x86_64 - UML + UML_X86 +
+ * 64_BIT adds up to UML/x86_64.
  */
 #ifdef __x86_64__
 #define EPOLL_PACKED __attribute__((packed))
 #else
+#if defined(CONFIG_UML) && defined(CONFIG_UML_X86) && defined(CONFIG_64BIT)
+#define EPOLL_PACKED __attribute__((packed))
+#else
 #define EPOLL_PACKED
 #endif
+#endif
 
 struct epoll_event {
 	__u32 events;
_

Patches currently in -mm which might be from jdike@addtoit.com are

uml-fix-epoll.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
array_size-check-for-type-uml-fix.patch
uml-fix-prototypes.patch
uml-move-sigio-testing-to-sigioc.patch
uml-create-archh.patch
uml-create-as-layouth.patch
uml-move-remaining-useful-contents-of-user_utilh.patch
uml-remove-user_utilh.patch
uml-add-missing-__init-declarations.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch

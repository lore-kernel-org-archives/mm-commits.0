From: akpm@linux-foundation.org
Subject: [merged] vmlinuxlds-add-missing-vmlinux_symbol-macros.patch
 removed from -mm tree
Date: Mon, 10 Apr 2017 11:50:53 -0700
Message-ID: <58ebd40d.jI0yznYLoRCQH8jE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46916 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752662AbdDJSuy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Apr 2017 14:50:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeyu@redhat.com, arnd@arndb.de, ewk@edkovsky.org, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: vmlinux.lds: add missing VMLINUX_SYMBOL macros
has been removed from the -mm tree.  Its filename was
     vmlinuxlds-add-missing-vmlinux_symbol-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jessica Yu <jeyu@redhat.com>
Subject: vmlinux.lds: add missing VMLINUX_SYMBOL macros

When __{start,end}_ro_after_init is referenced from C code, we run into the
following build errors on blackfin:

  kernel/extable.c:169: undefined reference to `__start_ro_after_init'
  kernel/extable.c:169: undefined reference to `__end_ro_after_init'

The build error is due to the fact that blackfin is one of the few arches
that prepends an underscore '_' to all symbols defined in C.  Fix this by
wrapping __{start,end}_ro_after_init in vmlinux.lds.h with
VMLINUX_SYMBOL(), which adds the necessary prefix for arches that have
HAVE_UNDERSCORE_SYMBOL_PREFIX.

Link: http://lkml.kernel.org/r/1491259387-15869-1-git-send-email-jeyu@redhat.com
Signed-off-by: Jessica Yu <jeyu@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Eddie Kovsky <ewk@edkovsky.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/vmlinux.lds.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/asm-generic/vmlinux.lds.h~vmlinuxlds-add-missing-vmlinux_symbol-macros include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~vmlinuxlds-add-missing-vmlinux_symbol-macros
+++ a/include/asm-generic/vmlinux.lds.h
@@ -261,9 +261,9 @@
  */
 #ifndef RO_AFTER_INIT_DATA
 #define RO_AFTER_INIT_DATA						\
-	__start_ro_after_init = .;					\
+	VMLINUX_SYMBOL(__start_ro_after_init) = .;			\
 	*(.data..ro_after_init)						\
-	__end_ro_after_init = .;
+	VMLINUX_SYMBOL(__end_ro_after_init) = .;
 #endif
 
 /*
_

Patches currently in -mm which might be from jeyu@redhat.com are



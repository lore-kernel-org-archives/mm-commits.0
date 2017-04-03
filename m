From: akpm@linux-foundation.org
Subject: + vmlinuxlds-add-missing-vmlinux_symbol-macros.patch added to -mm tree
Date: Mon, 03 Apr 2017 15:57:10 -0700
Message-ID: <58e2d346.F3hFoxaCKY5jF16X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55598 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751537AbdDCW5L (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Apr 2017 18:57:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeyu@redhat.com, arnd@arndb.de, ewk@edkovsky.org, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: vmlinux.lds: add missing VMLINUX_SYMBOL macros
has been added to the -mm tree.  Its filename is
     vmlinuxlds-add-missing-vmlinux_symbol-macros.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmlinuxlds-add-missing-vmlinux_symbol-macros.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmlinuxlds-add-missing-vmlinux_symbol-macros.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Kees Cook <keescook@chromium.org>
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

vmlinuxlds-add-missing-vmlinux_symbol-macros.patch


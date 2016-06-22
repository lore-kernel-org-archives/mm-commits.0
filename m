From: akpm@linux-foundation.org
Subject: [merged] vmlinuxldsh-replace-config_enabled-with-is_enabled.patch removed from -mm tree
Date: Wed, 22 Jun 2016 14:30:00 -0700
Message-ID: <576b0358.wdmgtdV3RD0gGbaF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45004 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbcFVVaB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jun 2016 17:30:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, arnd@arndb.de, michal.simek@xilinx.com, mmarek@suse.cz, nicolas.pitre@linaro.org, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: vmlinux.lds.h: replace config_enabled() with IS_ENABLED()
has been removed from the -mm tree.  Its filename was
     vmlinuxldsh-replace-config_enabled-with-is_enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: vmlinux.lds.h: replace config_enabled() with IS_ENABLED()

The use of config_enabled() against config options is ambiguous.

Now, IS_ENABLED() is implemented purely with macro expansion, so
let's replace config_enabled() with IS_ENABLED().

Link: http://lkml.kernel.org/r/1465883938-25194-5-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michal Simek <michal.simek@xilinx.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/vmlinux.lds.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-generic/vmlinux.lds.h~vmlinuxldsh-replace-config_enabled-with-is_enabled include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~vmlinuxldsh-replace-config_enabled-with-is_enabled
+++ a/include/asm-generic/vmlinux.lds.h
@@ -164,7 +164,7 @@
 
 #define ___OF_TABLE(cfg, name)	_OF_TABLE_##cfg(name)
 #define __OF_TABLE(cfg, name)	___OF_TABLE(cfg, name)
-#define OF_TABLE(cfg, name)	__OF_TABLE(config_enabled(cfg), name)
+#define OF_TABLE(cfg, name)	__OF_TABLE(IS_ENABLED(cfg), name)
 #define _OF_TABLE_0(name)
 #define _OF_TABLE_1(name)						\
 	. = ALIGN(8);							\
_

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

tree-wide-replace-config_enabled-with-is_enabled.patch


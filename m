From: akpm@linux-foundation.org
Subject: [patch 020/114] firmware/Makefile: force recompilation if
 makefile changes
Date: Mon, 08 May 2017 15:55:30 -0700
Message-ID: <20170508225530.y84NAtJY2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45900 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751243AbdEHWzb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:55:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dwmw2@infradead.org, gregkh@linuxfoundation.org, mcgrof@kernel.org, ming.lei@canonical.com, mm-commits@vger.kernel.org, mmarek@suse.com, teg@jklm.no, torvalds@linux-foundation.org, yamada.masahiro@socionext.com

From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: firmware/Makefile: force recompilation if makefile changes

If you modify the target asm we currently do not force the recompilation
of the firmware files.  The target asm is in the firmware/Makefile, peg
this file as a dependency to require re-compilation of firmware targets
when the asm changes.

Link: http://lkml.kernel.org/r/20170123150727.4883-1-mcgrof@kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Michal Marek <mmarek@suse.com>
Cc: Ming Lei <ming.lei@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tom Gundersen <teg@jklm.no>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 firmware/Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN firmware/Makefile~firmware-makefile-force-recompilation-if-makefile-changes firmware/Makefile
--- a/firmware/Makefile~firmware-makefile-force-recompilation-if-makefile-changes
+++ a/firmware/Makefile
@@ -176,7 +176,8 @@ quiet_cmd_fwbin = MK_FW   $@
 wordsize_deps := $(wildcard include/config/64bit.h include/config/32bit.h \
 		include/config/ppc32.h include/config/ppc64.h \
 		include/config/superh32.h include/config/superh64.h \
-		include/config/x86_32.h include/config/x86_64.h)
+		include/config/x86_32.h include/config/x86_64.h \
+		firmware/Makefile)
 
 $(patsubst %,$(obj)/%.gen.S, $(fw-shipped-y)): %: $(wordsize_deps)
 	$(call cmd,fwbin,$(patsubst %.gen.S,%,$@))
_

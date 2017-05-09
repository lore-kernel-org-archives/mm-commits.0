From: akpm@linux-foundation.org
Subject: [merged]
 firmware-makefile-force-recompilation-if-makefile-changes.patch removed
 from -mm tree
Date: Tue, 09 May 2017 11:01:01 -0700
Message-ID: <20170509180101.8SehHt2E8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34316 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753219AbdEISBC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:01:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwmw2@infradead.org, gregkh@linuxfoundation.org, mcgrof@kernel.org, ming.lei@canonical.com, mm-commits@vger.kernel.org, mmarek@suse.com, teg@jklm.no, yamada.masahiro@socionext.com


The patch titled
     Subject: firmware/Makefile: force recompilation if makefile changes
has been removed from the -mm tree.  Its filename was
     firmware-makefile-force-recompilation-if-makefile-changes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from mcgrof@kernel.org are



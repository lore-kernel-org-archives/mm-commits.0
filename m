From: akpm@linux-foundation.org
Subject: + firmware-makefile-force-recompilation-if-makefile-changes.patch added to -mm tree
Date: Mon, 06 Mar 2017 14:54:46 -0800
Message-ID: <58bde8b6.55yVtu5Vvgox3EyN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59516 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753162AbdCFXBj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Mar 2017 18:01:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mcgrof@kernel.org, dwmw2@infradead.org, gregkh@linuxfoundation.org, ming.lei@canonical.com, mmarek@suse.com, teg@jklm.no, mm-commits@vger.kernel.org


The patch titled
     Subject: firmware/Makefile: force recompilation if makefile changes
has been added to the -mm tree.  Its filename is
     firmware-makefile-force-recompilation-if-makefile-changes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/firmware-makefile-force-recompilation-if-makefile-changes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/firmware-makefile-force-recompilation-if-makefile-changes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: firmware/Makefile: force recompilation if makefile changes

If you modify the target asm we currently do not force the recompilation
of the firmware files.  The target asm is in the firmware/Makefile, peg
this file as a dependency to require re-compilation of firmware targets
when the asm changes.

Link: http://lkml.kernel.org/r/20170123150727.4883-1-mcgrof@kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
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

firmware-makefile-force-recompilation-if-makefile-changes.patch


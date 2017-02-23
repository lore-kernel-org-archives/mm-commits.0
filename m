From: akpm@linux-foundation.org
Subject: [merged] tools-vm-add-missing-makefile-rules.patch removed from
 -mm tree
Date: Thu, 23 Feb 2017 13:11:32 -0800
Message-ID: <58af5004.LSbBkHxu+jX2zYJe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38298 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751170AbdBWVLd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:11:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.thompson@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm: add missing Makefile rules
has been removed from the -mm tree.  Its filename was
     tools-vm-add-missing-makefile-rules.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Thompson <daniel.thompson@linaro.org>
Subject: tools/vm: add missing Makefile rules

Currently the tools/vm Makefile has a rather arbitrary implicit build
rule; page-types is the first value in TARGETS so lets just build that
one!  Additionally there is no install rule and this is needed for make -C
tools vm_install to work properly.

Provide a more sensible implicit build rule and a new install rule.

Note that the variables names used by the install rule (DESTDIR and
sbindir) are copied from prior-art in tools/power/cpupower.

Link: http://lkml.kernel.org/r/20170113165630.27541-1-daniel.thompson@linaro.org
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/Makefile |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN tools/vm/Makefile~tools-vm-add-missing-makefile-rules tools/vm/Makefile
--- a/tools/vm/Makefile~tools-vm-add-missing-makefile-rules
+++ a/tools/vm/Makefile
@@ -9,6 +9,8 @@ CC = $(CROSS_COMPILE)gcc
 CFLAGS = -Wall -Wextra -I../lib/
 LDFLAGS = $(LIBS)
 
+all: $(TARGETS)
+
 $(TARGETS): $(LIBS)
 
 $(LIBS):
@@ -20,3 +22,9 @@ $(LIBS):
 clean:
 	$(RM) page-types slabinfo page_owner_sort
 	make -C $(LIB_DIR) clean
+
+sbindir ?= /usr/sbin
+
+install: all
+	install -d $(DESTDIR)$(sbindir)
+	install -m 755 -p $(TARGETS) $(DESTDIR)$(sbindir)
_

Patches currently in -mm which might be from daniel.thompson@linaro.org are



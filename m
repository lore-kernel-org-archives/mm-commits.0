From: akpm@linux-foundation.org
Subject: + tools-vm-add-missing-makefile-rules.patch added to -mm tree
Date: Fri, 13 Jan 2017 14:56:26 -0800
Message-ID: <58795b1a.LhmWZe3KT1Ri6cZI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48836 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751378AbdAMW41 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2017 17:56:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.thompson@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm: add missing Makefile rules
has been added to the -mm tree.  Its filename is
     tools-vm-add-missing-makefile-rules.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tools-vm-add-missing-makefile-rules.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tools-vm-add-missing-makefile-rules.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

tools-vm-add-missing-makefile-rules.patch


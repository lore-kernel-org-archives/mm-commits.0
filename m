From: akpm@linux-foundation.org
Subject: - lguest-ldso-on-fc7-is-mmaping-shared-libraries-right-in-over-guest-memory.patch removed from -mm tree
Date: Thu, 09 Aug 2007 15:50:11 -0700
Message-ID: <200708092250.l79MoB3s023560@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58227 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761703AbXHIWu2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 18:50:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rminnich@gmail.com, arjan@infradead.org, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest: ld.so on FC7 is mmap'ing shared libraries right in over guest memory
has been removed from the -mm tree.  Its filename was
     lguest-ldso-on-fc7-is-mmaping-shared-libraries-right-in-over-guest-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lguest: ld.so on FC7 is mmap'ing shared libraries right in over guest memory
From: Ronald G. Minnich <rminnich@gmail.com>

[ FC7 maps shared libraries very low, where the launcher maps guest's physical
memory.  Quick fix is to link Launcher static, real fix is for 2.6.24.  ]

-static is a simple fix.  I expect this problem will be more common than we
like, as different distro's make different "improvements" to ld.so

[Arjan said:

  this description is incorrect; it's not an ld.so change that causes the
  low mapping.

  It's a command line option to the prelink program (which is in most
  distributions) that makes it use the entire address space, not just the
  higher bits...."]

Signed-off-by: Ronald G. Minnich <rminnich@gmail.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/lguest/Makefile |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN Documentation/lguest/Makefile~lguest-ldso-on-fc7-is-mmaping-shared-libraries-right-in-over-guest-memory Documentation/lguest/Makefile
--- a/Documentation/lguest/Makefile~lguest-ldso-on-fc7-is-mmaping-shared-libraries-right-in-over-guest-memory
+++ a/Documentation/lguest/Makefile
@@ -13,7 +13,9 @@ LGUEST_GUEST_TOP := ($(CONFIG_PAGE_OFFSE
 
 CFLAGS:=-Wall -Wmissing-declarations -Wmissing-prototypes -O3 -Wl,-T,lguest.lds
 LDLIBS:=-lz
-
+# Removing this works for some versions of ld.so (eg. Ubuntu Feisty) and
+# not others (eg. FC7).
+LDFLAGS+=-static
 all: lguest.lds lguest
 
 # The linker script on x86 is so complex the only way of creating one
_

Patches currently in -mm which might be from rminnich@gmail.com are

origin.patch

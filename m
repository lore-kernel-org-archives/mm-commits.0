From: akpm@linux-foundation.org
Subject: + lib-clz_tabc-put-in-lib-y-rather-than-obj-y.patch added to -mm
 tree
Date: Tue, 22 Dec 2015 14:55:25 -0800
Message-ID: <5679d4dd.DWLA8ntaG+REqhs2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60471 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbbLVWz0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Dec 2015 17:55:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cmetcalf@ezchip.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/clz_tab.c: put in lib-y rather than obj-y
has been added to the -mm tree.  Its filename is
     lib-clz_tabc-put-in-lib-y-rather-than-obj-y.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-clz_tabc-put-in-lib-y-rather-than-obj-y.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-clz_tabc-put-in-lib-y-rather-than-obj-y.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: lib/clz_tab.c: put in lib-y rather than obj-y

The clz table (__clz_tab) in lib/clz_tab.c is also provided as part of
libgcc.a, and many architectures link against libgcc.  To allow the linker
to avoid a multiple-definition link failure, clz_tab.o has to be in
lib/lib.a rather than lib/builtin.o.  The specific issue is that libgcc.a
comes before lib/builtin.o on vmlinux.o's link command line, so its _clz.o
is pulled to satisfy __clz_tab, and then when the remainder of
lib/builtin.o is pulled in to satisfy all the other dependencies, the
__clz_tab symbols conflict.  By putting clz_tab.o in lib.a, the linker can
simply avoid pulling it into vmlinux.o when this situation arises.

The definitions of __clz_tab are the same in libgcc.a and in the kernel;
arguably we could also simply rename the kernel version, but it's unlikely
the libgcc version will ever change to become incompatible, so just using
it seems reasonably safe.

Signed-off-by: Chris Metcalf <cmetcalf@ezchip.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/Makefile~lib-clz_tabc-put-in-lib-y-rather-than-obj-y lib/Makefile
--- a/lib/Makefile~lib-clz_tabc-put-in-lib-y-rather-than-obj-y
+++ a/lib/Makefile
@@ -153,7 +153,7 @@ obj-$(CONFIG_GLOB) += glob.o
 obj-$(CONFIG_MPILIB) += mpi/
 obj-$(CONFIG_SIGNATURE) += digsig.o
 
-obj-$(CONFIG_CLZ_TAB) += clz_tab.o
+lib-$(CONFIG_CLZ_TAB) += clz_tab.o
 
 obj-$(CONFIG_DDR) += jedec_ddr_data.o
 
_

Patches currently in -mm which might be from cmetcalf@ezchip.com are

lib-clz_tabc-put-in-lib-y-rather-than-obj-y.patch


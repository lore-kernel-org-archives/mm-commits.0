From: akpm@linux-foundation.org
Subject: [merged] linux-coredumph-needs-asm-siginfoh.patch removed from -mm tree
Date: Mon, 22 Oct 2012 12:13:21 -0700
Message-ID: <20121022191321.98D671E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:35258 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab2JVTNX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Oct 2012 15:13:23 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so376379ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 22 Oct 2012 12:13:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@nod.at, amwang@redhat.com, fengguang.wu@intel.com, jmfoote@cert.org, oleg@redhat.com, palves@redhat.com, roland@hack.frob.com, sfr@canb.auug.org.au, vda.linux@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: linux/coredump.h needs asm/siginfo.h
has been removed from the -mm tree.  Its filename was
     linux-coredumph-needs-asm-siginfoh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Richard Weinberger <richard@nod.at>
Subject: linux/coredump.h needs asm/siginfo.h

commit 5ab1c30 ("coredump: pass siginfo_t* to do_coredump() and below, not
merely signr") added siginfo_t to linux/coredump.h but forgot to include
asm/siginfo.h.  This breaks the build for UML/i386.  (And any other arch
where asm/siginfo.h is not magically preincluded...)

In file included from arch/x86/um/elfcore.c:2:0:
include/linux/coredump.h:15:25: error: unknown type name 'siginfo_t'
make[1]: *** [arch/x86/um/elfcore.o] Error 1

Signed-off-by: Richard Weinberger <richard@nod.at>
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Amerigo Wang <amwang@redhat.com>
Cc: "Jonathan M. Foote" <jmfoote@cert.org>
Cc: Roland McGrath <roland@hack.frob.com>
Cc: Pedro Alves <palves@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/coredump.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/coredump.h~linux-coredumph-needs-asm-siginfoh include/linux/coredump.h
--- a/include/linux/coredump.h~linux-coredumph-needs-asm-siginfoh
+++ a/include/linux/coredump.h
@@ -4,6 +4,7 @@
 #include <linux/types.h>
 #include <linux/mm.h>
 #include <linux/fs.h>
+#include <asm/siginfo.h>
 
 /*
  * These are the only things you should do on a core-file: use only these
_

Patches currently in -mm which might be from richard@nod.at are

linux-next.patch


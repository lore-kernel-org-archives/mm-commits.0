From: akpm@linux-foundation.org
Subject: + lib-makefile-fix-oid_registry-build-dependency.patch added to -mm tree
Date: Tue, 04 Dec 2012 13:09:10 -0800
Message-ID: <20121204210910.C23BD10008F@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:38814 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab2LDVJN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2012 16:09:13 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so424617vbi.1
        for <mm-commits@vger.kernel.org>; Tue, 04 Dec 2012 13:09:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tim.gardner@canonical.com, akinobu.mita@gmail.com, davem@davemloft.net, dhowells@redhat.com, walken@google.com


The patch titled
     Subject: lib/Makefile: fix oid_registry build dependency
has been added to the -mm tree.  Its filename is
     lib-makefile-fix-oid_registry-build-dependency.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tim Gardner <tim.gardner@canonical.com>
Subject: lib/Makefile: fix oid_registry build dependency

It is $(obj)/oid_registry.o that is dependent on
$(obj)/oid_registry_data.c.  The object file cannot be built until
$(obj)/oid_registry_data.c has been generated.

A periodic and hard to reproduce parallel build failure is due to this
incorrect lib/Makefile dependency.  The compile error is completely
disingenuous.

  GEN     lib/oid_registry_data.c
Compiling 49 OIDs
  CC      lib/oid_registry.o
gcc: error: lib/oid_registry.c: No such file or directory
gcc: fatal error: no input files
compilation terminated.
make[3]: *** [lib/oid_registry.o] Error 4

I've only ever been able to reproduce this build failure on an Ubuntu PPA,
and then only infrequently.  Restarting the build generally succeeds.  I
beleive the root of the issue to be an incorrect dependency, though I'm
not sure why it doesn't fail more often.  Its never failed when run by
hand, even on large N-way systems.  Commit a77ad6ea0b0bb1 ("X.509:
Implement simple static OID registry") which introduced this change came
in with 3.7-rc1, so this patch is not applicable for stable.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: David Howells <dhowells@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/Makefile~lib-makefile-fix-oid_registry-build-dependency lib/Makefile
--- a/lib/Makefile~lib-makefile-fix-oid_registry-build-dependency
+++ a/lib/Makefile
@@ -163,7 +163,7 @@ $(obj)/crc32table.h: $(obj)/gen_crc32tab
 #
 obj-$(CONFIG_OID_REGISTRY) += oid_registry.o
 
-$(obj)/oid_registry.c: $(obj)/oid_registry_data.c
+$(obj)/oid_registry.o: $(obj)/oid_registry_data.c
 
 $(obj)/oid_registry_data.c: $(srctree)/include/linux/oid_registry.h \
 			    $(src)/build_OID_registry
_

Patches currently in -mm which might be from tim.gardner@canonical.com are

linux-next.patch
lib-makefile-fix-oid_registry-build-dependency.patch


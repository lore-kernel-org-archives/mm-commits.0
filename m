From: akpm@linux-foundation.org
Subject: [merged] lib-makefile-fix-oid_registry-build-dependency.patch removed from -mm tree
Date: Wed, 12 Dec 2012 11:56:42 -0800
Message-ID: <20121212195643.71535200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f73.google.com ([209.85.215.73]:59759 "EHLO
	mail-la0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913Ab2LLT4r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 14:56:47 -0500
Received: by mail-la0-f73.google.com with SMTP id d3so65398lah.4
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 11:56:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tim.gardner@canonical.com, akinobu.mita@gmail.com, davem@davemloft.net, dhowells@redhat.com, rusty@ozlabs.org, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/Makefile: fix oid_registry build dependency
has been removed from the -mm tree.  Its filename was
     lib-makefile-fix-oid_registry-build-dependency.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: David Howells <dhowells@redhat.com>
Cc: Rusty Russell <rusty@ozlabs.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/Makefile~lib-makefile-fix-oid_registry-build-dependency lib/Makefile
--- a/lib/Makefile~lib-makefile-fix-oid_registry-build-dependency
+++ a/lib/Makefile
@@ -162,7 +162,7 @@ $(obj)/crc32table.h: $(obj)/gen_crc32tab
 #
 obj-$(CONFIG_OID_REGISTRY) += oid_registry.o
 
-$(obj)/oid_registry.c: $(obj)/oid_registry_data.c
+$(obj)/oid_registry.o: $(obj)/oid_registry_data.c
 
 $(obj)/oid_registry_data.c: $(srctree)/include/linux/oid_registry.h \
 			    $(src)/build_OID_registry
_

Patches currently in -mm which might be from tim.gardner@canonical.com are

origin.patch
linux-next.patch


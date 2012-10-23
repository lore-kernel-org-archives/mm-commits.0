From: akpm@linux-foundation.org
Subject: + uapi-fix-tools-vm-page-typesc.patch added to -mm tree
Date: Tue, 23 Oct 2012 15:09:28 -0700
Message-ID: <20121023220929.1A7635C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:41439 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324Ab2JWWJb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 18:09:31 -0400
Received: by mail-ee0-f74.google.com with SMTP id b57so260672eek.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 15:09:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, dshadowwolf@gmail.com, fengguang.wu@intel.com


The patch titled
     Subject: UAPI: fix tools/vm/page-types.c
has been added to the -mm tree.  Its filename is
     uapi-fix-tools-vm-page-typesc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Howells <dhowells@redhat.com>
Subject: UAPI: fix tools/vm/page-types.c

Fix tools/vm/page-types.c to use the UAPI variant of linux/kernel-page-flags.h
lest the following error appear:

	In file included from page-types.c:38:0:
	../../include/linux/kernel-page-flags.h:4:42: fatal error:
	uapi/linux/kernel-page-flags.h: No such file or directory

Reported-by: Daniel Hazelton <dshadowwolf@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Fengguang Wu <fengguang.wu@intel.com>
Tested-by: Daniel Hazelton <dshadowwolf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page-types.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN tools/vm/page-types.c~uapi-fix-tools-vm-page-typesc tools/vm/page-types.c
--- a/tools/vm/page-types.c~uapi-fix-tools-vm-page-typesc
+++ a/tools/vm/page-types.c
@@ -35,7 +35,7 @@
 #include <sys/mount.h>
 #include <sys/statfs.h>
 #include "../../include/uapi/linux/magic.h"
-#include "../../include/linux/kernel-page-flags.h"
+#include "../../include/uapi/linux/kernel-page-flags.h"
 
 
 #ifndef MAX_PATH
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
uapi-fix-tools-vm-page-typesc.patch
linux-next.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch


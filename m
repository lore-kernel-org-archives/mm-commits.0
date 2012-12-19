From: akpm@linux-foundation.org
Subject: + kcmp-include-linux-ptraceh.patch added to -mm tree
Date: Wed, 19 Dec 2012 12:56:51 -0800
Message-ID: <20121219205651.A425682004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:59942 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab2LSU4w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:56:52 -0500
Received: by mail-gg0-f201.google.com with SMTP id o6so280607ggm.0
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:56:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, alekskartashov@parallels.com, heiko.carstens@de.ibm.com


The patch titled
     Subject: kcmp: include linux/ptrace.h
has been added to the -mm tree.  Its filename is
     kcmp-include-linux-ptraceh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: kcmp: include linux/ptrace.h

This makes it compile on s390. After all the ptrace_may_access
(which we use this file) is declared exactly in linux/ptrace.h.

This is preparatory work to wire this syscall up on all archs.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Alexander Kartashov <alekskartashov@parallels.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcmp.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/kcmp.c~kcmp-include-linux-ptraceh kernel/kcmp.c
--- a/kernel/kcmp.c~kcmp-include-linux-ptraceh
+++ a/kernel/kcmp.c
@@ -4,6 +4,7 @@
 #include <linux/string.h>
 #include <linux/random.h>
 #include <linux/module.h>
+#include <linux/ptrace.h>
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/cache.h>
_

Patches currently in -mm which might be from gorcunov@openvz.org are

origin.patch
linux-next.patch
kcmp-include-linux-ptraceh.patch


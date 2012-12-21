From: akpm@linux-foundation.org
Subject: [merged] kcmp-include-linux-ptraceh.patch removed from -mm tree
Date: Fri, 21 Dec 2012 12:39:34 -0800
Message-ID: <20121221203935.1A79120004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f201.google.com ([209.85.212.201]:49510 "EHLO
	mail-wi0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab2LUUjh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 15:39:37 -0500
Received: by mail-wi0-f201.google.com with SMTP id hm2so272668wib.2
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 12:39:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, alekskartashov@parallels.com, heiko.carstens@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kcmp: include linux/ptrace.h
has been removed from the -mm tree.  Its filename was
     kcmp-include-linux-ptraceh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


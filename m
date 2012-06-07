From: akpm@linux-foundation.org
Subject: [nacked] cma-do-no-enable-it-by-default.patch removed from -mm tree
Date: Thu, 07 Jun 2012 14:54:42 -0700
Message-ID: <20120607215442.C1D41A02F8@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:45452 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932991Ab2FGVyo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jun 2012 17:54:44 -0400
Received: by qcsp5 with SMTP id p5so113133qcs.1
        for <mm-commits@vger.kernel.org>; Thu, 07 Jun 2012 14:54:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: borislav.petkov@amd.com, cyeoh@au1.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: CMA: mo no enable it by default
has been removed from the -mm tree.  Its filename was
     cma-do-no-enable-it-by-default.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Borislav Petkov <borislav.petkov@amd.com>
Subject: CMA: mo no enable it by default

CROSS_MEMORY_ATTACH is a MPI feature which shouldn't be enabled by default
on every linux system simply because the majority of users do not need it.

In the config option it says "...  which allow a process with the correct
privileges to directly read from or write to to another process's address
space." but this is the normal ptrace case where if one process has the
required privileges, it can access another process' address space.

So disable it - people who really need that normally know what they're
doing and also know how to enable it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: Christopher Yeoh <cyeoh@au1.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/Kconfig~cma-do-no-enable-it-by-default mm/Kconfig
--- a/mm/Kconfig~cma-do-no-enable-it-by-default
+++ a/mm/Kconfig
@@ -352,7 +352,7 @@ endchoice
 config CROSS_MEMORY_ATTACH
 	bool "Cross Memory Support"
 	depends on MMU
-	default y
+	default n
 	help
 	  Enabling this option adds the system calls process_vm_readv and
 	  process_vm_writev which allow a process with the correct privileges
_

Patches currently in -mm which might be from borislav.petkov@amd.com are

linux-next.patch


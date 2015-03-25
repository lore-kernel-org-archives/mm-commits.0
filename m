From: akpm@linux-foundation.org
Subject: + doc-sysctl-kerneltxt-document-threads-max.patch added to -mm
 tree
Date: Wed, 25 Mar 2015 13:55:20 -0700
Message-ID: <551320b8.e/aRj3YYWtV/L6Vj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32936 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbbCYUzV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Mar 2015 16:55:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xypron.glpk@gmx.de, linux@roeck-us.net, mingo@kernel.org, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Doc/sysctl/kernel.txt: document threads-max
has been added to the -mm tree.  Its filename is
     doc-sysctl-kerneltxt-document-threads-max.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/doc-sysctl-kerneltxt-document-threads-max.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/doc-sysctl-kerneltxt-document-threads-max.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: Doc/sysctl/kernel.txt: document threads-max

File /proc/sys/kernel/threads-max controls the maximum number of threads
that can be created using fork().

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff -puN Documentation/sysctl/kernel.txt~doc-sysctl-kerneltxt-document-threads-max Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~doc-sysctl-kerneltxt-document-threads-max
+++ a/Documentation/sysctl/kernel.txt
@@ -872,6 +872,27 @@ can be ORed together:
 
 ==============================================================
 
+threads-max
+
+This value controls the maximum number of threads that can be created
+using fork().
+
+During initialization the kernel sets this value such that even if the
+maximum number of threads is created, the thread structures occupy only
+a part (1/8th) of the available RAM pages.
+
+The minimum value that can be written to threads-max is 20.
+The maximum vlaue that can be written to threads-max is given by the
+constant FUTEX_TID_MASK (0x3fffffff).
+If a value outside of this range is written to threads-max an error
+EINVAL occurs.
+
+The value written is checked against the available RAM pages. If the
+thread structures would occupy too much (more than 1/8th) of the
+available RAM pages threads-max is reduced accordingly.
+
+==============================================================
+
 unknown_nmi_panic:
 
 The value in this file affects behavior of handling NMI. When the
_

Patches currently in -mm which might be from xypron.glpk@gmx.de are

kernel-forkc-new-function-for-max_threads.patch
kernel-forkc-avoid-division-by-zero.patch
kernel-forkc-avoid-division-by-zero-fix.patch
kernel-sysctlc-threads-max-observe-limits.patch
doc-sysctl-kerneltxt-document-threads-max.patch
doc-sysctl-kerneltxt-document-threads-max-fix.patch
linux-next.patch


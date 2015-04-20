From: akpm@linux-foundation.org
Subject: [merged] doc-sysctl-kerneltxt-document-threads-max.patch removed
 from -mm tree
Date: Mon, 20 Apr 2015 12:19:48 -0700
Message-ID: <55355154.1hShE41KFbA9TXUp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40391 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbbDTTN1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:13:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xypron.glpk@gmx.de, linux@roeck-us.net, mingo@kernel.org, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Doc/sysctl/kernel.txt: document threads-max
has been removed from the -mm tree.  Its filename was
     doc-sysctl-kerneltxt-document-threads-max.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: Doc/sysctl/kernel.txt: document threads-max

File /proc/sys/kernel/threads-max controls the maximum number of threads
that can be created using fork().

[akpm@linux-foundation.org: fix typo, per Guenter]
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
+The maximum value that can be written to threads-max is given by the
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

origin.patch


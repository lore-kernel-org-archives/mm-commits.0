From: akpm@linux-foundation.org
Subject: [merged] gcov-disable-constructors-for-uml.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:29:09 -0700
Message-ID: <201107271927.p6RJRtVt003254@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55020 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754957Ab1G0T22 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:28:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vitalivanov@gmail.com, oberpar@linux.vnet.ibm.com, richard@nod.at, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     gcov: disable CONSTRUCTORS for UML
has been removed from the -mm tree.  Its filename was
     gcov-disable-constructors-for-uml.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gcov: disable CONSTRUCTORS for UML
From: Vitaliy Ivanov <vitalivanov@gmail.com>

Selecting GCOV for UML causing configuration mismatch:
warning: (GCOV_KERNEL) selects CONSTRUCTORS which has unmet direct dependencies (!UML)

Constructors are not needed for UML.

Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>
Cc: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Acked-by: Richard Weinberger <richard@nod.at>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/gcov/Kconfig~gcov-disable-constructors-for-uml kernel/gcov/Kconfig
--- a/kernel/gcov/Kconfig~gcov-disable-constructors-for-uml
+++ a/kernel/gcov/Kconfig
@@ -3,7 +3,7 @@ menu "GCOV-based kernel profiling"
 config GCOV_KERNEL
 	bool "Enable gcov-based kernel profiling"
 	depends on DEBUG_FS
-	select CONSTRUCTORS
+	select CONSTRUCTORS if !UML
 	default n
 	---help---
 	This option enables gcov-based code profiling (e.g. for code coverage
_

Patches currently in -mm which might be from vitalivanov@gmail.com are

origin.patch


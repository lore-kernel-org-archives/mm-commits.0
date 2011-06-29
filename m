From: akpm@linux-foundation.org
Subject: + gcov-disable-constructors-for-uml.patch added to -mm tree
Date: Wed, 29 Jun 2011 14:08:38 -0700
Message-ID: <201106292108.p5TL8cPP012009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35325 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757850Ab1F2VJF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jun 2011 17:09:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vitalivanov@gmail.com, oberpar@linux.vnet.ibm.com, richard@nod.at


The patch titled
     gcov: disable CONSTRUCTORS for UML
has been added to the -mm tree.  Its filename is
     gcov-disable-constructors-for-uml.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gcov: disable CONSTRUCTORS for UML
From: Vitaliy Ivanov <vitalivanov@gmail.com>

Selecting GCOV for UML causing configuration mismatch:
warning: (GCOV_KERNEL) selects CONSTRUCTORS which has unmet direct dependencies (!UML)

Constructors are not needed for UML.

Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>
Cc: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: Richard Weinberger <richard@nod.at>
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

linux-next.patch
um-fix-_fortify_source=2-support-for-kernel-modules.patch
gcov-disable-constructors-for-uml.patch


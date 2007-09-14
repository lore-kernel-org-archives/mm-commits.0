From: akpm@linux-foundation.org
Subject: + mutex-documentation-is-unclear-about-software-interrupts-tasklets-and-timers.patch added to -mm tree
Date: Thu, 13 Sep 2007 18:08:36 -0700
Message-ID: <200709140108.l8E18aYS014723@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51179 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754925AbXINBIt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 21:08:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mattilinnanvuori@yahoo.com, arjan@linux.intel.com, mingo@elte.hu


The patch titled
     Mutex documentation is unclear about software interrupts, tasklets and timers
has been added to the -mm tree.  Its filename is
     mutex-documentation-is-unclear-about-software-interrupts-tasklets-and-timers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Mutex documentation is unclear about software interrupts, tasklets and timers
From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>

Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mutex-design.txt |    3 ++-
 include/linux/mutex.h          |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN Documentation/mutex-design.txt~mutex-documentation-is-unclear-about-software-interrupts-tasklets-and-timers Documentation/mutex-design.txt
--- a/Documentation/mutex-design.txt~mutex-documentation-is-unclear-about-software-interrupts-tasklets-and-timers
+++ a/Documentation/mutex-design.txt
@@ -90,7 +90,8 @@ of advantages of mutexes:
    * - task may not exit with mutex held
    * - memory areas where held locks reside must not be freed
    * - held mutexes must not be reinitialized
-   * - mutexes may not be used in irq contexts
+   * - mutexes may not be used in hardware or software interrupt
+   *   contexts such as tasklets and timers
 
    furthermore, there are also convenience features in the debugging
    code:
diff -puN include/linux/mutex.h~mutex-documentation-is-unclear-about-software-interrupts-tasklets-and-timers include/linux/mutex.h
--- a/include/linux/mutex.h~mutex-documentation-is-unclear-about-software-interrupts-tasklets-and-timers
+++ a/include/linux/mutex.h
@@ -29,7 +29,8 @@
  * - task may not exit with mutex held
  * - memory areas where held locks reside must not be freed
  * - held mutexes must not be reinitialized
- * - mutexes may not be used in irq contexts
+ * - mutexes may not be used in hardware or software interrupt
+ *   contexts such as tasklets and timers
  *
  * These semantics are fully enforced when DEBUG_MUTEXES is
  * enabled. Furthermore, besides enforcing the above rules, the mutex
_

Patches currently in -mm which might be from mattilinnanvuori@yahoo.com are

mutex-documentation-is-unclear-about-software-interrupts-tasklets-and-timers.patch

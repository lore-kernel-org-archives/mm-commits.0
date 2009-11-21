From: akpm@linux-foundation.org
Subject: + procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm-doc.patch added to -mm tree
Date: Fri, 20 Nov 2009 16:40:02 -0800
Message-ID: <200911210040.nAL0e2wV011275@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44535 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753817AbZKUAke (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Nov 2009 19:40:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, Sean_Foley@ca.ibm.com, andi@firstfloor.org, arjan@infradead.org, dvhltc@us.ibm.com, fultonm@ca.ibm.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm-doc
has been added to the -mm tree.  Its filename is
     procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm-doc.patch

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
Subject: procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm-doc
From: john stultz <johnstul@us.ibm.com>

Add some documentation about /proc/<pid>/task/<tid>/comm interface.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Mike Fulton <fultonm@ca.ibm.com>
Cc: Sean Foley <Sean_Foley@ca.ibm.com>
Cc: Darren Hart <dvhltc@us.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN Documentation/filesystems/proc.txt~procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm-doc Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm-doc
+++ a/Documentation/filesystems/proc.txt
@@ -38,6 +38,7 @@ Table of Contents
   3.3	/proc/<pid>/io - Display the IO accounting fields
   3.4	/proc/<pid>/coredump_filter - Core dump filtering settings
   3.5	/proc/<pid>/mountinfo - Information about mounts
+  3.6	/proc/<pid>/comm  & /proc/<pid>/task/<tid>/comm
 
 
 ------------------------------------------------------------------------------
@@ -1409,3 +1410,11 @@ For more information on mount propagatio
 
   Documentation/filesystems/sharedsubtree.txt
 
+
+3.6	/proc/<pid>/comm  & /proc/<pid>/task/<tid>/comm
+--------------------------------------------------------
+These files provide a method to access a tasks comm value. It also allows for
+a task to set its own or one of its thread siblings comm value. The comm value
+is limited in size compared to the cmdline value, so writing anything longer
+then the kernel's TASK_COMM_LEN (currently 16 chars) will result in a truncated
+comm value.
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

linux-next.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm-cleanup.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm-doc.patch
cris-convert-to-use-arch_gettimeoffset.patch
timecompare-fix-half-y2k38-problem-in-timecompare_update-while-calculating-offset.patch
cs5535-add-a-generic-mfgpt-driver.patch
cs5535-add-a-generic-clock-event-mfgpt-driver.patch
cs5535-move-the-divil-msr-definition-into-linux-cs5535h.patch
cs5535-move-vsa2-checks-into-linux-cs5535h.patch
cs5535-define-lxfb-gxfb-msrs-in-linux-cs5535h.patch
cs5535-drop-the-geode-specific-mfgpt-gpio-code.patch


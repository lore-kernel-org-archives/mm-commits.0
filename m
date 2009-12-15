From: akpm@linux-foundation.org
Subject: [folded] procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm-doc.patch removed from -mm tree
Date: Mon, 14 Dec 2009 17:06:46 -0800
Message-ID: <200912150106.nBF16lpu010688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46533 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758916AbZLOBHJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 20:07:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnstul@us.ibm.com, Sean_Foley@ca.ibm.com, andi@firstfloor.org, arjan@infradead.org, dvhltc@us.ibm.com, fultonm@ca.ibm.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm-doc
has been removed from the -mm tree.  Its filename was
     procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm-doc.patch

This patch was dropped because it was folded into procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm.patch

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

origin.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm-doc.patch
cs5535-add-a-generic-mfgpt-driver.patch
cs5535-add-a-generic-mfgpt-driver-fix.patch
cs5535-add-a-generic-clock-event-mfgpt-driver.patch
cs5535-move-the-divil-msr-definition-into-linux-cs5535h.patch
cs5535-move-vsa2-checks-into-linux-cs5535h.patch
cs5535-define-lxfb-gxfb-msrs-in-linux-cs5535h.patch
cs5535-drop-the-geode-specific-mfgpt-gpio-code.patch


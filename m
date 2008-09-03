From: akpm@linux-foundation.org
Subject: - ipc-document-the-new-auto_msgmni-proc-file.patch removed from -mm tree
Date: Wed, 03 Sep 2008 09:11:40 -0700
Message-ID: <200809031611.m83GBefh023783@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751919AbYICQMP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2008 12:12:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Nadia.Derbey@bull.net, mm-commits@vger.kernel.org


The patch titled
     ipc: document the new auto_msgmni proc file
has been removed from the -mm tree.  Its filename was
     ipc-document-the-new-auto_msgmni-proc-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc: document the new auto_msgmni proc file
From: Nadia Derbey <Nadia.Derbey@bull.net>

Update Documentation/filesystems/proc.txt: it describes the file
auto_msgmni intoduced to enable/disable msgmni automatic recomputing upon
memory add/remove (see thread http://lkml.org/lkml/2008/7/4/27).  Also
added a description for msgmni (this filex is only listed in
Documentation/sysctl/kernel.txt).

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff -puN Documentation/filesystems/proc.txt~ipc-document-the-new-auto_msgmni-proc-file Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~ipc-document-the-new-auto_msgmni-proc-file
+++ a/Documentation/filesystems/proc.txt
@@ -1339,6 +1339,25 @@ Enables/Disables the protection of the p
 "smaps".  When enabled, the contents of these files are visible only to
 readers that are allowed to ptrace() the given process.
 
+msgmni
+------
+
+Maximum number of message queue ids on the system.
+This value scales to the amount of lowmem. It is automatically recomputed
+upon memory add/remove or ipc namespace creation/removal.
+When a value is written into this file, msgmni's value becomes fixed, i.e. it
+is not recomputed anymore when one of the above events occurs.
+Use auto_msgmni to change this behavior.
+
+auto_msgmni
+-----------
+
+Enables/Disables automatic recomputing of msgmni upon memory add/remove or
+upon ipc namespace creation/removal (see the msgmni description above).
+Echoing "1" into this file enables msgmni automatic recomputing.
+Echoing "0" turns it off.
+auto_msgmni default value is 1.
+
 
 2.4 /proc/sys/vm - The virtual memory subsystem
 -----------------------------------------------
_

Patches currently in -mm which might be from Nadia.Derbey@bull.net are

origin.patch
message-queues-increase-range-limits.patch
message-queues-increase-range-limits-checkpatch-fixes.patch


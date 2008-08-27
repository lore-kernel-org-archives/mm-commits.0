From: akpm@linux-foundation.org
Subject: + ipc-document-the-new-auto_msgmni-proc-file.patch added to -mm tree
Date: Wed, 27 Aug 2008 16:29:06 -0700
Message-ID: <200808272329.m7RNT6IY028440@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45706 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753652AbYH0X3l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Aug 2008 19:29:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Nadia.Derbey@bull.net


The patch titled
     ipc: document the new auto_msgmni proc file
has been added to the -mm tree.  Its filename is
     ipc-document-the-new-auto_msgmni-proc-file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

ipc-document-the-new-auto_msgmni-proc-file.patch


From: akpm@linux-foundation.org
Subject: + sysrq-documentation-document-why-the-command-header-only-is-shown.patch added to -mm tree
Date: Mon, 12 Jan 2009 20:18:52 -0800
Message-ID: <200901130418.n0D4IqZZ004711@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56996 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751370AbZAMETD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 23:19:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com, mj@ucw.cz, randy.dunlap@oracle.com


The patch titled
     sysrq documentation: document why the command header only is shown
has been added to the -mm tree.  Its filename is
     sysrq-documentation-document-why-the-command-header-only-is-shown.patch

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
Subject: sysrq documentation: document why the command header only is shown
From: Andy Whitcroft <apw@canonical.com>

Document the interactions between loglevel and the sysrq output.  Also
document how to work round it should output be required on the console.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Cc: Martin Mares <mj@ucw.cz>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysrq.txt |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN Documentation/sysrq.txt~sysrq-documentation-document-why-the-command-header-only-is-shown Documentation/sysrq.txt
--- a/Documentation/sysrq.txt~sysrq-documentation-document-why-the-command-header-only-is-shown
+++ a/Documentation/sysrq.txt
@@ -212,6 +212,24 @@ within a function called by handle_sysrq
 a lock (you are also in an interrupt handler, which means don't sleep!), so
 you must call __handle_sysrq_nolock instead.
 
+*  When I hit a SysRq key combination only the header appears on the console?
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+Sysrq output is subject to the same console loglevel control as all
+other console output.  This means that if the kernel was booted 'quiet'
+as is common on distro kernels the output may not appear on the actual
+console, even though it will appear in the dmesg buffer, and be accessible
+via the dmesg command and to the consumers of /proc/kmsg.  As a specific
+exception the header line from the sysrq command is passed to all console
+consumers as if the current loglevel was maximum.  If only the header
+is emitted it is almost certain that the kernel loglevel is too low.
+Should you require the output on the console channel then you will need
+to temporarily up the console loglevel using alt-sysrq-8 or:
+
+    echo 8 > /proc/sysrq-trigger
+
+Remember to return the loglevel to normal after triggering the sysrq
+command you are interested in.
+
 *  I have more questions, who can I ask?
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 And I'll answer any questions about the registration system you got, also
_

Patches currently in -mm which might be from apw@canonical.com are

mmc-add-modalias-linkage-for-mmc-sd-devices.patch
sysrq-documentation-remove-the-redundant-updated-date.patch
sysrq-documentation-document-why-the-command-header-only-is-shown.patch
sysrq-add-commentary-on-why-we-use-the-console-loglevel-over-using-kern_emerg.patch


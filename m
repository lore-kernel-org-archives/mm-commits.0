From: akpm@linux-foundation.org
Subject: + document-panic_on_unrecovered_nmi-sysctl.patch added to -mm tree
Date: Fri, 10 Oct 2008 16:16:23 -0700
Message-ID: <200810102316.m9ANGNQB015275@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44996 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753244AbYJJXQf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Oct 2008 19:16:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de


The patch titled
     Document panic_on_unrecovered_nmi sysctl
has been added to the -mm tree.  Its filename is
     document-panic_on_unrecovered_nmi-sysctl.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Document panic_on_unrecovered_nmi sysctl
From: Bernhard Walle <bwalle@suse.de>

This adds "panic_on_unrecovered_nmi" sysctl to
Documentation/filesystems/proc.txt. The text is mainly taken from
http://readlist.com/lists/vger.kernel.org/linux-kernel/43/217998.html.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN Documentation/filesystems/proc.txt~document-panic_on_unrecovered_nmi-sysctl Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~document-panic_on_unrecovered_nmi-sysctl
+++ a/Documentation/filesystems/proc.txt
@@ -1322,6 +1322,18 @@ debugging information is displayed on co
 NMI switch that most IA32 servers have fires unknown NMI up, for example.
 If a system hangs up, try pressing the NMI switch.
 
+panic_on_unrecovered_nmi
+------------------------
+
+The default Linux behaviour on an NMI of either memory or unknown is to continue
+operation. For many environments such as scientific computing it is preferable
+that the box is taken out and the error dealt with than an uncorrected
+parity/ECC error get propogated.
+
+A small number of systems do generate NMI's for bizarre random reasons such as
+power management so the default is off. That sysctl works like the existing
+panic controls already in that directory.
+
 nmi_watchdog
 ------------
 
_

Patches currently in -mm which might be from bwalle@suse.de are

git-tip.patch
ia64-fix-the-difference-between-node_mem_map-and-node_start_pfn.patch
document-panic_on_unrecovered_nmi-sysctl.patch


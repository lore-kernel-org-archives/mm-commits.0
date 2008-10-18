From: akpm@linux-foundation.org
Subject: - document-panic_on_unrecovered_nmi-sysctl.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:12:28 -0700
Message-ID: <200810182312.m9INCSgT028000@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55818 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751307AbYJRXMd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:12:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, mm-commits@vger.kernel.org


The patch titled
     Document panic_on_unrecovered_nmi sysctl
has been removed from the -mm tree.  Its filename was
     document-panic_on_unrecovered_nmi-sysctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1321,6 +1321,18 @@ debugging information is displayed on co
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

origin.patch


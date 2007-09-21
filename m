From: akpm@linux-foundation.org
Subject: + add-documentation-for-extended-crashkernel-syntax.patch added to -mm tree
Date: Fri, 21 Sep 2007 00:26:53 -0700
Message-ID: <200709210726.l8L7QrvS024528@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47765 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754017AbXIUH24 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 03:28:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de, ak@suse.de, benh@kernel.crashing.org, ebiederm@xmission.com, lethal@linux-sh.org, paulus@samba.org, tony.luck@intel.com, vgoyal@in.ibm.com


The patch titled
     Add documentation for extended crashkernel syntax
has been added to the -mm tree.  Its filename is
     add-documentation-for-extended-crashkernel-syntax.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add documentation for extended crashkernel syntax
From: Bernhard Walle <bwalle@suse.de>

This adds the documentation for the extended crashkernel syntax into
Documentation/kdump/kdump.txt.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kdump/kdump.txt |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff -puN Documentation/kdump/kdump.txt~add-documentation-for-extended-crashkernel-syntax Documentation/kdump/kdump.txt
--- a/Documentation/kdump/kdump.txt~add-documentation-for-extended-crashkernel-syntax
+++ a/Documentation/kdump/kdump.txt
@@ -231,6 +231,32 @@ Dump-capture kernel config options (Arch
   any space below the alignment point will be wasted.
 
 
+Extended crashkernel syntax
+===========================
+
+While the "crashkernel=size[@offset]" syntax is sufficient for most
+configurations, sometimes it's handy to have the reserved memory dependent
+on the value of System RAM -- that's mostly for distributors that pre-setup
+the kernel command line to avoid a unbootable system after some memory has
+been removed from the machine.
+
+The syntax is:
+
+    crashkernel=<range1>:<size1>[,<range2>:<size2>,...][@offset]
+    range=start-[end]
+
+For example:
+
+    crashkernel=512M-2G:64M,2G-:128M
+
+This would mean:
+
+    1) if the RAM is smaller than 512M, then don't reserve anything
+       (this is the "rescue" case)
+    2) if the RAM size is between 512M and 2G, then reserve 64M
+    3) if the RAM size is larger than 2G, then reserve 128M
+
+
 Boot into System Kernel
 =======================
 
_

Patches currently in -mm which might be from bwalle@suse.de are

add-vmcoreinfo.patch
express-relocatability-of-kernel-on-x86_64-in-documentation.patch
express-relocatability-of-kernel-on-x86_64-in.patch
express-new-elf32-mechanisms-in-documentation.patch
add-reset_devices-to-the-recommended-parameters.patch
extended-crashkernel-command-line.patch
use-extended-crashkernel-command-line-on-i386.patch
use-extended-crashkernel-command-line-on-x86_64.patch
use-extended-crashkernel-command-line-on-ia64.patch
use-extended-crashkernel-command-line-on-ppc64.patch
use-extended-crashkernel-command-line-on-sh.patch
add-documentation-for-extended-crashkernel-syntax.patch

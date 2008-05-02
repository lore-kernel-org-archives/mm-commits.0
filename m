From: akpm@linux-foundation.org
Subject: - kexec-make-extended-crashkernel=-syntax-less-confusing.patch removed from -mm tree
Date: Fri, 02 May 2008 12:42:31 -0700
Message-ID: <200805021942.m42JgVmO011199@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932220AbYEBTmu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:42:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael@ellerman.id.au, bwalle@suse.de, ebiederm@xmission.com, horms@verge.net.au, mm-commits@vger.kernel.org


The patch titled
     kexec: make extended crashkernel= syntax less confusing
has been removed from the -mm tree.  Its filename was
     kexec-make-extended-crashkernel=-syntax-less-confusing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kexec: make extended crashkernel= syntax less confusing
From: Michael Ellerman <michael@ellerman.id.au>

The extended crashkernel syntax is a little confusing in the way it handles
ranges.  eg:

 crashkernel=512M-2G:64M,2G-:128M

Means if the machine has between 512M and 2G of memory the crash region should
be 64M, and if the machine has 2G of memory the region should be 64M.  Only if
the machine has more than 2G memory will 128M be allocated.

Although that semantic is correct, it is somewhat baffling.  Instead I propose
that the end of the range means the first address past the end of the range,
ie: 512M up to but not including 2G.

[bwalle@suse.de: clarify inclusive/exclusive in crashkernel commandline in documentation]
Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Acked-by: Bernhard Walle <bwalle@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Simon Horman <horms@verge.net.au>
Signed-off-by: Bernhard Walle <bwalle@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kdump/kdump.txt |    5 ++++-
 kernel/kexec.c                |    2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff -puN Documentation/kdump/kdump.txt~kexec-make-extended-crashkernel=-syntax-less-confusing Documentation/kdump/kdump.txt
--- a/Documentation/kdump/kdump.txt~kexec-make-extended-crashkernel=-syntax-less-confusing
+++ a/Documentation/kdump/kdump.txt
@@ -245,6 +245,8 @@ The syntax is:
     crashkernel=<range1>:<size1>[,<range2>:<size2>,...][@offset]
     range=start-[end]
 
+    'start' is inclusive and 'end' is exclusive.
+
 For example:
 
     crashkernel=512M-2G:64M,2G-:128M
@@ -253,10 +255,11 @@ This would mean:
 
     1) if the RAM is smaller than 512M, then don't reserve anything
        (this is the "rescue" case)
-    2) if the RAM size is between 512M and 2G, then reserve 64M
+    2) if the RAM size is between 512M and 2G (exclusive), then reserve 64M
     3) if the RAM size is larger than 2G, then reserve 128M
 
 
+
 Boot into System Kernel
 =======================
 
diff -puN kernel/kexec.c~kexec-make-extended-crashkernel=-syntax-less-confusing kernel/kexec.c
--- a/kernel/kexec.c~kexec-make-extended-crashkernel=-syntax-less-confusing
+++ a/kernel/kexec.c
@@ -1217,7 +1217,7 @@ static int __init parse_crashkernel_mem(
 		}
 
 		/* match ? */
-		if (system_ram >= start && system_ram <= end) {
+		if (system_ram >= start && system_ram < end) {
 			*crash_size = size;
 			break;
 		}
_

Patches currently in -mm which might be from michael@ellerman.id.au are

origin.patch


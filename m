From: akpm@linux-foundation.org
Subject: - kexec-make-extended-crashkernel=-syntax-less-confusing-fix.patch removed from -mm tree
Date: Thu, 01 May 2008 02:48:08 -0700
Message-ID: <200805010948.m419m8mi031700@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53433 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755591AbYEAJs0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:48:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, ebiederm@xmission.com, horms@verge.net.au, michael@ellerman.id.au, mm-commits@vger.kernel.org


The patch titled
     kexec: clarify inclusive/exclusive in crashkernel commandline in documentation
has been removed from the -mm tree.  Its filename was
     kexec-make-extended-crashkernel=-syntax-less-confusing-fix.patch

This patch was dropped because it was folded into kexec-make-extended-crashkernel=-syntax-less-confusing.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kexec: clarify inclusive/exclusive in crashkernel commandline in documentation
From: Bernhard Walle <bwalle@suse.de>

Reflect the changes from Michael Ellerman in crashkernel syntax that make the
end of the memory exclusive in the documentation.  It was simply not specified
before.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kdump/kdump.txt |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN Documentation/kdump/kdump.txt~make-extended-crashkernel=-syntax-less-confusing Documentation/kdump/kdump.txt
--- a/Documentation/kdump/kdump.txt~make-extended-crashkernel=-syntax-less-confusing
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
 
_

Patches currently in -mm which might be from bwalle@suse.de are

kexec-make-extended-crashkernel=-syntax-less-confusing.patch
kexec-make-extended-crashkernel=-syntax-less-confusing-fix.patch


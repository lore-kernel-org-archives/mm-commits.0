From: akpm@linux-foundation.org
Subject: + kexec-make-extended-crashkernel=-syntax-less-confusing-fix.patch added to -mm tree
Date: Wed, 30 Apr 2008 15:15:41 -0700
Message-ID: <200804302215.m3UMFfhh006199@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933728AbYD3WPv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 18:15:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de, ebiederm@xmission.com, michael@ellerman.id.au


The patch titled
     kexec: clarify inclusive/exclusive in crashkernel commandline in documentation
has been added to the -mm tree.  Its filename is
     kexec-make-extended-crashkernel=-syntax-less-confusing-fix.patch

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


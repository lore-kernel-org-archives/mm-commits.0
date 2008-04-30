From: akpm@linux-foundation.org
Subject: + kexec-make-extended-crashkernel=-syntax-less-confusing.patch added to -mm tree
Date: Wed, 30 Apr 2008 11:29:45 -0700
Message-ID: <200804301829.m3UITjfA028494@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756243AbYD3S3y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 14:29:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael@ellerman.id.au, bwalle@suse.de, ebiederm@xmission.com


The patch titled
     kexec: make extended crashkernel= syntax less confusing
has been added to the -mm tree.  Its filename is
     kexec-make-extended-crashkernel=-syntax-less-confusing.patch

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

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Acked-by: Bernhard Walle <bwalle@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
kexec-make-extended-crashkernel=-syntax-less-confusing.patch


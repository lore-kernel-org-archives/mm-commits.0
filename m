From: akpm@linux-foundation.org
Subject: + kernel-sysc-fix-uname26-for-40.patch added to -mm tree
Date: Mon, 23 Feb 2015 11:00:51 -0800
Message-ID: <54eb78e3.ahZ3hnY5bG+Ol2R0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42957 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbbBWTAw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 14:00:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nuxi@vault24.org, andi@firstfloor.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/sys.c: fix UNAME26 for 4.0
has been added to the -mm tree.  Its filename is
     kernel-sysc-fix-uname26-for-40.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-sysc-fix-uname26-for-40.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-sysc-fix-uname26-for-40.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jon DeVree <nuxi@vault24.org>
Subject: kernel/sys.c: fix UNAME26 for 4.0

There's a uname workaround for broken userspace which can't handle kernel
versions of 3.x.  Update it for 4.x.

Signed-off-by: Jon DeVree <nuxi@vault24.org>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sys.c~kernel-sysc-fix-uname26-for-40 kernel/sys.c
--- a/kernel/sys.c~kernel-sysc-fix-uname26-for-40
+++ a/kernel/sys.c
@@ -1127,7 +1127,7 @@ static int override_release(char __user
 				break;
 			rest++;
 		}
-		v = ((LINUX_VERSION_CODE >> 8) & 0xff) + 40;
+		v = ((LINUX_VERSION_CODE >> 8) & 0xff) + 60;
 		copy = clamp_t(size_t, len, 1, sizeof(buf));
 		copy = scnprintf(buf, copy, "2.6.%u%s", v, rest);
 		ret = copy_to_user(release, buf, copy + 1);
_

Patches currently in -mm which might be from nuxi@vault24.org are

kernel-sysc-fix-uname26-for-40.patch
kernel-sysc-fix-uname26-for-40-fix.patch


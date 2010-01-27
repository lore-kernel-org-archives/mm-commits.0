From: akpm@linux-foundation.org
Subject: + cpuidle-menu-remove-8-bytes-of-padding-on-64-bit-builds.patch added to -mm tree
Date: Wed, 27 Jan 2010 15:33:34 -0800
Message-ID: <201001272333.o0RNXYOk006883@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47225 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756518Ab0A0Xd7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jan 2010 18:33:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@rsk.demon.co.uk, arjan@linux.intel.com


The patch titled
     cpuidle menu: remove 8 bytes of padding on 64 bit builds
has been added to the -mm tree.  Its filename is
     cpuidle-menu-remove-8-bytes-of-padding-on-64-bit-builds.patch

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
Subject: cpuidle menu: remove 8 bytes of padding on 64 bit builds
From: Richard Kennedy <richard@rsk.demon.co.uk>

Reorder struct menu_device to remove 8 bytes of padding on 64 bit builds. 
Size drops from 136 to 128 bytes, so possibly needing one fewer cache
lines.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpuidle/governors/menu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/cpuidle/governors/menu.c~cpuidle-menu-remove-8-bytes-of-padding-on-64-bit-builds drivers/cpuidle/governors/menu.c
--- a/drivers/cpuidle/governors/menu.c~cpuidle-menu-remove-8-bytes-of-padding-on-64-bit-builds
+++ a/drivers/cpuidle/governors/menu.c
@@ -100,8 +100,8 @@ struct menu_device {
 	int             needs_update;
 
 	unsigned int	expected_us;
-	u64		predicted_us;
 	unsigned int	measured_us;
+	u64		predicted_us;
 	unsigned int	exit_us;
 	unsigned int	bucket;
 	u64		correction_factor[BUCKETS];
_

Patches currently in -mm which might be from richard@rsk.demon.co.uk are

get_maintainerpl-teach-git-log-to-use-no-color.patch
kernel-timekeeping-move-xtime_cache-to-be-in-the-same-cache-line-as-the-lock.patch
cpuidle-menu-remove-8-bytes-of-padding-on-64-bit-builds.patch


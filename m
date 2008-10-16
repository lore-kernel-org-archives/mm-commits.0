From: akpm@linux-foundation.org
Subject: + make-do_mounts_md-use-of-msleep-more-robust.patch added to -mm tree
Date: Thu, 16 Oct 2008 15:01:25 -0700
Message-ID: <200810162201.m9GM1Pvx027253@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755586AbYJPWBe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 18:01:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au


The patch titled
     make do_mounts_md() use of msleep ()more robust
has been added to the -mm tree.  Its filename is
     make-do_mounts_md-use-of-msleep-more-robust.patch

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
Subject: make do_mounts_md() use of msleep ()more robust
From: Stephen Rothwell <sfr@canb.auug.org.au>

Commit 589f800bb12c5cd6c9167bbf9bf3cb70cd8e422c ("fastboot: make the raid
autodetect code wait for all devices to init") added a call to msleep to
do_mounts_md.c but the declaration of that was only included implicitly
through linux/raid/md.h.  Make the include of linux/delay.h explicit.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts_md.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN init/do_mounts_md.c~make-do_mounts_md-use-of-msleep-more-robust init/do_mounts_md.c
--- a/init/do_mounts_md.c~make-do_mounts_md-use-of-msleep-more-robust
+++ a/init/do_mounts_md.c
@@ -1,4 +1,5 @@
 
+#include <linux/delay.h>
 #include <linux/raid/md.h>
 
 #include "do_mounts.h"
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
revert-i7300_idle-driver-v155.patch
make-do_mounts_md-use-of-msleep-more-robust.patch


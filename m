From: akpm@linux-foundation.org
Subject: + binfmt_misc-fix-binfmt_misc-priority.patch added to -mm tree
Date: Fri, 03 Sep 2010 14:20:34 -0700
Message-ID: <201009032120.o83LKYwF012950@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35514 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753962Ab0ICVVG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Sep 2010 17:21:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jsembera@suse.cz, ink@jurassic.park.msu.ru, rth@twiddle.net, stable@kernel.org, viro@ZenIV.linux.org.uk


The patch titled
     binfmt_misc: fix binfmt_misc priority
has been added to the -mm tree.  Its filename is
     binfmt_misc-fix-binfmt_misc-priority.patch

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
Subject: binfmt_misc: fix binfmt_misc priority
From: Jan Sembera <jsembera@suse.cz>

Commit 74641f584da ("alpha: binfmt_aout fix") (May 2009) introduced a
regression - binfmt_misc is now consulted after binfmt_elf, which will
unfortunately break ia32el.  ia32 ELF binaries on ia64 used to be matched
using binfmt_misc and executed using wrapper.  As 32bit binaries are now
matched by binfmt_elf before bindmt_misc kicks in, the wrapper is ignored.

The fix increases precedence of binfmt_misc to the original state.

Signed-off-by: Jan Sembera <jsembera@suse.cz>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Richard Henderson <rth@twiddle.net
Cc: <stable@kernel.org>		[2.6.everything.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_misc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/binfmt_misc.c~binfmt_misc-fix-binfmt_misc-priority fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~binfmt_misc-fix-binfmt_misc-priority
+++ a/fs/binfmt_misc.c
@@ -724,7 +724,7 @@ static int __init init_misc_binfmt(void)
 {
 	int err = register_filesystem(&bm_fs_type);
 	if (!err) {
-		err = register_binfmt(&misc_format);
+		err = insert_binfmt(&misc_format);
 		if (err)
 			unregister_filesystem(&bm_fs_type);
 	}
_

Patches currently in -mm which might be from jsembera@suse.cz are

binfmt_misc-fix-binfmt_misc-priority.patch


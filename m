From: akpm@linux-foundation.org
Subject: + compat-fix-sys_fanotify_mark.patch added to -mm tree
Date: Wed, 15 Jan 2014 12:52:28 -0800
Message-ID: <52d6f50c.EW47sC1GHr+VvTZA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43317 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbaAOUw3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jan 2014 15:52:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, ralf@linux-mips.org, mingo@redhat.com, krebbel@linux.vnet.ibm.com, jejb@parisc-linux.org, davem@davemloft.net, benh@kernel.crashing.org, heiko.carstens@de.ibm.com

Subject: + compat-fix-sys_fanotify_mark.patch added to -mm tree
To: heiko.carstens@de.ibm.com,benh@kernel.crashing.org,davem@davemloft.net,jejb@parisc-linux.org,krebbel@linux.vnet.ibm.com,mingo@redhat.com,ralf@linux-mips.org,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 15 Jan 2014 12:52:28 -0800


The patch titled
     Subject: compat: fix sys_fanotify_mark
has been added to the -mm tree.  Its filename is
     compat-fix-sys_fanotify_mark.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/compat-fix-sys_fanotify_mark.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/compat-fix-sys_fanotify_mark.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: compat: fix sys_fanotify_mark

91c2e0bcae72 ("unify compat fanotify_mark(2), switch to
COMPAT_SYSCALL_DEFINE") added a new unified compat fanotify_mark syscall
to be used by all architectures.  Unfortunately the unified version merges
the split mask parameter in a wrong way: the lower and higher word got
swapped.

This was discovered with glibc's tst-fanotify test case.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Reported-by: Andreas Krebbel <krebbel@linux.vnet.ibm.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: <stable@vger.kernel.org>	[3.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify_user.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/notify/fanotify/fanotify_user.c~compat-fix-sys_fanotify_mark fs/notify/fanotify/fanotify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~compat-fix-sys_fanotify_mark
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -886,9 +886,9 @@ COMPAT_SYSCALL_DEFINE6(fanotify_mark,
 {
 	return sys_fanotify_mark(fanotify_fd, flags,
 #ifdef __BIG_ENDIAN
-				((__u64)mask1 << 32) | mask0,
-#else
 				((__u64)mask0 << 32) | mask1,
+#else
+				((__u64)mask1 << 32) | mask0,
 #endif
 				 dfd, pathname);
 }
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

linux-next.patch
compat-fix-sys_fanotify_mark.patch


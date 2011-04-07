From: akpm@linux-foundation.org
Subject: + fcntlf_setfl-allow-setting-of-o_sync.patch added to -mm tree
Date: Thu, 07 Apr 2011 14:39:59 -0700
Message-ID: <201104072139.p37LdxOV001697@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753693Ab1DGVkB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Apr 2011 17:40:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sar@nec-labs.com


The patch titled
     fcntl(F_SETFL): allow setting of O_SYNC
has been added to the -mm tree.  Its filename is
     fcntlf_setfl-allow-setting-of-o_sync.patch

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
Subject: fcntl(F_SETFL): allow setting of O_SYNC
From: Steve Rago <sar@nec-labs.com>

This has probably been a problem since day 1 (I ran into this running the
2.4 kernel years ago; finally got around to fixing it).  The problem is
that fcntl(fd, F_SETFL, flags|O_SYNC) appears to work, but silently
ignores the O_SYNC flag.  Opening the file with O_SYNC works okay, but
setting it later on via fcntl doesn't work.

akpm: will cause surprise slowdowns of applications such as
http://koders.com/c/fidA34D8D5EE9AA5D0AB0F3C604678E2E935E5B0246.aspx?s=dupa

akpm: maybe we should sync the file when someone sets O_SYNC.

Signed-off-by: Steve Rago <sar@nec-labs.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fcntl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/fcntl.c~fcntlf_setfl-allow-setting-of-o_sync fs/fcntl.c
--- a/fs/fcntl.c~fcntlf_setfl-allow-setting-of-o_sync
+++ a/fs/fcntl.c
@@ -143,7 +143,7 @@ SYSCALL_DEFINE1(dup, unsigned int, filde
 	return ret;
 }
 
-#define SETFL_MASK (O_APPEND | O_NONBLOCK | O_NDELAY | O_DIRECT | O_NOATIME)
+#define SETFL_MASK (O_APPEND | O_NONBLOCK | O_NDELAY | O_DIRECT | O_NOATIME | O_SYNC)
 
 static int setfl(int fd, struct file * filp, unsigned long arg)
 {
_

Patches currently in -mm which might be from sar@nec-labs.com are

fcntlf_setfl-allow-setting-of-o_sync.patch


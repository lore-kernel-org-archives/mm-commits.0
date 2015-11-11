From: akpm@linux-foundation.org
Subject: + ncpfs-dont-allow-negative-timeouts.patch added to -mm tree
Date: Wed, 11 Nov 2015 14:58:33 -0800
Message-ID: <5643c819.0577yilc3SEcYxCo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57608 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbbKKW6f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Nov 2015 17:58:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, dhowells@redhat.com, jack@suse.com, jack@suse.cz, petr@vandrovec.name, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: ncpfs: don't allow negative timeouts
has been added to the -mm tree.  Its filename is
     ncpfs-dont-allow-negative-timeouts.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ncpfs-dont-allow-negative-timeouts.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ncpfs-dont-allow-negative-timeouts.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: ncpfs: don't allow negative timeouts

This code causes a static checker warning because it's a user controlled
variable where we cap the upper bound but not the lower bound.  Let's
return an -EINVAL for negative timeouts.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Jan Kara <jack@suse.com>
Cc: Petr Vandrovec <petr@vandrovec.name>
Cc: David Howells <dhowells@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/ioctl.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/ncpfs/ioctl.c~ncpfs-dont-allow-negative-timeouts fs/ncpfs/ioctl.c
--- a/fs/ncpfs/ioctl.c~ncpfs-dont-allow-negative-timeouts
+++ a/fs/ncpfs/ioctl.c
@@ -525,7 +525,9 @@ static long __ncp_ioctl(struct inode *in
 			switch (rqdata.cmd) {
 				case NCP_LOCK_EX:
 				case NCP_LOCK_SH:
-						if (rqdata.timeout == 0)
+						if (rqdata.timeout < 0)
+							return -EINVAL;
+						else if (rqdata.timeout == 0)
 							rqdata.timeout = NCP_LOCK_DEFAULT_TIMEOUT;
 						else if (rqdata.timeout > NCP_LOCK_MAX_TIMEOUT)
 							rqdata.timeout = NCP_LOCK_MAX_TIMEOUT;
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

ncpfs-dont-allow-negative-timeouts.patch
mm-add-tracepoint-for-scanning-pages-fix.patch


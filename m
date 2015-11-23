From: akpm@linux-foundation.org
Subject: [merged] ncpfs-dont-allow-negative-timeouts.patch removed from
 -mm tree
Date: Mon, 23 Nov 2015 12:14:59 -0800
Message-ID: <565373c3.a4BBFPHfQFzGwwLX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53573 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbbKWUPA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Nov 2015 15:15:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, dhowells@redhat.com, jack@suse.com, jack@suse.cz, petr@vandrovec.name, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: ncpfs: don't allow negative timeouts
has been removed from the -mm tree.  Its filename was
     ncpfs-dont-allow-negative-timeouts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: ncpfs: don't allow negative timeouts

This code causes a static checker warning because it's a user controlled
variable where we cap the upper bound but not the lower bound.  Let's
return an -EINVAL for negative timeouts.

[akpm@linux-foundation.org: remove unneeded `else']
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Jan Kara <jack@suse.com>
Cc: Petr Vandrovec <petr@vandrovec.name>
Cc: David Howells <dhowells@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/ioctl.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/ncpfs/ioctl.c~ncpfs-dont-allow-negative-timeouts fs/ncpfs/ioctl.c
--- a/fs/ncpfs/ioctl.c~ncpfs-dont-allow-negative-timeouts
+++ a/fs/ncpfs/ioctl.c
@@ -525,6 +525,8 @@ static long __ncp_ioctl(struct inode *in
 			switch (rqdata.cmd) {
 				case NCP_LOCK_EX:
 				case NCP_LOCK_SH:
+						if (rqdata.timeout < 0)
+							return -EINVAL;
 						if (rqdata.timeout == 0)
 							rqdata.timeout = NCP_LOCK_DEFAULT_TIMEOUT;
 						else if (rqdata.timeout > NCP_LOCK_MAX_TIMEOUT)
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

mm-add-tracepoint-for-scanning-pages-fix.patch


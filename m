From: akpm@linux-foundation.org
Subject: [merged] ncpfs-cleanup-indenting-in-ncp_lookup.patch removed from -mm tree
Date: Wed, 09 Apr 2014 10:55:47 -0700
Message-ID: <534589a3.7S6kp6gfBlcBUOlf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36962 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933776AbaDIRzs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Apr 2014 13:55:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, petr@vandrovec.name, chiluk@canonical.com, dan.carpenter@oracle.com

Subject: [merged] ncpfs-cleanup-indenting-in-ncp_lookup.patch removed from -mm tree
To: dan.carpenter@oracle.com,chiluk@canonical.com,petr@vandrovec.name,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 09 Apr 2014 10:55:47 -0700


The patch titled
     Subject: fs/ncpfs/dir.c: fix indenting in ncp_lookup()
has been removed from the -mm tree.  Its filename was
     ncpfs-cleanup-indenting-in-ncp_lookup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: fs/ncpfs/dir.c: fix indenting in ncp_lookup()

My static checker suggests adding curly braces here.  Probably that was
the intent, but actually the code works the same either way.  I've just
changed the indenting and left the code as-is.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Petr Vandrovec <petr@vandrovec.name>
Acked-by: Dave Chiluk <chiluk@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/dir.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ncpfs/dir.c~ncpfs-cleanup-indenting-in-ncp_lookup fs/ncpfs/dir.c
--- a/fs/ncpfs/dir.c~ncpfs-cleanup-indenting-in-ncp_lookup
+++ a/fs/ncpfs/dir.c
@@ -849,8 +849,8 @@ static struct dentry *ncp_lookup(struct
 				 dentry->d_name.len, 1);
 		if (!res)
 			res = ncp_lookup_volume(server, __name, &(finfo.i));
-			if (!res)
-				ncp_update_known_namespace(server, finfo.i.volNumber, NULL);
+		if (!res)
+			ncp_update_known_namespace(server, finfo.i.volNumber, NULL);
 	} else {
 		res = ncp_io2vol(server, __name, &len, dentry->d_name.name,
 				 dentry->d_name.len, !ncp_preserve_case(dir));
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch


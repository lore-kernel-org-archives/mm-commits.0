From: akpm@linux-foundation.org
Subject: [wrecked] add-a-refcount-check-in-dput.patch removed from -mm
 tree
Date: Thu, 29 Aug 2013 12:05:05 -0700
Message-ID: <521f9b61.UaOn+GvDcoUN9Fen%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35783 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948Ab3H2TFG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Aug 2013 15:05:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, menage@google.com

Subject: [wrecked] add-a-refcount-check-in-dput.patch removed from -mm tree
To: menage@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 29 Aug 2013 12:05:05 -0700


The patch titled
     Subject: add a refcount check in dput()
has been removed from the -mm tree.  Its filename was
     add-a-refcount-check-in-dput.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: Paul Menage <menage@google.com>
Subject: add a refcount check in dput()

Add a WARN_ON_ONCE() to check for passing an unreferenced dentry to dput().

This is analogous to the similar check in dget(), and will make
reference-counting bugs in filesystems more immediately obvious. (I
just spent a while debugging an oops that turned out to be due to
broken fs reference counting.)

Signed-off-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/dcache.c~add-a-refcount-check-in-dput fs/dcache.c
--- a/fs/dcache.c~add-a-refcount-check-in-dput
+++ a/fs/dcache.c
@@ -521,6 +521,7 @@ void dput(struct dentry *dentry)
 	if (!dentry)
 		return;
 
+	WARN_ON_ONCE(!dentry->d_count);
 repeat:
 	if (dentry->d_count == 1)
 		might_sleep();
_

Patches currently in -mm which might be from menage@google.com are



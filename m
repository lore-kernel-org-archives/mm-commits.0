From: akpm@linux-foundation.org
Subject: [merged] s390-cio-replace-strnicmp-with-strncasecmp.patch removed from -mm tree
Date: Tue, 14 Oct 2014 11:22:32 -0700
Message-ID: <543d69e8.YVhq9/BEqlmupwOw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44526 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755592AbaJNSWb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:22:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, oberpar@linux.vnet.ibm.com, sebott@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: s390/cio: replace strnicmp with strncasecmp
has been removed from the -mm tree.  Its filename was
     s390-cio-replace-strnicmp-with-strncasecmp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: s390/cio: replace strnicmp with strncasecmp

The kernel used to contain two functions for length-delimited,
case-insensitive string comparison, strnicmp with correct semantics and a
slightly buggy strncasecmp.  The latter is the POSIX name, so strnicmp was
renamed to strncasecmp, and strnicmp made into a wrapper for the new
strncasecmp to avoid breaking existing users.

To allow the compat wrapper strnicmp to be removed at some point in the
future, and to avoid the extra indirection cost, do
s/strnicmp/strncasecmp/g.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/cio/chp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/s390/cio/chp.c~s390-cio-replace-strnicmp-with-strncasecmp drivers/s390/cio/chp.c
--- a/drivers/s390/cio/chp.c~s390-cio-replace-strnicmp-with-strncasecmp
+++ a/drivers/s390/cio/chp.c
@@ -257,11 +257,11 @@ static ssize_t chp_status_write(struct d
 	if (!num_args)
 		return count;
 
-	if (!strnicmp(cmd, "on", 2) || !strcmp(cmd, "1")) {
+	if (!strncasecmp(cmd, "on", 2) || !strcmp(cmd, "1")) {
 		mutex_lock(&cp->lock);
 		error = s390_vary_chpid(cp->chpid, 1);
 		mutex_unlock(&cp->lock);
-	} else if (!strnicmp(cmd, "off", 3) || !strcmp(cmd, "0")) {
+	} else if (!strncasecmp(cmd, "off", 3) || !strcmp(cmd, "0")) {
 		mutex_lock(&cp->lock);
 		error = s390_vary_chpid(cp->chpid, 0);
 		mutex_unlock(&cp->lock);
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch


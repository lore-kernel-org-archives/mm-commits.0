From: akpm@linux-foundation.org
Subject: [merged] utsnameh-make-new_utsname-fields-use-the-proper-length-constant.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:37:06 -0700
Message-ID: <200906171837.n5HIb6Dj003148@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41456 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760431AbZFQShv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:37:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: danms@us.ibm.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     utsname.h: make new_utsname fields use the proper length constant
has been removed from the -mm tree.  Its filename was
     utsnameh-make-new_utsname-fields-use-the-proper-length-constant.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: utsname.h: make new_utsname fields use the proper length constant
From: Dan Smith <danms@us.ibm.com>

The members of the new_utsname structure are defined with magic numbers
that *should* correspond to the constant __NEW_UTS_LEN+1.  Everywhere
else, code assumes this and uses the constant, so this patch makes the
structure match.

Originally suggested by Serge here:

https://lists.linux-foundation.org/pipermail/containers/2009-March/016258.html

Signed-off-by: Dan Smith <danms@us.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/utsname.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN include/linux/utsname.h~utsnameh-make-new_utsname-fields-use-the-proper-length-constant include/linux/utsname.h
--- a/include/linux/utsname.h~utsnameh-make-new_utsname-fields-use-the-proper-length-constant
+++ a/include/linux/utsname.h
@@ -22,12 +22,12 @@ struct old_utsname {
 };
 
 struct new_utsname {
-	char sysname[65];
-	char nodename[65];
-	char release[65];
-	char version[65];
-	char machine[65];
-	char domainname[65];
+	char sysname[__NEW_UTS_LEN + 1];
+	char nodename[__NEW_UTS_LEN + 1];
+	char release[__NEW_UTS_LEN + 1];
+	char version[__NEW_UTS_LEN + 1];
+	char machine[__NEW_UTS_LEN + 1];
+	char domainname[__NEW_UTS_LEN + 1];
 };
 
 #ifdef __KERNEL__
_

Patches currently in -mm which might be from danms@us.ibm.com are

origin.patch


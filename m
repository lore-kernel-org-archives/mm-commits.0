From: akpm@linux-foundation.org
Subject: [merged] selinuxfs-remove-custome-hex_to_bin.patch removed from -mm tree
Date: Thu, 17 Nov 2011 12:22:07 -0800
Message-ID: <201111172022.pAHKM7Wd023655@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:62632 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab1KQUWK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2011 15:22:10 -0500
Received: by vcbfl13 with SMTP id fl13so353588vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2011 12:22:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, eparis@parisplace.org, jmorris@namei.org, mm-commits@vger.kernel.org


The patch titled
     Subject: selinuxfs: remove custom hex_to_bin()
has been removed from the -mm tree.  Its filename was
     selinuxfs-remove-custome-hex_to_bin.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: selinuxfs: remove custom hex_to_bin()

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Eric Paris <eparis@parisplace.org>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/selinux/selinuxfs.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff -puN security/selinux/selinuxfs.c~selinuxfs-remove-custome-hex_to_bin security/selinux/selinuxfs.c
--- a/security/selinux/selinuxfs.c~selinuxfs-remove-custome-hex_to_bin
+++ a/security/selinux/selinuxfs.c
@@ -749,14 +749,6 @@ out:
 	return length;
 }
 
-static inline int hexcode_to_int(int code) {
-	if (code == '\0' || !isxdigit(code))
-		return -1;
-	if (isdigit(code))
-		return code - '0';
-	return tolower(code) - 'a' + 10;
-}

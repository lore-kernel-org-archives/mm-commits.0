From: akpm@linux-foundation.org
Subject: + selinuxfs-remove-custome-hex_to_bin.patch added to -mm tree
Date: Thu, 21 Jul 2011 14:47:04 -0700
Message-ID: <201107212147.p6LLl4MW010398@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752997Ab1GUVrL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jul 2011 17:47:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andriy.shevchenko@linux.intel.com, eparis@parisplace.org, jmorris@namei.org


The patch titled
     selinuxfs: remove custome hex_to_bin()
has been added to the -mm tree.  Its filename is
     selinuxfs-remove-custome-hex_to_bin.patch

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
Subject: selinuxfs: remove custome hex_to_bin()
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

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
@@ -752,14 +752,6 @@ out:
 	return length;
 }
 
-static inline int hexcode_to_int(int code) {
-	if (code == '\0' || !isxdigit(code))
-		return -1;
-	if (isdigit(code))
-		return code - '0';
-	return tolower(code) - 'a' + 10;
-}

From: akpm@linux-foundation.org
Subject: + utsnameh-make-new_utsname-fields-use-the-proper-length-constant.patch added to -mm tree
Date: Fri, 17 Apr 2009 11:52:05 -0700
Message-ID: <200904171852.n3HIq6lB005213@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753864AbZDQSxs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Apr 2009 14:53:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: danms@us.ibm.com, serue@us.ibm.com


The patch titled
     utsname.h: make new_utsname fields use the proper length constant
has been added to the -mm tree.  Its filename is
     utsnameh-make-new_utsname-fields-use-the-proper-length-constant.patch

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

utsnameh-make-new_utsname-fields-use-the-proper-length-constant.patch


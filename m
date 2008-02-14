From: akpm@linux-foundation.org
Subject: + include-kernelh-from-configfsh.patch added to -mm tree
Date: Thu, 14 Feb 2008 13:47:29 -0800
Message-ID: <200802142147.m1ELlTfH004517@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37373 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761706AbYBNVru (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 16:47:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bn@niasdigital.com, Joel.Becker@oracle.com


The patch titled
     Include kernel.h from configfs.h
has been added to the -mm tree.  Its filename is
     include-kernelh-from-configfsh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Include kernel.h from configfs.h
From: bn@niasdigital.com

configfs.h uses the container_of macro and as such should include kernel.h.

Signed-off-by: Ben Nizette <bn@niasdigital.com>
Cc: Joel Becker <Joel.Becker@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/configfs.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/configfs.h~include-kernelh-from-configfsh include/linux/configfs.h
--- a/include/linux/configfs.h~include-kernelh-from-configfsh
+++ a/include/linux/configfs.h
@@ -37,6 +37,7 @@
 
 #ifdef __KERNEL__
 
+#include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/kref.h>
_

Patches currently in -mm which might be from bn@niasdigital.com are

include-kernelh-from-configfsh.patch
git-avr32.patch

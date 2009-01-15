From: akpm@linux-foundation.org
Subject: + capabilityh-externs-make-no-sense-in-userspace.patch added to -mm tree
Date: Thu, 15 Jan 2009 14:55:57 -0800
Message-ID: <200901152255.n0FMtvJ6001544@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936440AbZAOW4q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Jan 2009 17:56:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaswinder@infradead.org, jaswinderrajput@gmail.com, jmorris@namei.org, morgan@kernel.org


The patch titled
     capability.h: extern's make no sense in userspace
has been added to the -mm tree.  Its filename is
     capabilityh-externs-make-no-sense-in-userspace.patch

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
Subject: capability.h: extern's make no sense in userspace
From: Jaswinder Singh Rajput <jaswinder@infradead.org>

Impact: fix 2 make headers_check warnings:

 usr/include/linux/capability.h:72: leaks CONFIG_SECURITY to userspace where it is not valid
 usr/include/linux/capability.h:73: extern's make no sense in userspace

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Acked-by: Andrew G. Morgan <morgan@kernel.org>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/capability.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/capability.h~capabilityh-externs-make-no-sense-in-userspace include/linux/capability.h
--- a/include/linux/capability.h~capabilityh-externs-make-no-sense-in-userspace
+++ a/include/linux/capability.h
@@ -69,10 +69,6 @@ typedef struct __user_cap_data_struct {
 #define VFS_CAP_U32             VFS_CAP_U32_2
 #define VFS_CAP_REVISION	VFS_CAP_REVISION_2
 
-#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
-extern int file_caps_enabled;
-#endif

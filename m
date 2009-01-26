From: akpm@linux-foundation.org
Subject: [merged] capabilityh-externs-make-no-sense-in-userspace.patch removed from -mm tree
Date: Mon, 26 Jan 2009 11:04:13 -0800
Message-ID: <200901261904.n0QJ4DVx029643@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751818AbZAZTKC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jan 2009 14:10:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaswinder@infradead.org, jaswinderrajput@gmail.com, jmorris@namei.org, morgan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     capability.h: extern's make no sense in userspace
has been removed from the -mm tree.  Its filename was
     capabilityh-externs-make-no-sense-in-userspace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

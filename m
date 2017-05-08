From: akpm@linux-foundation.org
Subject: [patch 057/114] fs/xattr.c: zero out memory copied to
 userspace in getxattr
Date: Mon, 08 May 2017 15:57:24 -0700
Message-ID: <20170508225724.qjIVG0WTH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46742 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751895AbdEHW50 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:57:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, keescook@chromium.org, mhocko@suse.com, mm-commits@vger.kernel.org, stable@vger.kernel.org, torvalds@linux-foundation.org, vbabka@suse.cz

From: Michal Hocko <mhocko@suse.com>
Subject: fs/xattr.c: zero out memory copied to userspace in getxattr

getxattr uses vmalloc to allocate memory if kzalloc fails.  This is filled
by vfs_getxattr and then copied to the userspace.  vmalloc, however,
doesn't zero out the memory so if the specific implementation of the xattr
handler is sloppy we can theoretically expose a kernel memory.  There is
no real sign this is really the case but let's make sure this will not
happen and use vzalloc instead.

Fixes: 779302e67835 ("fs/xattr.c:getxattr(): improve handling of allocation failures")
Link: http://lkml.kernel.org/r/20170306103327.2766-1-mhocko@kernel.org
Acked-by: Kees Cook <keescook@chromium.org>
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>	[3.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/xattr.c~xattr-zero-out-memory-copied-to-userspace-in-getxattr fs/xattr.c
--- a/fs/xattr.c~xattr-zero-out-memory-copied-to-userspace-in-getxattr
+++ a/fs/xattr.c
@@ -530,7 +530,7 @@ getxattr(struct dentry *d, const char __
 			size = XATTR_SIZE_MAX;
 		kvalue = kzalloc(size, GFP_KERNEL | __GFP_NOWARN);
 		if (!kvalue) {
-			kvalue = vmalloc(size);
+			kvalue = vzalloc(size);
 			if (!kvalue)
 				return -ENOMEM;
 		}
_

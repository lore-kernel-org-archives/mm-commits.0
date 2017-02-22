From: akpm@linux-foundation.org
Subject: [patch 023/142] 9p: fix a potential acl leak
Date: Wed, 22 Feb 2017 15:40:53 -0800
Message-ID: <58ae2185.5x53+lmFGeXkus5p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48260 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934311AbdBVXl5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:41:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, xiyou.wangcong@gmail.com, ericvh@gmail.com, groug@kaod.org, jack@suse.cz, lucho@ionkov.net, rminnich@sandia.gov, salyzyn@android.com

From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: 9p: fix a potential acl leak

posix_acl_update_mode() could possibly clear 'acl', if so we leak the
memory pointed by 'acl'.  Save this pointer before calling
posix_acl_update_mode() and release the memory if 'acl' really gets
cleared.

Link: http://lkml.kernel.org/r/1486678332-2430-1-git-send-email-xiyou.wangcong@gmail.com
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reported-by: Mark Salyzyn <salyzyn@android.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Greg Kurz <groug@kaod.org>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/9p/acl.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/9p/acl.c~9p-fix-a-potential-acl-leak fs/9p/acl.c
--- a/fs/9p/acl.c~9p-fix-a-potential-acl-leak
+++ a/fs/9p/acl.c
@@ -277,6 +277,7 @@ static int v9fs_xattr_set_acl(const stru
 	case ACL_TYPE_ACCESS:
 		if (acl) {
 			struct iattr iattr;
+			struct posix_acl *old_acl = acl;
 
 			retval = posix_acl_update_mode(inode, &iattr.ia_mode, &acl);
 			if (retval)
@@ -287,6 +288,7 @@ static int v9fs_xattr_set_acl(const stru
 				 * by the mode bits. So don't
 				 * update ACL.
 				 */
+				posix_acl_release(old_acl);
 				value = NULL;
 				size = 0;
 			}
_

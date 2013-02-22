From: akpm@linux-foundation.org
Subject: + ocfs2-fix-ocfs2_init_security_and_acl-to-initialize-acl-correctly.patch added to -mm tree
Date: Fri, 22 Feb 2013 13:21:49 -0800
Message-ID: <20130222212149.A900431C194@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:56050 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691Ab3BVVVu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 16:21:50 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so108091ghb.5
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 13:21:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeff.liu@oracle.com, boyu.mt@taobao.com, jlbec@evilplan.org, mfasheh@suse.com, zohar@linux.vnet.ibm.com


The patch titled
     Subject: ocfs2: fix ocfs2_init_security_and_acl() to initialize acl correctly
has been added to the -mm tree.  Its filename is
     ocfs2-fix-ocfs2_init_security_and_acl-to-initialize-acl-correctly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jeff Liu <jeff.liu@oracle.com>
Subject: ocfs2: fix ocfs2_init_security_and_acl() to initialize acl correctly

We need to re-initialize the security if it isn't preserved for
ocfs2_reflink().  however, the code logic is broken at
ocfs2_init_security_and_acl() although ocfs2_init_security_get() succeed,
as a result, ocfs2_acl_init() does not involked.

Note this was introduced by 9d8f13ba3 ("security: new security_inode_init_security API adds function callback")

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Reviewed-by: Tao Ma <boyu.mt@taobao.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/xattr.c~ocfs2-fix-ocfs2_init_security_and_acl-to-initialize-acl-correctly fs/ocfs2/xattr.c
--- a/fs/ocfs2/xattr.c~ocfs2-fix-ocfs2_init_security_and_acl-to-initialize-acl-correctly
+++ a/fs/ocfs2/xattr.c
@@ -7189,7 +7189,7 @@ int ocfs2_init_security_and_acl(struct i
 	struct buffer_head *dir_bh = NULL;
 
 	ret = ocfs2_init_security_get(inode, dir, qstr, NULL);
-	if (!ret) {
+	if (ret) {
 		mlog_errno(ret);
 		goto leave;
 	}
_

Patches currently in -mm which might be from jeff.liu@oracle.com are

origin.patch
linux-next.patch
ocfs2-fix-ocfs2_init_security_and_acl-to-initialize-acl-correctly.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch


From: akpm@linux-foundation.org
Subject: + ocfs2-make-mlog_errno-return-the-errno-fix.patch added to -mm
 tree
Date: Fri, 03 Apr 2015 14:22:20 -0700
Message-ID: <551f048c.Gacz7e2fwOrKGnY4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48605 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbbDCVWV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Apr 2015 17:22:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, alex.chen@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: double evaluation concerns in mlog_errno()
has been added to the -mm tree.  Its filename is
     ocfs2-make-mlog_errno-return-the-errno-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-make-mlog_errno-return-the-errno-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-make-mlog_errno-return-the-errno-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: ocfs2: double evaluation concerns in mlog_errno()

It won't happen in real life, but for consistency etc then we should
only evaluate the "st" parameter once.

Also, since not all callers use the new return, it causes at static
checker warning:
fs/ocfs2/export.c:138 ocfs2_get_dentry() warn: unchecked 'PTR_ERR'

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: alex chen <alex.chen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/masklog.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/cluster/masklog.h~ocfs2-make-mlog_errno-return-the-errno-fix fs/ocfs2/cluster/masklog.h
--- a/fs/ocfs2/cluster/masklog.h~ocfs2-make-mlog_errno-return-the-errno-fix
+++ a/fs/ocfs2/cluster/masklog.h
@@ -202,7 +202,7 @@ extern struct mlog_bits mlog_and_bits, m
 	    _st != AOP_TRUNCATED_PAGE && _st != -ENOSPC &&		\
 	    _st != -EDQUOT)						\
 		mlog(ML_ERROR, "status = %lld\n", (long long)_st);	\
-	st;								\
+	_st;								\
 })
 
 #define mlog_bug_on_msg(cond, fmt, args...) do {			\
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
ocfs2-dereferencing-freed-pointers-in-ocfs2_reflink.patch
ocfs2-make-mlog_errno-return-the-errno-fix.patch
posix_acl-make-posix_acl_create-safer-and-cleaner.patch
paride-fix-the-verbose-module-param.patch
nilfs2-add-bmap-function-to-seek-a-valid-key-fix.patch
hfsplus-add-missing-curly-braces-in-hfsplus_delete_cat.patch
memstick-mspro_block-add-missing-curly-braces.patch
linux-next.patch


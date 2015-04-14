From: akpm@linux-foundation.org
Subject: [folded-merged] ocfs2-make-mlog_errno-return-the-errno-fix.patch
 removed from -mm tree
Date: Tue, 14 Apr 2015 15:10:10 -0700
Message-ID: <552d9042.hMRQ7MQzLfzpTWz9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54252 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225AbbDNWKL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Apr 2015 18:10:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, alex.chen@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: double evaluation concerns in mlog_errno()
has been removed from the -mm tree.  Its filename was
     ocfs2-make-mlog_errno-return-the-errno-fix.patch

This patch was dropped because it was folded into ocfs2-make-mlog_errno-return-the-errno.patch

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
ocfs2-make-mlog_errno-return-the-errno.patch


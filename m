Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09A48C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 03:57:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E312861245
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 03:57:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236272AbhIOD6f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Sep 2021 23:58:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:43634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236277AbhIOD6f (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Sep 2021 23:58:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC4466121E;
        Wed, 15 Sep 2021 03:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631678237;
        bh=qGYfpFiWLP7Skla2fJdoNj4EBbCO7N9FuGqzD4Inkus=;
        h=Date:From:To:Subject:From;
        b=OiwBT/Ku4RKgPOXOlq4oxyXS0GvJ1XJbl2w/pIU0iab4NUgqCfK1IbZ11F1bHQBBB
         Xb4JbiGPbK2NUKX/QTkXKjf5OYv8Q646GzqSBTWO/oqCoQLZxXj2dekr8bFpwqgBmd
         z847zbb7h2TviB/zx6XlT87JIMtYy0u2+vq1zUu8=
Date:   Tue, 14 Sep 2021 20:57:16 -0700
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, jaharkes@cs.cmu.edu,
        jing.yangyang@zte.com.cn, mm-commits@vger.kernel.org,
        tanxin.ctf@gmail.com, xiyuyang19@fudan.edu.cn, zealci@zte.com.cn
Subject:  +
 coda-avoid-doing-bad-things-on-inode-type-changes-during-revalidation.patch
 added to -mm tree
Message-ID: <20210915035716.bTP-19LH0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: coda: avoid doing bad things on inode type changes during revalidation
has been added to the -mm tree.  Its filename is
     coda-avoid-doing-bad-things-on-inode-type-changes-during-revalidation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/coda-avoid-doing-bad-things-on-inode-type-changes-during-revalidation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/coda-avoid-doing-bad-things-on-inode-type-changes-during-revalidation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Harkes <jaharkes@cs.cmu.edu>
Subject: coda: avoid doing bad things on inode type changes during revalidation

When Coda discovers an inconsistent object, it turns it into a symlink. 
However we can't just follow this change in the kernel on an existing file
or directory inode that may still have references.

This patch removes the inconsistent inode from the inode hash and
allocates a new inode for the symlink object.

Link: https://lkml.kernel.org/r/20210908140308.18491-7-jaharkes@cs.cmu.edu
Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Jing Yangyang <jing.yangyang@zte.com.cn>
Cc: Xin Tan <tanxin.ctf@gmail.com>
Cc: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/cnode.c      |   13 +++++++++----
 fs/coda/coda_linux.c |   39 +++++++++++++++++++--------------------
 fs/coda/coda_linux.h |    3 ++-
 3 files changed, 30 insertions(+), 25 deletions(-)

--- a/fs/coda/cnode.c~coda-avoid-doing-bad-things-on-inode-type-changes-during-revalidation
+++ a/fs/coda/cnode.c
@@ -63,9 +63,10 @@ struct inode * coda_iget(struct super_bl
 	struct inode *inode;
 	struct coda_inode_info *cii;
 	unsigned long hash = coda_f2i(fid);
+	umode_t inode_type = coda_inode_type(attr);
 
+retry:
 	inode = iget5_locked(sb, hash, coda_test_inode, coda_set_inode, fid);
-
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 
@@ -75,11 +76,15 @@ struct inode * coda_iget(struct super_bl
 		inode->i_ino = hash;
 		/* inode is locked and unique, no need to grab cii->c_lock */
 		cii->c_mapcount = 0;
+		coda_fill_inode(inode, attr);
 		unlock_new_inode(inode);
+	} else if ((inode->i_mode & S_IFMT) != inode_type) {
+		/* Inode has changed type, mark bad and grab a new one */
+		remove_inode_hash(inode);
+		coda_flag_inode(inode, C_PURGE);
+		iput(inode);
+		goto retry;
 	}
-
-	/* always replace the attributes, type might have changed */
-	coda_fill_inode(inode, attr);
 	return inode;
 }
 
--- a/fs/coda/coda_linux.c~coda-avoid-doing-bad-things-on-inode-type-changes-during-revalidation
+++ a/fs/coda/coda_linux.c
@@ -87,28 +87,27 @@ static struct coda_timespec timespec64_t
 }
 
 /* utility functions below */
+umode_t coda_inode_type(struct coda_vattr *attr)
+{
+	switch (attr->va_type) {
+	case C_VREG:
+		return S_IFREG;
+	case C_VDIR:
+		return S_IFDIR;
+	case C_VLNK:
+		return S_IFLNK;
+	case C_VNON:
+	default:
+		return 0;
+	}
+}
+
 void coda_vattr_to_iattr(struct inode *inode, struct coda_vattr *attr)
 {
-        int inode_type;
-        /* inode's i_flags, i_ino are set by iget 
-           XXX: is this all we need ??
-           */
-        switch (attr->va_type) {
-        case C_VNON:
-                inode_type  = 0;
-                break;
-        case C_VREG:
-                inode_type = S_IFREG;
-                break;
-        case C_VDIR:
-                inode_type = S_IFDIR;
-                break;
-        case C_VLNK:
-                inode_type = S_IFLNK;
-                break;
-        default:
-                inode_type = 0;
-        }
+	/* inode's i_flags, i_ino are set by iget
+	 * XXX: is this all we need ??
+	 */
+	umode_t inode_type = coda_inode_type(attr);
 	inode->i_mode |= inode_type;
 
 	if (attr->va_mode != (u_short) -1)
--- a/fs/coda/coda_linux.h~coda-avoid-doing-bad-things-on-inode-type-changes-during-revalidation
+++ a/fs/coda/coda_linux.h
@@ -53,10 +53,11 @@ int coda_getattr(struct user_namespace *
 		 u32, unsigned int);
 int coda_setattr(struct user_namespace *, struct dentry *, struct iattr *);
 
-/* this file:  heloers */
+/* this file:  helpers */
 char *coda_f2s(struct CodaFid *f);
 int coda_iscontrol(const char *name, size_t length);
 
+umode_t coda_inode_type(struct coda_vattr *attr);
 void coda_vattr_to_iattr(struct inode *, struct coda_vattr *);
 void coda_iattr_to_vattr(struct iattr *, struct coda_vattr *);
 unsigned short coda_flags_to_cflags(unsigned short);
_

Patches currently in -mm which might be from jaharkes@cs.cmu.edu are

coda-avoid-null-pointer-dereference-from-a-bad-inode.patch
coda-check-for-async-upcall-request-using-local-state.patch
coda-avoid-flagging-null-inodes.patch
coda-avoid-hidden-code-duplication-in-rename.patch
coda-avoid-doing-bad-things-on-inode-type-changes-during-revalidation.patch
coda-bump-module-version-to-72.patch


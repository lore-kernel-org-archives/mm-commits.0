Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6F38C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:34:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FC1361350
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:34:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237044AbhKIChc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:37:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:52994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236920AbhKIChb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:37:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 419D761288;
        Tue,  9 Nov 2021 02:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425286;
        bh=hex6s1sGLS8tR0OdF5oVtcab+ZoetTYj8dHYcaCmamE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=sfyeY70qxFMKdbVyi1GCw+S7WhJDtr2JQTuTHPizJ3pxf8uHEo4aFmirFFyXxL6l1
         P0WlweRoxPXEtNjQDxkPOqezokSJ80KbXfdLzxFD+DpfCICq5fNT280jh8c3J7Vtwg
         TubAzUvvVlb2qIal0X1iR7OBTDTEo3SlM2KUSUpw=
Date:   Mon, 08 Nov 2021 18:34:45 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        jaharkes@cs.cmu.edu, jing.yangyang@zte.com.cn, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, tanxin.ctf@gmail.com,
        torvalds@linux-foundation.org, xiyuyang19@fudan.edu.cn,
        zealci@zte.com.cn
Subject:  [patch 62/87] coda: avoid doing bad things on inode type
 changes during revalidation
Message-ID: <20211109023445.i2stAMlQg%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

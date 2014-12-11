From: akpm@linux-foundation.org
Subject: [merged] fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch removed from -mm tree
Date: Thu, 11 Dec 2014 10:54:53 -0800
Message-ID: <5489e87d.czkyJEHMMkp2Ltqk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44925 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410AbaLKSyy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:54:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, sfrench@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/cifs/file.c: replace count*size kzalloc by kcalloc
has been removed from the -mm tree.  Its filename was
     fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/cifs/file.c: replace count*size kzalloc by kcalloc

kcalloc manages count*sizeof overflow.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Steve French <sfrench@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/cifs/file.c~fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc fs/cifs/file.c
--- a/fs/cifs/file.c~fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc
+++ a/fs/cifs/file.c
@@ -1066,7 +1066,7 @@ cifs_push_mandatory_locks(struct cifsFil
 
 	max_num = (max_buf - sizeof(struct smb_hdr)) /
 						sizeof(LOCKING_ANDX_RANGE);
-	buf = kzalloc(max_num * sizeof(LOCKING_ANDX_RANGE), GFP_KERNEL);
+	buf = kcalloc(max_num, sizeof(LOCKING_ANDX_RANGE), GFP_KERNEL);
 	if (!buf) {
 		free_xid(xid);
 		return -ENOMEM;
@@ -1401,7 +1401,7 @@ cifs_unlock_range(struct cifsFileInfo *c
 
 	max_num = (max_buf - sizeof(struct smb_hdr)) /
 						sizeof(LOCKING_ANDX_RANGE);
-	buf = kzalloc(max_num * sizeof(LOCKING_ANDX_RANGE), GFP_KERNEL);
+	buf = kcalloc(max_num, sizeof(LOCKING_ANDX_RANGE), GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-affs-filec-forward-declaration-clean-up.patch
fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf.patch
fs-affs-filec-adding-support-to-o_direct.patch
fs-affs-filec-remove-obsolete-pagesize-check.patch
linux-next.patch


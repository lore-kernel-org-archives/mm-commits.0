From: akpm@linux-foundation.org
Subject: [merged]
 fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch removed from
 -mm tree
Date: Thu, 11 Dec 2014 10:54:55 -0800
Message-ID: <5489e87f.Pb91ldKbkruVymh0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44928 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618AbaLKSy4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:54:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, sfrench@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/cifs/smb2file.c: replace count*size kzalloc by kcalloc
has been removed from the -mm tree.  Its filename was
     fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/cifs/smb2file.c: replace count*size kzalloc by kcalloc

kcalloc manages count*sizeof overflow.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Steve French <sfrench@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/smb2file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/cifs/smb2file.c~fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc fs/cifs/smb2file.c
--- a/fs/cifs/smb2file.c~fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc
+++ a/fs/cifs/smb2file.c
@@ -111,7 +111,7 @@ smb2_unlock_range(struct cifsFileInfo *c
 		return -EINVAL;
 
 	max_num = max_buf / sizeof(struct smb2_lock_element);
-	buf = kzalloc(max_num * sizeof(struct smb2_lock_element), GFP_KERNEL);
+	buf = kcalloc(max_num, sizeof(struct smb2_lock_element), GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
@@ -247,7 +247,7 @@ smb2_push_mandatory_locks(struct cifsFil
 	}
 
 	max_num = max_buf / sizeof(struct smb2_lock_element);
-	buf = kzalloc(max_num * sizeof(struct smb2_lock_element), GFP_KERNEL);
+	buf = kcalloc(max_num, sizeof(struct smb2_lock_element), GFP_KERNEL);
 	if (!buf) {
 		free_xid(xid);
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


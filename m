From: akpm@osdl.org
Subject: - ext3-fsid-for-statvfs.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:01:13 -0800
Message-ID: <200612072301.kB7N1DbV029717@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51511 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163678AbWLGXBZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:01:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@cs.helsinki.fi, adilger@clusterfs.com, sct@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ext3: fsid for statvfs
has been removed from the -mm tree.  Its filename was
     ext3-fsid-for-statvfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext3: fsid for statvfs
From: Pekka Enberg <penberg@cs.helsinki.fi>

Update ext3_statfs to return an FSID that is a 64 bit XOR of the 128 bit
filesystem UUID as suggested by Andreas Dilger.  See the following Bugzilla
entry for details:

  http://bugzilla.kernel.org/show_bug.cgi?id=136

Cc: Andreas Dilger <adilger@clusterfs.com>
Cc: Stephen Tweedie <sct@redhat.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext3/super.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/ext3/super.c~ext3-fsid-for-statvfs fs/ext3/super.c
--- a/fs/ext3/super.c~ext3-fsid-for-statvfs
+++ a/fs/ext3/super.c
@@ -2387,6 +2387,7 @@ static int ext3_statfs (struct dentry * 
 	struct ext3_super_block *es = sbi->s_es;
 	ext3_fsblk_t overhead;
 	int i;
+	u64 fsid;
 
 	if (test_opt (sb, MINIX_DF))
 		overhead = 0;
@@ -2433,6 +2434,10 @@ static int ext3_statfs (struct dentry * 
 	buf->f_files = le32_to_cpu(es->s_inodes_count);
 	buf->f_ffree = percpu_counter_sum(&sbi->s_freeinodes_counter);
 	buf->f_namelen = EXT3_NAME_LEN;
+	fsid = le64_to_cpup((void *)es->s_uuid) ^
+	       le64_to_cpup((void *)es->s_uuid + sizeof(u64));
+	buf->f_fsid.val[0] = fsid & 0xFFFFFFFFUL;
+	buf->f_fsid.val[1] = (fsid >> 32) & 0xFFFFFFFFUL;
 	return 0;
 }
 
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

origin.patch
fault-injection-capability-for-kmalloc.patch
slab-leaks3-default-y.patch


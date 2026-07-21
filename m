Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E4C449B12;
	Tue, 21 Jul 2026 00:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784594621; cv=none; b=NfaUrooylisCFUIG/6rqNn6Tbb14m2Oep1c4a8xVMJI7RJ0bjNAXZTbV1u5k0VKNMhFa0TVK0BfMicHPcMHTzZz6kWZcvNoOP1SuMN9biCghKCMEmuUW1Ug9+qjMESV4h+IATvOQcj/YF+fTKZIO+qgRXT+b4+UbuU+MRcubpc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784594621; c=relaxed/simple;
	bh=deIaGZuQxUY6tuU6BKnUBK0pAjc3lU/VHCI00oO7hRw=;
	h=Date:To:From:Subject:Message-Id; b=sVazYV72Ush/JsllAMsGFyad2Y/oHlcmW7KWwwHHiuodcoumrTnmvSMmpSjkNlVairGFg41l5T4D/vlhCXFo1ttmzEl8mH26vCt3PIhzrOVR35oZJTv5OxJaQJOWTGIMJRGfl0iPZ0zq0neW86VxKbf3RXk1Ts1g8wxkgYYnG0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eptamkXk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eptamkXk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A781F000E9;
	Tue, 21 Jul 2026 00:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784594620;
	bh=rHPqUt2mNfYl8rMR/abTVlfg46W7DJuR29p+H+S2mLg=;
	h=Date:To:From:Subject;
	b=eptamkXko0j3+dkqKp+eqy5ERl9JG36tkXAnm4++gsyG9J1aPUbZgzbjn/s/mV8xC
	 9jj6ibw3LWjUkshKRuYNTSofl0pF2zaQ6M+QjkkTRkTXVcYGUNF8o60QhQot4DbQDc
	 CWhJz+H2hEdPJxOegPqQo7gMyOrCg7XTL1fK1Zec=
Date: Mon, 20 Jul 2026 17:43:39 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,dmantipov@yandex.ru,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] ocfs2-fix-boundary-check-in-ocfs2_check_dir_entry-to-use-buffer-offset.patch removed from -mm tree
Message-Id: <20260721004339.F1A781F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix boundary check in ocfs2_check_dir_entry() to use buffer offset
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-boundary-check-in-ocfs2_check_dir_entry-to-use-buffer-offset.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: fix boundary check in ocfs2_check_dir_entry() to use buffer offset
Date: Fri, 10 Jul 2026 12:05:12 +0800

Commit 390ac56cf0f6 ("ocfs2: add boundary check to
ocfs2_check_dir_entry()") added an out-of-bounds guard using the
caller-supplied 'offset' argument:

	if (offset > size - OCFS2_DIR_REC_LEN(1))
		return 0;

However, 'offset' and 'size' are not measured against the same base for
all callers.  In the block-based lookup path, ocfs2_find_entry_el() passes
'offset' as an absolute offset into the whole directory:

	i = ocfs2_search_dirblock(bh, dir, name, namelen,
				  block << sb->s_blocksize_bits,
				  bh->b_data, sb->s_blocksize, res_dir);

while 'size' is a single block size (sb->s_blocksize).  For any directory
entry located in the second or later block, 'offset' is >=
sb->s_blocksize, so the guard rejects every such entry even though it is
perfectly valid and lies entirely within its block buffer.

This makes mounting fail for filesystems whose system directory spans more
than one block, e.g.  a volume formatted with a small block size:

  mkfs.ocfs2 -b 512 -C 4096 -N 2 -T datafiles --fs-features=usrquota,grpquota

  ocfs2_check_dir_entry:314 ERROR: directory entry (#18: offset=512) too close to end or out-of-bounds
  ocfs2_init_local_system_inodes:496 ERROR: status=-22, sysfile=12, slot=0
  ocfs2_mount_volume:1757 ERROR: status = -22

The dirent's position within the buffer being validated is ((char *)de -
buf), which is what the rest of the function already uses (via
next_offset) and what must be bounds-checked against 'size'.  Compute that
buffer-relative offset and use it for the guard.  The subtraction is
reordered to size - buf_offset < OCFS2_DIR_REC_LEN(1) to avoid an unsigned
underflow when size is smaller than the minimal record length.

Link: https://lore.kernel.org/20260710040512.3310736-1-joseph.qi@linux.alibaba.com
Fixes: 390ac56cf0f6 ("ocfs2: add boundary check to ocfs2_check_dir_entry()")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Dmitry Antipov <dmantipov@yandex.ru>
Tested-by: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/dir.c~ocfs2-fix-boundary-check-in-ocfs2_check_dir_entry-to-use-buffer-offset
+++ a/fs/ocfs2/dir.c
@@ -302,10 +302,11 @@ static int ocfs2_check_dir_entry(struct
 				 unsigned long offset)
 {
 	const char *error_msg = NULL;
+	unsigned long buf_offset = (char *)de - buf;
 	unsigned long next_offset;
 	int rlen;
 
-	if (offset > size - OCFS2_DIR_REC_LEN(1)) {
+	if (buf_offset > size || size - buf_offset < OCFS2_DIR_REC_LEN(1)) {
 		/* Dirent is (maybe partially) beyond the buffer
 		 * boundaries so touching 'de' members is unsafe.
 		 */
@@ -316,7 +317,7 @@ static int ocfs2_check_dir_entry(struct
 	}
 
 	rlen = le16_to_cpu(de->rec_len);
-	next_offset = ((char *) de - buf) + rlen;
+	next_offset = buf_offset + rlen;
 
 	if (unlikely(rlen < OCFS2_DIR_REC_LEN(1)))
 		error_msg = "rec_len is smaller than minimal";
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-cluster-use-gfp_nofs-for-heartbeat-bio-allocation.patch
ocfs2-cluster-use-an-on-stack-bio-for-the-heartbeat-write.patch


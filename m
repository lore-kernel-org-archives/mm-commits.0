Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000F32E736D
	for <mm-commits@vger.kernel.org>; Sun, 31 May 2026 19:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780255824; cv=none; b=PuX4ZE9OXSBszND7JjaqU6tf4YSM5dUg14jT/aTVxiR9aYXStQS3MXNL79pENu09eOwiXUNqgRNhefwFwtACe/Od7YLWmIV/Uu0HdUeb7RHohKn5yMs5q+SrB56VzEKIX0X8ADOsMVeuf2Imfcf5OR3fzBlzKwPwa35iPinISNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780255824; c=relaxed/simple;
	bh=MqiDGOWpnYVuspcgfq5d/rNsg4/xlpFANZSy0YAgi/M=;
	h=Date:To:From:Subject:Message-Id; b=ADE/o7VU2krVX2tJgGb+LwUBShFHQN5UWn7RGiYf5v8Yldqy8cvBfTxzNGUdHUKDlJR16OkBrxrUlIUQJbKOEogeq2shao9xOQRc8OZVoGqnvMwq4sqcdsUjZK+T9Ocug7Da39mMyBRpdgciOUgKjEyA/81J1phWAsTSdYr5e+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ngVGHSHX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ngVGHSHX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934A91F00893;
	Sun, 31 May 2026 19:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780255822;
	bh=MFnetVIWF4OfBFbPA6FcNCR9ZlSyRH+wDQZ+QgaRink=;
	h=Date:To:From:Subject;
	b=ngVGHSHXAjeJirjYPHcuNTbx2k+aDxq+5/U34YK8drjVlOUleOUI2RF6qDHnIugvH
	 H5yTJ1hA8JYnjnexnQ1jhxhn5wTJmStyPjjFqSut5v5P+tVOw0rFh0edVrJbZtPBD4
	 aIbz3U0+4DiermIXzG1SyrovNb0lM/n0IYB0xUVY=
Date: Sun, 31 May 2026 12:30:22 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,2045gemini@gmail.com,rollkingzzc@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-validate-fast-symlink-target-during-inode-read.patch added to mm-nonmm-unstable branch
Message-Id: <20260531193022.934A91F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: validate fast symlink target during inode read
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-validate-fast-symlink-target-during-inode-read.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-validate-fast-symlink-target-during-inode-read.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Zhang Cen <rollkingzzc@gmail.com>
Subject: ocfs2: validate fast symlink target during inode read
Date: Thu, 28 May 2026 23:12:30 +0800

ocfs2_validate_inode_block() already rejects several inconsistent
self-contained dinodes before they are exposed to the rest of the
filesystem.  Fast symlinks need the same treatment.

A zero-cluster symlink is treated as a fast symlink and later read through
page_get_link() and ocfs2_fast_symlink_read_folio().  That path uses
strnlen() on the inline payload and then copies len + 1 bytes into the
folio.  If a corrupt dinode stores an i_size that does not fit the inline
area or omits the terminating NUL at i_size, that copy reads past the end
of the inode block buffer.

Reject zero-cluster symlink dinodes whose i_size exceeds the inline
fast-symlink capacity or whose inline payload is not NUL-terminated
exactly at i_size when the inode block is validated.  This keeps malformed
fast symlinks from reaching the read path.

Validation reproduced this kernel report:
KASAN use-after-free in ocfs2_fast_symlink_read_folio+0x12c/0x1f0
RIP: 0033:0x7f5c6d859aa7
Read of size 3905
Call trace:
  dump_stack_lvl+0x66/0xa0 (?:?)
  print_report+0xce/0x630 (?:?)
  ocfs2_fast_symlink_read_folio+0x12c/0x1f0 (fs/ocfs2/inode.c:?)
  srso_alias_return_thunk+0x5/0xfbef5 (?:?)
  __virt_addr_valid+0x19f/0x330 (?:?)
  kasan_report+0xe0/0x110 (?:?)
  kasan_check_range+0x105/0x1b0 (?:?)
  __asan_memcpy+0x23/0x60 (?:?)
  filemap_read_folio+0x27/0xe0 (?:?)
  filemap_read_folio+0x35/0xe0 (?:?)
  do_read_cache_folio+0x138/0x230 (?:?)
  __page_get_link+0x26/0x110 (?:?)
  page_get_link+0x2e/0x70 (?:?)
  vfs_readlink+0x15e/0x250 (?:?)
  touch_atime+0x4d/0x370 (?:?)
  do_readlinkat+0x186/0x200 (?:?)
  do_user_addr_fault+0x65a/0x890 (?:?)
  __x64_sys_readlink+0x46/0x60 (?:?)
  do_syscall_64+0x115/0x6a0 (arch/x86/entry/syscall_64.c:87)
  entry_SYSCALL_64_after_hwframe+0x77/0x7f (?:?)

Link: https://lore.kernel.org/20260528151230.361127-1-rollkingzzc@gmail.com
Fixes: ea022dfb3c2a ("ocfs: simplify symlink handling")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Gui-Dong Han <2045gemini@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/fs/ocfs2/inode.c~ocfs2-validate-fast-symlink-target-during-inode-read
+++ a/fs/ocfs2/inode.c
@@ -1639,6 +1639,29 @@ int ocfs2_validate_inode_block(struct su
 		}
 	}
 
+	if (S_ISLNK(le16_to_cpu(di->i_mode)) &&
+	    !le32_to_cpu(di->i_clusters)) {
+		int max_inline = ocfs2_fast_symlink_chars(sb);
+		u64 i_size = le64_to_cpu(di->i_size);
+
+		if (i_size >= max_inline) {
+			rc = ocfs2_error(sb,
+					 "Invalid dinode #%llu: fast symlink i_size %llu exceeds max %d\n",
+					 (unsigned long long)bh->b_blocknr,
+					 (unsigned long long)i_size,
+					 max_inline - 1);
+			goto bail;
+		}
+
+		if (strnlen((char *)di->id2.i_symlink, i_size + 1) != i_size) {
+			rc = ocfs2_error(sb,
+					 "Invalid dinode #%llu: fast symlink is not NUL-terminated at i_size %llu\n",
+					 (unsigned long long)bh->b_blocknr,
+					 (unsigned long long)i_size);
+			goto bail;
+		}
+	}
+
 	if (le32_to_cpu(di->i_flags) & OCFS2_CHAIN_FL) {
 		struct ocfs2_chain_list *cl = &di->id2.i_chain;
 		u16 bpc = 1 << (OCFS2_SB(sb)->s_clustersize_bits -
_

Patches currently in -mm which might be from rollkingzzc@gmail.com are

ocfs2-rebase-copied-fsdlm-lvb-pointers-in-locking_state.patch
ocfs2-reject-oversized-group-bitmap-descriptors.patch
ocfs2-validate-fast-symlink-target-during-inode-read.patch


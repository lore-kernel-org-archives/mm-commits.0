Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3363BBFB3
	for <mm-commits@vger.kernel.org>; Thu,  4 Jun 2026 21:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780609813; cv=none; b=gXX1hs2okqFp4yG8akrjMW9nGhUMGY251zYTf7Wc/EnHf4t0HmCuy6vuMIEL4WHoiZg0gJEHdfofWsu4JXAvyBjywcTp0QN3Hm40Bs6frvIoOccuxB5WwYSJTbCunjMcMI4jKYo9BfWuz31tZEDY3a7CQBn7PzVN14blXZHUoNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780609813; c=relaxed/simple;
	bh=bFuZX/XfPcvNkguAiseuRwVcyjslQzgl7LzT30VvJXk=;
	h=Date:To:From:Subject:Message-Id; b=NyeOEr22A/ssIGUdi4lHVfMXpdXJhFT+li/b2gw263EsB8Dw/Id9Y6XHa70/IWvkojJ+4u5GveptTARxZODKwhmxz5GYI0N6Tny8H4ul4Bpw6E6iUaLSGav3tP+eUMtKg5fePpf9twQKExgChXFbljVVpp+AOGr60gCcZW6oJ4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XwnLsoWI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XwnLsoWI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFEF21F00899;
	Thu,  4 Jun 2026 21:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780609811;
	bh=MViYMSjETF9weWSo0OCp7Fo0v8wauOw4X8KHnrSYy6g=;
	h=Date:To:From:Subject;
	b=XwnLsoWIjFLMGrlsFsQCEQu7fExCof173jWXop0k47W8I4EahRl9WTDjGSQr84oBL
	 /Fjl+DBQQQEbQt1Z00Ywse8t4WsTbUgOu/hPK25A249JnPzx6QvvHOGdXIZ+CHgajB
	 fHwb9Ge/IM9cL7TgIgwelxAUVGJwpZyG+iIze3gc=
Date: Thu, 04 Jun 2026 14:50:11 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,2045gemini@gmail.com,rollkingzzc@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-validate-fast-symlink-target-during-inode-read.patch removed from -mm tree
Message-Id: <20260604215011.AFEF21F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: validate fast symlink target during inode read
has been removed from the -mm tree.  Its filename was
     ocfs2-validate-fast-symlink-target-during-inode-read.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



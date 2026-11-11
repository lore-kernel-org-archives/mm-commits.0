Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794440610;
	b=W6dAnsrnghyniFOVvOOhYthaBo5qibcS4CQwlsulpCDQr8GtrQ1QyTxcSZ7IiXqKVGdD
	 3yIqEwkb1/foNVq3eALqOkKT7M9BN9QytsnboLER16zN0IdmfdGp0mHomFA8XhCkbGrQO
	 5Wz/u5ZUKqI5tiB71+4DqVpRBHV8cz57tJ92+NZoi3SJkTWqRyFc3TAPFKzYHzSuptTpC
	 zEafGGSYjI421zIa7kqp/VhVwit4auGjk8TojVtnPYMrsrBhSCMy3SgMZxgidSVvlzCiR
	 OHX6q7Gb2pMf6MmAAXcP7PdGqCilTfh9yIVQKwtP+iOVkGw3sEYAJHVoR/BTV3Xgpfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794440610;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=qTT3JjVgyfjL6SrNzvyIjKrpcE27CWiijiFo3Mo/wRU=;
	b=OJhIhgiOU8I1atWco/zcVMdDJpOANWhQXJeoKRAi/xoqeAMI7vtlCqUIkDWqcWOQZhq8
	 3S4OaueUWVhMGFyCSPONEcH9SARpEvqz2WtGsmRm+lKuUstmabnkL6xUYqrfZm8D4Eap1
	 qFF6CpTdmLonHKnJ1Q3wYJz3UUk/Djzhuq95hObRmubbfglEYdBWgs8cw87o5vZXKYzzw
	 WLom6yPTrB/R7zFwdsODQvr2M8cVh8sqQWSNVmrA8ZI0xMvZCJ51+aqNljYcgBSJk/63V
	 4fRctC9UsMa5Wvh4ko9KbQBAQsCEFcRAUuYLlHZ33g2PX0xjJgtA1QFf+YPtIAw/ybQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gme77uUu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01FC4606A335;
	Wed, 11 Nov 2026 23:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gme77uUu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EFBE1F00A05;
	Wed, 11 Nov 2026 23:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794440609;
	bh=qTT3JjVgyfjL6SrNzvyIjKrpcE27CWiijiFo3Mo/wRU=;
	h=Date:To:From:Subject;
	b=gme77uUu2HbgewHkNAPS3MY6kbp9ZEBycoJM6PEUTd645CArWXaIWyVPa1kB2a5va
	 woLPu6E6Y4uU8o3UM3gSgeGC8bOZvBHZg43lZ1vfwMvK1bCZrT0IsYqqujzlLP+6ms
	 tP/Bl5DVhVN5/LjrlCCTn7DpA06tmVLqV9uAreng=
Date: Wed, 11 Nov 2026 15:43:28 -0800
To: mm-commits@vger.kernel.org,vicky.yangwenfang@huawei.com,
	syzbot+42984127d45ad96219de@syzkaller.appspotmail.com,stable@vger.kernel.org,
	mark@fasheh.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,
	heming.zhao@suse.com,zhiyuanzhang912@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-kernel-bug-in-ocfs2_page_mkwrite-when-write_end-fails.patch added to mm-hotfixes-unstable branch
Message-Id: <20261111234329.5EFBE1F00A05@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: fix kernel BUG in ocfs2_page_mkwrite() when write_end fails
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ocfs2-fix-kernel-bug-in-ocfs2_page_mkwrite-when-write_end-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-kernel-bug-in-ocfs2_page_mkwrite-when-write_end-fails.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Zhiyuan Zhang <zhiyuanzhang912@gmail.com>
Subject: ocfs2: fix kernel BUG in ocfs2_page_mkwrite() when write_end fails
Date: Wed, 11 Nov 2026 02:34:44 +0000

syzbot reported a kernel BUG in the ocfs2 write fault path:

  (syz.0.17,5578,0):ocfs2_write_end_nolock:1945 ERROR: status = -30
  kernel BUG at fs/ocfs2/mmap.c:106!
  Call Trace:
   do_page_mkwrite+0x147/0x310 mm/memory.c:3879
   do_shared_fault mm/memory.c:6145 [inline]
   handle_mm_fault+0x1a53/0x3750 mm/memory.c:6943

__ocfs2_page_mkwrite() calls ocfs2_write_begin_nolock() and then
ocfs2_write_end_nolock(), and uses BUG_ON() to assert that the latter
returns the full length.  But ocfs2_write_end_nolock() can fail: since
commit 7f27ec978b0e ("ocfs2: call ocfs2_journal_access_di() before
ocfs2_journal_dirty() in ocfs2_write_end_nolock()") it gets journal
access to the inode buffer again, because the handle may have been
restarted since ocfs2_write_begin_nolock().  That fails with -EROFS or
-EIO once the journal has been aborted or jbd2 has seen write errors
on the device.  The syzbot reproducer gets there by shrinking the
backing loop device to zero with LOOP_SET_STATUS while writing to a
shared file mapping.

Handle the failure instead of crashing.  ocfs2_write_end_nolock()
leaves the mmap folio locked, because ocfs2_unlock_folios() skips it
when w_target_locked is set so that it can be returned with
VM_FAULT_LOCKED, and do_page_mkwrite() does not unlock it either when
->page_mkwrite() returns an error.  So unlock it and fail the fault;
the faulting task gets SIGBUS, like for the other errors in this
function.

For an mmap write ocfs2_write_end_nolock() returns either len or a
negative errno: inline data has already been converted to extents by
ocfs2_write_begin_nolock(), and copied is equal to len.

The BUG matters for local mounts, where the filesystem is expected to
go read-only and keep running after a journal abort.  On clustered
mounts ocfs2_abort() panics the node anyway as soon as it notices the
aborted journal.

Link: https://lore.kernel.org/20261111023444.22688-1-zhiyuanzhang912@gmail.com
Fixes: 7f27ec978b0e ("ocfs2: call ocfs2_journal_access_di() before ocfs2_journal_dirty() in ocfs2_write_end_nolock()")
Signed-off-by: Zhiyuan Zhang <zhiyuanzhang912@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: <syzbot+42984127d45ad96219de@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=42984127d45ad96219de
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: yangwenfang <vicky.yangwenfang@huawei.com>
Cc: <stable@vger.kernel.org>
---

 fs/ocfs2/mmap.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/mmap.c~ocfs2-fix-kernel-bug-in-ocfs2_page_mkwrite-when-write_end-fails
+++ a/fs/ocfs2/mmap.c
@@ -103,7 +103,17 @@ static vm_fault_t __ocfs2_page_mkwrite(s
 		goto out;
 	}
 	err = ocfs2_write_end_nolock(mapping, pos, len, len, fsdata);
-	BUG_ON(err != len);
+	if (err != len) {
+		/*
+		 * ocfs2_write_end_nolock() keeps the mmap folio locked so
+		 * that it can be returned to the VM with VM_FAULT_LOCKED.
+		 * On failure nobody else will unlock it, so do it here.
+		 */
+		folio_unlock(locked_folio);
+		mlog_errno(err);
+		ret = vmf_error(err);
+		goto out;
+	}
 	ret = VM_FAULT_LOCKED;
 out:
 	return ret;
_

Patches currently in -mm which might be from zhiyuanzhang912@gmail.com are

ocfs2-fix-kernel-bug-in-ocfs2_page_mkwrite-when-write_end-fails.patch


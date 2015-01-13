From: akpm@linux-foundation.org
Subject: + fs-affs-filec-fix-direct-io-writes-beyond-eof.patch added to
 -mm tree
Date: Mon, 12 Jan 2015 16:17:56 -0800
Message-ID: <54b46434.Oz5MhGsS7FIRf8n0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37500 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbbAMAR5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jan 2015 19:17:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs/file.c: fix direct IO writes beyond EOF
has been added to the -mm tree.  Its filename is
     fs-affs-filec-fix-direct-io-writes-beyond-eof.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-affs-filec-fix-direct-io-writes-beyond-eof.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-affs-filec-fix-direct-io-writes-beyond-eof.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs/file.c: fix direct IO writes beyond EOF

Use the same fallback to normal IO in case of write
operations beyond EOF as fat direct IO. This patch fixes

fsx file -d -Z -r 4096 -w 4096

Report:
129(129 mod 256): TRUNCATE DOWN from 0x3ff01 to 0xb3f6
130(130 mod 256): WRITE    0x22000 thru 0x2dfff (0xc000 bytes) HOLE

Thanks to Jan for helping me on this problem.

The ideal solution suggested by Jan Kara would be to use
cont_write_begin() but affs direct_IO shouldn't be used a lot anyway...

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/file.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN fs/affs/file.c~fs-affs-filec-fix-direct-io-writes-beyond-eof fs/affs/file.c
--- a/fs/affs/file.c~fs-affs-filec-fix-direct-io-writes-beyond-eof
+++ a/fs/affs/file.c
@@ -398,6 +398,13 @@ affs_direct_IO(int rw, struct kiocb *ioc
 	size_t count = iov_iter_count(iter);
 	ssize_t ret;
 
+	if (rw == WRITE) {
+		loff_t size = offset + count;
+
+		if (AFFS_I(inode)->mmu_private < size)
+			return 0;
+	}
+
 	ret = blockdev_direct_IO(rw, iocb, inode, iter, offset, affs_get_block);
 	if (ret < 0 && (rw & WRITE))
 		affs_write_failed(mapping, offset + count);
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
ocfs2-remove-unnecessary-else-in-ocfs2_set_acl.patch
fs-befs-linuxvfsc-remove-unnecessary-casting.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
fs-coda-dirc-forward-declaration-clean-up.patch
fs-ufs-superc-remove-unnecessary-casting.patch
fs-reiserfs-inodec-replace-0-by-null-for-pointers.patch
ptrace-remove-linux-compath-inclusion-under-config_compat.patch
vmcore-fix-pt_note-n_namesz-n_descsz-overflow-issue.patch
fs-affs-filec-replace-if-bug-by-bug_on.patch
fs-affs-filec-fix-direct-io-writes-beyond-eof.patch
linux-next.patch


From: akpm@linux-foundation.org
Subject: + aio-negative-offset-should-return-einval.patch added to -mm tree
Date: Wed, 09 Jan 2008 23:07:07 -0800
Message-ID: <200801100706.m0A76l2Q010179@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37333 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752383AbYAJHHf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 02:07:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, zach.brown@oracle.com


The patch titled
     aio: negative offset should return -EINVAL
has been added to the -mm tree.  Its filename is
     aio-negative-offset-should-return-einval.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aio: negative offset should return -EINVAL
From: Rusty Russell <rusty@rustcorp.com.au>

An AIO read or write should return -EINVAL if the offset is negative.
This check matches the one in pread and pwrite.

This was found by the libaio test suite.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Zach Brown <zach.brown@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/aio.c~aio-negative-offset-should-return-einval fs/aio.c
--- a/fs/aio.c~aio-negative-offset-should-return-einval
+++ a/fs/aio.c
@@ -1329,6 +1329,10 @@ static ssize_t aio_rw_vect_retry(struct 
 		opcode = IOCB_CMD_PWRITEV;
 	}
 
+	/* This matches the pread()/pwrite() logic */
+	if (iocb->ki_pos < 0)
+		return -EINVAL;
+
 	do {
 		ret = rw_op(iocb, &iocb->ki_iovec[iocb->ki_cur_seg],
 			    iocb->ki_nr_segs - iocb->ki_cur_seg,
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

modules-de-mutex-more-symbol-lookup-paths-in-the-module-code.patch
git-kbuild.patch
git-kvm.patch
git-libata-all.patch
git-scsi-misc.patch
kallsyms-should-prefer-non-weak-symbols.patch
virtio_net-remove-double-ether_setup.patch
modules-handle-symbols-that-have-a-zero-value.patch
modules-include-sectionsh-to-avoid-defining-linker-variables.patch
modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell.patch
modules-make-module_address_lookup-safe.patch
fixup-container_of-usage.patch
aio-partial-write-should-not-return-error-code.patch
aio-negative-offset-should-return-einval.patch
reiser4.patch

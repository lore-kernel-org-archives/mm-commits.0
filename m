From: akpm@linux-foundation.org
Subject: + aio-partial-write-should-not-return-error-code.patch added to -mm tree
Date: Wed, 09 Jan 2008 23:07:03 -0800
Message-ID: <200801100706.m0A76h13010171@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46024 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752550AbYAJHIL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 02:08:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, zach.brown@oracle.com


The patch titled
     aio: partial write should not return error code
has been added to the -mm tree.  Its filename is
     aio-partial-write-should-not-return-error-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aio: partial write should not return error code
From: Rusty Russell <rusty@rustcorp.com.au>

When an AIO write gets an error after writing some data (eg.  ENOSPC), it
should return the amount written already, not the error.  Just like write()
is supposed to.

This was found by the libaio test suite.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-By: Zach Brown <zach.brown@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN fs/aio.c~aio-partial-write-should-not-return-error-code fs/aio.c
--- a/fs/aio.c~aio-partial-write-should-not-return-error-code
+++ a/fs/aio.c
@@ -1347,6 +1347,13 @@ static ssize_t aio_rw_vect_retry(struct 
 	if ((ret == 0) || (iocb->ki_left == 0))
 		ret = iocb->ki_nbytes - iocb->ki_left;
 
+	/* If we managed to write some out we return that, rather than
+	 * the eventual error. */
+	if (opcode == IOCB_CMD_PWRITEV
+	    && ret < 0 && ret != -EIOCBQUEUED && ret != -EIOCBRETRY
+	    && iocb->ki_nbytes - iocb->ki_left)
+		ret = iocb->ki_nbytes - iocb->ki_left;
+
 	return ret;
 }
 
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

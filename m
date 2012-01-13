From: akpm@linux-foundation.org
Subject: [merged] fs-nfs-nfs4procc-fix-printk-warnings.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:37:44 -0800
Message-ID: <20120113203744.9093910004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:33312 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798Ab2AMUhp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:37:45 -0500
Received: by ghrr18 with SMTP id r18so207481ghr.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:37:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/nfs/nfs4proc.c: fix printk warnings
has been removed from the -mm tree.  Its filename was
     fs-nfs-nfs4procc-fix-printk-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/nfs/nfs4proc.c: fix printk warnings

i386 allmodconfig:

fs/nfs/nfs4proc.c: In function '__nfs4_get_acl_uncached':
fs/nfs/nfs4proc.c:3590: warning: format '%ld' expects type 'long int', but argument 4 has type 'size_t'
fs/nfs/nfs4proc.c:3590: warning: format '%ld' expects type 'long int', but argument 6 has type 'size_t'

Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/nfs4proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nfs/nfs4proc.c~fs-nfs-nfs4procc-fix-printk-warnings fs/nfs/nfs4proc.c
--- a/fs/nfs/nfs4proc.c~fs-nfs-nfs4procc-fix-printk-warnings
+++ a/fs/nfs/nfs4proc.c
@@ -3587,7 +3587,7 @@ static ssize_t __nfs4_get_acl_uncached(s
 		res.acl_flags |= NFS4_ACL_LEN_REQUEST;
 	resp_buf = page_address(pages[0]);
 
-	dprintk("%s  buf %p buflen %ld npages %d args.acl_len %ld\n",
+	dprintk("%s  buf %p buflen %zu npages %d args.acl_len %zu\n",
 		__func__, buf, buflen, npages, args.acl_len);
 	ret = nfs4_call_sync(NFS_SERVER(inode)->client, NFS_SERVER(inode),
 			     &msg, &args.seq_args, &res.seq_res, 0);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
drivers-scsi-megaraidc-fix-sparse-warnings-checkpatch-fixes.patch
drivers-usb-misc-emi26c-emi62c-fix-warnings.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
drivers-idle-intel_idlec-remove-redundant-local_irq_disable-call.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


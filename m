From: akpm@linux-foundation.org
Subject: - knfsd-fix-return-value-for-writes-to-some-files-in-nfsd-filesystem.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:47:43 -0800
Message-ID: <200702150847.l1F8lhCj025004@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39933 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965360AbXBOIrr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:47:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: fix return value for writes to some files in 'nfsd' filesystem
has been removed from the -mm tree.  Its filename was
     knfsd-fix-return-value-for-writes-to-some-files-in-nfsd-filesystem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: fix return value for writes to some files in 'nfsd' filesystem
From: NeilBrown <neilb@suse.de>

Most files in the 'nfsd' filesystem are transactional.  When you write, a
reply is generated that can be read back only on the same 'file'.

If the reply has zero length, the 'write' will incorrectly return a value of
'0' instead of the length that was written.  This causes 'rpc.nfsd' to give an
annoying warning.

This patch fixes the test.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfsctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nfsd/nfsctl.c~knfsd-fix-return-value-for-writes-to-some-files-in-nfsd-filesystem fs/nfsd/nfsctl.c
--- a/fs/nfsd/nfsctl.c~knfsd-fix-return-value-for-writes-to-some-files-in-nfsd-filesystem
+++ a/fs/nfsd/nfsctl.c
@@ -123,7 +123,7 @@ static ssize_t nfsctl_transaction_write(
 		return PTR_ERR(data);
 
 	rv =  write_op[ino](file, data, size);
-	if (rv>0) {
+	if (rv >= 0) {
 		simple_transaction_set(file, rv);
 		rv = size;
 	}
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
replace-highest_possible_node_id-with-nr_node_ids.patch
convert-highest_possible_processor_id-to-nr_cpu_ids.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
knfsd-nfsd4-fix-non-terminated-string.patch
knfsd-nfsd4-relax-checking-of-acl-inheritance-bits.patch
knfsd-nfsd4-simplify-nfsv4-posix-translation.patch
knfsd-nfsd4-represent-nfsv4-acl-with-array-instead-of-linked-list.patch
knfsd-nfsd4-fix-memory-leak-on-kmalloc-failure-in-savemem.patch
knfsd-nfsd4-fix-error-return-on-unsupported-acl.patch
knfsd-nfsd4-acls-dont-return-explicit-mask.patch
knfsd-nfsd4-acls-avoid-unnecessary-denies.patch
knfsd-nfsd4-fix-handling-of-directories-without-default-acls.patch
knfsd-stop-nfsd-writes-from-being-broken-into-lots-of-little-writes-to-filesystem.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch

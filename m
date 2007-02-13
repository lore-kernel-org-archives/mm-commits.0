From: akpm@linux-foundation.org
Subject: + knfsd-fix-return-value-for-writes-to-some-files-in-nfsd-filesystem.patch added to -mm tree
Date: Mon, 12 Feb 2007 23:09:09 -0800
Message-ID: <200702130709.l1D799uG024638@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57106 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbXBMHJh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 02:09:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     knfsd: fix return value for writes to some files in 'nfsd' filesystem
has been added to the -mm tree.  Its filename is
     knfsd-fix-return-value-for-writes-to-some-files-in-nfsd-filesystem.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
knfsd-fix-return-value-for-writes-to-some-files-in-nfsd-filesystem.patch
knfsd-tidy-up-choice-of-filesystem-identifier-when-creating-a-filehandle.patch
knfsd-add-some-new-fsid-types.patch
knfsd-allow-the-server-to-provide-a-gid-list-when-using-auth_unix-authentication.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
sysctl-remove-insert_at_head-from-register_sysctl.patch

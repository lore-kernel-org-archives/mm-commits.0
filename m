From: akpm@linux-foundation.org
Subject: - cifs-fix-range-check.patch removed from -mm tree
Date: Thu, 02 Oct 2008 17:14:27 -0700
Message-ID: <200810030014.m930ERsX001722@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38179 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753503AbYJCAZO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Oct 2008 20:25:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, sfrench@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     cifs: fix range check
has been removed from the -mm tree.  Its filename was
     cifs-fix-range-check.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cifs: fix range check
From: David Howells <dhowells@redhat.com>

Fix the CIFS range check to always use a big enough size variable that the
compiler won't moan about comparing it to ULONG_MAX/8 on a 64-bit platform.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Steven French <sfrench@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/asn1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/cifs/asn1.c~cifs-fix-range-check fs/cifs/asn1.c
--- a/fs/cifs/asn1.c~cifs-fix-range-check
+++ a/fs/cifs/asn1.c
@@ -394,8 +394,8 @@ asn1_oid_decode(struct asn1_ctx *ctx,
 		unsigned char *eoc, unsigned long **oid, unsigned int *len)
 {
 	unsigned long subid;
-	unsigned int size;
 	unsigned long *optr;
+	size_t size;
 
 	size = eoc - ctx->pointer + 1;
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
mm-tiny-shmem-nommu-fix.patch
git-v4l-dvb.patch
git-xfs.patch
git-mtd.patch
git-cifs.patch
git-drm.patch
git-security-testing.patch
cifs-fix-range-check.patch
uclinux-fix-gzip-header-parsing-in-binfmt_flatc.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-fix-3.patch
binfmt_elf_fdpic-support-auxvec-base-platform-string.patch
binfmt_elf_fdpic-convert-initial-stack-alignment-to-arch_align_stack.patch
binfmt_elf_fdpic-wire-up-at_execfd-at_execfn-at_secure.patch
sysctl-simplify-strategy.patch
afs-convert-to-new-aops.patch
mn10300-use-bcd2bin-bin2bcd.patch
mutex-subsystem-synchro-test-module.patch


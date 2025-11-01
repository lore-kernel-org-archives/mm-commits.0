Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87312727FE
	for <mm-commits@vger.kernel.org>; Sat,  1 Nov 2025 04:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761970236; cv=none; b=SUpCHaPKML00o/LWw5uFVRbTeqKYYLXDkXrA/MqE66Yy2gvUuPi0Y6jC76yGc5V9YrLC4GFQRA0qHGEjtdoWbpLLQT9VdssE5wMkhvPoeHVZaalTLvIZ63iFOhh21G6tHDV9ZN1dlFhurpam8epJ6QoYLfKrZKS9wWbT984gh2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761970236; c=relaxed/simple;
	bh=/uBp55Ck+/MLIJ2AK3phI406QNxrckvVYnQHeKSEqHg=;
	h=Date:To:From:Subject:Message-Id; b=e8lNctTRtl9/l1hmGKw4MX9gvT1Gl+Bi7AZB2u5HlQhdK3Pintpq8f42Ks/CVY2d8gbXh4SQXosODyzN1ZTfp1wPLcxSrhM/gveEaX9XqD9+TzI8bdpsuoQsNCrdR+u6ryd3VNn5xHUlfPIdCPH6TwOxZclpw2swVvFDhF6P2NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LIR6CRxo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LIR6CRxo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16843C4CEF1;
	Sat,  1 Nov 2025 04:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761970236;
	bh=/uBp55Ck+/MLIJ2AK3phI406QNxrckvVYnQHeKSEqHg=;
	h=Date:To:From:Subject:From;
	b=LIR6CRxoi6Yb+RU0b6qr99E1WnIyqkT86LTBJISonMwJDw/wMeEH0FGyT9TPPQS7I
	 SXJeNAYQnua6nc7tvBMzR/l2gl4Jyzzrox74acBGzUGYCMvEKkeaz2QSDJH4daK89t
	 YLei5U01vBj/PeONNREYFgUxb4Vi5BmQty1CLDeY=
Date: Fri, 31 Oct 2025 21:10:35 -0700
To: mm-commits@vger.kernel.org,xiubli@redhat.com,visitorckw@gmail.com,tytso@mit.edu,sagi@grimberg.me,kbusch@kernel.org,jaegeuk@kernel.org,idryomov@gmail.com,home7438072@gmail.com,hch@lst.de,ebiggers@kernel.org,axboe@kernel.dk,409411716@gms.tku.edu.tw,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ceph-replace-local-base64-helpers-with-lib-base64.patch added to mm-nonmm-unstable branch
Message-Id: <20251101041036.16843C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ceph: replace local base64 helpers with lib/base64
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ceph-replace-local-base64-helpers-with-lib-base64.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ceph-replace-local-base64-helpers-with-lib-base64.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Subject: ceph: replace local base64 helpers with lib/base64
Date: Wed, 29 Oct 2025 18:22:02 +0800

Remove the ceph_base64_encode() and ceph_base64_decode() functions and
replace their usage with the generic base64_encode() and base64_decode()
helpers from lib/base64.

This eliminates the custom implementation in Ceph, reduces code
duplication, and relies on the shared Base64 code in lib.  The helpers
preserve RFC 3501-compliant Base64 encoding without padding, so there are
no functional changes.

This change also improves performance: encoding is about 2.7x faster and
decoding achieves 43-52x speedups compared to the previous local
implementation.

Link: https://lkml.kernel.org/r/20251029102202.544118-1-409411716@gms.tku.edu.tw
Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Reviewed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Xiubo Li <xiubli@redhat.com>
Cc: Yu-Sheng Huang <home7438072@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ceph/crypto.c |   60 +++------------------------------------------
 fs/ceph/crypto.h |    6 ----
 fs/ceph/dir.c    |    5 ++-
 fs/ceph/inode.c  |    2 -
 4 files changed, 9 insertions(+), 64 deletions(-)

--- a/fs/ceph/crypto.c~ceph-replace-local-base64-helpers-with-lib-base64
+++ a/fs/ceph/crypto.c
@@ -15,59 +15,6 @@
 #include "mds_client.h"
 #include "crypto.h"
 
-/*
- * The base64url encoding used by fscrypt includes the '_' character, which may
- * cause problems in snapshot names (which can not start with '_').  Thus, we
- * used the base64 encoding defined for IMAP mailbox names (RFC 3501) instead,
- * which replaces '-' and '_' by '+' and ','.
- */
-static const char base64_table[65] =
-	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+,";
-
-int ceph_base64_encode(const u8 *src, int srclen, char *dst)
-{
-	u32 ac = 0;
-	int bits = 0;
-	int i;
-	char *cp = dst;
-
-	for (i = 0; i < srclen; i++) {
-		ac = (ac << 8) | src[i];
-		bits += 8;
-		do {
-			bits -= 6;
-			*cp++ = base64_table[(ac >> bits) & 0x3f];
-		} while (bits >= 6);
-	}
-	if (bits)
-		*cp++ = base64_table[(ac << (6 - bits)) & 0x3f];
-	return cp - dst;
-}
-
-int ceph_base64_decode(const char *src, int srclen, u8 *dst)
-{
-	u32 ac = 0;
-	int bits = 0;
-	int i;
-	u8 *bp = dst;
-
-	for (i = 0; i < srclen; i++) {
-		const char *p = strchr(base64_table, src[i]);
-
-		if (p == NULL || src[i] == 0)
-			return -1;
-		ac = (ac << 6) | (p - base64_table);
-		bits += 6;
-		if (bits >= 8) {
-			bits -= 8;
-			*bp++ = (u8)(ac >> bits);
-		}
-	}
-	if (ac & ((1 << bits) - 1))
-		return -1;
-	return bp - dst;
-}
-
 static int ceph_crypt_get_context(struct inode *inode, void *ctx, size_t len)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
@@ -318,7 +265,7 @@ int ceph_encode_encrypted_dname(struct i
 	}
 
 	/* base64 encode the encrypted name */
-	elen = ceph_base64_encode(cryptbuf, len, p);
+	elen = base64_encode(cryptbuf, len, p, false, BASE64_IMAP);
 	doutc(cl, "base64-encoded ciphertext name = %.*s\n", elen, p);
 
 	/* To understand the 240 limit, see CEPH_NOHASH_NAME_MAX comments */
@@ -412,7 +359,8 @@ int ceph_fname_to_usr(const struct ceph_
 			tname = &_tname;
 		}
 
-		declen = ceph_base64_decode(name, name_len, tname->name);
+		declen = base64_decode(name, name_len,
+				       tname->name, false, BASE64_IMAP);
 		if (declen <= 0) {
 			ret = -EIO;
 			goto out;
@@ -426,7 +374,7 @@ int ceph_fname_to_usr(const struct ceph_
 
 	ret = fscrypt_fname_disk_to_usr(dir, 0, 0, &iname, oname);
 	if (!ret && (dir != fname->dir)) {
-		char tmp_buf[CEPH_BASE64_CHARS(NAME_MAX)];
+		char tmp_buf[BASE64_CHARS(NAME_MAX)];
 
 		name_len = snprintf(tmp_buf, sizeof(tmp_buf), "_%.*s_%ld",
 				    oname->len, oname->name, dir->i_ino);
--- a/fs/ceph/crypto.h~ceph-replace-local-base64-helpers-with-lib-base64
+++ a/fs/ceph/crypto.h
@@ -8,6 +8,7 @@
 
 #include <crypto/sha2.h>
 #include <linux/fscrypt.h>
+#include <linux/base64.h>
 
 #define CEPH_FSCRYPT_BLOCK_SHIFT   12
 #define CEPH_FSCRYPT_BLOCK_SIZE    (_AC(1, UL) << CEPH_FSCRYPT_BLOCK_SHIFT)
@@ -89,11 +90,6 @@ static inline u32 ceph_fscrypt_auth_len(
  */
 #define CEPH_NOHASH_NAME_MAX (180 - SHA256_DIGEST_SIZE)
 
-#define CEPH_BASE64_CHARS(nbytes) DIV_ROUND_UP((nbytes) * 4, 3)
-
-int ceph_base64_encode(const u8 *src, int srclen, char *dst);
-int ceph_base64_decode(const char *src, int srclen, u8 *dst);
-
 void ceph_fscrypt_set_ops(struct super_block *sb);
 
 void ceph_fscrypt_free_dummy_policy(struct ceph_fs_client *fsc);
--- a/fs/ceph/dir.c~ceph-replace-local-base64-helpers-with-lib-base64
+++ a/fs/ceph/dir.c
@@ -998,13 +998,14 @@ static int prep_encrypted_symlink_target
 	if (err)
 		goto out;
 
-	req->r_path2 = kmalloc(CEPH_BASE64_CHARS(osd_link.len) + 1, GFP_KERNEL);
+	req->r_path2 = kmalloc(BASE64_CHARS(osd_link.len) + 1, GFP_KERNEL);
 	if (!req->r_path2) {
 		err = -ENOMEM;
 		goto out;
 	}
 
-	len = ceph_base64_encode(osd_link.name, osd_link.len, req->r_path2);
+	len = base64_encode(osd_link.name, osd_link.len,
+			    req->r_path2, false, BASE64_IMAP);
 	req->r_path2[len] = '\0';
 out:
 	fscrypt_fname_free_buffer(&osd_link);
--- a/fs/ceph/inode.c~ceph-replace-local-base64-helpers-with-lib-base64
+++ a/fs/ceph/inode.c
@@ -958,7 +958,7 @@ static int decode_encrypted_symlink(stru
 	if (!sym)
 		return -ENOMEM;
 
-	declen = ceph_base64_decode(encsym, enclen, sym);
+	declen = base64_decode(encsym, enclen, sym, false, BASE64_IMAP);
 	if (declen < 0) {
 		pr_err_client(cl,
 			"can't decode symlink (%d). Content: %.*s\n",
_

Patches currently in -mm which might be from 409411716@gms.tku.edu.tw are

lib-base64-rework-encode-decode-for-speed-and-stricter-validation.patch
lib-add-kunit-tests-for-base64-encoding-decoding.patch
fscrypt-replace-local-base64url-helpers-with-lib-base64.patch
ceph-replace-local-base64-helpers-with-lib-base64.patch


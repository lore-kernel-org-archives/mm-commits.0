From: akpm@linux-foundation.org
Subject: - ncpfs-use-get-put_unaligned_-helpers.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:49:42 -0700
Message-ID: <200804300549.m3U5ng6a030023@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36801 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758808AbYD3FuL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:50:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     ncpfs: use get/put_unaligned_* helpers
has been removed from the -mm tree.  Its filename was
     ncpfs-use-get-put_unaligned_-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ncpfs: use get/put_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/ncplib_kernel.c |   39 ++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff -puN fs/ncpfs/ncplib_kernel.c~ncpfs-use-get-put_unaligned_-helpers fs/ncpfs/ncplib_kernel.c
--- a/fs/ncpfs/ncplib_kernel.c~ncpfs-use-get-put_unaligned_-helpers
+++ a/fs/ncpfs/ncplib_kernel.c
@@ -102,48 +102,47 @@ static inline void ncp_init_request_s(st
 }
 
 static inline char *
- ncp_reply_data(struct ncp_server *server, int offset)
+ncp_reply_data(struct ncp_server *server, int offset)
 {
 	return &(server->packet[sizeof(struct ncp_reply_header) + offset]);
 }
 
-static inline __u8 BVAL(void* data)
+static inline u8 BVAL(void *data)
 {
-	return get_unaligned((__u8*)data);
+	return *(u8 *)data;
 }
 
-static __u8
- ncp_reply_byte(struct ncp_server *server, int offset)
+static u8 ncp_reply_byte(struct ncp_server *server, int offset)
 {
-	return get_unaligned((__u8 *) ncp_reply_data(server, offset));
+	return *(u8 *)ncp_reply_data(server, offset);
 }
 
-static inline __u16 WVAL_LH(void* data)
+static inline u16 WVAL_LH(void *data)
 {
-	return le16_to_cpu(get_unaligned((__le16*)data));
+	return get_unaligned_le16(data);
 }
 
-static __u16
- ncp_reply_le16(struct ncp_server *server, int offset)
+static u16
+ncp_reply_le16(struct ncp_server *server, int offset)
 {
-	return le16_to_cpu(get_unaligned((__le16 *) ncp_reply_data(server, offset)));
+	return get_unaligned_le16(ncp_reply_data(server, offset));
 }
 
-static __u16
- ncp_reply_be16(struct ncp_server *server, int offset)
+static u16
+ncp_reply_be16(struct ncp_server *server, int offset)
 {
-	return be16_to_cpu(get_unaligned((__be16 *) ncp_reply_data(server, offset)));
+	return get_unaligned_be16(ncp_reply_data(server, offset));
 }
 
-static inline __u32 DVAL_LH(void* data)
+static inline u32 DVAL_LH(void *data)
 {
-	return le32_to_cpu(get_unaligned((__le32*)data));
+	return get_unaligned_le32(data);
 }
 
 static __le32
- ncp_reply_dword(struct ncp_server *server, int offset)
+ncp_reply_dword(struct ncp_server *server, int offset)
 {
-	return get_unaligned((__le32 *) ncp_reply_data(server, offset));
+	return get_unaligned((__le32 *)ncp_reply_data(server, offset));
 }
 
 static inline __u32 ncp_reply_dword_lh(struct ncp_server* server, int offset) {
@@ -1006,8 +1005,8 @@ ncp_read_bounce(struct ncp_server *serve
 	result = ncp_request2(server, 72, bounce, bufsize);
 	ncp_unlock_server(server);
 	if (!result) {
-		int len = be16_to_cpu(get_unaligned((__be16*)((char*)bounce + 
-			  sizeof(struct ncp_reply_header))));
+		int len = get_unaligned_be16((char *)bounce +
+			  sizeof(struct ncp_reply_header));
 		result = -EIO;
 		if (len <= to_read) {
 			char* source;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
frv-fix-arch-frv-mm-unalignedo-build-error.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
git-kvm.patch
git-mips.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch


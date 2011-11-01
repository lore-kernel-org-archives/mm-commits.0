From: akpm@linux-foundation.org
Subject: [merged] security-follow-rename-pack_hex_byte-to-hex_byte_pack.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:16:35 -0700
Message-ID: <201111012116.pA1LGZlY011247@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:30277 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab1KAVQk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:16:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, jmorris@namei.org, zohar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: security: follow rename pack_hex_byte() to hex_byte_pack()
has been removed from the -mm tree.  Its filename was
     security-follow-rename-pack_hex_byte-to-hex_byte_pack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: security: follow rename pack_hex_byte() to hex_byte_pack()

There is no functional change.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Mimi Zohar <zohar@us.ibm.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/keys/encrypted-keys/encrypted.c |    2 +-
 security/keys/trusted.c                  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN security/keys/encrypted-keys/encrypted.c~security-follow-rename-pack_hex_byte-to-hex_byte_pack security/keys/encrypted-keys/encrypted.c
--- a/security/keys/encrypted-keys/encrypted.c~security-follow-rename-pack_hex_byte-to-hex_byte_pack
+++ a/security/keys/encrypted-keys/encrypted.c
@@ -293,7 +293,7 @@ static char *datablob_format(struct encr
 	/* convert the hex encoded iv, encrypted-data and HMAC to ascii */
 	bufp = &ascii_buf[len];
 	for (i = 0; i < (asciiblob_len - len) / 2; i++)
-		bufp = pack_hex_byte(bufp, iv[i]);
+		bufp = hex_byte_pack(bufp, iv[i]);
 out:
 	return ascii_buf;
 }
diff -puN security/keys/trusted.c~security-follow-rename-pack_hex_byte-to-hex_byte_pack security/keys/trusted.c
--- a/security/keys/trusted.c~security-follow-rename-pack_hex_byte-to-hex_byte_pack
+++ a/security/keys/trusted.c
@@ -1098,7 +1098,7 @@ static long trusted_read(const struct ke
 
 	bufp = ascii_buf;
 	for (i = 0; i < p->blob_len; i++)
-		bufp = pack_hex_byte(bufp, p->blob[i]);
+		bufp = hex_byte_pack(bufp, p->blob[i]);
 	if ((copy_to_user(buffer, ascii_buf, 2 * p->blob_len)) != 0) {
 		kfree(ascii_buf);
 		return -EFAULT;
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

origin.patch
linux-next.patch
selinuxfs-remove-custome-hex_to_bin.patch


From: akpm@linux-foundation.org
Subject: + security-follow-rename-pack_hex_byte-to-hex_byte_pack.patch added to -mm tree
Date: Tue, 18 Oct 2011 14:01:48 -0700
Message-ID: <201110182101.p9IL1nGB014440@hpaq7.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:15378 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab1JRVDF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2011 17:03:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andriy.shevchenko@linux.intel.com, jmorris@namei.org, zohar@us.ibm.com


The patch titled
     Subject: security: follow rename pack_hex_byte() to hex_byte_pack()
has been added to the -mm tree.  Its filename is
     security-follow-rename-pack_hex_byte-to-hex_byte_pack.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Subject: Subject: security: follow rename pack_hex_byte() to hex_byte_pack()

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

linux-next.patch
selinuxfs-remove-custome-hex_to_bin.patch
lib-rename-pack_hex_byte-to-hex_byte_pack.patch
kgdb-follow-rename-pack_hex_byte-to-hex_byte_pack.patch
security-follow-rename-pack_hex_byte-to-hex_byte_pack.patch
fat-follow-rename-pack_hex_byte-to-hex_byte_pack.patch
wireless-at76c50x-follow-rename-pack_hex_byte-to-hex_byte_pack.patch


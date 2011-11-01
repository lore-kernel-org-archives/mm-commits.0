From: akpm@linux-foundation.org
Subject: [merged] lib-rename-pack_hex_byte-to-hex_byte_pack.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:16:15 -0700
Message-ID: <201111012116.pA1LGFwl008082@hpaq11.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:16893 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab1KAVRI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:17:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, dhowells@redhat.com, hirofumi@mail.parknet.co.jp, jason.wessel@windriver.com, jesper.nilsson@axis.com, jmorris@namei.org, linville@tuxdriver.com, ya


The patch titled
     Subject: lib: rename pack_hex_byte() to hex_byte_pack()
has been removed from the -mm tree.  Its filename was
     lib-rename-pack_hex_byte-to-hex_byte_pack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib: rename pack_hex_byte() to hex_byte_pack()

As suggested by Andrew Morton in [1] there is better to have most
significant part first in the function name.

[1] https://lkml.org/lkml/2011/9/20/22

There is no functional change.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Mimi Zohar <zohar@us.ibm.com>
Cc: James Morris <jmorris@namei.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    7 ++++++-
 lib/vsprintf.c         |   14 +++++++-------
 2 files changed, 13 insertions(+), 8 deletions(-)

diff -puN include/linux/kernel.h~lib-rename-pack_hex_byte-to-hex_byte_pack include/linux/kernel.h
--- a/include/linux/kernel.h~lib-rename-pack_hex_byte-to-hex_byte_pack
+++ a/include/linux/kernel.h
@@ -372,13 +372,18 @@ extern const char hex_asc[];
 #define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
 #define hex_asc_hi(x)	hex_asc[((x) & 0xf0) >> 4]
 
-static inline char *pack_hex_byte(char *buf, u8 byte)
+static inline char *hex_byte_pack(char *buf, u8 byte)
 {
 	*buf++ = hex_asc_hi(byte);
 	*buf++ = hex_asc_lo(byte);
 	return buf;
 }
 
+static inline char * __deprecated pack_hex_byte(char *buf, u8 byte)
+{
+	return hex_byte_pack(buf, byte);
+}
+
 extern int hex_to_bin(char ch);
 extern int __must_check hex2bin(u8 *dst, const char *src, size_t count);
 
diff -puN lib/vsprintf.c~lib-rename-pack_hex_byte-to-hex_byte_pack lib/vsprintf.c
--- a/lib/vsprintf.c~lib-rename-pack_hex_byte-to-hex_byte_pack
+++ a/lib/vsprintf.c
@@ -547,7 +547,7 @@ char *mac_address_string(char *buf, char
 	}
 
 	for (i = 0; i < 6; i++) {
-		p = pack_hex_byte(p, addr[i]);
+		p = hex_byte_pack(p, addr[i]);
 		if (fmt[0] == 'M' && i != 5)
 			*p++ = separator;
 	}
@@ -667,13 +667,13 @@ char *ip6_compressed_string(char *p, con
 		lo = word & 0xff;
 		if (hi) {
 			if (hi > 0x0f)
-				p = pack_hex_byte(p, hi);
+				p = hex_byte_pack(p, hi);
 			else
 				*p++ = hex_asc_lo(hi);
-			p = pack_hex_byte(p, lo);
+			p = hex_byte_pack(p, lo);
 		}
 		else if (lo > 0x0f)
-			p = pack_hex_byte(p, lo);
+			p = hex_byte_pack(p, lo);
 		else
 			*p++ = hex_asc_lo(lo);
 		needcolon = true;
@@ -695,8 +695,8 @@ char *ip6_string(char *p, const char *ad
 	int i;
 
 	for (i = 0; i < 8; i++) {
-		p = pack_hex_byte(p, *addr++);
-		p = pack_hex_byte(p, *addr++);
+		p = hex_byte_pack(p, *addr++);
+		p = hex_byte_pack(p, *addr++);
 		if (fmt[0] == 'I' && i != 7)
 			*p++ = ':';
 	}
@@ -754,7 +754,7 @@ char *uuid_string(char *buf, char *end, 
 	}
 
 	for (i = 0; i < 16; i++) {
-		p = pack_hex_byte(p, addr[index[i]]);
+		p = hex_byte_pack(p, addr[index[i]]);
 		switch (i) {
 		case 3:
 		case 5:
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

origin.patch
linux-next.patch
selinuxfs-remove-custome-hex_to_bin.patch


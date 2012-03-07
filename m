From: akpm@linux-foundation.org
Subject: + fat-clean-up-xlate_to_uni.patch added to -mm tree
Date: Tue, 06 Mar 2012 16:26:20 -0800
Message-ID: <20120307002621.44212A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:60029 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757545Ab2CGA0W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Mar 2012 19:26:22 -0500
Received: by qcsp5 with SMTP id p5so720991qcs.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Mar 2012 16:26:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linkinjeon@gmail.com, cyberax82@gmail.com, hirofumi@mail.parknet.co.jp


The patch titled
     Subject: fat: clean up xlate_to_uni()
has been added to the -mm tree.  Its filename is
     fat-clean-up-xlate_to_uni.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: fat: clean up xlate_to_uni()

xlate_to_uni() is called by vfat_build_slots() with sbi->nls_io as the
final argument.  nls_io can never be null at this point because the check
is already being done in fat_fill_super() wherein the mount fails if it is
null.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Ravishankar N <cyberax82@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/namei_vfat.c |   83 ++++++++++++++++++------------------------
 1 file changed, 36 insertions(+), 47 deletions(-)

diff -puN fs/fat/namei_vfat.c~fat-clean-up-xlate_to_uni fs/fat/namei_vfat.c
--- a/fs/fat/namei_vfat.c~fat-clean-up-xlate_to_uni
+++ a/fs/fat/namei_vfat.c
@@ -521,57 +521,46 @@ xlate_to_uni(const unsigned char *name, 
 
 		op = &outname[*outlen * sizeof(wchar_t)];
 	} else {
-		if (nls) {
-			for (i = 0, ip = name, op = outname, *outlen = 0;
-			     i < len && *outlen <= FAT_LFN_LEN;
-			     *outlen += 1)
-			{
-				if (escape && (*ip == ':')) {
-					if (i > len - 5)
-						return -EINVAL;
-					ec = 0;
-					for (k = 1; k < 5; k++) {
-						nc = ip[k];
-						ec <<= 4;
-						if (nc >= '0' && nc <= '9') {
-							ec |= nc - '0';
-							continue;
-						}
-						if (nc >= 'a' && nc <= 'f') {
-							ec |= nc - ('a' - 10);
-							continue;
-						}
-						if (nc >= 'A' && nc <= 'F') {
-							ec |= nc - ('A' - 10);
-							continue;
-						}
-						return -EINVAL;
+		for (i = 0, ip = name, op = outname, *outlen = 0;
+			 i < len && *outlen <= FAT_LFN_LEN;
+			 *outlen += 1) {
+			if (escape && (*ip == ':')) {
+				if (i > len - 5)
+					return -EINVAL;
+				ec = 0;
+				for (k = 1; k < 5; k++) {
+					nc = ip[k];
+					ec <<= 4;
+					if (nc >= '0' && nc <= '9') {
+						ec |= nc - '0';
+						continue;
 					}
-					*op++ = ec & 0xFF;
-					*op++ = ec >> 8;
-					ip += 5;
-					i += 5;
-				} else {
-					if ((charlen = nls->char2uni(ip, len - i, (wchar_t *)op)) < 0)
-						return -EINVAL;
-					ip += charlen;
-					i += charlen;
-					op += 2;
+					if (nc >= 'a' && nc <= 'f') {
+						ec |= nc - ('a' - 10);
+						continue;
+					}
+					if (nc >= 'A' && nc <= 'F') {
+						ec |= nc - ('A' - 10);
+						continue;
+					}
+					return -EINVAL;
 				}
+				*op++ = ec & 0xFF;
+				*op++ = ec >> 8;
+				ip += 5;
+				i += 5;
+			} else {
+				charlen = nls->char2uni(ip, len - i,
+									(wchar_t *)op);
+				if (charlen < 0)
+					return -EINVAL;
+				ip += charlen;
+				i += charlen;
+				op += 2;
 			}
-			if (i < len)
-				return -ENAMETOOLONG;
-		} else {
-			for (i = 0, ip = name, op = outname, *outlen = 0;
-			     i < len && *outlen <= FAT_LFN_LEN;
-			     i++, *outlen += 1)
-			{
-				*op++ = *ip++;
-				*op++ = 0;
-			}
-			if (i < len)
-				return -ENAMETOOLONG;
 		}
+		if (i < len)
+			return -ENAMETOOLONG;
 	}
 
 	*longlen = *outlen;
_
Subject: Subject: fat: clean up xlate_to_uni()

Patches currently in -mm which might be from linkinjeon@gmail.com are

linux-next.patch
fat-clean-up-xlate_to_uni.patch
fat-fix-bug-in-enforcing-long-file-name-length.patch


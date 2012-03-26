From: akpm@linux-foundation.org
Subject: [merged] fat-fix-bug-in-enforcing-long-file-name-length.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:31:57 -0700
Message-ID: <20120326193157.64B54A00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:58674 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597Ab2CZTb6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:31:58 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so210371wgb.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:31:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linkinjeon@gmail.com, cyberax82@gmail.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: fix bug in enforcing Long File Name length
has been removed from the -mm tree.  Its filename was
     fat-fix-bug-in-enforcing-long-file-name-length.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: fat: fix bug in enforcing Long File Name length

Since '*outlen' is initialized to zero, it is currently possible to create
a filename of length (FAT_LFN_LEN + 1) when utf8 is not enabled.  To
enforce the FAT_LFN_LEN limit, we must perform one less iteration.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Ravishankar N <cyberax82@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/namei_vfat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/fat/namei_vfat.c~fat-fix-bug-in-enforcing-long-file-name-length fs/fat/namei_vfat.c
--- a/fs/fat/namei_vfat.c~fat-fix-bug-in-enforcing-long-file-name-length
+++ a/fs/fat/namei_vfat.c
@@ -522,7 +522,7 @@ xlate_to_uni(const unsigned char *name, 
 		op = &outname[*outlen * sizeof(wchar_t)];
 	} else {
 		for (i = 0, ip = name, op = outname, *outlen = 0;
-			 i < len && *outlen <= FAT_LFN_LEN;
+			 i < len && *outlen < FAT_LFN_LEN;
 			 *outlen += 1) {
 			if (escape && (*ip == ':')) {
 				if (i > len - 5)
_

Patches currently in -mm which might be from linkinjeon@gmail.com are

origin.patch
linux-next.patch


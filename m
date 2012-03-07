From: akpm@linux-foundation.org
Subject: + fat-fix-bug-in-enforcing-long-file-name-length.patch added to -mm tree
Date: Tue, 06 Mar 2012 16:26:22 -0800
Message-ID: <20120307002622.ECB31A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:48628 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759311Ab2CGA0Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Mar 2012 19:26:25 -0500
Received: by wejx9 with SMTP id x9so230316wej.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Mar 2012 16:26:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linkinjeon@gmail.com, cyberax82@gmail.com, hirofumi@mail.parknet.co.jp


The patch titled
     Subject: fat: fix bug in enforcing Long File Name length
has been added to the -mm tree.  Its filename is
     fat-fix-bug-in-enforcing-long-file-name-length.patch

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
Subject: Subject: fat: fix bug in enforcing Long File Name length

Patches currently in -mm which might be from linkinjeon@gmail.com are

linux-next.patch
fat-clean-up-xlate_to_uni.patch
fat-fix-bug-in-enforcing-long-file-name-length.patch


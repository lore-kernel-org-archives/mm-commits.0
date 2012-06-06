From: akpm@linux-foundation.org
Subject: + hfsplus-use-enomem-when-kzalloc-fails.patch added to -mm tree
Date: Wed, 06 Jun 2012 15:36:40 -0700
Message-ID: <20120606223640.8F26BA02F8@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:36550 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab2FFWgm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2012 18:36:42 -0400
Received: by fat25 with SMTP id 25so178498fat.1
        for <mm-commits@vger.kernel.org>; Wed, 06 Jun 2012 15:36:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linkinjeon@gmail.com


The patch titled
     Subject: hfsplus: use -ENOMEM when kzalloc() fails
has been added to the -mm tree.  Its filename is
     hfsplus-use-enomem-when-kzalloc-fails.patch

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
Subject: hfsplus: use -ENOMEM when kzalloc() fails

Use -ENOMEM return value instead of -EINVAL when kzalloc() fails.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/hfsplus/super.c~hfsplus-use-enomem-when-kzalloc-failed fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~hfsplus-use-enomem-when-kzalloc-failed
+++ a/fs/hfsplus/super.c
@@ -347,7 +347,7 @@ static int hfsplus_fill_super(struct sup
 	u64 last_fs_block, last_fs_page;
 	int err;
 
-	err = -EINVAL;
+	err = -ENOMEM;
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
 		goto out;
_
Subject: Subject: hfsplus: use -ENOMEM when kzalloc() fails

Patches currently in -mm which might be from linkinjeon@gmail.com are

drivers-scsi-ufs-reverse-the-ufshcd_is_device_present-logic.patch
ufs-fix-incorrect-return-value-about-success-and-failed.patch
hfsplus-use-enomem-when-kzalloc-fails.patch


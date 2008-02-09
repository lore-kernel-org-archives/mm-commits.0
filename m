From: akpm@linux-foundation.org
Subject: + memstick-fix-attribute-structure-casting-in-mspro_block_resume.patch added to -mm tree
Date: Sat, 09 Feb 2008 10:17:52 -0800
Message-ID: <200802091818.m19IIiJN025509@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50129 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752654AbYBISU1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 9 Feb 2008 13:20:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oakad@yahoo.com


The patch titled
     memstick: fix attribute structure casting in mspro_block_resume
has been added to the -mm tree.  Its filename is
     memstick-fix-attribute-structure-casting-in-mspro_block_resume.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memstick: fix attribute structure casting in mspro_block_resume
From: Alex Dubov <oakad@yahoo.com>

Signed-off-by: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/mspro_block.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN drivers/memstick/core/mspro_block.c~memstick-fix-attribute-structure-casting-in-mspro_block_resume drivers/memstick/core/mspro_block.c
--- a/drivers/memstick/core/mspro_block.c~memstick-fix-attribute-structure-casting-in-mspro_block_resume
+++ a/drivers/memstick/core/mspro_block.c
@@ -1237,7 +1237,7 @@ static int mspro_block_resume(struct mem
 
 	struct mspro_block_data *new_msb;
 	struct memstick_host *host = card->host;
-	struct mspro_sys_attr s_attr, r_attr;
+	struct mspro_sys_attr *s_attr, *r_attr;
 	unsigned char cnt;
 
 	mutex_lock(&host->lock);
@@ -1254,12 +1254,8 @@ static int mspro_block_resume(struct mem
 
 	for (cnt = 0; new_msb->attr_group.attrs[cnt]
 		      && msb->attr_group.attrs[cnt]; ++cnt) {
-		s_attr = container_of(new_msb->attr_group.attrs[cnt],
-				      struct mspro_sys_attr,
-				      dev_attr);
-		r_attr = container_of(msb->attr_group.attrs[cnt],
-				      struct mspro_sys_attr,
-				      dev_attr);
+		s_attr = mspro_from_sysfs_attr(new_msb->attr_group.attrs[cnt]);
+		r_attr = mspro_from_sysfs_attr(msb->attr_group.attrs[cnt]);
 
 		if (s_attr->id == MSPRO_BLOCK_ID_SYSINFO
 		    && r_attr->id == s_attr->id) {
_

Patches currently in -mm which might be from oakad@yahoo.com are

origin.patch
memstick-initial-commit-for-sony-memorystick-support.patch
memstick-initial-commit-for-sony-memorystick-support-fix-2.patch
updates-for-the-memstick-driver.patch
memstick-use-__blk_end_request-to-complete-requests.patch
memstick-fix-attribute-structure-casting-in-mspro_block_resume.patch
memstick-disable-busted-code.patch

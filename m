From: akpm@linux-foundation.org
Subject: + ocfs2-use-memweight.patch added to -mm tree
Date: Mon, 11 Jun 2012 16:17:47 -0700
Message-ID: <20120611231748.1E016A0137@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:55824 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab2FKXRu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 19:17:50 -0400
Received: by bkty5 with SMTP id y5so253004bkt.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 16:17:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, jlbec@evilplan.org, mfasheh@suse.com


The patch titled
     Subject: ocfs2: use memweight()
has been added to the -mm tree.  Its filename is
     ocfs2-use-memweight.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: ocfs2: use memweight()

Use memweight to count the total number of bits set in memory area.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/localalloc.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/localalloc.c~ocfs2-use-memweight fs/ocfs2/localalloc.c
--- a/fs/ocfs2/localalloc.c~ocfs2-use-memweight
+++ a/fs/ocfs2/localalloc.c
@@ -784,14 +784,10 @@ bail:
 
 static u32 ocfs2_local_alloc_count_bits(struct ocfs2_dinode *alloc)
 {
-	int i;
-	u8 *buffer;
-	u32 count = 0;
+	u32 count;
 	struct ocfs2_local_alloc *la = OCFS2_LOCAL_ALLOC(alloc);
 
-	buffer = la->la_bitmap;
-	for (i = 0; i < le16_to_cpu(la->la_size); i++)
-		count += hweight8(buffer[i]);
+	count = memweight(la->la_bitmap, le16_to_cpu(la->la_size));
 
 	trace_ocfs2_local_alloc_count_bits(count);
 	return count;
_
Subject: Subject: ocfs2: use memweight()

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
ocfs2-use-find_last_bit.patch
ocfs2-use-bitmap_weight.patch
string-introduce-memweight.patch
string-introduce-memweight-fix.patch
qnx4fs-use-memweight.patch
dm-use-memweight.patch
affs-use-memweight.patch
video-uvc-use-memweight.patch
ocfs2-use-memweight.patch
ext2-use-memweight.patch
ext3-use-memweight.patch
ext4-use-memweight.patch


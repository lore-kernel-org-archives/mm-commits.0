From: akpm@linux-foundation.org
Subject: + hfsplus-identify-journal-info-block-in-volume-header.patch added to -mm tree
Date: Fri, 21 Nov 2008 12:34:33 -0800
Message-ID: <200811212034.mALKYXP5029807@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42161 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752695AbYKUUfJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 15:35:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wt@penguintechs.org, zippel@linux-m68k.org


The patch titled
     hfsplus: identify journal info block in volume header
has been added to the -mm tree.  Its filename is
     hfsplus-identify-journal-info-block-in-volume-header.patch

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
Subject: hfsplus: identify journal info block in volume header
From: Warren Turkal <wt@penguintechs.org>

This is a patchset to change the way that the HFS+ filesystem detects
whether a volume has a journal or not.

The code currently mounts an HFS+ volume read-only by default when a
journal is detected.  One can force a read/write mount by giving the
"force" mount option.  The current code has this behavior since there is
no support for the HFS+ journal.

My problem is that the detection of the journal could be better.  The
current code tests the attribute bit in the volume header that indicates
there is a journal.  If that bit is set, the code assumes that there is a
journal.

Unfortunately, this is not enough to really determine if there is a
journal or not.  When that bit is set, one must also examine the journal
info block field of the volume header.  If this field is 0, there is no
journal, and the volume can be mounted read/write.


This patch:

The HFS+ support in the kernel currently will mount an HFS+ volume
read-only if the volume header has the attribute bit set that indicates
there is a journal.  The kernel does this because there is no support for
a journalled HFS+ volume.

The problem is that this is only half of what needs to be checked to see
if there really is a journal.  There is also an entry in the volume header
that tells you where to find the journal info block.  In the kernel
version of the kernel, this 4 byte block is labeled reserved.  This patch
identifies the journal info block in the header.

Signed-off-by: Warren Turkal <wt@penguintechs.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/hfsplus_raw.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/hfsplus/hfsplus_raw.h~hfsplus-identify-journal-info-block-in-volume-header fs/hfsplus/hfsplus_raw.h
--- a/fs/hfsplus/hfsplus_raw.h~hfsplus-identify-journal-info-block-in-volume-header
+++ a/fs/hfsplus/hfsplus_raw.h
@@ -94,7 +94,7 @@ struct hfsplus_vh {
 	__be16 version;
 	__be32 attributes;
 	__be32 last_mount_vers;
-	u32 reserved;
+	__be32 journal_info_block;
 
 	__be32 create_date;
 	__be32 modify_date;
_

Patches currently in -mm which might be from wt@penguintechs.org are

hfsplus-identify-journal-info-block-in-volume-header.patch
hfsplus-fix-journal-detection.patch


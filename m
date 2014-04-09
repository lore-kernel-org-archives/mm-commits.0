From: akpm@linux-foundation.org
Subject: + fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
 added to -mm tree
Date: Wed, 09 Apr 2014 13:54:06 -0700
Message-ID: <5345b36e.kXd6r2d5yaN5Th/F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38011 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933885AbaDIUyH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Apr 2014 16:54:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, fabf@skynet.be

Subject: + fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch added to -mm tree
To: fabf@skynet.be,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Wed, 09 Apr 2014 13:54:06 -0700


The patch titled
     Subject: fs/ocfs2/super.c: use OCFS2_MAX_VOL_LABEL_LEN and strlcpy
has been added to the -mm tree.  Its filename is
     fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/ocfs2/super.c: use OCFS2_MAX_VOL_LABEL_LEN and strlcpy

Replace strncpy(size 63) by defined value.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/super.c~fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy
+++ a/fs/ocfs2/super.c
@@ -2292,8 +2292,8 @@ static int ocfs2_initialize_super(struct
 		goto bail;
 	}
 
-	strncpy(osb->vol_label, di->id2.i_super.s_label, 63);
-	osb->vol_label[63] = '\0';
+	strlcpy(osb->vol_label, di->id2.i_super.s_label,
+		OCFS2_MAX_VOL_LABEL_LEN);
 	osb->root_blkno = le64_to_cpu(di->id2.i_super.s_root_blkno);
 	osb->system_dir_blkno = le64_to_cpu(di->id2.i_super.s_system_dir_blkno);
 	osb->first_cluster_group_blkno =
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
ntfs-remove-null-value-assignments.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
linux-next.patch
ufs-sb-mutex-merge-mutex_destroy.patch


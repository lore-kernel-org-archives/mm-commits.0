From: akpm@linux-foundation.org
Subject: + ocfs2-remove-unnecessary-else-in-ocfs2_set_acl.patch added to
 -mm tree
Date: Mon, 22 Dec 2014 13:07:22 -0800
Message-ID: <5498880a.UNTIG50KosMq1032%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37333 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294AbaLVVHX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Dec 2014 16:07:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove unnecessary else in ocfs2_set_acl()
has been added to the -mm tree.  Its filename is
     ocfs2-remove-unnecessary-else-in-ocfs2_set_acl.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-remove-unnecessary-else-in-ocfs2_set_acl.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-remove-unnecessary-else-in-ocfs2_set_acl.patch

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
Subject: ocfs2: remove unnecessary else in ocfs2_set_acl()

else is unnecessary after return.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/acl.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN fs/ocfs2/acl.c~ocfs2-remove-unnecessary-else-in-ocfs2_set_acl fs/ocfs2/acl.c
--- a/fs/ocfs2/acl.c~ocfs2-remove-unnecessary-else-in-ocfs2_set_acl
+++ a/fs/ocfs2/acl.c
@@ -245,16 +245,14 @@ int ocfs2_set_acl(handle_t *handle,
 			ret = posix_acl_equiv_mode(acl, &mode);
 			if (ret < 0)
 				return ret;
-			else {
-				if (ret == 0)
-					acl = NULL;
 
-				ret = ocfs2_acl_set_mode(inode, di_bh,
-							 handle, mode);
-				if (ret)
-					return ret;
+			if (ret == 0)
+				acl = NULL;
 
-			}
+			ret = ocfs2_acl_set_mode(inode, di_bh,
+						 handle, mode);
+			if (ret)
+				return ret;
 		}
 		break;
 	case ACL_TYPE_DEFAULT:
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
ocfs2-remove-unnecessary-else-in-ocfs2_set_acl.patch
vmcore-fix-pt_note-n_namesz-n_descsz-overflow-issue.patch
linux-next.patch


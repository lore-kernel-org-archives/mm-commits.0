From: akpm@linux-foundation.org
Subject: + fsnotify-remove-alignment-padding-from-fsnotify_mark-on-64-bit-builds.patch added to -mm tree
Date: Wed, 06 Oct 2010 13:59:58 -0700
Message-ID: <201010062059.o96KxwQq021502@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38295 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932956Ab0JFVAf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Oct 2010 17:00:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@rsk.demon.co.uk, eparis@redhat.com


The patch titled
     fsnotify: remove alignment padding from fsnotify_mark on 64 bit builds
has been added to the -mm tree.  Its filename is
     fsnotify-remove-alignment-padding-from-fsnotify_mark-on-64-bit-builds.patch

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
Subject: fsnotify: remove alignment padding from fsnotify_mark on 64 bit builds
From: Richard Kennedy <richard@rsk.demon.co.uk>

Reorder struct fsnotfiy_mark to remove 8 bytes of alignment padding on 64
bit builds.  Shrinks fsnotfiy_mark to 128 bytes allowing more objects per
slab in its kmem_cache and reduces the number of cachelines needed for
each structure.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fsnotify_backend.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/fsnotify_backend.h~fsnotify-remove-alignment-padding-from-fsnotify_mark-on-64-bit-builds include/linux/fsnotify_backend.h
--- a/include/linux/fsnotify_backend.h~fsnotify-remove-alignment-padding-from-fsnotify_mark-on-64-bit-builds
+++ a/include/linux/fsnotify_backend.h
@@ -275,8 +275,8 @@ struct fsnotify_mark {
 		struct fsnotify_inode_mark i;
 		struct fsnotify_vfsmount_mark m;
 	};
-	__u32 ignored_mask;		/* events types to ignore */
 	struct list_head free_g_list;	/* tmp list used when freeing this mark */
+	__u32 ignored_mask;		/* events types to ignore */
 #define FSNOTIFY_MARK_FLAG_INODE		0x01
 #define FSNOTIFY_MARK_FLAG_VFSMOUNT		0x02
 #define FSNOTIFY_MARK_FLAG_OBJECT_PINNED	0x04
_

Patches currently in -mm which might be from richard@rsk.demon.co.uk are

linux-next.patch
fsnotify-remove-alignment-padding-from-fsnotify_mark-on-64-bit-builds.patch
timer_list-remove-alignment-padding-on-64-bit-when-config_timer_stats.patch
mm-remove-alignment-padding-from-anon_vma-on-some-64-bit-builds.patch


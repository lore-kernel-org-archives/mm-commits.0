From: akpm@linux-foundation.org
Subject: [merged] jffs2-fixup-rb_root-initializations-to-use-rb_root.patch removed from -mm tree
Date: Fri, 19 Mar 2010 12:49:02 -0400
Message-ID: <201003191949.o2JJnjuW008995@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47598 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750966Ab0CSTuD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 15:50:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: venkatesh.pallipadi@intel.com, dwmw2@infradead.org, eparis@redhat.com, mm-commits@vger.kernel.org


The patch titled
     jffs2: fix up rb_root initializations to use RB_ROOT
has been removed from the -mm tree.  Its filename was
     jffs2-fixup-rb_root-initializations-to-use-rb_root.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jffs2: fix up rb_root initializations to use RB_ROOT
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

jffs2 uses rb_node = NULL; to zero rb_root.

The problem with this is that 17d9ddc72fb8bba0d4f678 ("rbtree: Add support
for augmented rbtrees") in the linux-next tree adds a new field to that
struct which needs to be NULLas well.  This patch uses RB_ROOT as the
intializer so all of the relevant fields will be NULL'd.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Eric Paris <eparis@redhat.com>
Acked-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/readinode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/jffs2/readinode.c~jffs2-fixup-rb_root-initializations-to-use-rb_root fs/jffs2/readinode.c
--- a/fs/jffs2/readinode.c~jffs2-fixup-rb_root-initializations-to-use-rb_root
+++ a/fs/jffs2/readinode.c
@@ -567,7 +567,7 @@ static void jffs2_free_tmp_dnode_info_li
 			else BUG();
 		}
 	}
-	list->rb_node = NULL;
+	*list = RB_ROOT;
 }
 
 static void jffs2_free_full_dirent_list(struct jffs2_full_dirent *fd)
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

origin.patch
linux-next.patch
arch-x86-kernel-hpetc-fix-bug-in-rtc-emulation.patch
cpufreq-unexport-unlock_policy_rwsem-functions.patch
cpufreq-fix-a-lockdep-warning.patch
ext3-fixup-rb_root-initializations-to-use-rb_root.patch


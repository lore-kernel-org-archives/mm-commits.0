From: akpm@linux-foundation.org
Subject: + jffs2-fixup-rb_root-initializations-to-use-rb_root.patch added to -mm tree
Date: Wed, 24 Feb 2010 15:07:24 -0800
Message-ID: <201002242307.o1ON7OuN025805@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38652 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758228Ab0BXXJP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 18:09:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com, dwmw2@infradead.org, eparis@redhat.com


The patch titled
     jffs2: fix up rb_root initializations to use RB_ROOT
has been added to the -mm tree.  Its filename is
     jffs2-fixup-rb_root-initializations-to-use-rb_root.patch

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
Subject: jffs2: fix up rb_root initializations to use RB_ROOT
From: venkatesh.pallipadi@intel.com

jffs2 uses rb_node = NULL; to zero rb_root.

The problem with this is that 17d9ddc72fb8bba0d4f678 ("rbtree: Add support
for augmented rbtrees") in the linux-next tree adds a new field to that
struct which needs to be NULLas well.  This patch uses RB_ROOT as the
intializer so all of the relevant fields will be NULL'd.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
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
ext4-fixup-rb_root-initializations-to-use-rb_root.patch
ext3-fixup-rb_root-initializations-to-use-rb_root.patch
jffs2-fixup-rb_root-initializations-to-use-rb_root.patch


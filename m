From: akpm@linux-foundation.org
Subject: + ext3-fixup-rb_root-initializations-to-use-rb_root.patch added to -mm tree
Date: Wed, 24 Feb 2010 15:07:22 -0800
Message-ID: <201002242307.o1ON7M7D025802@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36952 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758181Ab0BXXHo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 18:07:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com, eparis@redhat.com, jack@suse.cz


The patch titled
     ext3: fix up rb_root initializations to use RB_ROOT
has been added to the -mm tree.  Its filename is
     ext3-fixup-rb_root-initializations-to-use-rb_root.patch

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
Subject: ext3: fix up rb_root initializations to use RB_ROOT
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

ext3 uses rb_node = NULL; to zero rb_root.

The problem with this is that 17d9ddc72fb8bba0d4f678 ("rbtree: Add support
for augmented rbtrees") in the linux-next tree adds a new field to that
struct which needs to be NULLas well.  This patch uses RB_ROOT as the
intializer so all of the relevant fields will be NULL'd.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ext3/dir.c~ext3-fixup-rb_root-initializations-to-use-rb_root fs/ext3/dir.c
--- a/fs/ext3/dir.c~ext3-fixup-rb_root-initializations-to-use-rb_root
+++ a/fs/ext3/dir.c
@@ -297,7 +297,7 @@ static void free_rb_tree_fname(struct rb
 			kfree (old);
 		}
 		if (!parent)
-			root->rb_node = NULL;
+			*root = RB_ROOT;
 		else if (parent->rb_left == n)
 			parent->rb_left = NULL;
 		else if (parent->rb_right == n)
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

origin.patch
linux-next.patch
arch-x86-kernel-hpetc-fix-bug-in-rtc-emulation.patch
ext4-fixup-rb_root-initializations-to-use-rb_root.patch
ext3-fixup-rb_root-initializations-to-use-rb_root.patch
jffs2-fixup-rb_root-initializations-to-use-rb_root.patch


From: akpm@linux-foundation.org
Subject: +
 hfshfsplus-cache-pages-correctly-between-bnode_create-and-bnode_free.patch
 added to -mm tree
Date: Tue, 07 Jul 2015 15:20:09 -0700
Message-ID: <559c5099.Wxhtro4mxqVwSuv6%akpm__3603.94637468762$1436307627$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59530 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617AbbGGWUK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jul 2015 18:20:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htl10@users.sourceforge.net, akpm@osdl.org, anton@tuxera.com, hch@infradead.org, saproj@gmail.com, sasha.levin@oracle.com, slava@dubeyko.com, sougata@tuxera.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Subject: hfs,hfsplus: cache pages correctly between bnode_create and bnode_free
has been added to the -mm tree.  Its filename is
     hfshfsplus-cache-pages-correctly-between-bnode_create-and-bnode_free.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfshfsplus-cache-pages-correctly-between-bnode_create-and-bnode_free.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfshfsplus-cache-pages-correctly-between-bnode_create-and-bnode_free.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Subject: hfs,hfsplus: cache pages correctly between bnode_create and bnode_free

Pages looked up by __hfs_bnode_create() (called by hfs_bnode_create() and
hfs_bnode_find() for finding or creating pages corresponding to an inode)
are immediately kmap()'ed and used (both read and write) and kunmap()'ed,
and should not be page_cache_release()'ed until hfs_bnode_free().

This patch fixes a problem I first saw in July 2012: merely running "du"
on a large hfsplus-mounted directory a few times on a reasonably loaded
system would get the hfsplus driver all confused and complaining about
B-tree inconsistencies, and generates a "BUG: Bad page state".  Most
recently, I can generate this problem on up-to-date Fedora 22 with shipped
kernel 4.0.5, by running "du /" (="/" + "/home" + "/mnt" + other smaller
mounts) and "du /mnt" simultaneously on two windows, where /mnt is a
lightly-used QEMU VM image of the full Mac OS X 10.9:

$ df -i / /home /mnt
Filesystem                  Inodes   IUsed      IFree IUse% Mounted on
/dev/mapper/fedora-root    3276800  551665    2725135   17% /
/dev/mapper/fedora-home   52879360  716221   52163139    2% /home
/dev/nbd0p2             4294967295 1387818 4293579477    1% /mnt

After applying the patch, I was able to run "du /" (60+ times) and "du
/mnt" (150+ times) continuously and simultaneously for 6+ hours.

There are many reports of the hfsplus driver getting confused under load
and generating "BUG: Bad page state" or other similar issues over the
years.  [1]

The unpatched code [2] has always been wrong since it entered the kernel
tree.  The only reason why it gets away with it is that the
kmap/memcpy/kunmap follow very quickly after the page_cache_release() so
the kernel has not had a chance to reuse the memory for something else,
most of the time.

The current RW driver appears to have followed the design and development
of the earlier read-only hfsplus driver [3], where-by version 0.1 (Dec
2001) had a B-tree node-centric approach to
read_cache_page()/page_cache_release() per bnode_get()/bnode_put(),
migrating towards version 0.2 (June 2002) of caching and releasing pages
per inode extents.  When the current RW code first entered the kernel [2]
in 2005, there was an REF_PAGES conditional (and "//" commented out code)
to switch between B-node centric paging to inode-centric paging.  There
was a mistake with the direction of one of the REF_PAGES conditionals in
__hfs_bnode_create().  In a subsequent "remove debug code" commit [4], the
read_cache_page()/page_cache_release() per bnode_get()/bnode_put() were
removed, but a page_cache_release() was mistakenly left in (propagating
the "REF_PAGES <-> !REF_PAGE" mistake), and the commented-out
page_cache_release() in bnode_release() (which should be spanned by
!REF_PAGES) was never enabled.

References:
[1]:
Michael Fox, Apr 2013
http://www.spinics.net/lists/linux-fsdevel/msg63807.html
("hfsplus volume suddenly inaccessable after 'hfs: recoff %d too large'")

Sasha Levin, Feb 2015
http://lkml.org/lkml/2015/2/20/85 ("use after free")

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/740814
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1027887
https://bugzilla.kernel.org/show_bug.cgi?id=42342
https://bugzilla.kernel.org/show_bug.cgi?id=63841
https://bugzilla.kernel.org/show_bug.cgi?id=78761

[2]:
http://git.kernel.org/cgit/linux/kernel/git/tglx/history.git/commit/\
fs/hfs/bnode.c?id=d1081202f1d0ee35ab0beb490da4b65d4bc763db
commit d1081202f1d0ee35ab0beb490da4b65d4bc763db
Author: Andrew Morton <akpm@osdl.org>
Date:   Wed Feb 25 16:17:36 2004 -0800

    [PATCH] HFS rewrite

http://git.kernel.org/cgit/linux/kernel/git/tglx/history.git/commit/\
fs/hfsplus/bnode.c?id=91556682e0bf004d98a529bf829d339abb98bbbd

commit 91556682e0bf004d98a529bf829d339abb98bbbd
Author: Andrew Morton <akpm@osdl.org>
Date:   Wed Feb 25 16:17:48 2004 -0800

    [PATCH] HFS+ support

[3]:
http://sourceforge.net/projects/linux-hfsplus/

http://sourceforge.net/projects/linux-hfsplus/files/Linux%202.4.x%20patch/hfsplus%200.1/
http://sourceforge.net/projects/linux-hfsplus/files/Linux%202.4.x%20patch/hfsplus%200.2/

http://linux-hfsplus.cvs.sourceforge.net/viewvc/linux-hfsplus/linux/\
fs/hfsplus/bnode.c?r1=1.4&r2=1.5

Date:   Thu Jun 6 09:45:14 2002 +0000
Use buffer cache instead of page cache in bnode.c. Cache inode extents.

[4]:
http://git.kernel.org/cgit/linux/kernel/git/\
stable/linux-stable.git/commit/?id=a5e3985fa014029eb6795664c704953720cc7f7d

commit a5e3985fa014029eb6795664c704953720cc7f7d
Author: Roman Zippel <zippel@linux-m68k.org>
Date:   Tue Sep 6 15:18:47 2005 -0700

[PATCH] hfs: remove debug code

Signed-off-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: Sergei Antonov <saproj@gmail.com>
Reviewed-by: Anton Altaparmakov <anton@tuxera.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Sougata Santra <sougata@tuxera.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/bnode.c     |    9 ++++-----
 fs/hfsplus/bnode.c |    3 ---
 2 files changed, 4 insertions(+), 8 deletions(-)

diff -puN fs/hfs/bnode.c~hfshfsplus-cache-pages-correctly-between-bnode_create-and-bnode_free fs/hfs/bnode.c
--- a/fs/hfs/bnode.c~hfshfsplus-cache-pages-correctly-between-bnode_create-and-bnode_free
+++ a/fs/hfs/bnode.c
@@ -288,7 +288,6 @@ static struct hfs_bnode *__hfs_bnode_cre
 			page_cache_release(page);
 			goto fail;
 		}
-		page_cache_release(page);
 		node->page[i] = page;
 	}
 
@@ -398,11 +397,11 @@ node_error:
 
 void hfs_bnode_free(struct hfs_bnode *node)
 {
-	//int i;
+	int i;
 
-	//for (i = 0; i < node->tree->pages_per_bnode; i++)
-	//	if (node->page[i])
-	//		page_cache_release(node->page[i]);
+	for (i = 0; i < node->tree->pages_per_bnode; i++)
+		if (node->page[i])
+			page_cache_release(node->page[i]);
 	kfree(node);
 }
 
diff -puN fs/hfsplus/bnode.c~hfshfsplus-cache-pages-correctly-between-bnode_create-and-bnode_free fs/hfsplus/bnode.c
--- a/fs/hfsplus/bnode.c~hfshfsplus-cache-pages-correctly-between-bnode_create-and-bnode_free
+++ a/fs/hfsplus/bnode.c
@@ -454,7 +454,6 @@ static struct hfs_bnode *__hfs_bnode_cre
 			page_cache_release(page);
 			goto fail;
 		}
-		page_cache_release(page);
 		node->page[i] = page;
 	}
 
@@ -566,13 +565,11 @@ node_error:
 
 void hfs_bnode_free(struct hfs_bnode *node)
 {
-#if 0
 	int i;
 
 	for (i = 0; i < node->tree->pages_per_bnode; i++)
 		if (node->page[i])
 			page_cache_release(node->page[i]);
-#endif
 	kfree(node);
 }
 
_

Patches currently in -mm which might be from htl10@users.sourceforge.net are

hfshfsplus-cache-pages-correctly-between-bnode_create-and-bnode_free.patch
hfs-fix-b-tree-corruption-after-insertion-at-position-0.patch


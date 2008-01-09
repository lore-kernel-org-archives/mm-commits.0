From: akpm@linux-foundation.org
Subject: + reiser4-correct-references-to-filemap_nopage.patch added to -mm tree
Date: Tue, 08 Jan 2008 16:50:51 -0800
Message-ID: <200801090050.m090opWp008394@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45577 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752958AbYAIAzD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jan 2008 19:55:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, edward.shishkin@gmail.com, vs@namesys.com


The patch titled
     reiser4: correct references to filemap_nopage()
has been added to the -mm tree.  Its filename is
     reiser4-correct-references-to-filemap_nopage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiser4: correct references to filemap_nopage()
From: Nick Piggin <npiggin@suse.de>

Correct old reiser4 references to filemap_nopage. No code change.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Edward Shishkin <edward.shishkin@gmail.com>
Cc: "Vladimir V. Saveliev" <vs@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/item/extent_file_ops.c |    2 +-
 fs/reiser4/plugin/item/tail.c            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/reiser4/plugin/item/extent_file_ops.c~reiser4-correct-references-to-filemap_nopage fs/reiser4/plugin/item/extent_file_ops.c
--- a/fs/reiser4/plugin/item/extent_file_ops.c~reiser4-correct-references-to-filemap_nopage
+++ a/fs/reiser4/plugin/item/extent_file_ops.c
@@ -1311,7 +1311,7 @@ int reiser4_read_extent(struct file *fil
    plugin->s.file.readpage
    reiser4_read->unix_file_read->page_cache_readahead->reiser4_readpage->unix_file_readpage->extent_readpage
    or
-   filemap_nopage->reiser4_readpage->readpage_unix_file->->readpage_extent
+   filemap_fault->reiser4_readpage->readpage_unix_file->->readpage_extent
 
    At the beginning: coord->node is read locked, zloaded, page is
    locked, coord is set to existing unit inside of extent item (it is not necessary that coord matches to page->index)
diff -puN fs/reiser4/plugin/item/tail.c~reiser4-correct-references-to-filemap_nopage fs/reiser4/plugin/item/tail.c
--- a/fs/reiser4/plugin/item/tail.c~reiser4-correct-references-to-filemap_nopage
+++ a/fs/reiser4/plugin/item/tail.c
@@ -407,7 +407,7 @@ static int do_readpage_tail(uf_coord_t *
    plugin->s.file.readpage
    reiser4_read->unix_file_read->page_cache_readahead->reiser4_readpage->unix_file_readpage->readpage_tail
    or
-   filemap_nopage->reiser4_readpage->readpage_unix_file->->readpage_tail
+   filemap_fault->reiser4_readpage->readpage_unix_file->->readpage_tail
 
    At the beginning: coord->node is read locked, zloaded, page is locked, coord is set to existing unit inside of tail
    item. */
_

Patches currently in -mm which might be from npiggin@suse.de are

git-alsa.patch
drm-convert-from-nopage-to-fault.patch
drm-convert-from-nopage-to-fault-checkpatch-fixes.patch
git-dvb.patch
git-ieee1394.patch
git-infiniband.patch
git-jfs.patch
git-kvm.patch
nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch
git-sched.patch
sg-nopage.patch
git-x86.patch
slub-use-non-atomic-bit-unlock.patch
tmpfs-shuffle-add_to_swap_caches.patch
tmpfs-radix_tree_preloading.patch
radix-tree-avoid-atomic-allocations-for-preloaded-insertions.patch
mm-dont-allow-ioremapping-of-ranges-larger-than-vmalloc-space.patch
mm-special-mapping-nopage.patch
agp-alpha-nopage.patch
vt-bitlock-fix.patch
radix_treeh-trivial-comment-correction.patch
inotify-fix-race.patch
inotify-remove-debug-code.patch
relay-nopage.patch
uio-nopage.patch
ext2-xip-check-fix.patch
fb-defio-nopage.patch
rewrite-rd.patch
rewrite-rd-fix.patch
rd-support-xip.patch
reiser4.patch
reiser4-correct-references-to-filemap_nopage.patch

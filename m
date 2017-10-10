From: akpm@linux-foundation.org
Subject: + ceph-use-pagevec_lookup_range_nr_tag.patch added to -mm tree
Date: Tue, 10 Oct 2017 14:01:10 -0700
Message-ID: <59dd3516.bfFMkIascyJH44KZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60984 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933220AbdJJVBP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Oct 2017 17:01:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, daniel.m.jordan@oracle.com, zyan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ceph: use pagevec_lookup_range_nr_tag()
has been added to the -mm tree.  Its filename is
     ceph-use-pagevec_lookup_range_nr_tag.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ceph-use-pagevec_lookup_range_nr_tag.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ceph-use-pagevec_lookup_range_nr_tag.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: ceph: use pagevec_lookup_range_nr_tag()

Use new function for looking up pages since nr_pages argument from
pagevec_lookup_range_tag() is going away.

Link: http://lkml.kernel.org/r/20171009151359.31984-14-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: "Yan, Zheng" <zyan@redhat.com>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ceph/addr.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/ceph/addr.c~ceph-use-pagevec_lookup_range_nr_tag fs/ceph/addr.c
--- a/fs/ceph/addr.c~ceph-use-pagevec_lookup_range_nr_tag
+++ a/fs/ceph/addr.c
@@ -869,11 +869,9 @@ retry:
 		max_pages = wsize >> PAGE_SHIFT;
 
 get_more_pages:
-		pvec_pages = min_t(unsigned, PAGEVEC_SIZE,
-				   max_pages - locked_pages);
-		pvec_pages = pagevec_lookup_range_tag(&pvec, mapping, &index,
+		pvec_pages = pagevec_lookup_range_nr_tag(&pvec, mapping, &index,
 						end, PAGECACHE_TAG_DIRTY,
-						pvec_pages);
+						max_pages - locked_pages);
 		dout("pagevec_lookup_range_tag got %d\n", pvec_pages);
 		if (!pvec_pages && !locked_pages)
 			break;
_

Patches currently in -mm which might be from jack@suse.cz are

mm-readahead-increase-maximum-readahead-window.patch
mm-implement-find_get_pages_range_tag.patch
btrfs-use-pagevec_lookup_range_tag.patch
ceph-use-pagevec_lookup_range_tag.patch
ext4-use-pagevec_lookup_range_tag.patch
f2fs-use-pagevec_lookup_range_tag.patch
f2fs-simplify-page-iteration-loops.patch
f2fs-use-find_get_pages_tag-for-looking-up-single-page.patch
gfs2-use-pagevec_lookup_range_tag.patch
nilfs2-use-pagevec_lookup_range_tag.patch
mm-use-pagevec_lookup_range_tag-in-__filemap_fdatawait_range.patch
mm-use-pagevec_lookup_range_tag-in-write_cache_pages.patch
mm-add-variant-of-pagevec_lookup_range_tag-taking-number-of-pages.patch
ceph-use-pagevec_lookup_range_nr_tag.patch
mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag.patch
afs-use-find_get_pages_range_tag.patch
cifs-use-find_get_pages_range_tag.patch


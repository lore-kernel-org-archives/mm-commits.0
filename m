From: akpm@linux-foundation.org
Subject: [merged] ceph-use-pagevec_lookup_range_nr_tag.patch
 removed from -mm tree
Date: Thu, 16 Nov 2017 12:02:04 -0800
Message-ID: <20171116200204.oPgujpMsl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46604 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932697AbdKPUCF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:02:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.m.jordan@oracle.com, jack@suse.cz, mm-commits@vger.kernel.org, zyan@redhat.com


The patch titled
     Subject: ceph: use pagevec_lookup_range_nr_tag()
has been removed from the -mm tree.  Its filename was
     ceph-use-pagevec_lookup_range_nr_tag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -870,11 +870,9 @@ retry:
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


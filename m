Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EDE61F4168
	for <mm-commits@vger.kernel.org>; Mon,  7 Jul 2025 22:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751928045; cv=none; b=HNnlUZtmd1ym/GRZBpPdk5/bYe0z3D+romboZPP6AqNEZnAweKFcZ6Kli8PgW8BKUF0Uk/k0pLYZDOgR+ZfiwnjypK6vl0JvS38SO/+V9Iw8m53msP9F5Frq9Ke9IpZzSR1DfmuHqm7sJ+GS2gzyT7yM04YfgaLxS12t3id2XN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751928045; c=relaxed/simple;
	bh=IxTLtJ6YLyGgnu0cGS3Uzohjw0+ykkDgpRfUIfcdwdA=;
	h=Date:To:From:Subject:Message-Id; b=Ge6QiDdgCWRaMCbzC8fEg0Gdiakgql/C2TOvzh806f5eRdfXfMskkbkJXjeS+nGCru2v8Ba9HdjN666qt+zRFPA4nD0ph8rGH25QLg6N2I+5FpxL5YHiZnFOe+YNVCkLIGmqg3ZXOZz7027TfN1bz1okeJ1GuzMtEb/60dKP+RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w4Xht23b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w4Xht23b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96DEFC4CEE3;
	Mon,  7 Jul 2025 22:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751928044;
	bh=IxTLtJ6YLyGgnu0cGS3Uzohjw0+ykkDgpRfUIfcdwdA=;
	h=Date:To:From:Subject:From;
	b=w4Xht23bpLggNSVCabwsQE77L9JwM2+BMdTHrnIbSMkhIyNHeiLR0jdKwIUS0X4OP
	 dzkRx7Y/zvCsjm6v//Rnh2lrnNNcniJoWVfvxFoWDi388UFVJeIHTjkdJILgMr/x5b
	 oOQhKx/Te5dqSDg5Z5mk6pQbDaze+3jwRGrrQlZQ=
Date: Mon, 07 Jul 2025 15:40:44 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,willy@infradead.org,tj@kernel.org,surenb@google.com,mszeredi@redhat.com,mpatlasov@parallels.com,mhocko@suse.com,kirill.shutemov@linux.intel.com,joannelkoong@gmail.com,jlayton@kernel.org,jefflexu@linux.alibaba.com,jack@suse.cz,jackmanb@google.com,hannes@cmpxchg.org,gregkh@linuxfoundation.org,dakr@kernel.org,corbet@lwn.net,axboe@kernel.dk,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmstat-remove-the-nr_writeback_temp-node_stat_item-counter-fix.patch added to mm-unstable branch
Message-Id: <20250707224044.96DEFC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-vmstat-remove-the-nr_writeback_temp-node_stat_item-counter-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmstat-remove-the-nr_writeback_temp-node_stat_item-counter-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmstat-remove-the-nr_writeback_temp-node_stat_item-counter-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-vmstat-remove-the-nr_writeback_temp-node_stat_item-counter-fix
Date: Mon, 7 Jul 2025 16:09:31 +0200

Also remove the mention of NR_WRITEBACK_TEMP implications from a comment
in wb_position_ratio(). The rest of the comment there about fuse setting
bdi->max_ratio to 1% is still correct.

Link: https://lkml.kernel.org/r/5a848e15-6a57-4ecb-a015-d4f358b8a5d3@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Joanne Koong <joannelkoong@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Maxim Patlasov <mpatlasov@parallels.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/page-writeback.c~mm-vmstat-remove-the-nr_writeback_temp-node_stat_item-counter-fix
+++ a/mm/page-writeback.c
@@ -1101,9 +1101,7 @@ static void wb_position_ratio(struct dir
 	 * such filesystems balance_dirty_pages always checks wb counters
 	 * against wb limits. Even if global "nr_dirty" is under "freerun".
 	 * This is especially important for fuse which sets bdi->max_ratio to
-	 * 1% by default. Without strictlimit feature, fuse writeback may
-	 * consume arbitrary amount of RAM because it is accounted in
-	 * NR_WRITEBACK_TEMP which is not involved in calculating "nr_dirty".
+	 * 1% by default.
 	 *
 	 * Here, in wb_position_ratio(), we calculate pos_ratio based on
 	 * two values: wb_dirty and wb_thresh. Let's consider an example:
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-madvise-simplify-anon_name-handling.patch
mm-madvise-extract-mm-code-from-prctl_set_vma-to-mm-madvisec.patch
mm-madvise-move-madvise_set_anon_name-down-the-file.patch
mm-madvise-use-standard-madvise-locking-in-madvise_set_anon_name.patch
mm-vmstat-remove-the-nr_writeback_temp-node_stat_item-counter.patch
mm-vmstat-remove-the-nr_writeback_temp-node_stat_item-counter-fix.patch


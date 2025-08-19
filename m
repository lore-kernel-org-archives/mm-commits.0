Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A523B19049B
	for <mm-commits@vger.kernel.org>; Tue, 19 Aug 2025 02:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755571700; cv=none; b=FPI0ZSeUM8LLqM72jMk+tZVFQ0+ueCRTqgaTzpbgo0kTh+c/BtzIvl3NHoeoYj5Wl/EfCVSqHI181YbZy2WtLDQnr2owxHBQDIsrSE2oopM+AG71sosc6JMC0zeJwL602D8Iox+ozA+pREMYMbPmVXSbyWI3LDYOK4nRztH2C2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755571700; c=relaxed/simple;
	bh=frsdvy+FEv1bVpGQr/8HxEki5P/dYWgOXblFX0BfoQk=;
	h=Date:To:From:Subject:Message-Id; b=sK2xq1TxVF65AahnUmvsuhbm3NvgdFida5lIE0W7k/OA7FZtyP3k81zhmS1lG7Gp0KMNSDWOJ3kAlI8YX84AOYeg6EsiQ1pYX41RUZ06siFquTZkiDF6y+hUx0MvrnNxsJg9E+fcEEAAaDzuH7OFjseWmdSY6UFSJ/Fny1xfO3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=13oU1iKo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="13oU1iKo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3A3C4CEEB;
	Tue, 19 Aug 2025 02:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755571697;
	bh=frsdvy+FEv1bVpGQr/8HxEki5P/dYWgOXblFX0BfoQk=;
	h=Date:To:From:Subject:From;
	b=13oU1iKoY7cRQ/Y83PXjpc0cHq3mKEkqh944Q8TzVA4QSMHRQoGEVGjAKWBXKgDCP
	 13Dkqj0vwcOCmyPB2k06P/e4I10UZ47JGSGWncjsJHYj12x+HXWQzqQ2DTE8HOdvYT
	 WEZMyz1dIvCSSufwVqXBCMAWUd4x9eKQlGZjEJw8=
Date: Mon, 18 Aug 2025 19:48:17 -0700
To: mm-commits@vger.kernel.org,wqu@suse.com,willy@infradead.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,josef@toxicpanda.com,hannes@cmpxchg.org,dsterba@suse.com,clm@fb.com,boris@bur.io,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-add-as_uncharged.patch added to mm-new branch
Message-Id: <20250819024817.AF3A3C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/filemap: add AS_UNCHARGED
has been added to the -mm mm-new branch.  Its filename is
     mm-filemap-add-as_uncharged.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-add-as_uncharged.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Boris Burkov <boris@bur.io>
Subject: mm/filemap: add AS_UNCHARGED
Date: Mon, 18 Aug 2025 17:36:53 -0700

Patch series "introduce uncharged file mapped folios", v3.

I would like to revisit Qu's proposal to not charge btrfs extent_buffer
allocations to the user's cgroup.

https://lore.kernel.org/linux-mm/b5fef5372ae454a7b6da4f2f75c427aeab6a07d6.1727498749.git.wqu@suse.com/

I believe it is detrimental to randomly account these global pages to the
cgroup using them, basically at random.  More justification and
explanation may be found in the patches themselves.


This patch (of 4):

Btrfs currently tracks its metadata pages in the page cache, using a fake
inode (fs_info->btree_inode) with offsets corresponding to where the
metadata is stored in the filesystem's full logical address space.

A consequence of this is that when btrfs uses filemap_add_folio(), this
usage is charged to the cgroup of whichever task happens to be running at
the time.  These folios don't belong to any particular user cgroup, so I
don't think it makes much sense for them to be charged in that way.  Some
negative consequences as a result:

- A task can be holding some important btrfs locks, then need to lookup
  some metadata and go into reclaim, extending the duration it holds that
  lock for, and unfairly pushing its own reclaim pain onto other cgroups.

- If that cgroup goes into reclaim, it might reclaim these folios a
  different non-reclaiming cgroup might need soon.  This is naturally
  offset by LRU reclaim, but still.

A very similar proposal to use the root cgroup was previously made by Qu,
where he eventually proposed the idea of setting it per address_space. 
This makes good sense for the btrfs use case, as the uncharged behavior
should apply to all use of the address_space, not select allocations. 
I.e., if someone adds another filemap_add_folio() call using btrfs's
btree_inode, we would almost certainly want the uncharged behavior.

Link: https://lkml.kernel.org/r/cover.1755562487.git.boris@bur.io
Link: https://lore.kernel.org/linux-mm/b5fef5372ae454a7b6da4f2f75c427aeab6a07d6.1727498749.git.wqu@suse.com/
Link: https://lkml.kernel.org/r/43fed53d45910cd4fa7a71d2e92913e53eb28774.1755562487.git.boris@bur.io
Signed-off-by: Boris Burkov <boris@bur.io>
Suggested-by: Qu Wenruo <wqu@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Tested-by: syzbot@syzkaller.appspotmail.com
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    1 +
 mm/filemap.c            |   12 ++++++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

--- a/include/linux/pagemap.h~mm-filemap-add-as_uncharged
+++ a/include/linux/pagemap.h
@@ -211,6 +211,7 @@ enum mapping_flags {
 				   folio contents */
 	AS_INACCESSIBLE = 8,	/* Do not attempt direct R/W access to the mapping */
 	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
+	AS_UNCHARGED = 10,	/* Do not charge usage to a cgroup */
 	/* Bits 16-25 are used for FOLIO_ORDER */
 	AS_FOLIO_ORDER_BITS = 5,
 	AS_FOLIO_ORDER_MIN = 16,
--- a/mm/filemap.c~mm-filemap-add-as_uncharged
+++ a/mm/filemap.c
@@ -960,15 +960,19 @@ int filemap_add_folio(struct address_spa
 {
 	void *shadow = NULL;
 	int ret;
+	bool charge_mem_cgroup = !test_bit(AS_UNCHARGED, &mapping->flags);
 
-	ret = mem_cgroup_charge(folio, NULL, gfp);
-	if (ret)
-		return ret;
+	if (charge_mem_cgroup) {
+		ret = mem_cgroup_charge(folio, NULL, gfp);
+		if (ret)
+			return ret;
+	}
 
 	__folio_set_locked(folio);
 	ret = __filemap_add_folio(mapping, folio, index, gfp, &shadow);
 	if (unlikely(ret)) {
-		mem_cgroup_uncharge(folio);
+		if (charge_mem_cgroup)
+			mem_cgroup_uncharge(folio);
 		__folio_clear_locked(folio);
 	} else {
 		/*
_

Patches currently in -mm which might be from boris@bur.io are

mm-filemap-add-as_uncharged.patch
mm-add-vmstat-for-cgroup-uncharged-pages.patch
btrfs-set-as_uncharged-on-the-btree_inode.patch


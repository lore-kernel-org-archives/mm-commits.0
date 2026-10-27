Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793124581;
	b=3KFiwNAmGoL35peotbo+0+wRCd2MTRt69gp38F0sCxpbJinYXCwxsWXvk9tiQpOcFMan
	 4jRLkOzSzLto/896j/POK0yatVdh398UqIvLhQaq0wSMJxeOKlFMOcn65Ya2H5bXQRkKT
	 bEk186Zs+EkqEEs0cBHE3hFbONu2iDruSlaH7U2hmxUaXxiyGMX7fHN9gQfFEgIuKW/PW
	 CltfQsER5SkQ/dBSnaQRzs4/Ixqq7Hh0MeCnf4pUnoLk8cGZze9tVRkHYZCMJ8U/qLX4h
	 ZuxW6G6yCVzlipB/u4Gwd+yBUmTFh006BEOaoFi1ppot6/qCIrW1FSzdur3Em3XpE+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793124581;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=bkjXxs2a5BIYOp/8br1KRpXcrMk8B2EiRquuReW6yeM=;
	b=EA30zFDfM8inHOW3IXVTCfYpXhHL7BEwozeazYOh4y/CZ2aKQbn1YoKYQRQdd23RGYKM
	 pSbZM+ydM8jC3BLtO13W/jPj9ZtkysIMb/R1TBBhZ1XIA9XanJLBnpcR+kxks3t/gzm5g
	 k0jzqOGJm5QodjGtv4zWDBtlvUY0Kde9IOpgDAryVw4i6j4BntjCRyFGKiJ65iVuBQsYt
	 VK7RFSYsNOmWFwGHRGgXjyjyfTkXbXgcs+W1sgWAUW2FTFuXxr4upMpIK9UFnf02lPYrw
	 4+UZhPifu3hHfcn/G/cGH5auqeU8qUx9sT41sYvtbebPbfECqcT6g1fSrvwxeNf9Y+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gOlIip3E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A73606A31E
	for <mm-commits@vger.kernel.org>; Tue, 27 Oct 2026 18:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gOlIip3E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 708DB1F01825;
	Tue, 27 Oct 2026 18:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793124580;
	bh=bkjXxs2a5BIYOp/8br1KRpXcrMk8B2EiRquuReW6yeM=;
	h=Date:To:From:Subject;
	b=gOlIip3EsckamBqed9h1j2i5EvloRptlXFYpqnAPnOoyRQJ6HY1yIhlmxvYnyO4O4
	 G2x+mriDE6v7lIyAVCg+RpfuDyojl62hSaSrW5nEl+yB0B95IYZ8/5UZXah+3WrdWf
	 JADfmK1r8Yd/ah9omEasrGBY6B1Ay7BM8qeJ4JDs=
Date: Tue, 27 Oct 2026 11:09:40 -0700
To: mm-commits@vger.kernel.org,mason@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mempolicy-charge-shared-policy-nodes.patch removed from -mm tree
Message-Id: <20261027180940.708DB1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/mempolicy: charge shared policy nodes
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-charge-shared-policy-nodes.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Chris Mason <mason@kernel.org>
Subject: mm/mempolicy: charge shared policy nodes
Date: Mon, 26 Oct 2026 10:40:34 +0100

Patch series "mm/shmem: various (urgent?) fixes", v1.

Hi,

the fixing fun continues.

This is a handful of fixes for shmem/tmpfs. I sneaked in a related
hugetlb fix that stalled upstream.

Some of the stuff is more urgent (patch #1, F_SEAL_EXEC, truncation
hangs), others are less urgent but still rather unpleasant.

The majority are fixes from Anthropic that I cleaned up or reworked.
While doing that, I found a bunch of other issues and tried to fix them
somewhat cleanly.

In general, shmem + swap handling is a nightmare. shmem_undo_range() is
such utter garbage it makes me want to cry. I mean, really, WTF did we
end up creating there. Does any expert here have time to clean that up and
make it *actually* maintainable.

The following things are still broken in shmem_undo_range():

(1) Truncate/punch of a single page of a large swap-error marker

We don't split. Consequently, read access afterwards will still fail
instead of returning 0s.

I have a fix to try to split (which can fail), but I don't consider it
that urgent, really. So I'm not including it. Might send it later
separately.

Truncate/punch of a partial page can obviously never do the right thing,
as we cannot poison parts of pages ...

(2) Truncate/punch whole pages within part of a large swap entry

We try to read the entry, but if we are out of memory that might fail.
Consequently, we will not free up swap space and a re-read will not give
us 0s but the previous content.

AI proposed a nasty NOFAIL patch which has too many nasty side effects
IMHO (allowing users to force-read pages and retain them afterwards even
though memory.max would disallow it). This needs a proper thought. Likely,
support for splitting large swap entries (and large folios in the
swapcache, which I recall is under development  by Kairui). But splitting
can fail ...

(3) Truncate/punch of a part of a base-page swap entry

We obviously have to read the page in, in order to 0-out the parts to
discard. That might obviously fail.

Maybe we should install swapin-error markers if swapping during
truncate/punchhole fails, to at least tell user space on later access
that something went wrong? We might affect unrelated data, outside the
requested range, though. Anyhow, these are long standing issues and
I don't consider them urgent.

They need a proper solution.

I did my best trying to test these fixes. I was able to reproduce some
of the things (including unkillable truncation hangs), and the fixes seemed
to help.

But again, shmem_undo_range() is just an absolute mess.

Please prioritize review of these fixes, I want to get fixes for the
issues in a timely manner upstream.


This patch (of 16):

Any local user can bypass memory.max with mbind() on a tmpfs file, and
allocate unbounded kernel memory.

mbind() sets a NUMA memory policy for a range of a mapping. If the
mapping is of a shmem and friends, the kernel also stores the policy on
the inode, in a tree with one entry per range of the file.

Each mbind() on a single page of a mapping can add one shared policy node
(struct sp_node) and one struct mempolicy to that tree. They outlive the
mapping and stay around until the inode is destroyed. The tree is not
bounded by the file size, so the file can be empty.

Memory that user space can allocate must be charged to a memory cgroup. A
slab cache does that for all of its objects if it is created with
SLAB_ACCOUNT. numa_policy_init() creates the slab caches for both
structs without SLAB_ACCOUNT, so they are not charged to any cgroup.

Reproduced with mbind() on single pages of an empty tmpfs file, from a
cgroup with memory.max=8M: the global OOM killer killed tasks owned by
root, and the machine panicked.

Fix this by creating both caches with SLAB_ACCOUNT. This change implies
that mbind() can now fail when running into memcg limits. Further,
the policy_cache also serves task and VMA policies, so they are
similarly accounted now.

Note that per-file limits are not really helpful, as the user could
simply use many files; having limits per user is tricky as well.

Fix generated by an LLM and submitted by Chris Mason in private.

[david@kernel.org: smaller description tweaks]
Link: https://lore.kernel.org/20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org
Link: https://lore.kernel.org/20261026-fixes_shmem-v1-1-703206d5fa0c@kernel.org
Fixes: 5d097056c9a0 ("kmemcg: account certain kmem allocations to memcg")
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lukas Czerner <lczerner@redhat.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Daniel Verkamp <dverkamp@chromium.org>
Cc: Jeff Xu <jeffxu@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Stevens <stevensd@chromium.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: <sashiko-bot@kernel.org>
Cc: <stable@vger.kernel.org>
---

 mm/mempolicy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index e9860fb9f73f8..ad49b7524064a 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -3372,11 +3372,11 @@ void __init numa_policy_init(void)
 
 	policy_cache = kmem_cache_create("numa_policy",
 					 sizeof(struct mempolicy),
-					 0, SLAB_PANIC, NULL);
+					 0, SLAB_PANIC | SLAB_ACCOUNT, NULL);
 
 	sn_cache = kmem_cache_create("shared_policy_node",
 				     sizeof(struct sp_node),
-				     0, SLAB_PANIC, NULL);
+				     0, SLAB_PANIC | SLAB_ACCOUNT, NULL);
 
 	for_each_node(nid) {
 		preferred_node_policy[nid] = (struct mempolicy) {


Patches currently in -mm which might be from mason@kernel.org are

mm-shmem-honour-f_seal_exec-when-an-acl-is-set.patch
mm-shmem-avoid-moving-the-truncation-start-backwards.patch


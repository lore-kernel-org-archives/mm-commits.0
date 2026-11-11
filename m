Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794423835;
	b=oKgbSYbhTW6DPNsXSeYZdQMtnDj84KFOC0S8xN8cPk5+sHcewhJCPjGs5a7At+Q5MP17
	 76Hqb1IdW+atB9h8mqEmVEN7CeU4G3Kwp3O9iUD3FOlWSf1SsHLuXcRYYtNMrUCwhsvZP
	 0vdq4Yeem5Thg/Bg19XnmRMIdTIJ3MLpufE58e3oTU26QkJdzo4zOHh2xoWa6uveJmfyH
	 ZPsz5h39QCXzhlwcFc/yPGozEfL4LdBn/jvICpFfF9USZ/rcr9JON1ctVT/NMSYIfOgO6
	 fk7mncHVfAQGsmFmZAKem0HXUV87aPrbB1TWTC7G3jYEjf4NVvLMRHEAKByjZOVj62Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794423835;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=/J9ZsdBTsczMP7kWvo8AWkhIxuhUUf0Icf5v58zQZlM=;
	b=ZW4uyLCe/oq7XOErA7DDtHNpUG7a91fwtVzmqaRfClloGxYNpE8om0qdsV5Mr7j+2om4
	 fDIdENL5DikDZHX3kKIoMRWXSJjZKh5FspT2npQqwh5rg+yJP/Hy2rDqkNsw+99NO6OZa
	 CMw6iKxzC31bA8/pbaM73DFpCGsPHil6a0mnM0EHgcHZcLrqU98fH132s/g/m6avbVmKV
	 o4bHKXUId9i6Ev5iRrwlXDn3Q2CVjQGs8Cb3cLZbUClVFxHUXaUeD9f8VlLOMKjP/oIN9
	 XSB4XtXRsc/CdQgVBy3LpdZncMn7s4D8OtR02o7aM59rCXMqk0nRZt73ZgDIt9V+kfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="fR1+I/fY";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED07606A32D;
	Wed, 11 Nov 2026 19:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fR1+I/fY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7856F1F00A05;
	Wed, 11 Nov 2026 19:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794423834;
	bh=/J9ZsdBTsczMP7kWvo8AWkhIxuhUUf0Icf5v58zQZlM=;
	h=Date:To:From:Subject;
	b=fR1+I/fYvLGhPNGJLWUGehQ/QVykGQAHrh+tm4es/m0HGQ5SyphXRBPO21bRKvi+A
	 am8o/u5eAlFhItXZUTSh+Tc+gd1ahqWXIhfINdDzm+6We/E1cqtDe7+YW4SNROZTlQ
	 CjyLtvZDbyni4yV4ZxR5Amg0DTpsQqLyulQcgFa8=
Date: Wed, 11 Nov 2026 11:03:53 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,ryncsn@gmail.com,
	qi.zheng@linux.dev,noah@feldt.systems,kasong@tencent.com,hannes@cmpxchg.org,
	david@kernel.org,baohua@kernel.org,shakeel.butt@linux.dev,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-splice-all-generations-when-reparenting-a-memcg.patch added to mm-hotfixes-unstable branch
Message-Id: <20261111190354.7856F1F00A05@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: mglru: splice all generations when reparenting a memcg
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mglru-splice-all-generations-when-reparenting-a-memcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-splice-all-generations-when-reparenting-a-memcg.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: mm: mglru: splice all generations when reparenting a memcg
Date: Tue, 10 Nov 2026 16:09:13 -0800

Noah reported list_del corruption on single-node hosts running 7.2.11,
which already has commit bf4ade7dbd76 ("memcg: keep folio's objcg same as
its node").  The bad pointer is an MGLRU list head in a freed
mem_cgroup_per_node:

  slab mem_cgroup_per_node start ff31bfa36a3c9e00 pointer offset 528 size 1920
  list_del corruption. next->prev should be ffacf881ccc70e08, but was ff31bfa36a3ca010. (next=ff31bfa36a3ca010)

When a memcg goes offline, __lru_gen_reparent_memcg() moves its MGLRU
lists to the parent.  It moves only the generations (gens) from min_seq to
max_seq, and it puts each list at the same index in the parent.

A folio's gen in folio->flags can be ahead of the list it is on.  In the
parent, the same index can stand for an older gen, so the folio's gen can
end up older than its list.  Once the parent's min_seq passes that gen,
sort_folio() puts the folio on the list for max_seq + 1, where it stays
until the next aging.

If the parent goes offline before that aging, the folio is not moved to
the grandparent.  It stays on the parent's list after the parent is freed,
and the next list_del() on it touches freed memory.  This needs two
cgroups on one branch to go offline one after the other, such as a
container and then its pod.

The parent always has MAX_NR_GENS gens at this point, so every index is
valid in it.  Move all MAX_NR_GENS lists, not only the gens from min_seq
to max_seq.

A reproducer that drives these steps through the lru_gen debugfs file gets
a KASAN use-after-free on the freed mem_cgroup_per_node without this
patch, and no report with it.

Link: https://lore.kernel.org/20261111000913.22943-1-shakeel.butt@linux.dev
Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Noah Feldt <noah@feldt.systems>
Closes: https://lore.kernel.org/all/20261110132853.71228-1-noah@feldt.systems/
Reviewed-by: Kairui Song <kasong@tencent.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: <stable@vger.kernel.org>
---

 mm/vmscan.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c~mm-mglru-splice-all-generations-when-reparenting-a-memcg
+++ a/mm/vmscan.c
@@ -4752,19 +4752,25 @@ void max_lru_gen_memcg(struct mem_cgroup
  * The same generation has different meanings in the parent and child memcg,
  * so this compromise method will cause the LRU inversion problem. But as the
  * system runs, this problem will be fixed automatically.
+ *
+ * Move all MAX_NR_GENS lists, not only the gens from min_seq to max_seq.
+ * An earlier reparenting can leave a folio whose gen is older than the list
+ * it is on. Once min_seq passes that gen, sort_folio() puts the folio on the
+ * list for max_seq + 1, where it stays until the next aging. If that list
+ * were skipped, the folio would stay behind on a memcg that is about to be
+ * freed. The parent has MAX_NR_GENS gens here, so every index is valid in it.
  */
 static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec *parent_lruvec,
 				     int zone, int type)
 {
 	struct lru_gen_folio *child_lrugen, *parent_lrugen;
 	enum lru_list lru = type * LRU_INACTIVE_FILE;
-	int i;
+	int gen;
 
 	child_lrugen = &child_lruvec->lrugen;
 	parent_lrugen = &parent_lruvec->lrugen;
 
-	for (i = 0; i < get_nr_gens(child_lruvec, type); i++) {
-		int gen = lru_gen_from_seq(child_lrugen->max_seq - i);
+	for (gen = 0; gen < MAX_NR_GENS; gen++) {
 		long nr_pages = child_lrugen->nr_pages[gen][type][zone];
 		int child_lru_active = lru_gen_is_active(child_lruvec, gen) ? LRU_ACTIVE : 0;
 		int parent_lru_active = lru_gen_is_active(parent_lruvec, gen) ? LRU_ACTIVE : 0;
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

mm-mglru-splice-all-generations-when-reparenting-a-memcg.patch
memcg-move-memoryhigh-enforcement-out-of-try_charge_memcg.patch
memcg-force-charges-from-reclaim-before-trying-the-limits.patch
memcg-use-high_work-for-kernel-threads.patch
memcg-use-high_work-for-remote-charges.patch
memcg-simplify-high-limit-handling-after-a-charge.patch


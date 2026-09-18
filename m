Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B13522A4E1;
	Fri, 18 Sep 2026 03:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789703352; cv=none; b=cJuI9IzgJ7F4BO/mDi6uXnKQThDEVDPYVl8HtvkU5r2iBW8dbVDLzlhF1HdWvBLUAlmJ4biKuG2wxiceg6IILuSyqYEtqEDO2k8dGOeK9LR+gYPd1KI6zMBbuZ1oN82YaxEvMuDrc4Qidd2SYYiN4+ISWQgEEL/f+dq3HBBSmeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789703352; c=relaxed/simple;
	bh=xxvIj5Y5MeuDG8AaO87fs635Ag613nSpGDM+Vz28jwY=;
	h=Date:To:From:Subject:Message-Id; b=F36qG6VyUVbOMmj/XFjIipQckbxFYzZ3V9lDicjp/vaapDA2BDHmChBTrnx8ICLzbeiGbZU0CldCh1f/mT6hmRIoHAOgfxdNjF83lMYb4RjkhgI1drk6eyQMf9qa2SOqe9jTi4WYdHcDOe274eiwPFXiUCzpB+NoaxSZ4r/l+rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LUhrTrkG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LUhrTrkG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13AE41F000FF;
	Fri, 18 Sep 2026 03:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789703351;
	bh=fU/Oqg//rr2Mqgc6IHYv3GW40OfU2Uj1MHt9pW2fTbw=;
	h=Date:To:From:Subject;
	b=LUhrTrkGdqKTypgUKR38ECrP7Czs258mrtb5S7RX46mAPZNIW96qGE0BcWtBx911h
	 ORvgwK8y+oirBIkGgCZK2DCRMqwK4XY2QHkeeSTCiijM3hj/nySkzSv0NaVbvj82NU
	 rWs92fRxiRGbX6UlH2GpupGOS1eahFBppgfobnTU=
Date: Thu, 17 Sep 2026 20:49:10 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,osalvador@suse.de,muchun.song@linux.dev,kees@kernel.org,david@kernel.org,colin.i.king@gmail.com,almasrymina@google.com,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_cgroup-move-per-node-usage-on-cgroup-reparenting.patch added to mm-new branch
Message-Id: <20260918034911.13AE41F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb_cgroup: move per-node usage on cgroup reparenting
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb_cgroup-move-per-node-usage-on-cgroup-reparenting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_cgroup-move-per-node-usage-on-cgroup-reparenting.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: mm/hugetlb_cgroup: move per-node usage on cgroup reparenting
Date: Fri, 18 Sep 2026 10:56:11 +0800

hugetlb_cgroup_css_offline() hands the folios of a dying cgroup over to
its parent with hugetlb_cgroup_move_parent(), which moves the page_counter
charges and the hugetlb_cgroup pointer of the folio but not its per-node
usage.  The parent's hugetlb.<size>.numa_stat is short by that usage while
they are charged, and underflows once they are freed, exposing incorrect
per-node usage values to userspace.

Move the per-node usage to the parent as well.  The folios keep their node
here, so only the cgroup which holds the usage changes.

Link: https://lore.kernel.org/20260918-for-hugetlb-charge-v2-2-2b6d8c2bdc36@kylinos.cn
Fixes: f47761999052 ("hugetlb: add hugetlb.*.numa_stat file")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
---

 mm/hugetlb_cgroup.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/hugetlb_cgroup.c~mm-hugetlb_cgroup-move-per-node-usage-on-cgroup-reparenting
+++ a/mm/hugetlb_cgroup.c
@@ -241,6 +241,8 @@ static void hugetlb_cgroup_move_parent(i
 	/* Take the pages off the local counter */
 	page_counter_cancel(counter, nr_pages);
 
+	hugetlb_cgroup_move_usage(h_cg, parent, folio, folio);
+
 	set_hugetlb_cgroup(folio, parent);
 out:
 	return;
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

mm-use-a-folio-in-the-softleaf_is_device_private-path.patch
mm-hugetlb-fix-resv_huge_pages-double-decrement-in-memfd-error-path.patch
mm-memcontrol-remove-unused-memcg-parameter-in-calculate_high_delay.patch
selftests-mm-khugepaged-consolidate-error-exits-via-kselftest-helpers.patch
mm-page_owner-preserve-original-free_pid-free_tgid-during-folio-migration.patch
mm-memfd-fix-hugetlb-reservation-accounting-in-error-paths.patch
selftests-mm-fix-ptrace-peekdata-check-in-memfd_secret-test.patch
mm-hugetlb_cgroup-move-per-node-usage-on-cross-node-migration.patch
mm-hugetlb_cgroup-move-per-node-usage-on-cgroup-reparenting.patch


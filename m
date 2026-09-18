Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A05935674A;
	Fri, 18 Sep 2026 21:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789767481; cv=none; b=Ou127a5uSwTN333cKRHNTWgn6MIBm15fCmhdcOTx+KyDAzMO+y0mG9nyuoT5Dugr8xN34CECVAkPImiR7k6eYJvuZByew5LgNTjgFalb7esmYUZQXe7cUx/VUxUgGf3t3kUwmgBSfdtaqy9Bo0w6v1KRbW2hkIdFBRUTxY1NbN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789767481; c=relaxed/simple;
	bh=l3qyJVaUepmtmwdmQcTW1kEqfrzmVKxzf/8DO+Unfhw=;
	h=Date:To:From:Subject:Message-Id; b=RGhGRtkWaZPIawYJZiRWyAebmQeMjb3cNNZsth3ebQvFMqodHNWiuneurWtitPjG++av0So9FCwXke1t8kzH05oEFeiX9y4WwPr0J74W2NcVdnJ9MTYHTonejtlEFFVnXGnJJZs6Ls5V9svI05dadOh6/V+4MaEdOUEtjE6vuSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1ciuN6cw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1ciuN6cw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1B31F00898;
	Fri, 18 Sep 2026 21:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789767480;
	bh=YibPwF3WASXo8sxXk0A2vHy0Q+q8ibPQi9hLWn2RS8w=;
	h=Date:To:From:Subject;
	b=1ciuN6cwwAQBLjQjZgCigbm6TfN7ExH7y9j13bwt2ni3rYbq9M/fzUZ0WerWQbkzM
	 /Qgc2302bU62R8w7qOJttSIvuo7acJzGWOqtu9lcIYgUPu6OZ5JT03ASPl6OA0rJ7O
	 n4o2po2YAI0YKU7PiH5pZyuujmt1FJ4AW/jApjVk=
Date: Fri, 18 Sep 2026 14:37:59 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,osalvador@suse.de,muchun.song@linux.dev,kees@kernel.org,david@kernel.org,colin.i.king@gmail.com,almasrymina@google.com,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hugetlb_cgroup-move-per-node-usage-on-cgroup-reparenting.patch removed from -mm tree
Message-Id: <20260918213759.DE1B31F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb_cgroup: move per-node usage on cgroup reparenting
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_cgroup-move-per-node-usage-on-cgroup-reparenting.patch

This patch was dropped because an updated version will be issued

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


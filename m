Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B8036F8E4
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067175; cv=none; b=RRR/6wjgMIlL0ggWtYv9dfwhQPZbkKC3K7vGAOzqd91gKkkPs4Gx84JtFVV5OVJQHmKKtdxQMtGxFT1W//jHGTF74MppO2xYqtKgSZczk2PCa1f2ILWZ96y1MouFe2qyrNnr67OxBe36jgNg2T8sks/z5MHwEgbwlI+hZF+zU7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067175; c=relaxed/simple;
	bh=g68AGnDgbP4cMr+8M5inR+iRRNA2uk8Nw4r7v4vxE+c=;
	h=Date:To:From:Subject:Message-Id; b=GhYbTeXDMp058k9k54vuwvF1qHTMu9EMfkGiOI+slCxfu812vXOwG3RV4tlLiDXwTu3WS67ygp8uofvBjxnq4kUM9DQ+p/6X8ohte4Lh51hqjLmKpVRqPH95euo7zRJL3F26HOVa80E0S6hqlMElARo453oolfFW+lYaUngb5m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MuGwlhHx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MuGwlhHx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A00371F00A3A;
	Sun, 21 Jun 2026 18:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067174;
	bh=KhaM0wlwQvZ8wR2DEyhaIoJdbOEEz92wlKLJKhHVhyE=;
	h=Date:To:From:Subject;
	b=MuGwlhHxZoUzh2lQVNOD7r9IcqD78N+GQd3ajAw9+Gcl1bRxsNick8BRuws1Er8/X
	 vkQkAB699uJBAYX93xTX7evaX4T3jo3CK7femFopknTudnckA6MwG74Fs1x5JBMxf8
	 a5D71ysant2qpWQabtWsNZc9pOUGHx28QTgr03Bc=
Date: Sun, 21 Jun 2026 11:39:34 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,peterx@redhat.com,npache@redhat.com,mhocko@suse.com,luizcap@redhat.com,ljs@kernel.org,li.wang@linux.dev,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,jhubbard@nvidia.com,jgg@ziepe.ca,donettom@linux.ibm.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-hugetlb-vmemmap-add-setup-of-hugetlb-pages.patch removed from -mm tree
Message-Id: <20260621183934.A00371F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: hugetlb-vmemmap: add setup of HugeTLB pages
has been removed from the -mm tree.  Its filename was
     selftests-mm-hugetlb-vmemmap-add-setup-of-hugetlb-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: hugetlb-vmemmap: add setup of HugeTLB pages
Date: Mon, 11 May 2026 19:28:28 +0300

hugetlb-vmemmap test fails if there are no free huge pages prepared by a
wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Link: https://lore.kernel.org/20260511162840.375890-45-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Li Wang <li.wang@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugetlb-vmemmap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/mm/hugetlb-vmemmap.c~selftests-mm-hugetlb-vmemmap-add-setup-of-hugetlb-pages
+++ a/tools/testing/selftests/mm/hugetlb-vmemmap.c
@@ -97,6 +97,9 @@ int main(int argc, char **argv)
 	ksft_print_header();
 	ksft_set_plan(1);
 
+	if (!hugetlb_setup_default(1))
+		ksft_exit_skip("Not enough free huge pages\n");
+
 	pagesize  = psize();
 	maplength = default_huge_page_size();
 	if (!maplength)
_

Patches currently in -mm which might be from rppt@kernel.org are



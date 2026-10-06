Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E244A64E8;
	Tue,  6 Oct 2026 23:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791330294; cv=none; b=Tf3qzztmQRLU650w2JETTMy9E6dHN6Rt0Ek/m5wK0DYEZ2rLvfCeROZcCeh3bEBDU1sPdzWYEN2U7MRL8/5upLLzVGly+CLXBxOEcSxAFFYGXKY42IkiE1mtnDqH1oQ5XZENT+ajfQ2SDlx8ZuqSEV3y0wvH8GdtjqJJtRs3b+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791330294; c=relaxed/simple;
	bh=qs2EiyS+1g6Ww1l8jJ0U/BrtuKgnGkqsfTsLOwAQuXw=;
	h=Date:To:From:Subject:Message-Id; b=PKGKTTeFPvFH/GE8pNB7OZH4hh+sxL9iDZfarcRSAQklhg9GhE7U8VcyYtnIWbrqwQoL5yuTJoFT8w7NQpt+7OoSLzed624iu82U9eR2skbmkAqAU6bgs+D54rTvdhpnUT4ONlIqxY2L4SIy4ZK7lZ/fIh7jr9P/gJ1YUqufb0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dJRnNx77; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dJRnNx77"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11391F0089B;
	Tue,  6 Oct 2026 23:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791330292;
	bh=UAe7ShXeQyXVGTrLkoZ2s+O/lUy8YWCVUsY47NEUlNo=;
	h=Date:To:From:Subject;
	b=dJRnNx77eGiDq5gTwD333W2sXqxkBWrYPs5tRGTDZI6gZr+42Xlz2K+1EpN9exini
	 4phnaZG2dCSIR+P/3VXwoCEccaniTTox+tZzcCCe4yziir7wZ8+B0PCgPEgzdWNBbv
	 OFdtca6DqpSgX8Kn4hObmcYMvtdoZ4ALME0VHJEs=
Date: Tue, 06 Oct 2026 16:44:52 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,sj@kernel.org,shuah@kernel.org,sarthak.sharma@arm.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,cmllamas@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-cleanup-wformat-issues-in-hugetlb-mmap.patch removed from -mm tree
Message-Id: <20261006234452.D11391F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: cleanup -Wformat issues in hugetlb-mmap
has been removed from the -mm tree.  Its filename was
     selftests-mm-cleanup-wformat-issues-in-hugetlb-mmap.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Carlos Llamas <cmllamas@google.com>
Subject: selftests/mm: cleanup -Wformat issues in hugetlb-mmap
Date: Sun, 27 Sep 2026 16:24:18 +0000

Commit ae571cd6015c ("selftests/mm: hugetlb-mmap: add setup of HugeTLB
pages") and commit 9c5a65f374f8 ("selftests/mm: merge map_hugetlb into
hugepage-mmap") added logs of 'hugepage_size' which has a size_t type.
However, the incorrect format specifier '%lu' was used which triggers
-Wformat warnings when building for 32-bit:

  hugetlb-mmap.c:125:55: warning: format specifies type 'unsigned long'
  but the argument has type 'size_t' (aka 'unsigned int') [-Wformat]
    125 | ksft_print_msg("Default size hugepages (%lu kB)\n", hugepage_size >> 10);
        |                                         ~~~         ^~~~~~~~~~~~~~~~~~~
        |                                         %zu

  hugetlb-mmap.c:134:47: warning: format specifies type 'unsigned long'
  but the argument has type 'size_t' (aka 'unsigned int') [-Wformat]
    134 | ksft_exit_skip("Not enough %lu Kb pages\n", hugepage_size >> 10);
        |                            ~~~              ^~~~~~~~~~~~~~~~~~~
        |                            %zu

Fix this by switching to the expected '%zu' format specifier.

Link: https://lore.kernel.org/20260927162419.820609-1-cmllamas@google.com
Fixes: ae571cd6015c ("selftests/mm: hugetlb-mmap: add setup of HugeTLB pages")
Fixes: 9c5a65f374f8 ("selftests/mm: merge map_hugetlb into hugepage-mmap")
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
Reviewed-by: SJ Park <sj@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
---

 tools/testing/selftests/mm/hugetlb-mmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/hugetlb-mmap.c~selftests-mm-cleanup-wformat-issues-in-hugetlb-mmap
+++ a/tools/testing/selftests/mm/hugetlb-mmap.c
@@ -122,7 +122,7 @@ int main(int argc, char **argv)
 		hugepage_size = default_huge_page_size();
 		if (!hugepage_size)
 			ksft_exit_skip("Could not detect default hugetlb page size.");
-		ksft_print_msg("Default size hugepages (%lu kB)\n", hugepage_size >> 10);
+		ksft_print_msg("Default size hugepages (%zu kB)\n", hugepage_size >> 10);
 	}
 
 	/* munmap will fail if the length is not page aligned */
@@ -131,7 +131,7 @@ int main(int argc, char **argv)
 
 	hugetlb_set_nr_pages(hugepage_size, nr);
 	if (hugetlb_free_pages(hugepage_size) < nr)
-		ksft_exit_skip("Not enough %lu Kb pages\n", hugepage_size >> 10);
+		ksft_exit_skip("Not enough %zu Kb pages\n", hugepage_size >> 10);
 
 	ksft_set_plan(2);
 	ksft_print_msg("Mapping %lu Mbytes\n", (unsigned long)length >> 20);
_

Patches currently in -mm which might be from cmllamas@google.com are



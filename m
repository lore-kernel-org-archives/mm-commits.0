Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D213D305683;
	Sun, 27 Sep 2026 20:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790539976; cv=none; b=tM3Q0T+wZ0CGK+i9EiMc2USMQrxwnHhdaNT19qIJuC0Yq5BVSI4aRJ0lAip3DY8H8SslNhrE+ZZWppw01SUAFD9SzuTTCAJtQ1rnqxpHMsr9ruUjet7eoxjL3B7ZQ8MH4boV7qLbdMylk/L8phSMuUokgKiJelRZsV4X08OoT/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790539976; c=relaxed/simple;
	bh=Brh5GM6xlZB8uduPq0gxV839Xf/60HdSoeRrVg0/PqY=;
	h=Date:To:From:Subject:Message-Id; b=ULrZtqnMoKNBOlHjdSouLQPbeh6VJGoFgchBdmLsO+QgZTTfp5i1jy3r6z3D9tiiJ8uuyNnQyD7uZffL/CjKIxn1RzQdT3Be1r+ct8XIk8yuzPt+U4I+sAjIuimJDzlpxhcUbvSObLHsH6B41FUtkvNuH6919L8n4xoTGAWr+gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wteUpcGB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wteUpcGB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 650A81F000FF;
	Sun, 27 Sep 2026 20:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790539974;
	bh=xQKKQtcLK/wmOwyAUxEk6pPhc144Z40daHqbHyFW6u0=;
	h=Date:To:From:Subject;
	b=wteUpcGBwifqVNQMpTdhPnhwqgyjzT+UuiqopjFQ1cW9XivxB575Xxwg8irv3cGbo
	 IWMLdAYCnl5hGxPhDPbVxo648ubtje7nXDndsXIM4xfjzjF08EJah4Bex8xZhX6hiC
	 4G/i9ncbdJOH43oq37CS8FMi6diiDTxpgQ6BMHpg=
Date: Sun, 27 Sep 2026 13:12:53 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,cmllamas@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-cleanup-wformat-issues-in-hugetlb-mmap.patch added to mm-hotfixes-unstable branch
Message-Id: <20260927201254.650A81F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: cleanup -Wformat issues in hugetlb-mmap
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-cleanup-wformat-issues-in-hugetlb-mmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-cleanup-wformat-issues-in-hugetlb-mmap.patch

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
Cc: Mike Rapoport <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
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

selftests-mm-cleanup-wformat-issues-in-hugetlb-mmap.patch


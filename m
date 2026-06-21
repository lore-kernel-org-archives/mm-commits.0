Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F6436D506
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067182; cv=none; b=s25Xb1Rl8vFwQbPStSIquE0+KmNzqUEQI2UM3Kxlr5xyKxfwOmGhMzN07vsoU4k8iSPmAaNzSx3Xne45dqwArXF21esc2EP6gRdMGUj0jfSP59B7k6dPEPAwf8kuQqN89DsqFdA2TtPwrBySMZyPO7kJ9Yd+NkhVnuj6XMgBnzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067182; c=relaxed/simple;
	bh=rQi/K9j7jPpadTm93nt1ghww4j5BP6MjC+umIQUYXj8=;
	h=Date:To:From:Subject:Message-Id; b=NL4jtlP08hSUgFo1d6bSnXOvQ2/ZncIMy4hZ57YGZKU4HAptx9YB0Rmf3Xi1f9pcvKxWQUoDnJGDaEjAL4GtV5dfkMZ9wwdNC8s7wAakcgRtuWI305noncI1zJh9TKTekEBbU3e3kP2YrQY8EQdfzwWlGznSAFHhMlAJZL2j6tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N4+NTFKk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N4+NTFKk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B18C1F000E9;
	Sun, 21 Jun 2026 18:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067181;
	bh=Nl2gCbqL+qLZAD1ZBkBv9O8LD0cENZsNF1Gexm+977s=;
	h=Date:To:From:Subject;
	b=N4+NTFKkdjZfiEe9Vb6Rzxu3z1lAZGubGP+SPTlOYPTuA+fpMR15gyRXr3wwnUZdI
	 lVJJPndQqoBUKVpCVefugfPGPXbBHx6PJj9EUP3HC96XPUVeB0Yl7T46bmzaxJqU8a
	 k5OSVqWyqvT1Kc1u3ORs5o7W5Ej+uZeg2Tl/ZP8s=
Date: Sun, 21 Jun 2026 11:39:40 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,peterx@redhat.com,npache@redhat.com,mhocko@suse.com,luizcap@redhat.com,ljs@kernel.org,li.wang@linux.dev,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,jhubbard@nvidia.com,jgg@ziepe.ca,donettom@linux.ibm.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-uffd-stress-use-hugetlb_save-and-alloc-huge-pages.patch removed from -mm tree
Message-Id: <20260621183941.3B18C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: uffd-stress: use hugetlb_save and alloc huge pages
has been removed from the -mm tree.  Its filename was
     selftests-mm-uffd-stress-use-hugetlb_save-and-alloc-huge-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: uffd-stress: use hugetlb_save and alloc huge pages
Date: Mon, 11 May 2026 19:28:33 +0300

uffd-stress skips HugeTLB tests if there are no free huge pages prepared
by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Link: https://lore.kernel.org/20260511162840.375890-50-rppt@kernel.org
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

 tools/testing/selftests/mm/uffd-stress.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-uffd-stress-use-hugetlb_save-and-alloc-huge-pages
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -480,9 +480,12 @@ int main(int argc, char **argv)
 	 * Ensure nr_parallel - 1 hugepages on top of that to account
 	 * for racy extra reservation of hugepages.
 	 */
-	if (gopts->test_type == TEST_HUGETLB &&
-	   hugetlb_free_default_pages() < 2 * (bytes / gopts->page_size) + gopts->nr_parallel - 1)
-		ksft_exit_skip("Skipping userfaultfd... not enough hugepages\n");
+	if (gopts->test_type == TEST_HUGETLB) {
+		unsigned long nr = 2 * (bytes / gopts->page_size) + gopts->nr_parallel - 1;
+
+		if (!hugetlb_setup_default(nr))
+			ksft_exit_skip("Skipping userfaultfd... not enough hugepages\n");
+	}
 
 	gopts->nr_pages_per_cpu = bytes / gopts->page_size / gopts->nr_parallel;
 	if (!gopts->nr_pages_per_cpu) {
_

Patches currently in -mm which might be from rppt@kernel.org are



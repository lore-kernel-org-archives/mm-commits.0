Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20303115B5
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 15:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774625321; cv=none; b=T9q79ro8ta6Wn5pbyyQzuf0IWgEcUGa73epwVMrLVM5lykdRMQqDheZnIeyoXWJmQuOeWhYDdxMsPXkHnBR1T9ZRqrSK2Rtu37fywIROVGgOu/u1KBh/g9Y0JbygrIh5FlITEmznkEIegy5JHDdkmSba3qdZx5ntfIEagqDk9dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774625321; c=relaxed/simple;
	bh=QWwHZRQ8YiYq7+9VChl7vVAGwWYAXOo9pTeD1LrIW6U=;
	h=Date:To:From:Subject:Message-Id; b=Y4RQTEmOScH1LuELFfzIX05l53jxRAWpXY9JbrZLWKEaANZX6RUBCIm/abZ4pT3DyVA7Ac+HysJR8ZlsQOM5x+agBvcfgY7NWhWqHegqdCh/9bij6ArHPEj1mFNCika/CPI9mvaoIooUjOhZfXecrsFl+vfHyXIfpOHu0Z8mleo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GKKp6sua; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GKKp6sua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E14C2BC87;
	Fri, 27 Mar 2026 15:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774625320;
	bh=QWwHZRQ8YiYq7+9VChl7vVAGwWYAXOo9pTeD1LrIW6U=;
	h=Date:To:From:Subject:From;
	b=GKKp6suafiWsz+smRyRRNiTFezrfYDL7fZiL6MAG6li58CPgR9gMFLnFt5UvA3QhZ
	 eGcvWDAl7pjAWOW8yqP6YRTnmE6+qOly0QnSRmZW5UPgNBRFKo8x4cXeLtj567ILk1
	 dCHZ4Rraj7XHqUJu6ea/2VDPcZnAsOdgB0lWpovU=
Date: Fri, 27 Mar 2026 08:28:40 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,lkp@intel.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,chris@chrisdown.name,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch removed from -mm tree
Message-Id: <20260327152840.A6E14C2BC87@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix
Date: Fri Mar 20 07:55:26 PM PDT 2026

fix build

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202603210319.P5MPyTEf-lkp@intel.com/
Cc: Chris Down <chris@chrisdown.name>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/vm_util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -124,7 +124,7 @@ bool pagemap_is_huge_zero(int fd, char *
 {
 	uint64_t categories;
 
-	if (!pagemap_scan_supported(fd, start))
+	if (!pagemap_scan_supported(fd))
 		return false;
 
 	categories = pagemap_scan_get_categories(fd, start);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-hv-vmbus-replace-deprecated-mmap-hook-with-mmap_prepare-fix.patch
selftests-mm-skip-uffd-wp-mremap-if-uffd-write-protect-is-unsupported-fix.patch
lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix.patch


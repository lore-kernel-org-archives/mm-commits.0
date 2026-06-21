Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6508C36CE03
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067161; cv=none; b=jvLRqgDnJR+VEjZgnq2vic2H9sXyjveH4PLzP/jjp7j9xPqWM19PxYGkgNlZ4OrD0lcqHT+PB6qPf52bxU5oCXbBF8cgLXGK8lvMLf67hG9mVVFQA4rzOiEWW2duaVA/mo7/wS/SNef/ylENgYdtlK2wMAvrJ/S1tczC1ylzizg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067161; c=relaxed/simple;
	bh=+H5kJEAw5gWBuctfo4kBi4XldDKXiJSrOLTR1h7p69c=;
	h=Date:To:From:Subject:Message-Id; b=XRAAl5reIrW9BE8Ww3MxmEHr+SvYVo/TazAJd6Z7GHqbF0Y477sLVZFbREueuwBAgUcens/eNCWkmAGFxhaPbEzJSMP7K8SNyMGPnaMC1NcJ9xvLHP5QxUPWmIHBppzL4KLSh6zvlIXtnNV4MQTNpcUspNw+ioyPhKjKsHJTCoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IUoVpcbH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IUoVpcbH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FAD61F00A3A;
	Sun, 21 Jun 2026 18:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067160;
	bh=zD0eQzRs4lFsN+Ut963GZXqHntAk1hl0B6yOgOuHlBI=;
	h=Date:To:From:Subject;
	b=IUoVpcbH78f7kmdnUeWjt0paerpU2tZJcHmHnpTDnCL8LbsW411SLuvdVOtmczT+/
	 8budzdvEvw2Pqes/r5xcMt5o/lcm3ImHkiqmhyWPUKus/2ZqQqJPfAP4CRscD6oHcE
	 ZQptK3RdLSiSxWtdXSx/UqwCPhhPZ56MKZRrCgwo=
Date: Sun, 21 Jun 2026 11:39:19 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,peterx@redhat.com,npache@redhat.com,mhocko@suse.com,luizcap@redhat.com,ljs@kernel.org,li.wang@linux.dev,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,jhubbard@nvidia.com,jgg@ziepe.ca,donettom@linux.ibm.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-gup_longterm-add-setup-of-hugetlb-pages.patch removed from -mm tree
Message-Id: <20260621183920.3FAD61F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: gup_longterm: add setup of HugeTLB pages
has been removed from the -mm tree.  Its filename was
     selftests-mm-gup_longterm-add-setup-of-hugetlb-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: gup_longterm: add setup of HugeTLB pages
Date: Mon, 11 May 2026 19:28:17 +0300

gup_longterm tests skips HugeTLB tests if there are no free huge pages
prepared by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Link: https://lore.kernel.org/20260511162840.375890-34-rppt@kernel.org
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

 tools/testing/selftests/mm/gup_longterm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/gup_longterm.c~selftests-mm-gup_longterm-add-setup-of-hugetlb-pages
+++ a/tools/testing/selftests/mm/gup_longterm.c
@@ -510,7 +510,7 @@ int main(int argc, char **argv)
 	int i;
 
 	pagesize = getpagesize();
-	nr_hugetlbsizes = detect_hugetlb_page_sizes(hugetlbsizes,
+	nr_hugetlbsizes = hugetlb_setup(2, hugetlbsizes,
 						    ARRAY_SIZE(hugetlbsizes));
 
 	ksft_print_header();
_

Patches currently in -mm which might be from rppt@kernel.org are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B7B36D506
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067186; cv=none; b=iFFwjl8lujdQEFmPnm5BLpHPkvQzm/FDm7nJFAcm1kf1uR2Jot1GaOAmD2XLVmkT6HjNZtu2gBkIX4/wUyYJrUshA6MxpBovV8hhWENTZBR2IbIs72u8HfxpBqxabgXPlwwa95HWHrxgVNavfO1OGyLrlmG2VCU/XLH5/lA1CvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067186; c=relaxed/simple;
	bh=LUonG1YmkvR4TXlCljI6kqLJt99Ie5e65YZkD6KLqBo=;
	h=Date:To:From:Subject:Message-Id; b=hvtgnkd+bYGDKgeiurpDVsLcBD6BGmAx4MhQf1evAnWPkhZBzntZA5K/cC5PJqpE1TnnUc1XV2dNwx11o2TqltqzgI0lG4VSZZ94Q2SfDPBBQlUzx4SbMYAsIdaflJcJCy9iHFmRRktTdyE+OnqyjIzxq3TafFQYNWq/4EMgsvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wWv3Aj6r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wWv3Aj6r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8E61F00A3A;
	Sun, 21 Jun 2026 18:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067185;
	bh=SOW65rlGiGF+GbW+i/vWSOehVl7+mtvbt9c0IsICNEM=;
	h=Date:To:From:Subject;
	b=wWv3Aj6roptodUTqwtGhZyBWME7pLO/twIXGAFdWrejRSMxSL5Oj580WJNVq55T/m
	 maZZi3DoWPAWwxiysrntGVxiaCJ4t4wVv92DKNL5SplJ72z/OEcykhaKLbc2X0Ioo4
	 XeaF1GpIz+c56n2ugN2KY1vJPdYavInFn18Bb8Kk=
Date: Sun, 21 Jun 2026 11:39:44 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,peterx@redhat.com,npache@redhat.com,mhocko@suse.com,luizcap@redhat.com,ljs@kernel.org,li.wang@linux.dev,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,jhubbard@nvidia.com,jgg@ziepe.ca,donettom@linux.ibm.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-va_high_addr_switch-add-setup-of-hugetlb-pages.patch removed from -mm tree
Message-Id: <20260621183945.2D8E61F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: va_high_addr_switch: add setup of HugeTLB pages
has been removed from the -mm tree.  Its filename was
     selftests-mm-va_high_addr_switch-add-setup-of-hugetlb-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: va_high_addr_switch: add setup of HugeTLB pages
Date: Mon, 11 May 2026 19:28:36 +0300

va_high_addr_switch skips HugeTLB tests if there are no free huge pages
prepared by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Link: https://lore.kernel.org/20260511162840.375890-53-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Luiz Capitulino <luizcap@redhat.com>
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

 tools/testing/selftests/mm/va_high_addr_switch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/va_high_addr_switch.c~selftests-mm-va_high_addr_switch-add-setup-of-hugetlb-pages
+++ a/tools/testing/selftests/mm/va_high_addr_switch.c
@@ -325,7 +325,7 @@ int main(int argc, char **argv)
 	if (!supported_arch())
 		ksft_exit_skip("Architecture not supported\n");
 
-	if (argc == 2 && !strcmp(argv[1], "--run-hugetlb"))
+	if (hugetlb_setup_default(6))
 		run_hugetlb = true;
 
 	testcases_init();
_

Patches currently in -mm which might be from rppt@kernel.org are



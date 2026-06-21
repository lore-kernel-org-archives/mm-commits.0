Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395D536C5B2
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067152; cv=none; b=DPVGJz5GeHU4cVNxHgormaTRF7mou+taTwYRZIiQxZY0Tt4FGOY55tdBUh1891fkyymerLsXNEkEBwak7JjRPTIggsMEuFezq0JWTLO5qB6CP4pV3xAA7xZF/dyoRAyUDsFP9fvd8WlFMwTU8huTBDkjiEvcGDHwYp5DGAMwpCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067152; c=relaxed/simple;
	bh=vsvdiAwbBWSZcytRmkMBk/yfApraaEhusOfJYy+K8aA=;
	h=Date:To:From:Subject:Message-Id; b=EvPSeuy8JamA3B6iWlWyB/YdczjhUt9pDTpOxa01nfAkbHkwgDSd3eUVTsqbgLyBixM/SaXX1DX6dCO2tvuK3KKtaYg+G328ezNDn5QXwrNtVSokkAHug+t1MDbwPtIt7LnsxrFhgGjbA/VtdpakGiYkYdV9V6l44TUdGU3LXwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Pmj23Evt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Pmj23Evt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12E071F000E9;
	Sun, 21 Jun 2026 18:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067151;
	bh=ucLinLAhlzOJ8QVbFsyf0u269YuNB11DXy1RCcKLf+M=;
	h=Date:To:From:Subject;
	b=Pmj23Evt7kmKdk/Lc1we73ROfWCEjyykhf5q5+G4UGXOzBrwo5ijqxZQl0BqUWUl7
	 CyloBXB1hVqwYNLj42W//TCKLQVkEKMuBD5z0kxjUFjFl9SybbNumvUNW1CtWoAQJ+
	 PMt4iW9GgOvE1OM+g45kkODcXRVyH5pDo1ymvUnc=
Date: Sun, 21 Jun 2026 11:39:10 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,peterx@redhat.com,npache@redhat.com,mhocko@suse.com,luizcap@redhat.com,ljs@kernel.org,li.wang@linux.dev,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,jhubbard@nvidia.com,jgg@ziepe.ca,donettom@linux.ibm.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-hugepage_settings-add-apis-to-get-and-set-nr_hugepages.patch removed from -mm tree
Message-Id: <20260621183911.12E071F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: hugepage_settings: add APIs to get and set nr_hugepages
has been removed from the -mm tree.  Its filename was
     selftests-mm-hugepage_settings-add-apis-to-get-and-set-nr_hugepages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: hugepage_settings: add APIs to get and set nr_hugepages
Date: Mon, 11 May 2026 19:28:10 +0300

Add APIs that allow reading and writing of

/sys/kernel/mm/hugepages/hugepages-NkB/nr_hugepages

to detect and change the amount of HugeTLB pages of different sizes.

Link: https://lore.kernel.org/20260511162840.375890-27-rppt@kernel.org
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

 tools/testing/selftests/mm/hugepage_settings.c |   25 +++++++++++++++
 tools/testing/selftests/mm/hugepage_settings.h |   23 +++++++++++++
 2 files changed, 48 insertions(+)

--- a/tools/testing/selftests/mm/hugepage_settings.c~selftests-mm-hugepage_settings-add-apis-to-get-and-set-nr_hugepages
+++ a/tools/testing/selftests/mm/hugepage_settings.c
@@ -463,3 +463,28 @@ unsigned long get_free_hugepages(void)
 	fclose(f);
 	return fhp;
 }
+
+static void hugetlb_sysfs_path(char *buf, size_t buflen,
+			       unsigned long size, const char *attr)
+{
+	snprintf(buf, buflen, "/sys/kernel/mm/hugepages/hugepages-%lukB/%s",
+		 size / 1024, attr);
+}
+
+unsigned long hugetlb_nr_pages(unsigned long size)
+{
+	char path[PATH_MAX];
+
+	hugetlb_sysfs_path(path, sizeof(path), size, "nr_hugepages");
+
+	return read_num(path);
+}
+
+void hugetlb_set_nr_pages(unsigned long size, unsigned long nr)
+{
+	char path[PATH_MAX];
+
+	hugetlb_sysfs_path(path, sizeof(path), size, "nr_hugepages");
+
+	write_num(path, nr);
+}
--- a/tools/testing/selftests/mm/hugepage_settings.h~selftests-mm-hugepage_settings-add-apis-to-get-and-set-nr_hugepages
+++ a/tools/testing/selftests/mm/hugepage_settings.h
@@ -94,4 +94,27 @@ int detect_hugetlb_page_sizes(unsigned l
 unsigned long default_huge_page_size(void);
 unsigned long get_free_hugepages(void);
 
+unsigned long hugetlb_nr_pages(unsigned long size);
+void hugetlb_set_nr_pages(unsigned long size, unsigned long nr);
+
+static inline unsigned long hugetlb_nr_default_pages(void)
+{
+	unsigned long size = default_huge_page_size();
+
+	if (!size)
+		return 0;
+
+	return hugetlb_nr_pages(size);
+}
+
+static inline void hugetlb_set_nr_default_pages(unsigned long nr)
+{
+	unsigned long size = default_huge_page_size();
+
+	if (!size)
+		return;
+
+	hugetlb_set_nr_pages(size, nr);
+}
+
 #endif /* __HUGEPAGE_SETTINGS_H__ */
_

Patches currently in -mm which might be from rppt@kernel.org are



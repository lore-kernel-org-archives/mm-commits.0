Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91288A953
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 20:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723579994; cv=none; b=g6QfnplC5t5D5zr0qC4BtvWLI69kse1cnHkM2nMI/XD9d8KiQJvOmkQ6wkLKYXQdpID5OhKAlU/4NFYZHvjWYv6Lni8oRvvHOiIN6Xn2OYbC1e/p+/yMIQ0IbFAr07UCK0XZhQ0qAQYhnHJxNaoBmOSNgHCc/npCMXMA+7xusqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723579994; c=relaxed/simple;
	bh=KtwypgOveP+4vY4zmi81UFlOHR6+TWbqMRyI0yGGhC8=;
	h=Date:To:From:Subject:Message-Id; b=JkTZqMeeSfoxYD4vA3xuauE1JD3U25G7HjR3GIpOdNPln4YjgLPOXdqdS/M7WtagjJo9L5szInhA6WpPIWuzY0YcIK6d0Vx0IVagvNbaV6CC2btgvFnuH+gRqrEih4Yq4jU1sf/X7sz/4mEjScdkJ9d8a4pIrsXxRcxThF8mTas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FuCpeoVS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FuCpeoVS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F0BC32782;
	Tue, 13 Aug 2024 20:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723579994;
	bh=KtwypgOveP+4vY4zmi81UFlOHR6+TWbqMRyI0yGGhC8=;
	h=Date:To:From:Subject:From;
	b=FuCpeoVSjISNgpHwo8pNZ5a8oA5DlNVhu0KDHVxi/pZob3R8d9w8yKdZyI1sAKVsi
	 o/LZ7ROFJPd9xus2Z/DLZzZMoTcD7HM9kx5o6A6i8LTbfzO1sIQlWZKB3Gn/EXsqqK
	 ug1IukEttBCkXuB3LCwgTh/U6rSw/ZhXX6N7T+zs=
Date: Tue, 13 Aug 2024 13:13:13 -0700
To: mm-commits@vger.kernel.org,zhais@google.com,yuzhao@google.com,willy@infradead.org,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,roman.gushchin@linux.dev,riel@surriel.com,hannes@cmpxchg.org,david@redhat.com,corbet@lwn.net,cerasuolodomenico@gmail.com,baohua@kernel.org,alexlzhu@fb.com,ak@linux.intel.com,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-sysfs-entry-to-disable-splitting-underutilized-thps.patch added to mm-unstable branch
Message-Id: <20240813201314.20F0BC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add sysfs entry to disable splitting underutilized THPs
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-sysfs-entry-to-disable-splitting-underutilized-thps.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-sysfs-entry-to-disable-splitting-underutilized-thps.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Usama Arif <usamaarif642@gmail.com>
Subject: mm: add sysfs entry to disable splitting underutilized THPs
Date: Tue, 13 Aug 2024 13:02:49 +0100

If disabled, THPs faulted in or collapsed will not be added to
_deferred_list, and therefore won't be considered for splitting under
memory pressure if underutilized.

Link: https://lkml.kernel.org/r/20240813120328.1275952-7-usamaarif642@gmail.com
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Cc: Alexander Zhu <alexlzhu@fb.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Shuang Zhai <zhais@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- a/mm/huge_memory.c~mm-add-sysfs-entry-to-disable-splitting-underutilized-thps
+++ a/mm/huge_memory.c
@@ -74,6 +74,7 @@ static unsigned long deferred_split_coun
 					  struct shrink_control *sc);
 static unsigned long deferred_split_scan(struct shrinker *shrink,
 					 struct shrink_control *sc);
+static bool split_underutilized_thp = true;
 
 static atomic_t huge_zero_refcount;
 struct folio *huge_zero_folio __read_mostly;
@@ -439,6 +440,27 @@ static ssize_t hpage_pmd_size_show(struc
 static struct kobj_attribute hpage_pmd_size_attr =
 	__ATTR_RO(hpage_pmd_size);
 
+static ssize_t split_underutilized_thp_show(struct kobject *kobj,
+			    struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%d\n", split_underutilized_thp);
+}
+
+static ssize_t split_underutilized_thp_store(struct kobject *kobj,
+			     struct kobj_attribute *attr,
+			     const char *buf, size_t count)
+{
+	int err = kstrtobool(buf, &split_underutilized_thp);
+
+	if (err < 0)
+		return err;
+
+	return count;
+}
+
+static struct kobj_attribute split_underutilized_thp_attr = __ATTR(
+	thp_low_util_shrinker, 0644, split_underutilized_thp_show, split_underutilized_thp_store);
+
 static struct attribute *hugepage_attr[] = {
 	&enabled_attr.attr,
 	&defrag_attr.attr,
@@ -447,6 +469,7 @@ static struct attribute *hugepage_attr[]
 #ifdef CONFIG_SHMEM
 	&shmem_enabled_attr.attr,
 #endif
+	&split_underutilized_thp_attr.attr,
 	NULL,
 };
 
@@ -3468,6 +3491,9 @@ void deferred_split_folio(struct folio *
 	if (folio_order(folio) <= 1)
 		return;
 
+	if (!partially_mapped && !split_underutilized_thp)
+		return;
+
 	/*
 	 * The try_to_unmap() in page reclaim path might reach here too,
 	 * this may cause a race condition to corrupt deferred split queue.
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

mm-introduce-a-pageflag-for-partially-mapped-folios.patch
mm-split-underutilized-thps.patch
mm-add-sysfs-entry-to-disable-splitting-underutilized-thps.patch


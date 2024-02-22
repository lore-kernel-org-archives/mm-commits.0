Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84F91118B
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560212; cv=none; b=d035ZsQ+Ot7B48O75QLu9+9FdEiSJQHHH+Wr9rhBlK8hqA7XqTXixouht954IaolcG2+EmmH0h2vH5WdhPeP3QYgG4F0dW3QJ/jgJWG0CkMxNNoq6cUSgBbvtsl29NlruaSy53SacVWgUamHXQxM3t1PucYOfaOxfLuTQnJYgXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560212; c=relaxed/simple;
	bh=e9vU6KqMNKjGYcdmzjIqsoLCw7L4idfmIBM45MKb+fc=;
	h=Date:To:From:Subject:Message-Id; b=M/ruOA9EFx+c3nopCjZyrTNDo5xeGJM11nkdNX2nok4wNV7hZCJXL0Xy3p5yTFQ5RfhYUzXJW5OqfziSh98y++yjAg8tuFXpG8NGN3TNum74j+4l5eVfLOg5RuXlaC4tMwWzgNcNqOeLC1dTt9aDcZmjGoluRNfCwKEjBCSsJx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SG4y5ZuX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SG4y5ZuX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB63C433F1;
	Thu, 22 Feb 2024 00:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560211;
	bh=e9vU6KqMNKjGYcdmzjIqsoLCw7L4idfmIBM45MKb+fc=;
	h=Date:To:From:Subject:From;
	b=SG4y5ZuXrCJsBKeCiOp6uJ6ksAv6lQsCyVaEZ59797i7vSo7cLPW4CSDdqR/b4+p4
	 BGylcmo/cJSeYJ6IMd8IEovPq9bNDuuNcxJuoY589zmUOE14//ywl9CwZrAS4Opx+G
	 3OnQnwlJcSzLwt3Y9hB+hgSi11DJCkT3LCSjH+TM=
Date: Wed, 21 Feb 2024 16:03:31 -0800
To: mm-commits@vger.kernel.org,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-cma-add-sysfs-file-release_pages_success.patch removed from -mm tree
Message-Id: <20240222000331.BCB63C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/cma: add sysfs file 'release_pages_success'
has been removed from the -mm tree.  Its filename was
     mm-cma-add-sysfs-file-release_pages_success.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/cma: add sysfs file 'release_pages_success'
Date: Tue, 6 Feb 2024 10:27:31 +0530

This adds the following new sysfs file tracking the number of successfully
released pages from a given CMA heap area.  This file will be available
via CONFIG_CMA_SYSFS and help in determining active CMA pages available on
the CMA heap area.  This adds a new 'nr_pages_released' (CONFIG_CMA_SYSFS)
into 'struct cma' which gets updated during cma_release().

/sys/kernel/mm/cma/<cma-heap-area>/release_pages_success

After this change, an user will be able to find active CMA pages available
in a given CMA heap area via the following method.

Active pages = alloc_pages_success - release_pages_success

That's valuable information for both software designers, and system admins
as it allows them to tune the number of CMA pages available in the system.
This increases user visibility for allocated CMA area and its
utilization.

Link: https://lkml.kernel.org/r/20240206045731.472759-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-cma |    6 ++++++
 mm/cma.c                                      |    1 +
 mm/cma.h                                      |    5 +++++
 mm/cma_sysfs.c                                |   15 +++++++++++++++
 4 files changed, 27 insertions(+)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-cma~mm-cma-add-sysfs-file-release_pages_success
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-cma
@@ -23,3 +23,9 @@ Date:		Feb 2021
 Contact:	Minchan Kim <minchan@kernel.org>
 Description:
 		the number of pages CMA API failed to allocate
+
+What:		/sys/kernel/mm/cma/<cma-heap-name>/release_pages_success
+Date:		Feb 2024
+Contact:	Anshuman Khandual <anshuman.khandual@arm.com>
+Description:
+		the number of pages CMA API succeeded to release
--- a/mm/cma.c~mm-cma-add-sysfs-file-release_pages_success
+++ a/mm/cma.c
@@ -562,6 +562,7 @@ bool cma_release(struct cma *cma, const
 
 	free_contig_range(pfn, count);
 	cma_clear_bitmap(cma, pfn, count);
+	cma_sysfs_account_release_pages(cma, count);
 	trace_cma_release(cma->name, pfn, pages, count);
 
 	return true;
--- a/mm/cma.h~mm-cma-add-sysfs-file-release_pages_success
+++ a/mm/cma.h
@@ -27,6 +27,8 @@ struct cma {
 	atomic64_t nr_pages_succeeded;
 	/* the number of CMA page allocation failures */
 	atomic64_t nr_pages_failed;
+	/* the number of CMA page released */
+	atomic64_t nr_pages_released;
 	/* kobject requires dynamic object */
 	struct cma_kobject *cma_kobj;
 #endif
@@ -44,10 +46,13 @@ static inline unsigned long cma_bitmap_m
 #ifdef CONFIG_CMA_SYSFS
 void cma_sysfs_account_success_pages(struct cma *cma, unsigned long nr_pages);
 void cma_sysfs_account_fail_pages(struct cma *cma, unsigned long nr_pages);
+void cma_sysfs_account_release_pages(struct cma *cma, unsigned long nr_pages);
 #else
 static inline void cma_sysfs_account_success_pages(struct cma *cma,
 						   unsigned long nr_pages) {};
 static inline void cma_sysfs_account_fail_pages(struct cma *cma,
 						unsigned long nr_pages) {};
+static inline void cma_sysfs_account_release_pages(struct cma *cma,
+						   unsigned long nr_pages) {};
 #endif
 #endif
--- a/mm/cma_sysfs.c~mm-cma-add-sysfs-file-release_pages_success
+++ a/mm/cma_sysfs.c
@@ -24,6 +24,11 @@ void cma_sysfs_account_fail_pages(struct
 	atomic64_add(nr_pages, &cma->nr_pages_failed);
 }
 
+void cma_sysfs_account_release_pages(struct cma *cma, unsigned long nr_pages)
+{
+	atomic64_add(nr_pages, &cma->nr_pages_released);
+}
+
 static inline struct cma *cma_from_kobj(struct kobject *kobj)
 {
 	return container_of(kobj, struct cma_kobject, kobj)->cma;
@@ -48,6 +53,15 @@ static ssize_t alloc_pages_fail_show(str
 }
 CMA_ATTR_RO(alloc_pages_fail);
 
+static ssize_t release_pages_success_show(struct kobject *kobj,
+					  struct kobj_attribute *attr, char *buf)
+{
+	struct cma *cma = cma_from_kobj(kobj);
+
+	return sysfs_emit(buf, "%llu\n", atomic64_read(&cma->nr_pages_released));
+}
+CMA_ATTR_RO(release_pages_success);
+
 static void cma_kobj_release(struct kobject *kobj)
 {
 	struct cma *cma = cma_from_kobj(kobj);
@@ -60,6 +74,7 @@ static void cma_kobj_release(struct kobj
 static struct attribute *cma_attrs[] = {
 	&alloc_pages_success_attr.attr,
 	&alloc_pages_fail_attr.attr,
+	&release_pages_success_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(cma);
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are



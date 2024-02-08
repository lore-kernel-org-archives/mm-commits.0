Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A00A1DFE8
	for <mm-commits@vger.kernel.org>; Thu,  8 Feb 2024 00:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707350868; cv=none; b=UokplpeaxwkvbD+pkA7AcwkSTkSi0KKJvruDGhgxiIfSkaavIqJnTGpIN8T4wWKU3rGgNwqtUJ+qAQFJGV2fuESHZnrBKMd07OVuVFj5AsHhheDpwf2xKYywh4paL81MQhN0cY1zL/QPg9eLd8BGOJuWic+92172pyw2hkervcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707350868; c=relaxed/simple;
	bh=KC1tsF0nujLznbmyYW4Gc7BFxalFzHR9Wi0H/u2NflU=;
	h=Date:To:From:Subject:Message-Id; b=fGOpZ6j5TrC8rA0Ku/uarm2o+ObDKlqNmBf71xG3zy7h5OcwfMGH1AZZdyy2gd6m8E+Mh/mGG+DK+dpP9mPGHgb22cnaA6jqFr6W6c0NLNhPNBzsN3QXiud8uOFqAOiRed56pUF0SyLLsQMxGZXZhmsIbouDJ7looCmetkB6b28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yc+jYrtN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yc+jYrtN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66833C433F1;
	Thu,  8 Feb 2024 00:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707350867;
	bh=KC1tsF0nujLznbmyYW4Gc7BFxalFzHR9Wi0H/u2NflU=;
	h=Date:To:From:Subject:From;
	b=yc+jYrtN0iaDAjA1gut+Dmp3zPeVSNBFq2lXC/1AtQbgdfWwfygPmFNM5sj8mTxk4
	 k3jO8sb85a66wxfEpkMywzaOSU37OgZ4es5EnlDbilx7PbB3XjuzW1eVYe8OGPObaN
	 zyHIzdZlsxqT0lBc1aULo2a3VGQYgMPjiTWzuGWc=
Date: Wed, 07 Feb 2024 16:07:46 -0800
To: mm-commits@vger.kernel.org,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-add-sysfs-file-release_pages_success.patch added to mm-unstable branch
Message-Id: <20240208000747.66833C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/cma: add sysfs file 'release_pages_success'
has been added to the -mm mm-unstable branch.  Its filename is
     mm-cma-add-sysfs-file-release_pages_success.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-add-sysfs-file-release_pages_success.patch

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

mm-cma-dont-treat-bad-input-arguments-for-cma_alloc-as-its-failure.patch
mm-cma-drop-config_cma_debug.patch
mm-cma-make-max_cma_areas-=-config_cma_areas.patch
mm-cma-add-sysfs-file-release_pages_success.patch


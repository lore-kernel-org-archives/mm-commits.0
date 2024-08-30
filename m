Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903991C2320
	for <mm-commits@vger.kernel.org>; Fri, 30 Aug 2024 22:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725057443; cv=none; b=XNf+eDGVentq6zU1+eik83jZ/mw6yQRLqWlqWis/SGvBlzUFYo0f/5fsU51xvN2tlqgkctW2NkZfVB7uUw9nQvJK40koz1AurdBNuKS+ByZuJjvweaqsqSkDnStbLyWww/bjCpfZeHsWdTFk5IKvOLlhTgVchmWlSraoEe7J7FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725057443; c=relaxed/simple;
	bh=SMz2d538NKZogZr4LLr74cjuchkE9g1nyDlLPpRyEP4=;
	h=Date:To:From:Subject:Message-Id; b=HZzPip5Lmupzpdq7sYXVaidnhFpEBhCCbNuY9z7dzWP8DJULTUBO3H7nzsAf+fIAAj6JRYKmgJl51uzQ8XTir2Tp/Urndj4NZqEDh+6tbqQ65VGqzTpp2h8bPkEevG2F6gBLfyF1X9treGdFJS9Df0SbJCrMLa15m5gAmhl8nms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FGG5zmf3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FGG5zmf3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DE83C4CEC2;
	Fri, 30 Aug 2024 22:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725057443;
	bh=SMz2d538NKZogZr4LLr74cjuchkE9g1nyDlLPpRyEP4=;
	h=Date:To:From:Subject:From;
	b=FGG5zmf3cKRcF05csHaw9sYIcGmxWzHumsMjTt68hj/AJgZuowlxwoalRwINR7AOV
	 SneCyEOPGiLCFHaOE5LQZ4yMwVkILsatc6gSbcOZu5uFvpigvDJe8PkIEZBFaukO/F
	 3jwZsA/mLHhBd8ry/f5SFchPLzgx0SWIXFG0/tuo=
Date: Fri, 30 Aug 2024 15:37:22 -0700
To: mm-commits@vger.kernel.org,zhais@google.com,yuzhao@google.com,willy@infradead.org,shakeel.butt@linux.dev,ryncsn@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,roman.gushchin@linux.dev,riel@surriel.com,npache@redhat.com,hannes@cmpxchg.org,david@redhat.com,corbet@lwn.net,cerasuolodomenico@gmail.com,baohua@kernel.org,alexlzhu@fb.com,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-sysfs-entry-to-disable-splitting-underused-thps.patch added to mm-unstable branch
Message-Id: <20240830223723.1DE83C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add sysfs entry to disable splitting underused THPs
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-sysfs-entry-to-disable-splitting-underused-thps.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-sysfs-entry-to-disable-splitting-underused-thps.patch

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
Subject: mm: add sysfs entry to disable splitting underused THPs
Date: Fri, 30 Aug 2024 11:03:40 +0100

If disabled, THPs faulted in or collapsed will not be added to
_deferred_list, and therefore won't be considered for splitting under
memory pressure if underused.

Link: https://lkml.kernel.org/r/20240830100438.3623486-7-usamaarif642@gmail.com
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Cc: Alexander Zhu <alexlzhu@fb.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Shuang Zhai <zhais@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |   10 +++++++
 mm/huge_memory.c                           |   26 +++++++++++++++++++
 2 files changed, 36 insertions(+)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-add-sysfs-entry-to-disable-splitting-underused-thps
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -202,6 +202,16 @@ PMD-mappable transparent hugepage::
 
 	cat /sys/kernel/mm/transparent_hugepage/hpage_pmd_size
 
+All THPs at fault and collapse time will be added to _deferred_list,
+and will therefore be split under memory presure if they are considered
+"underused". A THP is underused if the number of zero-filled pages in
+the THP is above max_ptes_none (see below). It is possible to disable
+this behaviour by writing 0 to shrink_underused, and enable it by writing
+1 to it::
+
+	echo 0 > /sys/kernel/mm/transparent_hugepage/shrink_underused
+	echo 1 > /sys/kernel/mm/transparent_hugepage/shrink_underused
+
 khugepaged will be automatically started when PMD-sized THP is enabled
 (either of the per-size anon control or the top-level control are set
 to "always" or "madvise"), and it'll be automatically shutdown when
--- a/mm/huge_memory.c~mm-add-sysfs-entry-to-disable-splitting-underused-thps
+++ a/mm/huge_memory.c
@@ -74,6 +74,7 @@ static unsigned long deferred_split_coun
 					  struct shrink_control *sc);
 static unsigned long deferred_split_scan(struct shrinker *shrink,
 					 struct shrink_control *sc);
+static bool split_underused_thp = true;
 
 static atomic_t huge_zero_refcount;
 struct folio *huge_zero_folio __read_mostly;
@@ -440,6 +441,27 @@ static ssize_t hpage_pmd_size_show(struc
 static struct kobj_attribute hpage_pmd_size_attr =
 	__ATTR_RO(hpage_pmd_size);
 
+static ssize_t split_underused_thp_show(struct kobject *kobj,
+			    struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%d\n", split_underused_thp);
+}
+
+static ssize_t split_underused_thp_store(struct kobject *kobj,
+			     struct kobj_attribute *attr,
+			     const char *buf, size_t count)
+{
+	int err = kstrtobool(buf, &split_underused_thp);
+
+	if (err < 0)
+		return err;
+
+	return count;
+}
+
+static struct kobj_attribute split_underused_thp_attr = __ATTR(
+	shrink_underused, 0644, split_underused_thp_show, split_underused_thp_store);
+
 static struct attribute *hugepage_attr[] = {
 	&enabled_attr.attr,
 	&defrag_attr.attr,
@@ -448,6 +470,7 @@ static struct attribute *hugepage_attr[]
 #ifdef CONFIG_SHMEM
 	&shmem_enabled_attr.attr,
 #endif
+	&split_underused_thp_attr.attr,
 	NULL,
 };
 
@@ -3601,6 +3624,9 @@ void deferred_split_folio(struct folio *
 	if (folio_order(folio) <= 1)
 		return;
 
+	if (!partially_mapped && !split_underused_thp)
+		return;
+
 	/*
 	 * The try_to_unmap() in page reclaim path might reach here too,
 	 * this may cause a race condition to corrupt deferred split queue.
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

revert-mm-skip-cma-pages-when-they-are-not-available.patch
revert-mm-skip-cma-pages-when-they-are-not-available-update.patch
mm-store-zero-pages-to-be-swapped-out-in-a-bitmap.patch
mm-remove-code-to-handle-same-filled-pages.patch
mm-introduce-a-pageflag-for-partially-mapped-folios.patch
mm-split-underused-thps.patch
mm-add-sysfs-entry-to-disable-splitting-underused-thps.patch


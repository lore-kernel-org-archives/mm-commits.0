Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050D5431A5B
	for <mm-commits@vger.kernel.org>; Mon, 10 Aug 2026 17:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786383647; cv=none; b=BuyhGBeOITeTVa5TQoPfZ76lSOe5zYj1M7i7UeQjQWQsPeKpznLtMf0DUtmI8zYgJx0aOmshpX04JpI0OMZe2WVBn9B9dGRFjl6OolFgdRRS6i50ltvsowaTLlxSIR2BkLrf8/z+umSpnelM8GBowRylmT9ukqIjMp4HLpyNMvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786383647; c=relaxed/simple;
	bh=2KmkJIUN0BzhXviXLZSnVaOnAkDZh13CU9+aDbH1NkM=;
	h=Date:To:From:Subject:Message-Id; b=G+7V/VyrI/68mitflzsw5OKR3reRfUJEG31ZLpFLDYFd6DRPGFeEZ4NGWw7ZwGXn0X7kwkiobMYSyEQzODnQRExRkG5XtrNrSd766yI22YU9m8rK0BHBnBiHvuinZjfeUqG6UCZi18Ind8J3l3hoCTJrYHJkAiw7KR92RvnNJOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WkxS7GXe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WkxS7GXe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5746B1F000E9;
	Mon, 10 Aug 2026 17:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786383644;
	bh=BhIfQhO6AOF8++1qI5TyBS2029NaapdQov5URjl513k=;
	h=Date:To:From:Subject;
	b=WkxS7GXeHzsRoPo/tIruXGzq5gvbJK8NCmjtgP9kPikWNe0eLnMqERTxYWaKiRnwo
	 qHctn3Rwh3L92QJpm8Hpi7FN2i62OrPXqM/FOEQIqnCxpOJ13/95M/SjlT4k410KZ4
	 8KOBhCfJhD7KRywuQh+VrznZqae8D4FYu4emgliA=
Date: Mon, 10 Aug 2026 10:40:43 -0700
To: mm-commits@vger.kernel.org,yang.lee@linux.alibaba.com,peterx@redhat.com,jhubbard@nvidia.com,jgg@ziepe.ca,cuiyunhui@bytedance.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup_test-keep-longterm-pin-state-per-file.patch added to mm-new branch
Message-Id: <20260810174044.5746B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup_test: keep longterm pin state per file
has been added to the -mm mm-new branch.  Its filename is
     mm-gup_test-keep-longterm-pin-state-per-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup_test-keep-longterm-pin-state-per-file.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/gup_test: keep longterm pin state per file
Date: Mon, 10 Aug 2026 13:31:14 +0200

The pin longterm test currently stores its data globally, shared among
multiple concurrent users of the interface (multiple open file descriptors
-> multiple "struct file"'s).  That makes the gup_test interface
problematic to use concurrently: two users, such as concurrent selftest
runs, can interfere with the same longterm pin state.

While this has not been observed as a problem so far in practice, let's
just handle it cleanly.  There could be a way to trigger selftest failures
by e.g., running the cow.c and gup_longerm.c selftests concurrently, but
we usually run them sequentially.  Let's add a "Fixes" tag to be safe, but
not need to CC stable.

Link: https://lore.kernel.org/20260810-gup_test_data-v1-1-fb1d41be5bb4@kernel.org
Fixes: c77369b437f9 ("mm/gup_test: start/stop/read functionality for PIN LONGTERM test")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reported-by: yunhui cui <cuiyunhui@bytedance.com>
Closes: https://lore.kernel.org/r/20260608025043.88087-1-cuiyunhui@bytedance.com
Tested-by: Yunhui Cui <cuiyunhui@bytedance.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup_test.c |   94 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 62 insertions(+), 32 deletions(-)

--- a/mm/gup_test.c~mm-gup_test-keep-longterm-pin-state-per-file
+++ a/mm/gup_test.c
@@ -8,6 +8,12 @@
 #include <linux/highmem.h>
 #include "gup_test.h"
 
+struct gup_test_data {
+	struct mutex longterm_mutex;
+	struct page **longterm_pages;
+	unsigned long longterm_nr_pages;
+};
+
 static void put_back_pages(unsigned int cmd, struct page **pages,
 			   unsigned long nr_pages, unsigned int gup_test_flags)
 {
@@ -208,23 +214,20 @@ free_pages:
 	return ret;
 }
 
-static DEFINE_MUTEX(pin_longterm_test_mutex);
-static struct page **pin_longterm_test_pages;
-static unsigned long pin_longterm_test_nr_pages;
-
-static inline void pin_longterm_test_stop(void)
+static inline void pin_longterm_test_stop(struct gup_test_data *data)
 {
-	if (pin_longterm_test_pages) {
-		if (pin_longterm_test_nr_pages)
-			unpin_user_pages(pin_longterm_test_pages,
-					 pin_longterm_test_nr_pages);
-		kvfree(pin_longterm_test_pages);
-		pin_longterm_test_pages = NULL;
-		pin_longterm_test_nr_pages = 0;
+	if (data->longterm_pages) {
+		if (data->longterm_nr_pages)
+			unpin_user_pages(data->longterm_pages,
+					 data->longterm_nr_pages);
+		kvfree(data->longterm_pages);
+		data->longterm_pages = NULL;
+		data->longterm_nr_pages = 0;
 	}
 }
 
-static inline int pin_longterm_test_start(unsigned long arg)
+static inline int pin_longterm_test_start(struct gup_test_data *data,
+		unsigned long arg)
 {
 	long nr_pages, cur_pages, addr, remaining_pages;
 	int gup_flags = FOLL_LONGTERM;
@@ -233,7 +236,7 @@ static inline int pin_longterm_test_star
 	int ret = 0;
 	bool fast;
 
-	if (pin_longterm_test_pages)
+	if (data->longterm_pages)
 		return -EINVAL;
 
 	if (copy_from_user(&args, (void __user *)arg, sizeof(args)))
@@ -263,12 +266,12 @@ static inline int pin_longterm_test_star
 		return -EINTR;
 	}
 
-	pin_longterm_test_pages = pages;
-	pin_longterm_test_nr_pages = 0;
+	data->longterm_pages = pages;
+	data->longterm_nr_pages = 0;
 
-	while (nr_pages - pin_longterm_test_nr_pages) {
-		remaining_pages = nr_pages - pin_longterm_test_nr_pages;
-		addr = args.addr + pin_longterm_test_nr_pages * PAGE_SIZE;
+	while (nr_pages - data->longterm_nr_pages) {
+		remaining_pages = nr_pages - data->longterm_nr_pages;
+		addr = args.addr + data->longterm_nr_pages * PAGE_SIZE;
 
 		if (fast)
 			cur_pages = pin_user_pages_fast(addr, remaining_pages,
@@ -277,11 +280,11 @@ static inline int pin_longterm_test_star
 			cur_pages = pin_user_pages(addr, remaining_pages,
 						   gup_flags, pages);
 		if (cur_pages < 0) {
-			pin_longterm_test_stop();
+			pin_longterm_test_stop(data);
 			ret = cur_pages;
 			break;
 		}
-		pin_longterm_test_nr_pages += cur_pages;
+		data->longterm_nr_pages += cur_pages;
 		pages += cur_pages;
 	}
 
@@ -290,19 +293,20 @@ static inline int pin_longterm_test_star
 	return ret;
 }
 
-static inline int pin_longterm_test_read(unsigned long arg)
+static inline int pin_longterm_test_read(struct gup_test_data *data,
+		unsigned long arg)
 {
 	__u64 user_addr;
 	unsigned long i;
 
-	if (!pin_longterm_test_pages)
+	if (!data->longterm_pages)
 		return -EINVAL;
 
 	if (copy_from_user(&user_addr, (void __user *)arg, sizeof(user_addr)))
 		return -EFAULT;
 
-	for (i = 0; i < pin_longterm_test_nr_pages; i++) {
-		void *addr = kmap_local_page(pin_longterm_test_pages[i]);
+	for (i = 0; i < data->longterm_nr_pages; i++) {
+		void *addr = kmap_local_page(data->longterm_pages[i]);
 		unsigned long ret;
 
 		ret = copy_to_user((void __user *)(unsigned long)user_addr, addr,
@@ -318,25 +322,26 @@ static inline int pin_longterm_test_read
 static long pin_longterm_test_ioctl(struct file *filep, unsigned int cmd,
 				    unsigned long arg)
 {
+	struct gup_test_data *data = filep->private_data;
 	int ret = -EINVAL;
 
-	if (mutex_lock_killable(&pin_longterm_test_mutex))
+	if (mutex_lock_killable(&data->longterm_mutex))
 		return -EINTR;
 
 	switch (cmd) {
 	case PIN_LONGTERM_TEST_START:
-		ret = pin_longterm_test_start(arg);
+		ret = pin_longterm_test_start(data, arg);
 		break;
 	case PIN_LONGTERM_TEST_STOP:
-		pin_longterm_test_stop();
+		pin_longterm_test_stop(data);
 		ret = 0;
 		break;
 	case PIN_LONGTERM_TEST_READ:
-		ret = pin_longterm_test_read(arg);
+		ret = pin_longterm_test_read(data, arg);
 		break;
 	}
 
-	mutex_unlock(&pin_longterm_test_mutex);
+	mutex_unlock(&data->longterm_mutex);
 	return ret;
 }
 
@@ -375,15 +380,40 @@ static long gup_test_ioctl(struct file *
 	return 0;
 }
 
+static int gup_test_open(struct inode *inode, struct file *file)
+{
+	struct gup_test_data *data;
+	int ret;
+
+	data = kzalloc_obj(*data);
+	if (!data)
+		return -ENOMEM;
+
+	ret = nonseekable_open(inode, file);
+	if (ret) {
+		kfree(data);
+		return ret;
+	}
+
+	mutex_init(&data->longterm_mutex);
+	file->private_data = data;
+	return 0;
+}
+
 static int gup_test_release(struct inode *inode, struct file *file)
 {
-	pin_longterm_test_stop();
+	struct gup_test_data *data = file->private_data;
+
+	pin_longterm_test_stop(data);
+	mutex_destroy(&data->longterm_mutex);
+	kfree(data);
+	file->private_data = NULL;
 
 	return 0;
 }
 
 static const struct file_operations gup_test_fops = {
-	.open = nonseekable_open,
+	.open = gup_test_open,
 	.unlocked_ioctl = gup_test_ioctl,
 	.compat_ioctl = compat_ptr_ioctl,
 	.release = gup_test_release,
_

Patches currently in -mm which might be from david@kernel.org are

mm-standardize-printing-for-pgtable-entries.patch
mm-gup-fix-always-draining-lru-caches-in-collect_longterm_unpinnable_folios.patch
mm-gup-factor-out-lru-cache-draining-for-folio-into-lru_cache_drain_for_folio.patch
mm-gup_test-keep-longterm-pin-state-per-file.patch


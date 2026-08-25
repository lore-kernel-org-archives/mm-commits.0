Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B8C34E777
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622903; cv=none; b=RXiKXCeH/r7Nwn4hKl2dusfuK+gGIFEFZQStBJeCiooxNLlyf5JtYFrITD6441ed6FMQMka5I8epEqPanW7iWxVNZHaTDIRgwiEUyO21i4kdUgf82XC1WlZrljixP0VvyWPEcQPdGUap+VwHeSCAJgqrbHtaLFBaN4iivwojYJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622903; c=relaxed/simple;
	bh=leCBxKAClRoswx7sRMcLln3sXrmBb4yqvo6lXMFYxLM=;
	h=Date:To:From:Subject:Message-Id; b=f2w8UV+ztSt1x+DW2zfeTrXxhKZS1ZbE3MbLSL409jR5kxfVutwMUKl6HUnEVpyhp7UA6tUDEH92MZgGusc/s7fWBEG6PUZhYeymknt2mGgIQb34n/UBKe93ZgTLXqrNnl1aVjrUPfB9VNx93dBCSHq2LG4AdswZ/tL6Fw+YyJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X5NRwzpB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X5NRwzpB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4FB1F000E9;
	Tue, 25 Aug 2026 01:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622901;
	bh=QBVW23gEFcva+JOGCOw+9Vbzs22sFoHN+W25Yd6TT5g=;
	h=Date:To:From:Subject;
	b=X5NRwzpBYhxwXf2fR/Arc5WZoOBuz4pZZ4PQHnRFWbB/QY5cN2WftSLF3lRRUVc9r
	 NjIYW3DeU17hswLsyA+FmV8kC1y7F6tP9T5W//FDzKYn9qCxL+Rk0JUJioqz1b4f4c
	 fkwK6FqjipLzttbBqYjGaBK7vADYgmfCw1idHwfM=
Date: Mon, 24 Aug 2026 18:55:01 -0700
To: mm-commits@vger.kernel.org,yang.lee@linux.alibaba.com,peterx@redhat.com,lance.yang@linux.dev,jhubbard@nvidia.com,jgg@ziepe.ca,cuiyunhui@bytedance.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup_test-keep-longterm-pin-state-per-file.patch removed from -mm tree
Message-Id: <20260825015501.8D4FB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup_test: keep longterm pin state per file
has been removed from the -mm tree.  Its filename was
     mm-gup_test-keep-longterm-pin-state-per-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Tested-by: Lance Yang <lance.yang@linux.dev>
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



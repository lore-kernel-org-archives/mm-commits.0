Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713C82EDD70
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 04:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782363359; cv=none; b=Boni/hE1xQSo+KMIadT2Nm8Iy9y8AgTcGhoLm67OAFGYwuT3eEPsKq5oaa1mnV333MoUmYXxFgtZ1O+g0kCauPXxR3LVVaS7k8qaLijA20IihqvJqegXA/5IddPdTGr8MZ8A0MLfNWdAweq0G8T5xBNqtIJimbhWZBPfrUvqiVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782363359; c=relaxed/simple;
	bh=1kOTmdKUkvBkJUFNlmTSePc1uXviT5AJnE2TcmqOf2o=;
	h=Date:To:From:Subject:Message-Id; b=ZPkMiwD3cS4H5Z1P5r0AdNBVRoG7ZeymwRiLid77cOfuOIOIG1KsPWhEasLN8SqQuOLymJkECCB39xJ20ueOZ9aCWy39l4b413a+LS13yNy52zCtfu3RTbOV6B/R9npt+HnbJ5IYo30Wb1mqWTxrr1qAW9b//pXEcVyHNAe5CE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GJdyeK2g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GJdyeK2g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C041F000E9;
	Thu, 25 Jun 2026 04:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782363358;
	bh=flXSNnpYfUkA1iTc3BVEndfUc10q5TT1NttVUUZstdQ=;
	h=Date:To:From:Subject;
	b=GJdyeK2gwpOwZGiymF+KOFWnWh64qNNO88n7fHXAE269G75R6KFN751J5E+HxJFWj
	 7QFZtSBcBcFzGDYtGBVlDBeAxnlgPXjIQ/dKdy24S9JjaLoyyaQY+e0qfQCnt/+47o
	 c6/sGm8sOVZkbBuFb0TBL8+WQnj0+aBt143ADt3Y=
Date: Wed, 24 Jun 2026 21:55:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ye.liu@linux.dev,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,corbet@lwn.net,chenyichong@uniontech.com,zhen.ni@easystack.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-add-print_mode-filter.patch added to mm-new branch
Message-Id: <20260625045558.08C041F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_owner: add print_mode filter
has been added to the -mm mm-new branch.  Its filename is
     mm-page_owner-add-print_mode-filter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-add-print_mode-filter.patch

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
From: Zhen Ni <zhen.ni@easystack.cn>
Subject: mm/page_owner: add print_mode filter
Date: Thu, 25 Jun 2026 12:30:58 +0800

Patch series "mm/page_owner: add per-fd filter infrastructure for
print_mode and NUMA filtering", v11.

This patch series introduces per-file-descriptor filtering capabilities to the
page_owner feature.


This patch (of 4):

Add a print_mode filter to page_owner that allows users to choose between
printing stack traces, stack handles, or both, providing flexibility for
different debugging and analysis scenarios.

The filter provides three modes via page_owner:
- Writing "mode=stack" prints stack traces for each page (default)
- Writing "mode=handle" prints only the handle number
- Writing "mode=stack_handle" prints both stack traces and handles

The default stack mode maintains backward compatibility with existing
usage, displaying complete stack traces for each page allocation.

The handle mode dramatically reduces log size and improves performance by
showing only the handle number instead of the full stack trace.  Testing
shows handle mode reduces output size by ~66% (84MB vs 244MB) and improves
read performance by ~4.4x compared to full stack output.  The mapping from
handles to actual stack traces can be obtained via the show_stacks_handles
interface.

The stack_handle mode prints both stack traces and handles, making it
easier to identify pages with the same allocation pattern by comparing
handle numbers instead of comparing large stack traces.

Example usage:
  # Using the page_owner_filter tool (recommended)
  ./page_owner_filter -m stack          # Print only stack traces (default)
  ./page_owner_filter -m handle         # Print only handles
  ./page_owner_filter -m stack_handle   # Print both stack and handles

Sample output (handle mode):
  Page allocated via order 0, migratetype Unmovable, gfp_mask 0x1100ca,
  pid 1, tgid 1 (systemd), ts 123456789 ns
  PFN 0x1000 type Unmovable Block 1 type Unmovable
  Flags 0x3fffe800000084(referenced|lru|active|private|node=0|zone=1)
  handle: 17432583
  ...

This implementation uses per-file-descriptor filter state stored in
file->private_data, allowing each opener to have independent filter
configuration.

Link: https://lore.kernel.org/20260625043101.338794-1-zhen.ni@easystack.cn
Link: https://lore.kernel.org/20260625043101.338794-2-zhen.ni@easystack.cn
Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Yichong Chen <chenyichong@uniontech.com>
Cc: Ye Liu <ye.liu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |  129 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 123 insertions(+), 6 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-add-print_mode-filter
+++ a/mm/page_owner.c
@@ -61,6 +61,23 @@ struct stack_print_ctx {
 	u8 flags;
 };
 
+enum page_owner_print_mode {
+	PAGE_OWNER_PRINT_STACK,
+	PAGE_OWNER_PRINT_HANDLE,
+	PAGE_OWNER_PRINT_STACK_HANDLE,
+};
+
+static const char * const page_owner_print_mode_strings[] = {
+	[PAGE_OWNER_PRINT_STACK]	= "stack",
+	[PAGE_OWNER_PRINT_HANDLE]	= "handle",
+	[PAGE_OWNER_PRINT_STACK_HANDLE]	= "stack_handle",
+};
+
+struct page_owner_filter_state {
+	enum page_owner_print_mode print_mode;
+	spinlock_t lock;
+};
+
 static bool page_owner_enabled __initdata;
 DEFINE_STATIC_KEY_FALSE(page_owner_inited);
 
@@ -587,16 +604,23 @@ static inline int print_page_owner_memcg
 static ssize_t
 print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 		struct page *page, struct page_owner *page_owner,
-		depot_stack_handle_t handle)
+		depot_stack_handle_t handle,
+		struct page_owner_filter_state *state)
 {
 	int ret, pageblock_mt, page_mt;
 	char *kbuf;
+	enum page_owner_print_mode print_mode;
+	unsigned long flags;
 
 	count = min_t(size_t, count, PAGE_SIZE);
 	kbuf = kmalloc(count, GFP_KERNEL);
 	if (!kbuf)
 		return -ENOMEM;
 
+	spin_lock_irqsave(&state->lock, flags);
+	print_mode = state->print_mode;
+	spin_unlock_irqrestore(&state->lock, flags);
+
 	ret = scnprintf(kbuf, count,
 			"Page allocated via order %u, mask %#x(%pGg), pid %d, tgid %d (%s), ts %llu ns\n",
 			page_owner->order, page_owner->gfp_mask,
@@ -615,9 +639,18 @@ print_page_owner(char __user *buf, size_
 			migratetype_names[pageblock_mt],
 			&page->flags.f);
 
-	ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
-	if (ret >= count)
-		goto err;
+	if (print_mode != PAGE_OWNER_PRINT_HANDLE) {
+		ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
+		if (ret >= count)
+			goto err;
+	}
+
+	if (print_mode != PAGE_OWNER_PRINT_STACK) {
+		ret += scnprintf(kbuf + ret, count - ret, "handle: %u\n",
+				 handle);
+		if (ret >= count)
+			goto err;
+	}
 
 	if (page_owner->last_migrate_reason != MIGRATE_REASON_NONE) {
 		ret += scnprintf(kbuf + ret, count - ret,
@@ -705,6 +738,7 @@ read_page_owner(struct file *file, char
 	struct page_ext *page_ext;
 	struct page_owner *page_owner;
 	depot_stack_handle_t handle;
+	struct page_owner_filter_state *state = file->private_data;
 
 	if (!static_branch_unlikely(&page_owner_inited))
 		return -EINVAL;
@@ -782,7 +816,7 @@ read_page_owner(struct file *file, char
 		page_owner_tmp = *page_owner;
 		page_ext_put(page_ext);
 		return print_page_owner(buf, count, pfn, page,
-				&page_owner_tmp, handle);
+				&page_owner_tmp, handle, state);
 ext_put_continue:
 		page_ext_put(page_ext);
 	}
@@ -871,7 +905,90 @@ static void init_early_allocated_pages(v
 		init_pages_in_zone(zone);
 }
 
+static int page_owner_open(struct inode *inode, struct file *file)
+{
+	struct page_owner_filter_state *state;
+
+	state = kzalloc_obj(*state);
+	if (!state)
+		return -ENOMEM;
+
+	spin_lock_init(&state->lock);
+	state->print_mode = PAGE_OWNER_PRINT_STACK;
+	file->private_data = state;
+	return 0;
+}
+
+static int page_owner_release(struct inode *inode, struct file *file)
+{
+	kfree(file->private_data);
+	return 0;
+}
+
+static ssize_t page_owner_write(struct file *file,
+				 const char __user *buf,
+				 size_t count, loff_t *ppos)
+{
+	char *kbuf;
+	char *orig;
+	char *token;
+	int ret;
+	size_t max_input_len;
+	struct page_owner_filter_state *state = file->private_data;
+	enum page_owner_print_mode new_print_mode;
+	unsigned long flags;
+
+	/*
+	 * Maximum input length for filter commands:
+	 * 32: print_mode command max length is 17 ("mode=stack_handle").
+	 */
+	max_input_len = 32;
+
+	if (count > max_input_len)
+		return -EINVAL;
+
+	kbuf = memdup_user_nul(buf, count);
+	if (IS_ERR(kbuf))
+		return PTR_ERR(kbuf);
+
+	orig = kbuf;
+
+	spin_lock_irqsave(&state->lock, flags);
+	new_print_mode = state->print_mode;
+	spin_unlock_irqrestore(&state->lock, flags);
+
+	while ((token = strsep(&kbuf, " \t\n")) != NULL) {
+		if (*token == '\0')
+			continue;
+
+		if (!strncmp(token, "mode=", 5)) {
+			ret = sysfs_match_string(page_owner_print_mode_strings,
+						token + 5);
+			if (ret < 0)
+				goto out_free;
+			new_print_mode = ret;
+		} else {
+			ret = -EINVAL;
+			goto out_free;
+		}
+	}
+
+	spin_lock_irqsave(&state->lock, flags);
+	state->print_mode = new_print_mode;
+	spin_unlock_irqrestore(&state->lock, flags);
+
+	ret = count;
+
+out_free:
+	kfree(orig);
+	return ret;
+}
+
 static const struct file_operations page_owner_fops = {
+	.owner		= THIS_MODULE,
+	.open		= page_owner_open,
+	.release	= page_owner_release,
+	.write		= page_owner_write,
 	.read		= read_page_owner,
 	.llseek		= lseek_page_owner,
 };
@@ -1003,7 +1120,7 @@ static int __init pageowner_init(void)
 		return 0;
 	}
 
-	debugfs_create_file("page_owner", 0400, NULL, NULL, &page_owner_fops);
+	debugfs_create_file("page_owner", 0600, NULL, NULL, &page_owner_fops);
 	dir = debugfs_create_dir("page_owner_stacks", NULL);
 	debugfs_create_file("show_stacks", 0400, dir,
 			    (void *)(STACK_PRINT_FLAG_STACK |
_

Patches currently in -mm which might be from zhen.ni@easystack.cn are

mm-page_owner-add-print_mode-filter.patch
mm-page_owner-add-numa-node-filter.patch
tools-mm-add-page_owner_filter-userspace-tool.patch
mm-page_owner-document-page_owner-filter.patch


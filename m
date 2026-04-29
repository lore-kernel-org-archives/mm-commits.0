Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1CD3F23DD
	for <mm-commits@vger.kernel.org>; Wed, 29 Apr 2026 12:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777464694; cv=none; b=bCDhTy/4XSxzhqjV54dXKmykO/d/Uvb5ngvP0/6kIhXr56IXZc8E54lZO8lcvqQaZ/3C0qCBIHgSUOJUoL2JiFSntoIAUQmJ01whBgTUfmBpthnkaJ6NPsuzxnJQNGY7Md5Hgm01ZbCBH9GWexNoFaDQJsRGRfLkiIhjbiPiYS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777464694; c=relaxed/simple;
	bh=llL4Id5RGBcmEEuojAZAZJGsPk17qjU5001wtsgtB28=;
	h=Date:To:From:Subject:Message-Id; b=W1yOMpj7e+WsOe5QI6Gye5ApDseG78iUNO8OT0ZSFGTE7IkvzpQVCwNhAj/NMRVuBHMFGU1PRoeaGInwDEddSkJo0XchtLb9ddi08mt/8KVzqPGHN/k9XIffqNqjOV9hPjYpzqiLtMM2c/w6VZbGCKXqqOrYOBYMZnCctwHwWE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FAhpQqrq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FAhpQqrq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0FC0C19425;
	Wed, 29 Apr 2026 12:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777464693;
	bh=llL4Id5RGBcmEEuojAZAZJGsPk17qjU5001wtsgtB28=;
	h=Date:To:From:Subject:From;
	b=FAhpQqrq3emnrurGgxtV/9ZbVWvvlo4vuWX7rC3exmLGc3Y2nXOKWoAbC8WBkIYG1
	 1oxrlLEQyCaI5EG1KTYz6uoY5b8Rv8jBzRuTgyYHyB5p1+Zva1NNuh1J1tID0+sRsV
	 0cg7I+2X4B/r84UoxQHmYHdx9ydLj/Pm3DZJoFhM=
Date: Wed, 29 Apr 2026 05:11:33 -0700
To: mm-commits@vger.kernel.org,zhen.ni@easystack.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_owner-add-numa-node-filter-with-nodelist-support.patch removed from -mm tree
Message-Id: <20260429121133.D0FC0C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_owner: add NUMA node filter with nodelist support
has been removed from the -mm tree.  Its filename was
     mm-page_owner-add-numa-node-filter-with-nodelist-support.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zhen Ni <zhen.ni@easystack.cn>
Subject: mm/page_owner: add NUMA node filter with nodelist support
Date: Tue, 28 Apr 2026 15:11:11 +0800

Add NUMA node filtering functionality to page_owner to allow filtering
pages by specific NUMA node(s) using nodelist format.

The filter allows users to focus on pages from specific NUMA nodes, which
is useful for NUMA-aware memory allocation analysis and debugging.

Supported input formats:
- Single node: echo "2" > nid
- Multiple nodes: echo "0,2,3" > nid
- Node range: echo "0-3" > nid
- Mixed format: echo "0,2-4,7" > nid
- Disable filter: echo "-1" > nid

Link: https://lore.kernel.org/linux-mm/20260417154638.22370-4-zhen.ni@easystack.cn/
Link: https://lore.kernel.org/linux-mm/20260419155540.376847-4-zhen.ni@easystack.cn/
Link: https://lore.kernel.org/20260428071112.1420380-4-zhen.ni@easystack.cn
Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
Suggested-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   82 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

--- a/mm/page_owner.c~mm-page_owner-add-numa-node-filter-with-nodelist-support
+++ a/mm/page_owner.c
@@ -685,6 +685,7 @@ read_page_owner(struct file *file, char
 	struct page_ext *page_ext;
 	struct page_owner *page_owner;
 	depot_stack_handle_t handle;
+	nodemask_t mask;
 
 	if (!static_branch_unlikely(&page_owner_inited))
 		return -EINVAL;
@@ -698,6 +699,8 @@ read_page_owner(struct file *file, char
 	while (!pfn_valid(pfn) && (pfn & (MAX_ORDER_NR_PAGES - 1)) != 0)
 		pfn++;
 
+	mask = owner_filter.nid_mask;
+
 	/* Find an allocated page */
 	for (; pfn < max_pfn; pfn++) {
 		/*
@@ -730,6 +733,14 @@ read_page_owner(struct file *file, char
 		if (unlikely(!page_ext))
 			continue;
 
+		/* NUMA node filter using bitmask */
+		if (!nodes_empty(mask)) {
+			int nid = page_to_nid(page);
+
+			if (!node_isset(nid, mask))
+				goto ext_put_continue;
+		}
+
 		/*
 		 * Some pages could be missed by concurrent allocation or free,
 		 * because we don't hold the zone lock.
@@ -1009,6 +1020,75 @@ DEFINE_SIMPLE_ATTRIBUTE(page_owner_print
 			&page_owner_print_mode_get,
 			&page_owner_print_mode_set, "%lld");
 
+static ssize_t nid_filter_write(struct file *file,
+				 const char __user *buf,
+				 size_t count, loff_t *ppos)
+{
+	char *kbuf;
+	nodemask_t mask;
+	int ret;
+	int val;
+
+	/*
+	 * Limit input size to handle worst-case nodelist (all nodes).
+	 * Worst case per node: ",NNNNN" (comma + 5-digit node number) = 6 bytes.
+	 * Formula: 100 bytes overhead + 6 * MAX_NUMNODES
+	 */
+	if (count > (100 + 6 * MAX_NUMNODES))
+		return -EINVAL;
+
+	kbuf = kmalloc(count + 1, GFP_KERNEL);
+	if (!kbuf)
+		return -ENOMEM;
+
+	if (copy_from_user(kbuf, buf, count)) {
+		ret = -EFAULT;
+		goto out_free;
+	}
+	kbuf[count] = '\0';
+
+	/* Support: "-1" to clear, or nodelist format like "0", "0,2", "0-3" */
+	if (kstrtoint(kbuf, 10, &val) == 0 && val == -1)
+		nodes_clear(mask);
+	else if (nodelist_parse(kbuf, mask)) {
+		ret = -EINVAL;
+		goto out_free;
+	}
+
+	owner_filter.nid_mask = mask;
+	ret = count;
+
+out_free:
+	kfree(kbuf);
+	return ret;
+}
+
+static int nid_filter_show(struct seq_file *m, void *v)
+{
+	nodemask_t mask = owner_filter.nid_mask;
+
+	if (nodes_empty(mask))
+		seq_puts(m, "-1\n");
+	else
+		seq_printf(m, "%*pbl\n", nodemask_pr_args(&mask));
+
+	return 0;
+}
+
+static int nid_filter_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, nid_filter_show, NULL);
+}
+
+static const struct file_operations nid_filter_fops = {
+	.owner		= THIS_MODULE,
+	.open		= nid_filter_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.write		= nid_filter_write,
+	.release	= single_release,
+};
+
 
 static int __init pageowner_init(void)
 {
@@ -1024,6 +1104,8 @@ static int __init pageowner_init(void)
 	filter_dir = debugfs_create_dir("page_owner_filter", NULL);
 	debugfs_create_file("print_mode", 0600, filter_dir, NULL,
 			    &page_owner_print_mode_fops);
+	debugfs_create_file("nid", 0600, filter_dir, NULL,
+			    &nid_filter_fops);
 
 	dir = debugfs_create_dir("page_owner_stacks", NULL);
 	debugfs_create_file("show_stacks", 0400, dir,
_

Patches currently in -mm which might be from zhen.ni@easystack.cn are

mm-page_owner-fix-%pgp-format-specifier-argument-type.patch


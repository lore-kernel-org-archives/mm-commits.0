Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD40E30C615
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 11:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777030552; cv=none; b=bq8RaSZSa/3Hp8HmEdG7Byb+vwWNMlkHtISi+RMxfqwjVXYek2e+QZIC/HHXOLRx6vZ6pxED+tIKeUBQetaOZqse57twWgDH+rF5qjMatg+kq/kV3IH8thLqTquQJoMlVOXsbRIMEItFDkN3OeYt+AGbXlEwyXtH7hJ23Ok66EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777030552; c=relaxed/simple;
	bh=PeQU7W1Yiy0vr2cwNJjkJLwQDDqPk6uqHKE8e6RnlJo=;
	h=Date:To:From:Subject:Message-Id; b=LB0ctBr+P0RBLzyM961QMwsBKbzvf0O/Y1sM/qPBr+Ne2c60yonwcr4Qo0TuBmD/ejD9evHN3UTV9lmz/Awvpc12yYyiRnRFif223q9aHnLsSvizf3Xeo4n214kWK/dzMgoZrI9OrN/Tf0UbW5Cq4vYEp2TgDBQ4t16uzBzk7HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fusKX1gC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fusKX1gC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB45C19425;
	Fri, 24 Apr 2026 11:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777030552;
	bh=PeQU7W1Yiy0vr2cwNJjkJLwQDDqPk6uqHKE8e6RnlJo=;
	h=Date:To:From:Subject:From;
	b=fusKX1gCU7MX7I5o0WvW/S7/mSw1qH/8rN2USCooREMf4fo6eLDfH9vBxU0f/mIQ6
	 XkJh3twZ8RE1UhNC2vTR7pV8q9d9BRdJhjlAO0SyDFK0+yzjjFs71BfGWGBy5zjldI
	 9FJguaPM8HpGbv804zr7m5cIHwiOpwglrMD9I1V0=
Date: Fri, 24 Apr 2026 04:35:51 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,zhen.ni@easystack.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-add-numa-node-filter-with-nodelist-support.patch added to mm-new branch
Message-Id: <20260424113552.6FB45C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_owner: add NUMA node filter with nodelist support
has been added to the -mm mm-new branch.  Its filename is
     mm-page_owner-add-numa-node-filter-with-nodelist-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-add-numa-node-filter-with-nodelist-support.patch

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
Subject: mm/page_owner: add NUMA node filter with nodelist support
Date: Sun, 19 Apr 2026 23:55:40 +0800

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
Link: https://lore.kernel.org/20260419155540.376847-4-zhen.ni@easystack.cn
Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
Suggested-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   76 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

--- a/mm/page_owner.c~mm-page_owner-add-numa-node-filter-with-nodelist-support
+++ a/mm/page_owner.c
@@ -707,6 +707,7 @@ read_page_owner(struct file *file, char
 		 * user through copy_to_user() or GFP_KERNEL allocations.
 		 */
 		struct page_owner page_owner_tmp;
+		nodemask_t mask;
 
 		/*
 		 * If the new page is in a new MAX_ORDER_NR_PAGES area,
@@ -730,6 +731,15 @@ read_page_owner(struct file *file, char
 		if (unlikely(!page_ext))
 			continue;
 
+		/* NUMA node filter using bitmask */
+		mask = READ_ONCE(owner_filter.nid_mask);
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
@@ -1009,6 +1019,70 @@ DEFINE_SIMPLE_ATTRIBUTE(page_owner_print
 			&page_owner_print_mode_get,
 			&page_owner_print_mode_set, "%lld");
 
+static ssize_t nid_filter_write(struct file *file,
+				 const char __user *buf,
+				 size_t count, loff_t *ppos)
+{
+	char *kbuf;
+	nodemask_t mask;
+	int ret;
+
+	/* Limit input size to handle worst-case nodelist (all nodes) */
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
+	if (strcmp(kbuf, "-1\n") == 0 || strcmp(kbuf, "-1") == 0)
+		nodes_clear(mask);
+	else if (nodelist_parse(kbuf, mask)) {
+		ret = -EINVAL;
+		goto out_free;
+	}
+
+	WRITE_ONCE(owner_filter.nid_mask, mask);
+	ret = count;
+
+out_free:
+	kfree(kbuf);
+	return ret;
+}
+
+static int nid_filter_show(struct seq_file *m, void *v)
+{
+	nodemask_t mask = READ_ONCE(owner_filter.nid_mask);
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
@@ -1024,6 +1098,8 @@ static int __init pageowner_init(void)
 	filter_dir = debugfs_create_dir("page_owner_filter", NULL);
 	debugfs_create_file("print_mode", 0600, filter_dir, NULL,
 			    &page_owner_print_mode_fops);
+	debugfs_create_file("nid", 0600, filter_dir, NULL,
+			    &nid_filter_fops);
 
 	dir = debugfs_create_dir("page_owner_stacks", NULL);
 	debugfs_create_file("show_stacks", 0400, dir,
_

Patches currently in -mm which might be from zhen.ni@easystack.cn are

mm-page_owner-add-filter-infrastructure.patch
mm-page_owner-add-print_mode-filter.patch
mm-page_owner-add-numa-node-filter-with-nodelist-support.patch


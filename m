Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE67364935
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622881; cv=none; b=pc/RcttcPWmXwGczHvtiex5bBoEdWhrnguGzW1I/gJQTLK+5hGpOlGaoVOjXhWS3GxgUhQYcR8uvLjvOjSvrmD334THk8kzAJhw7G4IfjYJH9ddWo+0NbK9C75qv66PvXjV+pyU1ivFrRk9puiXZVspn7phery0VxsOKtC9N11o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622881; c=relaxed/simple;
	bh=+SFsMYZYZtXXufRc+dAYsl30VxJyG8847eKDi+jdS7o=;
	h=Date:To:From:Subject:Message-Id; b=nFx5NzK0R/aJMdYMSzma0wqn1B4H36T8Z/sNeUXJmZYGyo3E24/7oY+DEWH4RLjvMalKB+y5dRQgcxEkHDOczb7kxTRJq5SvXvCm6FaA19IzYVcd3B5W/DwWohzEodAJuius7SrBmEkEmDI23B1Gj1W5JmOk6HzfHGHZbhyB79c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sisu3b9A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sisu3b9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5FA51F00A3A;
	Tue, 25 Aug 2026 01:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622880;
	bh=9iYHbBWEDwQ6yxiL/TTvwkw1F9e41I1979I8HWtmMwI=;
	h=Date:To:From:Subject;
	b=Sisu3b9ASDz2N7FFR1mM/8rX4kYOXpYVc22enl31FOwfVIfqE+/H7we1/XHSAivcw
	 M5pEr6Ir465MRVmFlRnvjddUbNB7F/UON+xk+um7FVZK1mI3Yl4Nom3PC5SyVwOzCg
	 REOjmRL/uNgYJU+817zR6K4p04j3tVqIUCu2+s1A=
Date: Mon, 24 Aug 2026 18:54:39 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,souravpanda@google.com,kent.overstreet@linux.dev,hao.ge@linux.dev,corbet@lwn.net,abhishekbapat@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] alloc_tag-add-ioctl-filters-to-proc-allocinfo.patch removed from -mm tree
Message-Id: <20260825015439.E5FA51F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: add ioctl filters to /proc/allocinfo
has been removed from the -mm tree.  Its filename was
     alloc_tag-add-ioctl-filters-to-proc-allocinfo.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Abhishek Bapat <abhishekbapat@google.com>
Subject: alloc_tag: add ioctl filters to /proc/allocinfo
Date: Wed, 8 Jul 2026 18:01:24 +0000

Extend the capability of the IOCTL mechanism to filter allocations based
on tag's module name, function name, file name and line number.

Link: https://lore.kernel.org/6a6100c0c58cb2911f39126b9fe177a8c17db16f.1783532853.git.abhishekbapat@google.com
Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
Acked-by: Hao Ge <hao.ge@linux.dev>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Sourav Panda <souravpanda@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/alloc_tag.h |   26 +++++++++++
 mm/alloc_tag.c                 |   68 +++++++++++++++++++++++++++++--
 2 files changed, 89 insertions(+), 5 deletions(-)

--- a/include/uapi/linux/alloc_tag.h~alloc_tag-add-ioctl-filters-to-proc-allocinfo
+++ a/include/uapi/linux/alloc_tag.h
@@ -45,8 +45,32 @@ struct allocinfo_tag_data {
 	struct allocinfo_counter counter;
 };
 
+enum {
+	ALLOCINFO_FILTER_MODNAME,
+	ALLOCINFO_FILTER_FUNCTION,
+	ALLOCINFO_FILTER_FILENAME,
+	ALLOCINFO_FILTER_LINENO,
+	__ALLOCINFO_FILTER_LAST = ALLOCINFO_FILTER_LINENO
+};
+
+#define ALLOCINFO_FILTER_MASK_MODNAME		(1 << ALLOCINFO_FILTER_MODNAME)
+#define ALLOCINFO_FILTER_MASK_FUNCTION		(1 << ALLOCINFO_FILTER_FUNCTION)
+#define ALLOCINFO_FILTER_MASK_FILENAME		(1 << ALLOCINFO_FILTER_FILENAME)
+#define ALLOCINFO_FILTER_MASK_LINENO		(1 << ALLOCINFO_FILTER_LINENO)
+
+#define ALLOCINFO_FILTER_MASKS \
+	((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)
+
+struct allocinfo_filter {
+	__u64 mask; /* bitmask of the filter fields used */
+	struct allocinfo_tag fields;
+};
+
 struct allocinfo_get_at {
-	__u64 pos;	/* input */
+	/* inputs */
+	__u64 pos;
+	struct allocinfo_filter filter;
+	/* output */
 	struct allocinfo_tag_data data;
 };
 
--- a/mm/alloc_tag.c~alloc_tag-add-ioctl-filters-to-proc-allocinfo
+++ a/mm/alloc_tag.c
@@ -62,6 +62,7 @@ struct allocinfo_private {
 	struct codetag_iterator iter;
 	struct codetag_iterator reported_iter;
 	bool print_header;
+	struct allocinfo_filter filter;
 	/* ioctl uses a separate iterator not to interfere with reads */
 	struct codetag_iterator ioctl_iter;
 	bool positioned; /* seq_open_private() sets to 0 */
@@ -204,6 +205,12 @@ static void allocinfo_copy_str(char *des
 	strscpy_pad(dest, allocinfo_str(src), ALLOCINFO_STR_SIZE);
 }
 
+/* Compare two strings and only consider the trimmed suffix if s1 is too long */
+static int allocinfo_cmp_str(const char *str, const char *template)
+{
+	return strncmp(allocinfo_str(str), template, ALLOCINFO_STR_SIZE);
+}
+
 /*
  * Populates the UAPI allocinfo_tag_data structure with active runtime
  * profiling counters extracted from the given kernel codetag.
@@ -244,6 +251,40 @@ static int allocinfo_ioctl_get_content_i
 }
 
 /*
+ * Verifies whether a given codetag satisfies the active filtering criteria by
+ * matching its characteristics against the specified filter.
+ */
+static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter)
+{
+	if (!filter || !filter->mask)
+		return true;
+
+	if (filter->mask & ALLOCINFO_FILTER_MASK_MODNAME) {
+		/* user wants to filter by modname but ct->modname is NULL */
+		if (!ct->modname) {
+			/* validate if user was attempting to filter for built-in allocations */
+			if (filter->fields.modname[0] != '\0')
+				return false;
+		} else if (allocinfo_cmp_str(ct->modname, filter->fields.modname))
+			return false;
+	}
+
+	if ((filter->mask & ALLOCINFO_FILTER_MASK_FUNCTION) &&
+	    ct->function && allocinfo_cmp_str(ct->function, filter->fields.function))
+		return false;
+
+	if ((filter->mask & ALLOCINFO_FILTER_MASK_FILENAME) &&
+	    ct->filename && allocinfo_cmp_str(ct->filename, filter->fields.filename))
+		return false;
+
+	if ((filter->mask & ALLOCINFO_FILTER_MASK_LINENO) &&
+	    ct->lineno != filter->fields.lineno)
+		return false;
+
+	return true;
+}
+
+/*
  * Seeks the ioctl iterator to the specified 0-indexed tag position, reads its
  * profiling data and returns it to userspace.
  */
@@ -251,29 +292,46 @@ static int allocinfo_ioctl_get_at(struct
 {
 	struct allocinfo_private *priv;
 	struct codetag *ct;
-	__u64 pos;
 	struct allocinfo_get_at params = {0};
+	__u64 skip_count;
 
 	if (copy_from_user(&params, arg, sizeof(params)))
 		return -EFAULT;
 
+	if (params.filter.mask & ~ALLOCINFO_FILTER_MASKS)
+		return -EINVAL;
+
 	priv = m->private;
-	pos = params.pos;
 
 	mutex_lock(&priv->ioctl_lock);
 	codetag_lock_module_list(alloc_tag_cttype);
 
-	if (pos >= codetag_get_count(alloc_tag_cttype)) {
+	if (params.pos >= codetag_get_count(alloc_tag_cttype)) {
 		codetag_unlock_module_list(alloc_tag_cttype);
 		mutex_unlock(&priv->ioctl_lock);
 		return -ENOENT;
 	}
 
+	skip_count = params.pos;
+
+	if (params.filter.mask)
+		priv->filter = params.filter;
+	else
+		priv->filter.mask = 0;
+
 	/* Find the codetag */
 	priv->ioctl_iter = codetag_get_ct_iter(alloc_tag_cttype);
 	ct = codetag_next_ct(&priv->ioctl_iter);
-	while (ct && pos--)
+
+	while (ct) {
+		if (matches_filter(ct, &priv->filter)) {
+			if (skip_count == 0)
+				break;
+			skip_count--;
+		}
 		ct = codetag_next_ct(&priv->ioctl_iter);
+	}
+
 	if (ct) {
 		allocinfo_to_params(ct, &params.data);
 		priv->positioned = true;
@@ -314,6 +372,8 @@ static int allocinfo_ioctl_get_next(stru
 	}
 
 	ct = codetag_next_ct(&priv->ioctl_iter);
+	while (ct && !matches_filter(ct, &priv->filter))
+		ct = codetag_next_ct(&priv->ioctl_iter);
 	if (ct)
 		allocinfo_to_params(ct, &params);
 
_

Patches currently in -mm which might be from abhishekbapat@google.com are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4202136492C
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622883; cv=none; b=FjVe8YS/CoUphd/chFfdqH4anQ3xEIWXTgnVl5xD4E0cPFlkLpvr3w0jFkQOrQW9vVCyIwI2SfewRDK7tv87/L46FOed+ygxIyDSKjXfND/KrtLcN5/ZHVq86ZG4b3i1enD9dT8HZqHVVMIf2B6+O17x7Ss4cZsuusxvxXZYutk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622883; c=relaxed/simple;
	bh=mrXwSKUIvZ0rSM1GXgOEn8CxskgFJnGnut+5xsZV8bM=;
	h=Date:To:From:Subject:Message-Id; b=uU42CfFXhmsqbrqA8wzUyjJfB900e1c6qqdpk2g+RkVYnj/Sgzjnvn38Cmgipa47Lf7iiqRoRH6GusIAJN+GzgOJyeiC3tk2IOandC/qYWbIR6PStsM4Rsw8pLFz0U/Cbv381anlcgQPKSKogu5ezLy7+LwD7jc9TJyz+uFJTIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YRYm2U6C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YRYm2U6C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119181F000E9;
	Tue, 25 Aug 2026 01:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622881;
	bh=yUcEKKkYb6HSYfZ80eBEq0UIzXFW1BQMYFXoIzFfxyU=;
	h=Date:To:From:Subject;
	b=YRYm2U6CDAOKoaFUIvq95a+WsNpqcf7OJwIOoUcg+gAOFHfT33EcuoZkIZ5kuQkcX
	 n1mSPoBbqR+kyN+p6fMDLjIaxsBx5faelcdn/F6DX1fKtrd5MTwPqzxycTjaBHfVU4
	 euRKdNwBxDk71PCFakIMQC1J1FTG1frWLV8X9JNo=
Date: Mon, 24 Aug 2026 18:54:40 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,souravpanda@google.com,kent.overstreet@linux.dev,hao.ge@linux.dev,corbet@lwn.net,abhishekbapat@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] alloc_tag-add-size-based-filtering-to-ioctl.patch removed from -mm tree
Message-Id: <20260825015441.119181F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: add size-based filtering to ioctl
has been removed from the -mm tree.  Its filename was
     alloc_tag-add-size-based-filtering-to-ioctl.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Abhishek Bapat <abhishekbapat@google.com>
Subject: alloc_tag: add size-based filtering to ioctl
Date: Wed, 8 Jul 2026 18:01:25 +0000

Extend the allocinfo filtering mechanism to allow users to filter tags
based on the total number of bytes allocated [min_size, max_size].  The
size range is inclusive.

Filtering by size involves retrieving allocinfo per-CPU counters, which is
an expensive operation.  Hence, the performance of size-based filtering
will be worse than other filters.

Link: https://lore.kernel.org/0a7653b70ae0d64e967fbea0e933bc35f8ac656e.1783532853.git.abhishekbapat@google.com
Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
Acked-by: Hao Ge <hao.ge@linux.dev>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Sourav Panda <souravpanda@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/alloc_tag.h |    8 +++
 mm/alloc_tag.c                 |   64 ++++++++++++++++++++++++-------
 2 files changed, 58 insertions(+), 14 deletions(-)

--- a/include/uapi/linux/alloc_tag.h~alloc_tag-add-size-based-filtering-to-ioctl
+++ a/include/uapi/linux/alloc_tag.h
@@ -50,13 +50,17 @@ enum {
 	ALLOCINFO_FILTER_FUNCTION,
 	ALLOCINFO_FILTER_FILENAME,
 	ALLOCINFO_FILTER_LINENO,
-	__ALLOCINFO_FILTER_LAST = ALLOCINFO_FILTER_LINENO
+	ALLOCINFO_FILTER_MIN_SIZE,
+	ALLOCINFO_FILTER_MAX_SIZE,
+	__ALLOCINFO_FILTER_LAST = ALLOCINFO_FILTER_MAX_SIZE
 };
 
 #define ALLOCINFO_FILTER_MASK_MODNAME		(1 << ALLOCINFO_FILTER_MODNAME)
 #define ALLOCINFO_FILTER_MASK_FUNCTION		(1 << ALLOCINFO_FILTER_FUNCTION)
 #define ALLOCINFO_FILTER_MASK_FILENAME		(1 << ALLOCINFO_FILTER_FILENAME)
 #define ALLOCINFO_FILTER_MASK_LINENO		(1 << ALLOCINFO_FILTER_LINENO)
+#define ALLOCINFO_FILTER_MASK_MIN_SIZE		(1 << ALLOCINFO_FILTER_MIN_SIZE)
+#define ALLOCINFO_FILTER_MASK_MAX_SIZE		(1 << ALLOCINFO_FILTER_MAX_SIZE)
 
 #define ALLOCINFO_FILTER_MASKS \
 	((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)
@@ -64,6 +68,8 @@ enum {
 struct allocinfo_filter {
 	__u64 mask; /* bitmask of the filter fields used */
 	struct allocinfo_tag fields;
+	__u64 min_size;
+	__u64 max_size;
 };
 
 struct allocinfo_get_at {
--- a/mm/alloc_tag.c~alloc_tag-add-size-based-filtering-to-ioctl
+++ a/mm/alloc_tag.c
@@ -211,16 +211,20 @@ static int allocinfo_cmp_str(const char
 	return strncmp(allocinfo_str(str), template, ALLOCINFO_STR_SIZE);
 }
 
+/* Fetch the per-CPU counters */
+static inline struct alloc_tag_counters allocinfo_prefetch_counters(struct codetag *ct)
+{
+	return alloc_tag_read(ct_to_alloc_tag(ct));
+}
+
 /*
  * Populates the UAPI allocinfo_tag_data structure with active runtime
  * profiling counters extracted from the given kernel codetag.
  */
 static void allocinfo_to_params(struct codetag *ct,
-				struct allocinfo_tag_data *data)
+				struct allocinfo_tag_data *data,
+				struct alloc_tag_counters *counters)
 {
-	struct alloc_tag *tag = ct_to_alloc_tag(ct);
-	struct alloc_tag_counters counter = alloc_tag_read(tag);
-
 	if (ct->modname)
 		allocinfo_copy_str(data->tag.modname, ct->modname);
 	else
@@ -228,9 +232,9 @@ static void allocinfo_to_params(struct c
 	allocinfo_copy_str(data->tag.function, ct->function);
 	allocinfo_copy_str(data->tag.filename, ct->filename);
 	data->tag.lineno = ct->lineno;
-	data->counter.bytes = counter.bytes;
-	data->counter.calls = counter.calls;
-	data->counter.accurate = !alloc_tag_is_inaccurate(tag);
+	data->counter.bytes = counters->bytes;
+	data->counter.calls = counters->calls;
+	data->counter.accurate = !alloc_tag_is_inaccurate(ct_to_alloc_tag(ct));
 }
 
 /*
@@ -254,7 +258,9 @@ static int allocinfo_ioctl_get_content_i
  * Verifies whether a given codetag satisfies the active filtering criteria by
  * matching its characteristics against the specified filter.
  */
-static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter)
+static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter,
+			   struct alloc_tag_counters *counters,
+			   bool *fetched_counters)
 {
 	if (!filter || !filter->mask)
 		return true;
@@ -281,6 +287,19 @@ static bool matches_filter(struct codeta
 	    ct->lineno != filter->fields.lineno)
 		return false;
 
+	if (filter->mask & (ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLOCINFO_FILTER_MASK_MAX_SIZE)) {
+		if (!*fetched_counters) {
+			*counters = allocinfo_prefetch_counters(ct);
+			*fetched_counters = true;
+		}
+		if ((filter->mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
+		    counters->bytes < filter->min_size)
+			return false;
+		if ((filter->mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
+		    counters->bytes > filter->max_size)
+			return false;
+	}
+
 	return true;
 }
 
@@ -294,6 +313,8 @@ static int allocinfo_ioctl_get_at(struct
 	struct codetag *ct;
 	struct allocinfo_get_at params = {0};
 	__u64 skip_count;
+	struct alloc_tag_counters counters;
+	bool fetched_counters;
 
 	if (copy_from_user(&params, arg, sizeof(params)))
 		return -EFAULT;
@@ -301,6 +322,11 @@ static int allocinfo_ioctl_get_at(struct
 	if (params.filter.mask & ~ALLOCINFO_FILTER_MASKS)
 		return -EINVAL;
 
+	if ((params.filter.mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
+	    (params.filter.mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
+	    params.filter.min_size > params.filter.max_size)
+		return -EINVAL;
+
 	priv = m->private;
 
 	mutex_lock(&priv->ioctl_lock);
@@ -324,7 +350,8 @@ static int allocinfo_ioctl_get_at(struct
 	ct = codetag_next_ct(&priv->ioctl_iter);
 
 	while (ct) {
-		if (matches_filter(ct, &priv->filter)) {
+		fetched_counters = false;
+		if (matches_filter(ct, &priv->filter, &counters, &fetched_counters)) {
 			if (skip_count == 0)
 				break;
 			skip_count--;
@@ -333,7 +360,9 @@ static int allocinfo_ioctl_get_at(struct
 	}
 
 	if (ct) {
-		allocinfo_to_params(ct, &params.data);
+		if (!fetched_counters)
+			counters = allocinfo_prefetch_counters(ct);
+		allocinfo_to_params(ct, &params.data, &counters);
 		priv->positioned = true;
 	}
 
@@ -359,6 +388,8 @@ static int allocinfo_ioctl_get_next(stru
 	struct codetag *ct;
 	struct allocinfo_tag_data params;
 	int ret = 0;
+	struct alloc_tag_counters counters;
+	bool fetched_counters;
 
 	memset(&params, 0, sizeof(params));
 	priv = m->private;
@@ -372,11 +403,18 @@ static int allocinfo_ioctl_get_next(stru
 	}
 
 	ct = codetag_next_ct(&priv->ioctl_iter);
-	while (ct && !matches_filter(ct, &priv->filter))
+	while (ct) {
+		fetched_counters = false;
+		if (matches_filter(ct, &priv->filter, &counters, &fetched_counters))
+			break;
 		ct = codetag_next_ct(&priv->ioctl_iter);
-	if (ct)
-		allocinfo_to_params(ct, &params);
+	}
 
+	if (ct) {
+		if (!fetched_counters)
+			counters = allocinfo_prefetch_counters(ct);
+		allocinfo_to_params(ct, &params, &counters);
+	}
 	if (!ct) {
 		priv->positioned = false;
 		ret = -ENOENT;
_

Patches currently in -mm which might be from abhishekbapat@google.com are



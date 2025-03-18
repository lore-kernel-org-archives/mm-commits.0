Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D821D6DD8
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274562; cv=none; b=jtANRcbbgRvxHVNufAWyA1Pkg2Ztqhy3vyM5BRZUP26sSX3ZxBt0Kc9i9AQZ/0rR/Id9BeSt6VhWjAPwNydKHEVXsxcji1SOZhRcmP1dzcIsXo0QvgzALZNezhFXQScCntIfntQJhLl3FupfmPrykr2HXi1WxxlIYvAy2jCjoA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274562; c=relaxed/simple;
	bh=yk/1oni7PuMGR22CpFdvGpaFfEfI+PQIYgo2cUoDpk8=;
	h=Date:To:From:Subject:Message-Id; b=CW9o1Zv84wxgpZGP1MoqCqjY/7L+Q8R7TJUWzj3I2nhryEkJdDDTz7ZETlhDzYxsWMEAEPuHk3LmBw+2Px7kEKZd9oIcp5sLQRKsDgR5+I6c2xijtkDbi6+91wwQXtJ8CPcv+iGgS0xaI7RZLsnbdXN6gFHhwzCm31+Jnp3AXqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rL4VBcM6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rL4VBcM6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F0BC4CEDD;
	Tue, 18 Mar 2025 05:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274562;
	bh=yk/1oni7PuMGR22CpFdvGpaFfEfI+PQIYgo2cUoDpk8=;
	h=Date:To:From:Subject:From;
	b=rL4VBcM6UIwHLsJBGfEo7z78MU6I8r4RRhuiDB+YBLm9DA/sTpbv/675Ska8ZB9/w
	 stvKmocU7qDwrHmqwV8DhhrQQXmqTdH4AQpUSx30ONxJQwGtzwHLaXQqFzHQ/B5uLr
	 1h8SM3HPsuNJY8w7TfsVTvDg85tTH/ZgXjn14oiw=
Date: Mon, 17 Mar 2025 22:09:22 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-return-error-when-for-attempts-to-install-filters-on-wrong-sysfs-directory.patch removed from -mm tree
Message-Id: <20250318050922.95F0BC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: return error when for attempts to install filters on wrong sysfs directory
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-return-error-when-for-attempts-to-install-filters-on-wrong-sysfs-directory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: return error when for attempts to install filters on wrong sysfs directory
Date: Wed, 5 Mar 2025 14:27:31 -0800

Return error if the user tries to install a DAMOS filter on DAMOS filters
sysfs directory that assumed to be used for filters that handled by a
DAMON layer that not same to that for the installing filter.

Link: https://lkml.kernel.org/r/20250305222733.59089-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-return-error-when-for-attempts-to-install-filters-on-wrong-sysfs-directory
+++ a/mm/damon/sysfs-schemes.c
@@ -362,6 +362,23 @@ static ssize_t type_show(struct kobject
 			damon_sysfs_scheme_filter_type_strs[filter->type]);
 }
 
+static bool damos_sysfs_scheme_filter_valid_type(
+		enum damos_sysfs_filter_handle_layer layer,
+		enum damos_filter_type type)
+{
+	switch (layer) {
+	case DAMOS_SYSFS_FILTER_HANDLE_LAYER_BOTH:
+		return true;
+	case DAMOS_SYSFS_FILTER_HANDLE_LAYER_CORE:
+		return !damos_filter_for_ops(type);
+	case DAMOS_SYSFS_FILTER_HANDLE_LAYER_OPS:
+		return damos_filter_for_ops(type);
+	default:
+		break;
+	}
+	return false;
+}
+
 static ssize_t type_store(struct kobject *kobj,
 		struct kobj_attribute *attr, const char *buf, size_t count)
 {
@@ -373,6 +390,9 @@ static ssize_t type_store(struct kobject
 	for (type = 0; type < NR_DAMOS_FILTER_TYPES; type++) {
 		if (sysfs_streq(buf, damon_sysfs_scheme_filter_type_strs[
 					type])) {
+			if (!damos_sysfs_scheme_filter_valid_type(
+						filter->handle_layer, type))
+				break;
 			filter->type = type;
 			ret = count;
 			break;
_

Patches currently in -mm which might be from sj@kernel.org are



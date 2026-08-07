Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5B43B5F59
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068145; cv=none; b=Ao2YbotpAMWkF0DIBLVXYGZLAgV8St0VKf+qnF+LptbYen0zQUiI9Yz88ZWiPAlGzcXDcpyYwOzDgm41DBVqV3aKVUWsJsQdYqMULNYTahASV+62MZPdITf25aGyQYuQbw3uE4ynH+YPRiM6pISv6tuSszUiY4W4djPk3yjUjvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068145; c=relaxed/simple;
	bh=jYDhYSoNMFgzT0mjLcePyLoj4/k24Ic4ZGM2Obyt9w8=;
	h=Date:To:From:Subject:Message-Id; b=IHtIJuy8poRByMb2W6LJejotqdgkXV9aWcNbhJjE0z6RwqZTjfsvTS+QRXydMM01GxXZ9gxf9Z6yDzl5AT7NCDXsOfr2HqvjNSV3dsF4YDuOgV/u3uTVoX4wh7QAyLjle7oLY+o78ll3CmPAORAx0j1Dm7GBN3JObRe5655pgtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UnleyR12; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UnleyR12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 616271F000E9;
	Fri,  7 Aug 2026 02:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068144;
	bh=H0ibNJnPkv04eg96uequ6SoQ1LfayR/OPr/3+9HXPQ8=;
	h=Date:To:From:Subject;
	b=UnleyR12uIU/Msg93dSmr765AvnHV8irQQcB3WOwqH0oBqfP1Bc1YmigJZXy58Vp+
	 8ylx/OT8gwEKR7ifYjzv83A4i+Xf8o8rQh75g+eUWngGWZ6utmU3W9OcNued0hA8KA
	 MVDgh8iSOE16GmdgSFk0CeNA2Sm88IMRbq3GfLfQ=
Date: Thu, 06 Aug 2026 19:02:23 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,husong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-update-outdated-comment-about-damos-filter-handling.patch removed from -mm tree
Message-Id: <20260807020224.616271F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: update outdated comment about DAMOS filter handling
has been removed from the -mm tree.  Its filename was
     mm-damon-update-outdated-comment-about-damos-filter-handling.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Song Hu <husong@kylinos.cn>
Subject: mm/damon: update outdated comment about DAMOS filter handling
Date: Tue, 21 Jul 2026 07:00:08 -0700

The kernel-doc comment above enum damos_filter_type states that only the
anon and memcg type filters are handled by damon_operations (and therefore
accounted as 'tried'), and that DAMON_OPS_VADDR and DAMON_OPS_FVADDR do
not support those two filter types.

Neither is accurate anymore.  damos_filter_for_ops() routes every filter
type except ADDR and TARGET to the operations layer, and the VADDR and
FVADDR operations (the latter being a copy of the former) handle all of
those types through damos_folio_filter_match() / damos_va_filter_out(). 
Update the comment to match the code.

Link: https://lore.kernel.org/20260721140011.269802-1-sj@kernel.org
Signed-off-by: Song Hu <husong@kylinos.cn>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/include/linux/damon.h~mm-damon-update-outdated-comment-about-damos-filter-handling
+++ a/include/linux/damon.h
@@ -398,16 +398,15 @@ struct damos_stat {
  * @DAMOS_FILTER_TYPE_TARGET:	Data Access Monitoring target.
  * @NR_DAMOS_FILTER_TYPES:	Number of filter types.
  *
- * The anon pages type and memcg type filters are handled by underlying
- * &struct damon_operations as a part of scheme action trying, and therefore
- * accounted as 'tried'.  In contrast, other types are handled by core layer
- * before trying of the action and therefore not accounted as 'tried'.
+ * All types except &DAMOS_FILTER_TYPE_ADDR and &DAMOS_FILTER_TYPE_TARGET
+ * are handled by the underlying &struct damon_operations as a part of scheme
+ * action trying, and therefore accounted as 'tried'.  In contrast,
+ * &DAMOS_FILTER_TYPE_ADDR and &DAMOS_FILTER_TYPE_TARGET filters are handled
+ * by the core layer before trying of the action, and therefore not accounted
+ * as 'tried'.
  *
- * The support of the filters that handled by &struct damon_operations depend
- * on the running &struct damon_operations.
- * &enum DAMON_OPS_PADDR supports both anon pages type and memcg type filters,
- * while &enum DAMON_OPS_VADDR and &enum DAMON_OPS_FVADDR don't support any of
- * the two types.
+ * Support for the operations-handled filters depends on the running
+ * &struct damon_operations.
  */
 enum damos_filter_type {
 	DAMOS_FILTER_TYPE_ANON,
_

Patches currently in -mm which might be from husong@kylinos.cn are



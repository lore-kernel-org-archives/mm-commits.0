Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4233A2544
	for <mm-commits@vger.kernel.org>; Tue, 14 Jul 2026 03:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783998656; cv=none; b=FKiBTwBOTzkpJsaKk8/Isy9TC05cZ2TjVk4abRfaGuYzhF1rD/t3P7sdZ6pnQHMtTOdJjqFhV/8B/sl2A4BZI9McK95Rv9a05I0UsPzcj1xSNpBwh6axQ+OiQhYrhA8ZhCh9J+Sf0IJKK0yw5n038S+MfLblygPfza+ujEj6I+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783998656; c=relaxed/simple;
	bh=biy65sNBY9e0uK94B/SwTIel+jAyioj95QWz/ccXLUU=;
	h=Date:To:From:Subject:Message-Id; b=Z0Xf2UK03XZ3aq2qC6poRghNUYTwmxqKBfBzgZHLZn6NBFbn0ucM9irNavhK/4SH58SrNiRcqxR1iS/24tKjpoJWx0SLLk0qbA03DdVmXdt/Qxd9RTaFnXIwT6qNsVORy/o2ZwUfFkGXyy8OUgXowFGocWC83ZVxxLTpygkEM8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0Od1DSWv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0Od1DSWv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 086961F000E9;
	Tue, 14 Jul 2026 03:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783998655;
	bh=WII97beIQkGjuC6y9HZGBDuLP39KYEvYmZmTblJxDN0=;
	h=Date:To:From:Subject;
	b=0Od1DSWvkaTzE/Qm905T2Ki5HWAX5CgjABVjfGYCqwNYeQTM7L/mP+EkEdUjVx1OL
	 jConLoPjKzVKx+iczlxGWYVTsCo7SdP+myUShAUeuWpjkHeT0RlpC57vxt93Hzmm++
	 XY699FTydH/FX63MgkeriWffad5LJgEZxNaetcS8=
Date: Mon, 13 Jul 2026 20:10:54 -0700
To: mm-commits@vger.kernel.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_owner-add-missing-newline-to-count_threshold-format-string.patch removed from -mm tree
Message-Id: <20260714031055.086961F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_owner: add missing newline to count_threshold format string
has been removed from the -mm tree.  Its filename was
     mm-page_owner-add-missing-newline-to-count_threshold-format-string.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Ye Liu <ye.liu@linux.dev>
Subject: mm/page_owner: add missing newline to count_threshold format string
Date: Wed, 1 Jul 2026 14:10:48 +0800

The DEFINE_SIMPLE_ATTRIBUTE format string for page_owner_threshold_fops is
missing a trailing \n.  simple_attr_read() uses scnprintf() with the
format string, which does not append a newline, so reading
/sys/kernel/debug/page_owner_stacks/count_threshold produces output
without a terminating newline.  Add the missing \n to match the standard
debugfs attribute convention.

Link: https://lore.kernel.org/20260701061101.344679-6-ye.liu@linux.dev
Signed-off-by: Ye Liu <ye.liu@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_owner.c~mm-page_owner-add-missing-newline-to-count_threshold-format-string
+++ a/mm/page_owner.c
@@ -974,7 +974,7 @@ static int page_owner_threshold_set(void
 }
 
 DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops, &page_owner_threshold_get,
-			&page_owner_threshold_set, "%llu");
+			&page_owner_threshold_set, "%llu\n");
 
 
 static int __init pageowner_init(void)
_

Patches currently in -mm which might be from ye.liu@linux.dev are

mm-page_owner-move-free_ts_nsec-output-to-free-section-in-__dump_page_owner.patch
mm-page_owner-drop-redundant-page_owner-prefix-from-static-symbols.patch
mm-page_owner-clamp-skip_buddy_pages-pfn-advance-at-max_order_nr_pages-boundary.patch
mm-page_owner-use-memcg_data-snapshot-instead-of-pagememcgkmem-to-avoid-toctou-vm_bug_on.patch


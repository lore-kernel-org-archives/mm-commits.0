Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72ECE33065C
	for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 02:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782786369; cv=none; b=HFNhHaSaSHWLBXAYlwsfV+etNj1neKi6oXC4hhWF4l+r03YzNcxT8NVEoFyq37JAnnRfGaFHRwJUG//3XqKPnGQIIxDxw5z53tCIWrpzVoubr2Uczz4FV6GmeakykwBEqO6izvv+e/C6v+6/eaUkOsuPCtjP1U6579i3p74TyC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782786369; c=relaxed/simple;
	bh=h6rw42GWyN+TS1LlesZeT4OT+GkvSG8jW0I0bWujV1E=;
	h=Date:To:From:Subject:Message-Id; b=Mkd8T1y7RoPKoLAbr/DcbhDrWH+slb0WCPIkT7/pnFTlSXgLjs/yHvc35Twc4fxy/Gxz2WP2GA57JGhB3nnC8ls6w4STJtHv2jKjJvl5dENsxfq53+PApNxykCh3tKIBhq/CK59tlgXJP/YVV/6Z1O/WX23hFbzqZXVN0YyWEXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eIDb2vv8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eIDb2vv8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5CB1F00A3A;
	Tue, 30 Jun 2026 02:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782786368;
	bh=hIu29dSbTWOgnBgffxwYxiFZBR430gCGUtwCe+dMZ3A=;
	h=Date:To:From:Subject;
	b=eIDb2vv8p+lfacFZYuOaiJN0zPHzFRCClFZONEHR5/n/LGEFwme66uRKVZe7hjAdP
	 DdDG7pz/J1KL8j1WRq8deURgY7fF/JCfrLLLr92z09U/M6pGFo32Jq8oxSRn51wHUU
	 nnbgCsU8PkIV5MS8yWUITXpMAB7P+hnkyEnFgk14=
Date: Mon, 29 Jun 2026 19:26:07 -0700
To: mm-commits@vger.kernel.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_owner-add-missing-newline-to-count_threshold-format-string.patch removed from -mm tree
Message-Id: <20260630022608.0C5CB1F00A3A@smtp.kernel.org>
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
Date: Fri, 26 Jun 2026 10:45:43 +0800

The DEFINE_SIMPLE_ATTRIBUTE format string for page_owner_threshold_fops is
missing a trailing \n.  simple_attr_read() uses scnprintf() with the
format string, which does not append a newline, so reading
/sys/kernel/debug/page_owner_stacks/count_threshold produces output
without a terminating newline.  Add the missing \n to match the standard
debugfs attribute convention.

Link: https://lore.kernel.org/20260626024550.25677-5-ye.liu@linux.dev
Signed-off-by: Ye Liu <ye.liu@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_owner.c~mm-page_owner-add-missing-newline-to-count_threshold-format-string
+++ a/mm/page_owner.c
@@ -981,7 +981,7 @@ static int page_owner_threshold_set(void
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


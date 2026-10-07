Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CFF32DB780
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334213; cv=none; b=I4dGUitj+nmYBikJ+1e8p0uyrfg27SJYqP4BdtsZyi/0xyxcNkFJPKuCwpcMRGJHFh78hO4kDofTIFwVHy0AaR7K2X7oWFjuwy8bY0WRDhF6ZN5stWcTCPXP0S5tru/o147HdPUVHY4EWR5eLD0qE3+uQqd9lqqB1q//j4F7jf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334213; c=relaxed/simple;
	bh=5NrJSK+xVleplf5r5WJfmb6kMipBWQdfsrSIu5qZ6I0=;
	h=Date:To:From:Subject:Message-Id; b=MnRiWWnb5pxsJER4D/k1LW5ULlaudiZuX8lEX1ZJUuKPBBCntOPp7x0mnXuuYKRSmUWq4tHGdyS6Drl6xmt5nCq48hVstcyebkkAv6Jo1yk+1aV0e7jvxcl8JmZTGRb4Kbgu3mSLSRPxDqhXT6J0oz6Erq2pU63Or/VotIsZBFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A54qU7lB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A54qU7lB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A7D1F0089C;
	Wed,  7 Oct 2026 00:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334212;
	bh=xTC4fST/4VNIb7iXKMGMOZFvHrXt91cwO2OCQAFG8rA=;
	h=Date:To:From:Subject;
	b=A54qU7lB+IuXvzfUQMSJLKZiCRYQb/0qFNvr9nJKCwv5Y6/bzt3I2DxRqGTprIUsn
	 UNjFjxLtSVoppSqItZ8Mv/KJjDLufNHtYDKhrxFaD2hFkO+erqkQqmSZ9RdjSTEZRw
	 iod4nOPWY1mZYPzLrZAAeIcMkHnhWyFrr2xryDf4=
Date: Tue, 06 Oct 2026 17:50:11 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liujing@cmss.chinamobile.com,liam@infradead.org,david@kernel.org,corbet@lwn.net,chenyichong@uniontech.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-mm-page_owner_sort-fix-sort-option-being-silently-ignored.patch removed from -mm tree
Message-Id: <20261007005011.D7A7D1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/mm/page_owner_sort: fix --sort option being silently ignored
has been removed from the -mm tree.  Its filename was
     tools-mm-page_owner_sort-fix-sort-option-being-silently-ignored.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ye Liu <liuye@kylinos.cn>
Subject: tools/mm/page_owner_sort: fix --sort option being silently ignored
Date: Wed, 19 Aug 2026 10:16:09 +0800

Patch series "tools/mm/page_owner_sort: fix --sort, add module filter,
improve usage", v3.

This series improves the page_owner_sort tool with a bug fix, a new
module-name feature, and better usage text.

Patch 1 fixes a long-standing bug where --sort was silently ignored when
used without a short option (-a, -m, -p, etc.).  The COMP_NO_FLAG case
fell through to COMP_NUM and overwrote the sort conditions configured by
parse_sort_args().

Patch 2 adds kernel module name support for sort, cull, and filter
operations.  Page owner stack traces already contain module names in the
"function+0xNN/0xNN [module]" format produced by %pS, but page_owner_sort
had no way to use them.  Records without module frames are assigned
"vmlinux".

  # Aggregate page usage per module
  ./page_owner_sort input.txt output.txt --cull=mod

  # Filter to records from xfs module only
  ./page_owner_sort input.txt output.txt --module xfs

  # Sort by module name, then by pid descending
  ./page_owner_sort input.txt output.txt --sort=mod,-pid

Patch 3 lists all available sort keys with abbreviations and examples
directly in the --sort help section so users no longer need to read the
source to discover valid keys.


This patch (of 3):

When --sort is used without any short option (-a, -m, -p, etc.),
compare_flag remains COMP_NO_FLAG.  The switch (compare_flag) then falls
through to the COMP_NUM case and calls set_single_cmp(), which
unconditionally overwrites the sort conditions that parse_sort_args()
already configured.  This makes --sort silently ineffective unless a short
option is also supplied.

Split COMP_NO_FLAG out of the COMP_NUM fallthrough so that --sort is
respected when no short option is present.

Reproduction:
  # Before fix: ascending order (ignored --sort=-pid)
  ./page_owner_sort --sort=-pid input.txt output.txt
  # After fix: descending order as expected

Link: https://lore.kernel.org/20260819021611.2910835-1-ye.liu@linux.dev
Link: https://lore.kernel.org/20260819021611.2910835-2-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Liu Jing <liujing@cmss.chinamobile.com>
Cc: Yichong Chen <chenyichong@uniontech.com>
---

 tools/mm/page_owner_sort.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/mm/page_owner_sort.c~tools-mm-page_owner_sort-fix-sort-option-being-silently-ignored
+++ a/tools/mm/page_owner_sort.c
@@ -821,6 +821,9 @@ int main(int argc, char **argv)
 		set_single_cmp(compare_stacktrace, SORT_ASC);
 		break;
 	case COMP_NO_FLAG:
+		if (sc.size > 0)
+			break;
+		/* fallthrough */
 	case COMP_NUM:
 		set_single_cmp(compare_num, SORT_DESC);
 		break;
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-vmalloc-group-xa_init-with-vbq-field-initializations.patch
mm-vmalloc-extract-vmap_insert_free_area-helper.patch
mm-vmalloc-extract-show_busy_info-from-vmalloc_info_show.patch
mm-vmalloc-fix-vmalloc_dump_obj-address-alignment-for-last-page-lookups.patch
mm-vmalloc-fix-vmalloc_dump_obj-cross-zone-va-lookup.patch


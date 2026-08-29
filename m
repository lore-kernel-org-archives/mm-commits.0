Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1391A20E030
	for <mm-commits@vger.kernel.org>; Sat, 29 Aug 2026 02:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787969373; cv=none; b=MZJuh09io+W0obyzt9B+FqZJT87ca2BLFVx/6QNm/KDPSlt+H/9gxqsqjrXF7SzVzI+nFF0CQjueWvSf7T4+XHE7mjjLnKq9Ay/Zlgc/2xsFj83q0gItOop1YObPDmQ2iqIfWPHCDDoXEMsy8imjK9mi5fQh0W2Rvv956GDKvfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787969373; c=relaxed/simple;
	bh=gJ+1oPVSbHOM+P/IC6MmkdY6uKJ/pr00+4t99nqluDc=;
	h=Date:To:From:Subject:Message-Id; b=p9yB5WcAbRER1hoHGutnjvnc4L+I+pPD5Lc+QAJ49EtmtAQZhrVW9YRmFYBkga0NQiBeap7NzGH5pzWjwFmHJeJZ4XlJil5uFJ05do+8clKpXEkpaH0ONx4aJwFgqSyjHwrbzHFOdgfzHRsoqMG40JXglT3j+6zhEr2vC9eOz8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FIjCq7/s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FIjCq7/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5241F000E9;
	Sat, 29 Aug 2026 02:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787969371;
	bh=eK8lVQRbmBCGyVj+GbUrMm3VxJMcHatHnTDy/YLcyhI=;
	h=Date:To:From:Subject;
	b=FIjCq7/sClRvn//Zkspc8BCRdaAeaDYMuaeKQesQGxVh7JS9mILtPUpi4U61T/FME
	 EqTE7k7k+To+pg/Ozn9i92lveGQ4avitK0dKlWmAOXZparOsuOKuIFjJkp2Nugds5Q
	 RXuVqN8PdSFUIIY6ppev0yom10V6FC0lEL+1+FoE=
Date: Fri, 28 Aug 2026 19:09:31 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liujing@cmss.chinamobile.com,liam@infradead.org,david@kernel.org,corbet@lwn.net,chenyichong@uniontech.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-page_owner_sort-fix-sort-option-being-silently-ignored.patch added to mm-new branch
Message-Id: <20260829020931.7F5241F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/mm/page_owner_sort: fix --sort option being silently ignored
has been added to the -mm mm-new branch.  Its filename is
     tools-mm-page_owner_sort-fix-sort-option-being-silently-ignored.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-page_owner_sort-fix-sort-option-being-silently-ignored.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

mm-vmalloc-fix-vmap_purge_lock-livelock-under-memory-pressure.patch
tools-mm-page_owner_sort-fix-sort-option-being-silently-ignored.patch
tools-mm-page_owner_sort-add-module-name-sort-cull-filter-support.patch
tools-mm-page_owner_sort-show-available-sort-keys-in-usage-text.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5EA3126CA
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 19:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782415429; cv=none; b=pmVb51+3uw9axk+YnXHAHAlcw9FhFy6O+76XIhINp4iM5ZRoAx0k6RGTBBkTKWqPNX4hlTPBmD0vcdtkbH80dUekUVaWLJ7763oMaomqNdhZonnHKojWIZeQlLIFYPE8NbJ6RO83jG2PVFhnkPD7stMnoVcjk8ziHr5ZYOT63f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782415429; c=relaxed/simple;
	bh=+tgytk1JkaXt72SjhShLCYb/FJdHfAJluIXULrBEN4w=;
	h=Date:To:From:Subject:Message-Id; b=UJtjMssImSQ4awjW8Rwex5j7OBjkPsIYz3Up/YGdh2Rjrkm/3skSPmkKGUemg/B7Vd90I1cKUmI7W/Eq4ziPNEAC4Rz2Rv66zv4udVX9vHiJBW+WwjofsuomVMVibjsje0tCJEt6foVPvseENAxyIU6FPbduy1Uivt0StUlGDI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PEse6Lw2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PEse6Lw2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06AAF1F000E9;
	Thu, 25 Jun 2026 19:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782415428;
	bh=+KPo8emJvhzU46zBWwls9ucGMVNO56oZHF2mxC1olA4=;
	h=Date:To:From:Subject;
	b=PEse6Lw2rw/k5L1epXraJMxEkFxkQIM/RWQRRdjge4Oq5A/yp8HYBfKF0vgDNkL27
	 UYqZa0oQqwVeDfLguXfKR4bz/ieMpnXoKT7v/ALpJ+0kyJRtU84HK+7XLO54Q6v7Pb
	 SZtpZxYriaZ+W4GG6XZcw1OA1DCejLbXevW3D/XU=
Date: Thu, 25 Jun 2026 12:23:47 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhen.ni@easystack.cn,ye.liu@linux.dev,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,corbet@lwn.net,chenyichong@uniontech.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-add-print_mode-filter-fix.patch added to mm-new branch
Message-Id: <20260625192348.06AAF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-page_owner-add-print_mode-filter-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-page_owner-add-print_mode-filter-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-add-print_mode-filter-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_owner-add-print_mode-filter-fix
Date: Thu Jun 25 12:18:25 PM PDT 2026

remove local max_input_len. per Zi Yan

Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Ye Liu <ye.liu@linux.dev>
Cc: Yichong Chen <chenyichong@uniontech.com>
Cc: Zhen Ni <zhen.ni@easystack.cn>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-add-print_mode-filter-fix
+++ a/mm/page_owner.c
@@ -933,7 +933,6 @@ static ssize_t page_owner_write(struct f
 	char *orig;
 	char *token;
 	int ret;
-	size_t max_input_len;
 	struct page_owner_filter_state *state = file->private_data;
 	enum page_owner_print_mode new_print_mode;
 	unsigned long flags;
@@ -942,9 +941,7 @@ static ssize_t page_owner_write(struct f
 	 * Maximum input length for filter commands:
 	 * 32: print_mode command max length is 17 ("mode=stack_handle").
 	 */
-	max_input_len = 32;
-
-	if (count > max_input_len)
+	if (count > 32)
 		return -EINVAL;
 
 	kbuf = memdup_user_nul(buf, count);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mincore-use-walk_page_range_vma-in-do_mincore-fix.patch
mm-page_owner-add-print_mode-filter-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch
security-apparmor-apparmorfsc-conditionally-compile-get_loaddata_common_ref.patch


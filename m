Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C854221D3D3
	for <mm-commits@vger.kernel.org>; Thu, 29 May 2025 23:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748560416; cv=none; b=Dz17W66O0UzrOmgoTNI7M3Oq2Taz24Yt2boEg9q5UyZvGZNyX4+YzqrH/riGwRgMZTVgcW+/X4AOXRib7uvVEYZS1HovmR/2N8imgm2X1MuUF4rPuwE5yA7c9pYJix48rOqwtLNtXwtcCp1nLy86MCGIrbeLcZoPCP7DUQCebvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748560416; c=relaxed/simple;
	bh=yJl+OyUAvTadIMJBkXEbS7t//oK5Vd4ZcVTPsclLgmg=;
	h=Date:To:From:Subject:Message-Id; b=kFDIvD+CALS5f5hFonNg9niBih7xJiE+SNJvfGwRcj9Q+7tG1sViknHGLzOX19P4C7ByQp+h8EAdV9vdWZ6DEHZwrDMQrL3rbVsa+YKgovo0X/Z12cYJPAq1MW4AeCk6pAN66hcv6UkazPjqdn1zwpO6OWn7LW6mjN6kgTK1Yps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=csM7zPA5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="csM7zPA5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF83C4CEE7;
	Thu, 29 May 2025 23:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748560416;
	bh=yJl+OyUAvTadIMJBkXEbS7t//oK5Vd4ZcVTPsclLgmg=;
	h=Date:To:From:Subject:From;
	b=csM7zPA5I6aK9X2Hn97vYl7JPLcXY510SiZHFriGYN4UQOlbed0x5Xyn8LouxHJP3
	 oXQnyRkxnCrcQy+CPzXqCOakm6BzhLP5tcNfN4PI++v60R3I9Gn5pt4F9FT30LIZzj
	 diTovuTUIIZ9J1WKY2k3HzoggMciOEDiloHG0oaQ=
Date: Thu, 29 May 2025 16:13:35 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,koct9i@gmail.com,david@redhat.com,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-strictly-check-vmstat_text-array-size.patch added to mm-new branch
Message-Id: <20250529231336.1FF83C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: strictly check vmstat_text array size
has been added to the -mm mm-new branch.  Its filename is
     mm-strictly-check-vmstat_text-array-size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-strictly-check-vmstat_text-array-size.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: strictly check vmstat_text array size
Date: Thu, 29 May 2025 14:05:41 +0300

/proc/vmstat displays counters from various sources.  It is easy to forget
to add or remove a label when a new counter is added or removed.

There is a BUILD_BUG_ON() function that catches missing labels.  However,
for some reason, it ignores extra labels.

Let's make the check strict.  This would help to catch issues when a
counter is removed.

Link: https://lkml.kernel.org/r/20250529110541.2960330-1-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmstat.c~mm-strictly-check-vmstat_text-array-size
+++ a/mm/vmstat.c
@@ -1870,7 +1870,7 @@ static void *vmstat_start(struct seq_fil
 	if (*pos >= NR_VMSTAT_ITEMS)
 		return NULL;
 
-	BUILD_BUG_ON(ARRAY_SIZE(vmstat_text) < NR_VMSTAT_ITEMS);
+	BUILD_BUG_ON(ARRAY_SIZE(vmstat_text) != NR_VMSTAT_ITEMS);
 	fold_vm_numa_events();
 	v = kmalloc_array(NR_VMSTAT_ITEMS, sizeof(unsigned long), GFP_KERNEL);
 	m->private = v;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-strictly-check-vmstat_text-array-size.patch


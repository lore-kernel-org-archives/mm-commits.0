Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ADA278F34
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976884; cv=none; b=WYfIBBPMTDlIuT/r/YEAo5XmHfXAF0pBv3BFhS7oh1VoJ6KStrsAUebHndx2/JQq+UbmT2e7h2tCiRKgqB/BCpySyWoQl+O8xlgZxCHz9bO6OWetRJK2uv6hMfj3JsdBWT8bj2P2TWsW4nvrsfWcCl4Gs2U4b0rp7ac4oLWYdFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976884; c=relaxed/simple;
	bh=Nj3TbPa9198w0UEgeFhYkEmaGlhz/KO7IfIZLseuSfI=;
	h=Date:To:From:Subject:Message-Id; b=KTngE3HjPTbeGc3Y+TaMTU60ZE2pv4YIQEl3xf/ulrBrY6q7vPNfEvqFeyNc+RZ/pUlmiQN1rwmfgLAOZW/wdx0Jl1IZjDZea3x5XA9Ho1M9AyQWntTcDW4vnSzWw4CUYZdea8IR4lAaHbb636vZ+ugUfZg5aipZI//jJbjPntc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hSDYFd2C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hSDYFd2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA312C4CEE3;
	Sun, 20 Jul 2025 02:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976883;
	bh=Nj3TbPa9198w0UEgeFhYkEmaGlhz/KO7IfIZLseuSfI=;
	h=Date:To:From:Subject:From;
	b=hSDYFd2CaGpwgsAXBl2d0moKRU1DbfL9PrZkXcJr2IjF2C1Q51TdWL67Qx0C94zWe
	 pI3XaItuQ53pVOSalo0z6Jj6dPGag5VkEG/a2LZKIcHXLWtMWTRPARw+LEOQpRfNW6
	 Wx6XqzX9XnXgAnEsdYUsN3ZadPPwA9nQ0g8dfyjA=
Date: Sat, 19 Jul 2025 19:01:23 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,koct9i@gmail.com,david@redhat.com,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-strictly-check-vmstat_text-array-size.patch removed from -mm tree
Message-Id: <20250720020123.CA312C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: strictly check vmstat_text array size
has been removed from the -mm tree.  Its filename was
     mm-strictly-check-vmstat_text-array-size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
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
@@ -1867,7 +1867,7 @@ static void *vmstat_start(struct seq_fil
 	if (*pos >= NR_VMSTAT_ITEMS)
 		return NULL;
 
-	BUILD_BUG_ON(ARRAY_SIZE(vmstat_text) < NR_VMSTAT_ITEMS);
+	BUILD_BUG_ON(ARRAY_SIZE(vmstat_text) != NR_VMSTAT_ITEMS);
 	fold_vm_numa_events();
 	v = kmalloc_array(NR_VMSTAT_ITEMS, sizeof(unsigned long), GFP_KERNEL);
 	m->private = v;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are



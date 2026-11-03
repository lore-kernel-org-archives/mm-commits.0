Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672134;
	b=ZJrvAFWSZUIZCGXUXoj5DZprbE2xLoTK0X6YY9+zaHzGwy1BwEZnEk+ZtKNIb0388ZV+
	 1nDfJcqKxXSIecOs1U6JyGcVBkYKCwtppzdr7lo6MpO9lGT9knnbBHfLXvCNR12iCQcMa
	 zkQy43X1FLZuUmK8Fq1UyPXalohfeEzZEvFIUkTHmshs7G8JLGKMlctYfQX7WnTioVKdo
	 zbj08ARx4j+pFxzbSbylT2+6hL3lkzC6jciAGEnfDG/62iu32AoSSp+qFizFvJJLCFqdm
	 gKssU9n8sfb2zHFQFBwmcSor+RX45Ecl7UGGISLoh8/1nssizk/9qesQoufDGszDelg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672134;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=nkCAHTjzrl9GjjM1C3n0eGP/ps9XFQ2vdUpTQf41dYc=;
	b=Nlr7SVkG6iVjJkqrjwyMlFZdr++IVS5ZBBWMdmlQokkTfTCDFM4f2p38FTuQ2CpQ8PoR
	 59FSNykO9XgihCYYl8pAtfVk5GEZ+miv8JSmoUrK7Gw+dgFlo6ryuM42wG1sckbOnf6oN
	 +rZ5oYPBh/SBVCrTKsTw9uGZtCe4wjXE9Dy2DSmRGtsduQ5xzg4ncPNQvoBsJl0hZ9m3C
	 SlqI6+7DHIzHV4c4Lz8H+ulcZ26BgqX/4fKvv9J+2ysvBmZGZnRoJMkEBPzYCvUDgqFLs
	 43UrJBL0Req+xk07sRGn7ga0ow2prsBxg99EWtnYQRTviXApz3eUl59owkSCJDUsQkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="P3/YaW7t";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3C3606A32D;
	Tue,  3 Nov 2026 02:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=P3/YaW7t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889971F000C1;
	Tue,  3 Nov 2026 02:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672133;
	bh=nkCAHTjzrl9GjjM1C3n0eGP/ps9XFQ2vdUpTQf41dYc=;
	h=Date:To:From:Subject;
	b=P3/YaW7tg7QmbkxY1WmmyWMjSLlzrPWmcLZgX1b7xQLpw08kRC+tMr9LBYTN6OsJC
	 mcP7xJ55wu9XBhe50echLeieaUSVszR1icnT0ZdI7fDD1Pj/5MAv9U/xrlRbENy79d
	 41w4/Mfs9uWFKCkUw7eReJOWja6PkD7f0OQyYqSE=
Date: Mon, 02 Nov 2026 18:15:33 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	stable@vger.kernel.org,sj@kernel.org,rppt@kernel.org,pfalcato@suse.de,
	mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kees@kernel.org,
	jannh@google.com,gourry@gourry.net,dave@stgolabs.net,ccross@google.com,
	david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-madvise-preserve-vma_softdirty_bit-when-changing-anonymous-names.patch removed from -mm tree
Message-Id: <20261103021533.889971F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/madvise: preserve VMA_SOFTDIRTY_BIT when changing anonymous names
has been removed from the -mm tree.  Its filename was
     mm-madvise-preserve-vma_softdirty_bit-when-changing-anonymous-names.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/madvise: preserve VMA_SOFTDIRTY_BIT when changing anonymous names
Date: Fri, 23 Oct 2026 14:47:29 +0100

When changing the anonymous VMA name, madvise_update_vma() calls
vma_modify_name() to possibly merge with adjacent VMAs. We don't call
vma_modify_flags() and consequently don't obtain the new VMA flags.

Later in the function we update the VMA flags to the stale new_vma_flags
we obtained before. This can result in us losing the VMA_SOFTDIRTY_BIT
flag set on a VMA we just merged with.

There is no need to update the VMA flags at all, so just exit early. This
skips calling khugepaged_enter_vma(), but since the flags didn't change
this is fine.

[ljs@kernel.org: minor edit of commit message, rebased]
Link: https://lore.kernel.org/20261023-fix-vma-atomic-v1-3-8ff4fae1fc85@kernel.org
Fixes: 9a10064f5625 ("mm: add a field to store names for private anonymous memory")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jann Horn <jannh@google.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: SJ Park <sj@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Colin Cross <ccross@google.com>
Cc: <stable@vger.kernel.org>
---

 mm/madvise.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/madvise.c~mm-madvise-preserve-vma_softdirty_bit-when-changing-anonymous-names
+++ a/mm/madvise.c
@@ -177,6 +177,9 @@ static int madvise_update_vma(vm_flags_t
 
 	/* vm_flags is protected by the mmap_lock held in write mode. */
 	vma_start_write(vma);
+	if (set_new_anon_name)
+		return replace_anon_vma_name(vma, anon_name);
+
 	vma_overwrite_flags(vma, new_vma_flags);
 	/*
 	 * If the vma become good for khugepaged to scan,
@@ -186,9 +189,6 @@ static int madvise_update_vma(vm_flags_t
 	if (vma_flags_test(&new_vma_flags, VMA_HUGEPAGE_BIT))
 		khugepaged_enter_vma(vma, vma_flags_to_legacy(new_vma_flags));
 
-	if (set_new_anon_name)
-		return replace_anon_vma_name(vma, anon_name);
-
 	return 0;
 }
 
_

Patches currently in -mm which might be from david@kernel.org are

mm-memory-failure-fix-folio-refcount-leak-and-min_order_for_split-locking.patch


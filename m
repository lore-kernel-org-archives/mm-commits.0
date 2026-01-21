Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700553612F4
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966103; cv=none; b=KuMpjeHEMFFNGOu1bkB8qyU6n45efueaLKkI9kCIQIWwa/McfNOrxwcMCrmeyeLskthwZeqiC4ARuh6BkdtY37YKhANv2ZtSgfjUDzJtAkAEb0gcyp92qshLQVTB6/HmdxI7NmLVXyp6C1nTFw6v45lA+IadvTnsodtfLRl1EmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966103; c=relaxed/simple;
	bh=H9hJvp7oULmnGrj7fpmposL+z6gkojezW/z5tg1p1Jg=;
	h=Date:To:From:Subject:Message-Id; b=pKKZcXB6rZgf9dn80alfSE0YOfgXN7jLGEWCzYMdgag8TYP9YLWaHYDMd+HjgJtwEpit9sdHVWKyoPDNQGY8om7O1+CBkDyM9dK6Wd+l440WZiHYknBxAQQ0pe6hkIrnyyZ9hAs18B4lLWoljsxgWSAPCzF4nEbt/kvAZt6Ch1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UAA2kRGb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UAA2kRGb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459F0C16AAE;
	Wed, 21 Jan 2026 03:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966103;
	bh=H9hJvp7oULmnGrj7fpmposL+z6gkojezW/z5tg1p1Jg=;
	h=Date:To:From:Subject:From;
	b=UAA2kRGbKoaT5Lf5gDqPRA3vV5j/KufEujBldnf675pWOiVVEqX7dKf3RLyIW3P3I
	 Q1zUuPOK4T7QJEHZq5yZnSPSEOW0+De9RH+vYgycgbjHcas4Una0BG7pyr61Uq7UgJ
	 OD4WgDChQGZ9ADiivlrHMbg0QKiQ9XrxXzGcydOo=
Date: Tue, 20 Jan 2026 19:28:22 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pfalcato@suse.de,niecheng1@uniontech.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jannh@google.com,anshuman.khandual@arm.com,guanwentao@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-cleanup-vma_iter_bulk_alloc.patch removed from -mm tree
Message-Id: <20260121032823.459F0C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: cleanup vma_iter_bulk_alloc
has been removed from the -mm tree.  Its filename was
     mm-cleanup-vma_iter_bulk_alloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wentao Guan <guanwentao@uniontech.com>
Subject: mm: cleanup vma_iter_bulk_alloc
Date: Thu, 6 Nov 2025 19:09:29 +0800

commit d24062914837 ("fork: use __mt_dup() to duplicate maple tree in
dup_mmap()"), removed the only user and mas_expected_entries has been
removed, since commit e3852a1213ffc ("maple_tree: Drop bulk insert
support").  Also cleanup the mas_expected_entries in maple_tree.h.

No functional change.

Link: https://lkml.kernel.org/r/20251106110929.3522073-1-guanwentao@uniontech.com
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Cheng Nie <niecheng1@uniontech.com>
Cc: Guan Wentao <guanwentao@uniontech.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |    1 -
 mm/vma.h                   |    6 ------
 2 files changed, 7 deletions(-)

--- a/include/linux/maple_tree.h~mm-cleanup-vma_iter_bulk_alloc
+++ a/include/linux/maple_tree.h
@@ -528,7 +528,6 @@ bool mas_nomem(struct ma_state *mas, gfp
 void mas_pause(struct ma_state *mas);
 void maple_tree_init(void);
 void mas_destroy(struct ma_state *mas);
-int mas_expected_entries(struct ma_state *mas, unsigned long nr_entries);
 
 void *mas_prev(struct ma_state *mas, unsigned long min);
 void *mas_prev_range(struct ma_state *mas, unsigned long max);
--- a/mm/vma.h~mm-cleanup-vma_iter_bulk_alloc
+++ a/mm/vma.h
@@ -561,12 +561,6 @@ static inline unsigned long vma_iter_end
 	return vmi->mas.last + 1;
 }
 
-static inline int vma_iter_bulk_alloc(struct vma_iterator *vmi,
-				      unsigned long count)
-{
-	return mas_expected_entries(&vmi->mas, count);
-}
-
 static inline
 struct vm_area_struct *vma_iter_prev_range(struct vma_iterator *vmi)
 {
_

Patches currently in -mm which might be from guanwentao@uniontech.com are



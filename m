Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14951C27
	for <mm-commits@vger.kernel.org>; Fri,  6 Jun 2025 04:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749185773; cv=none; b=X9QgAOcXLgl+zB+qVXqVBkxU5Ew08Qw0OXry/34oqADx6U/LAunNpHVWE7lsQmU2NTLCW2PReNuCJYGAL4jDktuEywe3Cs2Lah3PQGZtGlP7/s6xwS2nvcx4FlkzvrL209QGz9Y16xo4cslYDJ9YnqH5P81n5q0Iy67//rNb7o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749185773; c=relaxed/simple;
	bh=EE6lmtdiHBfpMQQH9XvVMhxj+0824flYOK2n2GzG5YM=;
	h=Date:To:From:Subject:Message-Id; b=UlLMbnpz3vJfS10wIKhV4lUNr1c2s1Blbx5kyboi5aeZ7a8AE1w5ZFJUswbL24I6w5fTiLGzBahs6fpFfqkGEgvHVk8e5+x4MeCX2SRnseSXR9+XJnSW+1b27XOP23qwt1JqQl03mM+iFLJaiJRdZtJp6+Z4KWYC+3toQRBtrX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qeRQ6R8m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qeRQ6R8m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4C5C4CEEB;
	Fri,  6 Jun 2025 04:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749185773;
	bh=EE6lmtdiHBfpMQQH9XvVMhxj+0824flYOK2n2GzG5YM=;
	h=Date:To:From:Subject:From;
	b=qeRQ6R8mupdi+tKbUkaUUqyJdoDXvPsxEVS4ODLHQNqoyyq9yJFlV39HxTO35hy/M
	 y0JFJlAf1kSk9Y2PcqvgRGbdAdFXUSFUOf+KAqtrWSBW21NAbms1HttbYXFQrjuCoJ
	 K3fH455ovuLHq1eMCBHKejPzvyeb5RrrV9oN7rp0=
Date: Thu, 05 Jun 2025 21:56:12 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,peterz@infradead.org,oleg@redhat.com,mhiramat@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,pulehui@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-expose-abnormal-new_pte-during-move_ptes.patch removed from -mm tree
Message-Id: <20250606045613.0C4C5C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: expose abnormal new_pte during move_ptes
has been removed from the -mm tree.  Its filename was
     mm-expose-abnormal-new_pte-during-move_ptes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pu Lehui <pulehui@huawei.com>
Subject: mm: expose abnormal new_pte during move_ptes
Date: Thu, 29 May 2025 15:56:48 +0000

When executing move_ptes, the new_pte must be NULL, otherwise it will be
overwritten by the old_pte, and cause the abnormal new_pte to be leaked. 
In order to make this problem to be more explicit, let's add WARN_ON_ONCE
when new_pte is not NULL.

[akpm@linux-foundation.org: s/WARN_ON_ONCE/VM_WARN_ON_ONCE/]
Link: https://lkml.kernel.org/r/20250529155650.4017699-3-pulehui@huaweicloud.com
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/mremap.c~mm-expose-abnormal-new_pte-during-move_ptes
+++ a/mm/mremap.c
@@ -237,6 +237,8 @@ static int move_ptes(struct pagetable_mo
 
 	for (; old_addr < old_end; old_pte++, old_addr += PAGE_SIZE,
 				   new_pte++, new_addr += PAGE_SIZE) {
+		VM_WARN_ON_ONCE(!pte_none(*new_pte));
+
 		if (pte_none(ptep_get(old_pte)))
 			continue;
 
_

Patches currently in -mm which might be from pulehui@huawei.com are



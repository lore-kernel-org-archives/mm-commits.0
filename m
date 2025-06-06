Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62E11FB3
	for <mm-commits@vger.kernel.org>; Fri,  6 Jun 2025 04:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749185628; cv=none; b=qRo1BFq9gsjVpPk0xksz/qtKP3oOhSitz5YZ3JJRJNnNTCjDD//tYhP4FV0R9d4sKf0d72X/vhjj88yuN+Pov6PZ5UJGxeMKag62l2O/CIUxm2/G3EcjTncQRw+bQ5awuVBr249T/+xOjGCRkcKJS9uapbogsAYLrpVSRp85K6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749185628; c=relaxed/simple;
	bh=MvLsQUf/MK1wg1fsYme6XcuV6EyGdc6n4fHtzwVcfsI=;
	h=Date:To:From:Subject:Message-Id; b=DqGiUwRRfmhE9h6p9oUhy7Li+GTdcQC53tPlSTjDDZdytvO7IIjlaBdUVyewNd8MfuTzyfb44OTuOHP7AzWod7u+T3c5n/sCcjVxwRI7WN2eC0Hvy1S2UN1abDeQ1R1ZMUV7/r62oBOaL1fz4ssTAsDDLZ/Z/Lh1SdzDmnf0qBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1ECprA7a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1ECprA7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C06C4CEEB;
	Fri,  6 Jun 2025 04:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749185627;
	bh=MvLsQUf/MK1wg1fsYme6XcuV6EyGdc6n4fHtzwVcfsI=;
	h=Date:To:From:Subject:From;
	b=1ECprA7aoycyZTQV8EkLUk5vZRIn8dgBqP+jZArWwyeQVeRtqj391eY3LnicreskO
	 ElY0OYCQ41PerO7PPac2Weuh3hW9db3zCo7FvU2iO3YOVBhqYtF6sF6HKPIdWTPVR7
	 t/xnXsdsR61ZYqdLyFYBzFMzvWjSuq8BZMb0Vql8=
Date: Thu, 05 Jun 2025 21:53:46 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pulehui@huawei.com,peterz@infradead.org,oleg@redhat.com,mhiramat@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-expose-abnormal-new_pte-during-move_ptes-fix.patch removed from -mm tree
Message-Id: <20250606045347.38C06C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-expose-abnormal-new_pte-during-move_ptes-fix
has been removed from the -mm tree.  Its filename was
     mm-expose-abnormal-new_pte-during-move_ptes-fix.patch

This patch was dropped because it was folded into mm-expose-abnormal-new_pte-during-move_ptes.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-expose-abnormal-new_pte-during-move_ptes-fix
Date: Thu May 29 08:46:26 PM PDT 2025

s/WARN_ON_ONCE/VM_WARN_ON_ONCE/

Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Pu Lehui <pulehui@huawei.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mremap.c~mm-expose-abnormal-new_pte-during-move_ptes-fix
+++ a/mm/mremap.c
@@ -237,7 +237,7 @@ static int move_ptes(struct pagetable_mo
 
 	for (; old_addr < old_end; old_pte++, old_addr += PAGE_SIZE,
 				   new_pte++, new_addr += PAGE_SIZE) {
-		WARN_ON_ONCE(!pte_none(*new_pte));
+		VM_WARN_ON_ONCE(!pte_none(*new_pte));
 
 		if (pte_none(ptep_get(old_pte)))
 			continue;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-expose-abnormal-new_pte-during-move_ptes.patch
selftests-mm-add-test-about-uprobe-pte-be-orphan-during-vma-merge-fix.patch
mm-add-zblock-allocator-fix.patch
mm-add-zblock-allocator-fix-2.patch
mm-add-zblock-allocator-fix-2-fix.patch
mm-add-zblock-allocator-fix-3.patch
mm-zblock-avoid-failing-the-build-fix.patch


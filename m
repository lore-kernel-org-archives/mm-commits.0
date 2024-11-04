Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B3C290F
	for <mm-commits@vger.kernel.org>; Mon,  4 Nov 2024 04:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730696203; cv=none; b=UNbOoCUrBEvqiDnOt12U5KJnVrL1jrX2zN7VOn4LOPSKOZf2duM5YrYRW2XNIGlU5LWFYRXzQhdArxPZAsrnkwvKdRJU45P3K3PmlkqHaC9e/yWxZyXfp7WGDByddu44enxHsbdXMuQD5L/G+mgH8ipD5li0aOxcSAN7fDvaQPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730696203; c=relaxed/simple;
	bh=AEXZ5oQyvVKZyHYksGcU7HzavflNMNO729qoVDhVypM=;
	h=Date:To:From:Subject:Message-Id; b=r2PpaWSs6+7QMisX88yjtoKgjqqM+KH+tkt3g0t8AuTpj0DA8PyIxxoRtFV7mujptD8YE6yKP3uwBB6m15vExuOgAQnsRlBM9uXmE7jzFo4WM03b0ETp+++9rxLP8Hpll6QHKLcYhIysRyjAaKBs2hs73yRP/CFasAXtOZfuudE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XD1fZQgS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XD1fZQgS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F4EC4CECE;
	Mon,  4 Nov 2024 04:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730696202;
	bh=AEXZ5oQyvVKZyHYksGcU7HzavflNMNO729qoVDhVypM=;
	h=Date:To:From:Subject:From;
	b=XD1fZQgSC66oHVWP8ld07/Sp2E4XG9H9Uk0SHLg06ncnO+6xCqTLZueqhdlu4Aeqd
	 sX5uf/wSVVy9lMnnIpB2ab8HNw8pZkb9tCEmr1cm/ngBBrb7zwSpLtL4HwfbFX0HrM
	 xv7XIjVFW5fvzF7BiR3gPNqJj4QwYd3n7UbNmg4Y=
Date: Sun, 03 Nov 2024 20:56:42 -0800
To: mm-commits@vger.kernel.org,liujing@cmss.chinamobile.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] tools-mm-free-the-allocated-memory-fix.patch removed from -mm tree
Message-Id: <20241104045642.C7F4EC4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools-mm-free-the-allocated-memory-fix
has been removed from the -mm tree.  Its filename was
     tools-mm-free-the-allocated-memory-fix.patch

This patch was dropped because it was folded into tools-mm-free-the-allocated-memory.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: tools-mm-free-the-allocated-memory-fix
Date: Wed Oct 23 07:26:22 PM PDT 2024

fix whitespace

Cc: Liu Jing <liujing@cmss.chinamobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/page_owner_sort.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/mm/page_owner_sort.c~tools-mm-free-the-allocated-memory-fix
+++ a/tools/mm/page_owner_sort.c
@@ -377,7 +377,7 @@ static char *get_comm(char *buf)
 	if (errno != 0) {
 		if (debug_on)
 			fprintf(stderr, "wrong comm in follow buf:\n%s\n", buf);
-		free (comm_str);
+		free(comm_str);
 		return NULL;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-keep-track-of-free-highatomic-fix.patch
mm-refactor-arch_calc_vm_flag_bits-and-arm64-mte-handling-fix.patch
mm-fix-__wp_page_copy_user-fallback-path-for-remote-mm-fix.patch
mm-memoryc-remove-stray-newline-at-top-of-file.patch
tools-mm-free-the-allocated-memory.patch
memcg-v1-no-need-for-memcg-locking-for-mglru-fix.patch
mm-vma-the-pgoff-is-correct-if-can_merge_right-fix.patch
memcg-workingset-remove-folio_memcg_rcu-usage-fix.patch
bootmem-stop-using-page-index-fix.patch
vma-detect-infinite-loop-in-vma-tree-fix.patch
maple_tree-add-a-test-checking-storing-null-fix.patch
fs-proc-kcorec-fix-coccinelle-reported-error-instances-fix.patch


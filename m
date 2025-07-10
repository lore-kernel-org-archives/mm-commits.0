Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6123A280A58;
	Thu, 10 Jul 2025 03:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752119992; cv=none; b=ar2hgZd+Lb3oQcW+AohORlQ79I6ZFlVY0I6Aa9qvL5w1rAGWk83pjSUDVohwQlHfP1Y93EUAs9A4pYKi9kYMZXiMCt7Bib3j7AbwN+WtPUNjKqljamFBxr4Ni/SJ3b49SgaFdwKfO4HOYBleEkuqLX+gX8xEuG29EJCp+IpLTvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752119992; c=relaxed/simple;
	bh=kEtiM8cSFZN+M2rZgs7rEbuYg9eapiJgnxY0KAeqWOg=;
	h=Date:To:From:Subject:Message-Id; b=huCp+iUiOzDcYpVthgd9RK9izRJu5n95MbrbTKiNPXinL7heMnOvvlzH/qrpWkSyy7nh/t8X9FgKYCVRRmdbmf2EGBzfFARGWmMf40v3PrLUC7SHVzvozd2uDUAXrx9kaylrgli5PzG5BfEIlg2NeniTQxl7i38fRlFceyzR5ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=slXJIMwm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="slXJIMwm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5DD5C4CEE3;
	Thu, 10 Jul 2025 03:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752119991;
	bh=kEtiM8cSFZN+M2rZgs7rEbuYg9eapiJgnxY0KAeqWOg=;
	h=Date:To:From:Subject:From;
	b=slXJIMwmyFJjKRmkHgQWq55SIIaZTY+seydUxLjh+Cmo8jChf6qjjCikrvTkxkqw9
	 HM7xbtLTy4WFE4BP55dfIFHKr0xXoUr1J8miX+XKSFwaQbe4T5VIRpXncBNFtGXwr5
	 S2g8ZzNpE3bCcmaKywj7K78bO/MDoEMXPLsJfbYQ=
Date: Wed, 09 Jul 2025 20:59:51 -0700
To: mm-commits@vger.kernel.org,yzhong@purestorage.com,surenb@google.com,stable@vger.kernel.org,oliver.sang@intel.com,kent.overstreet@linux.dev,cachen@purestorage.com,00107082@163.com,harry.yoo@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] lib-alloc_tag-do-not-acquire-non-existent-lock-in-alloc_tag_top_users-v3.patch removed from -mm tree
Message-Id: <20250710035951.C5DD5C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib-alloc_tag-do-not-acquire-non-existent-lock-in-alloc_tag_top_users-v3
has been removed from the -mm tree.  Its filename was
     lib-alloc_tag-do-not-acquire-non-existent-lock-in-alloc_tag_top_users-v3.patch

This patch was dropped because it was folded into lib-alloc_tag-do-not-acquire-non-existent-lock-in-alloc_tag_top_users.patch

------------------------------------------------------
From: Harry Yoo <harry.yoo@oracle.com>
Subject: lib-alloc_tag-do-not-acquire-non-existent-lock-in-alloc_tag_top_users-v3
Date: Tue, 24 Jun 2025 16:25:13 +0900

Link: https://lkml.kernel.org/r/20250624072513.84219-1-harry.yoo@oracle.com
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202506181351.bba867dd-lkp@intel.com
Closes: https://lore.kernel.org/oe-lkp/202506131711.5b41931c-lkp@intel.com
Fixes: 780138b12381 ("alloc_tag: check mem_profiling_support in alloc_tag_init")
Fixes: 1438d349d16b ("lib: add memory allocations report in show_mem()")
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
Cc: Casey Chen <cachen@purestorage.com>
Cc: David Wang <00107082@163.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yuanyuan Zhong <yzhong@purestorage.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/alloc_tag.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/alloc_tag.c~lib-alloc_tag-do-not-acquire-non-existent-lock-in-alloc_tag_top_users-v3
+++ a/lib/alloc_tag.c
@@ -137,7 +137,8 @@ size_t alloc_tag_top_users(struct codeta
 
 	if (IS_ERR_OR_NULL(alloc_tag_cttype))
 		return 0;
-	else if (can_sleep)
+
+	if (can_sleep)
 		codetag_lock_module_list(alloc_tag_cttype, true);
 	else if (!codetag_trylock_module_list(alloc_tag_cttype))
 		return 0;
_

Patches currently in -mm which might be from harry.yoo@oracle.com are

lib-alloc_tag-do-not-acquire-non-existent-lock-in-alloc_tag_top_users.patch
mm-zsmalloc-do-not-pass-__gfp_movable-if-config_compaction=n.patch
mm-check-if-folio-has-valid-mapcount-before-folio_test_anonksm-when-necessary.patch


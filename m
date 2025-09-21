Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D5928DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489838; cv=none; b=UtnMRkcXmBpI4onEx4e8UZcJeaXLwYBzLXFHyLQEYuuuTJ7NhmO6DpBljE9rEeX590A2x7I6gej1opCFBuwhlqkMywDM5HTqzkyHZq0owvb0U5XZeBnBEm2LxAxdhEZRLdCxnpJh9e4gF9w3fKoG2H2rmHTS0SAUco53bTy9AMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489838; c=relaxed/simple;
	bh=kjC0gO8fsDmZIb2hudm5lxjBnTXJFEbxIY7whSmixbg=;
	h=Date:To:From:Subject:Message-Id; b=G+f9IysLJdnf8lshqV+K9GKYs4UeUatCw9/HP+M2olFP7ZT5T1PirN/tSjcjfYL7rL5K/OkU5S1AAosGyBz423Xxk4Ukwpoh7n3O4iZy7FTtgdv+22RT8wAv54tnkYPtIiy2rQPeNXfZr9xBxq8+z3gjMCUbqIOD3pIrIc0cm8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AJBD5TOQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AJBD5TOQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D71C4CEE7;
	Sun, 21 Sep 2025 21:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489838;
	bh=kjC0gO8fsDmZIb2hudm5lxjBnTXJFEbxIY7whSmixbg=;
	h=Date:To:From:Subject:From;
	b=AJBD5TOQnCA6LYtn5wr3qS7rInrUhBbVL50Y1w+qozGicmtOUemEVSqihSMsQssFF
	 vzRee4bVhdfzZv7FM9iSk10TNE9BCS/RUlFhi+icLbKN49Maan2KeEQBKaZcMNQDhy
	 YHQfijii/FqZ4ln7YUgfIR39a0Xp1sXdAhAdwnqc=
Date: Sun, 21 Sep 2025 14:23:57 -0700
To: mm-commits@vger.kernel.org,tursulin@ursulin.net,simona@ffwll.ch,rodrigo.vivi@intel.com,lorenzo.stoakes@oracle.com,joonas.lahtinen@linux.intel.com,jani.nikula@linux.intel.com,airlied@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] drm-i915-gem-drop-nth_page-usage-within-sg-entry.patch removed from -mm tree
Message-Id: <20250921212357.F0D71C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drm/i915/gem: drop nth_page() usage within SG entry
has been removed from the -mm tree.  Its filename was
     drm-i915-gem-drop-nth_page-usage-within-sg-entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: drm/i915/gem: drop nth_page() usage within SG entry
Date: Mon, 1 Sep 2025 17:03:47 +0200

It's no longer required to use nth_page() when iterating pages within a
single SG entry, so let's drop the nth_page() usage.

Link: https://lkml.kernel.org/r/20250901150359.867252-27-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/gem/i915_gem_pages.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_pages.c~drm-i915-gem-drop-nth_page-usage-within-sg-entry
+++ a/drivers/gpu/drm/i915/gem/i915_gem_pages.c
@@ -779,7 +779,7 @@ __i915_gem_object_get_page(struct drm_i9
 	GEM_BUG_ON(!i915_gem_object_has_struct_page(obj));
 
 	sg = i915_gem_object_get_sg(obj, n, &offset);
-	return nth_page(sg_page(sg), offset);
+	return sg_page(sg) + offset;
 }
 
 /* Like i915_gem_object_get_page(), but mark the returned page dirty */
_

Patches currently in -mm which might be from david@redhat.com are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F6113D279;
	Thu, 16 Jan 2025 05:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737004580; cv=none; b=Q0jYMhmM29ZM7X21XFDMjRdVcra0Coq8/sgmR1rDlLv5NAYvjnLgbOdtGg4EAVusNe7oGqpUsoGBM+fhd8EfULIv7h3acv9kxZbZ92SKf6TUoFBw94fzP2cYnQOJkDcDENISOrRWhTAn78pS9tfWqkqLgSdYQBqbe672RQ/SZxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737004580; c=relaxed/simple;
	bh=kMFFtLaOk5zTAf8mKvZMfeUhX6c/yt4n1ZfPZND5cUM=;
	h=Date:To:From:Subject:Message-Id; b=JJ6OGKnXSMDmKOPCPhINWVX3TjJkFHzUu+ZLnxSlUWdphGCZTaR/nOmIgl49Rm4fI0KESjITNjvxzI12mJ++39UdDP44gPViOVzHbuUNob3fxN/OCxqHFnQaZNnQxz7OKGBtwMks53EQcf1aiTKeS2Jca/j9NLuWFzMzaELRBKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IGH+qzMQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IGH+qzMQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528D7C4CED6;
	Thu, 16 Jan 2025 05:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737004578;
	bh=kMFFtLaOk5zTAf8mKvZMfeUhX6c/yt4n1ZfPZND5cUM=;
	h=Date:To:From:Subject:From;
	b=IGH+qzMQxfkQtMtqXHQGYIeElN1nZUTvIlxg6ItnWZhfLUUL5wTWy5LrCmxmrLHdo
	 BspHsw6jXrNuzQ9+VpV4LtLkYdkk3MBWJJEtmIC0O9y4+l+LmG3m9snI1oso7KFfDO
	 ibbgSLnDTK+4T5oTMhVvG2EaJ9YkM8BFVfG6skKQ=
Date: Wed, 15 Jan 2025 21:16:17 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,stable@vger.kernel.org,quic_zhenhuah@quicinc.com,kent.overstreet@linux.dev,00107082@163.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] alloc_tag-skip-pgalloc_tag_swap-if-profiling-is-disabled.patch removed from -mm tree
Message-Id: <20250116051618.528D7C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: skip pgalloc_tag_swap if profiling is disabled
has been removed from the -mm tree.  Its filename was
     alloc_tag-skip-pgalloc_tag_swap-if-profiling-is-disabled.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: alloc_tag: skip pgalloc_tag_swap if profiling is disabled
Date: Thu, 26 Dec 2024 13:16:39 -0800

When memory allocation profiling is disabled, there is no need to swap
allocation tags during migration.  Skip it to avoid unnecessary overhead.

Once I added these checks, the overhead of the mode when memory profiling
is enabled but turned off went down by about 50%.

Link: https://lkml.kernel.org/r/20241226211639.1357704-2-surenb@google.com
Fixes: e0a955bf7f61 ("mm/codetag: add pgalloc_tag_copy()")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: David Wang <00107082@163.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zhenhua Huang <quic_zhenhuah@quicinc.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/alloc_tag.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/lib/alloc_tag.c~alloc_tag-skip-pgalloc_tag_swap-if-profiling-is-disabled
+++ a/lib/alloc_tag.c
@@ -195,6 +195,9 @@ void pgalloc_tag_swap(struct folio *new,
 	union codetag_ref ref_old, ref_new;
 	struct alloc_tag *tag_old, *tag_new;
 
+	if (!mem_alloc_profiling_enabled())
+		return;
+
 	tag_old = pgalloc_tag_get(&old->page);
 	if (!tag_old)
 		return;
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-avoid-current-alloc_tag-manipulations-when-profiling-is-disabled.patch


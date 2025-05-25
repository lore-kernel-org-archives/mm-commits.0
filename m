Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9503FC1D;
	Sun, 25 May 2025 07:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748159665; cv=none; b=hN9zLlaQYf1hQ6cHY0UbIzV1G0LLxoKXAPndRP9UB7RfXcZS6FMMJI4NuZsC6ywrwRPDtwZaiFda5NqvUqlswhyKC0O1je0wkbJQbi0ZuGCuIgADDLsPyZ5TQFYAJ+298De1lxs9viQdO6XlzrVKS53dnzznWaPTcrxAsMHy6QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748159665; c=relaxed/simple;
	bh=AC+vClzQqOufCni+hMA6uxZTGa2qSmit2NKCGnMZaqs=;
	h=Date:To:From:Subject:Message-Id; b=f678fV1KoF4CJsWN2vcU0JA6/t2nUSW9+0IozPfZu1bQUfq05tvubAvcMKdMFlKcZ55Z0liUSHjc3fPVgKrFHR65/pqyqBAyFg+9DwNkK0Wl/7KusZuYu7I3psXnG1WNOTm7HIDBZTfpr8dloUzvKs6ZYhTpwxa27OGQk5a1PrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y+c2upKn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y+c2upKn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EBECC4CEEA;
	Sun, 25 May 2025 07:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748159664;
	bh=AC+vClzQqOufCni+hMA6uxZTGa2qSmit2NKCGnMZaqs=;
	h=Date:To:From:Subject:From;
	b=Y+c2upKn7mURy7wtZDdV2brRzHlCQAKjlreXJeqWhzXP0ZGOtiqB7KCeUXg+hJy3Q
	 ojrWeSdPprXZxVAJebsq1/lL2Rmoie4Pe/c4LVD2HG/2WBJ49cuiHAukNY3GYIFR3R
	 XvxZDUE8CJfu3nJtBEbW36MNKk77VryK4Ef6jBhM=
Date: Sun, 25 May 2025 00:54:23 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,stable@vger.kernel.org,shung-hsi.yu@suse.com,pawan.kumar.gupta@linux.intel.com,erhard_f@mailbox.org,eddyz87@gmail.com,dakr@kernel.org,kees@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-vmalloc-actually-use-the-in-place-vrealloc-region.patch removed from -mm tree
Message-Id: <20250525075424.4EBECC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmalloc: actually use the in-place vrealloc region
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-actually-use-the-in-place-vrealloc-region.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kees Cook <kees@kernel.org>
Subject: mm: vmalloc: actually use the in-place vrealloc region
Date: Thu, 15 May 2025 14:42:15 -0700

Patch series "mm: vmalloc: Actually use the in-place vrealloc region".

This fixes a performance regression[1] with vrealloc()[1].


The refactoring to not build a new vmalloc region only actually worked
when shrinking.  Actually return the resized area when it grows.  Ugh.

Link: https://lkml.kernel.org/r/20250515214217.619685-1-kees@kernel.org
Fixes: a0309faf1cb0 ("mm: vmalloc: support more granular vrealloc() sizing")
Signed-off-by: Kees Cook <kees@kernel.org>
Reported-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Closes: https://lore.kernel.org/all/20250515-bpf-verifier-slowdown-vwo2meju4cgp2su5ckj@6gi6ssxbnfqg [1]
Tested-by: Eduard Zingerman <eddyz87@gmail.com>
Tested-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Reviewed-by: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Cc: "Erhard F." <erhard_f@mailbox.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/vmalloc.c~mm-vmalloc-actually-use-the-in-place-vrealloc-region
+++ a/mm/vmalloc.c
@@ -4111,6 +4111,7 @@ void *vrealloc_noprof(const void *p, siz
 		if (want_init_on_alloc(flags))
 			memset((void *)p + old_size, 0, size - old_size);
 		vm->requested_size = size;
+		return (void *)p;
 	}
 
 	/* TODO: Grow the vm_area, i.e. allocate and map additional pages. */
_

Patches currently in -mm which might be from kees@kernel.org are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D797A702
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103905; cv=none; b=kzVmpzm9dzziVbJmsgiD4bN8aw6tq3PNZKKQETSsHEUJMdVDd5t+F6N9af7Z9NoBew8D9aQzTw+3AhtrETUR7QYIvljeNOjJHoCqEfjDZ/7tbvXZsvvIlbUmDwrV7Ihds7v5apMSLXgmcCWwg3sX0357a66xkpMYKsFzvlh0zYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103905; c=relaxed/simple;
	bh=JnOkPj5fPfDm/58uhMhucFqbTiQzSK3wnRqlM0BFJ90=;
	h=Date:To:From:Subject:Message-Id; b=kI82BYq9KvOpLLP012/dioIftxp4cTroYKS5wrYFRrYLiMDinff8ov3b5QSpHU7MDsb8xfDQ5L/z0j4Rsh+N+cXQeaZkMgTByPxxlZ2nUsHTQavEqXpKUZO3g3HoG9X//AsSvNftKmK9c7jRUlCOQROuYtYS2tkf1NWj7OCKhME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VPLoK7bA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VPLoK7bA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 650FBC113CD;
	Fri, 26 Apr 2024 03:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103905;
	bh=JnOkPj5fPfDm/58uhMhucFqbTiQzSK3wnRqlM0BFJ90=;
	h=Date:To:From:Subject:From;
	b=VPLoK7bAnkpD888kiCfhKMZY8Sm9O2F9uiRMTytDwy5dyCAjPayuZw/C2E6jupQV4
	 rQGzWBSK0G8TCb8SdC2mLePF8/DTpKlwf+O2DQTnhl0GwPIK565Eps5eTK2WpDYsoL
	 ouCP1xrIw1aEDGnhG/jLifbm3KLI1AwwQ3qyoM98=
Date: Thu, 25 Apr 2024 20:58:24 -0700
To: mm-commits@vger.kernel.org,wedsonaf@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,peterz@infradead.org,pasha.tatashin@soleen.com,ojeda@kernel.org,kent.overstreet@linux.dev,keescook@chromium.org,gary@garyguo.net,dennis@kernel.org,cl@linux.com,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@samsung.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_ext-enable-early_page_ext-when-config_mem_alloc_profiling_debug=y.patch removed from -mm tree
Message-Id: <20240426035825.650FBC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_ext: enable early_page_ext when CONFIG_MEM_ALLOC_PROFILING_DEBUG=y
has been removed from the -mm tree.  Its filename was
     mm-page_ext-enable-early_page_ext-when-config_mem_alloc_profiling_debug=y.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm/page_ext: enable early_page_ext when CONFIG_MEM_ALLOC_PROFILING_DEBUG=y
Date: Thu, 21 Mar 2024 09:36:43 -0700

For all page allocations to be tagged, page_ext has to be initialized
before the first page allocation.  Early tasks allocate their stacks using
page allocator before alloc_node_page_ext() initializes page_ext area,
unless early_page_ext is enabled.  Therefore these allocations will
generate a warning when CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled. 
Enable early_page_ext whenever CONFIG_MEM_ALLOC_PROFILING_DEBUG=y to
ensure page_ext initialization prior to any page allocation.  This will
have all the negative effects associated with early_page_ext, such as
possible longer boot time, therefore we enable it only when debugging with
CONFIG_MEM_ALLOC_PROFILING_DEBUG enabled and not universally for
CONFIG_MEM_ALLOC_PROFILING.

Link: https://lkml.kernel.org/r/20240321163705.3067592-22-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Kees Cook <keescook@chromium.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alex Gaynor <alex.gaynor@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andreas Hindborg <a.hindborg@samsung.com>
Cc: Benno Lossin <benno.lossin@proton.me>
Cc: "Björn Roy Baron" <bjorn3_gh@protonmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Gary Guo <gary@garyguo.net>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_ext.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/page_ext.c~mm-page_ext-enable-early_page_ext-when-config_mem_alloc_profiling_debug=y
+++ a/mm/page_ext.c
@@ -95,7 +95,16 @@ unsigned long page_ext_size;
 
 static unsigned long total_usage;
 
+#ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
+/*
+ * To ensure correct allocation tagging for pages, page_ext should be available
+ * before the first page allocation. Otherwise early task stacks will be
+ * allocated before page_ext initialization and missing tags will be flagged.
+ */
+bool early_page_ext __meminitdata = true;
+#else
 bool early_page_ext __meminitdata;
+#endif
 static int __init setup_early_page_ext(char *str)
 {
 	early_page_ext = true;
_

Patches currently in -mm which might be from surenb@google.com are

userfaultfd-remove-write_once-when-setting-folio-index-during-uffdio_move.patch


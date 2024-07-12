Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB42127E0F
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824917; cv=none; b=n9jD5jNXxROwR2EXF8EOoakMYOxE5dw2MQFSz4tScq/7NLjaM4K69QRKbkMXGbfLmLN45IdiPZ9Cz9n9B56opArhWkLYONi17kjuX2l/LInI8UPYvssR2+s3GCaiF9ebLPKHa3xWKHC72O4p+kUHhZm2WpX0SayHlV4QLTBABlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824917; c=relaxed/simple;
	bh=ph3nxf57+eEj27Vq1+Q3Q1oM3GgD298Heu+x7ajcrgk=;
	h=Date:To:From:Subject:Message-Id; b=haCJ3vq3m/gRd3MXfAgKJdtS9rYABjeCFFvVgjvDARjpAsgr0r9nV6NwvuHDj7RcPXmilWoPZAwhAdmti1oZW0p6tPEK7VtaFnpTVoTzecPbqVW8CoRs5MA5Kz9jzKxQJzQwo1lhZIstce5TJB3yFnQLSmIoOlm0OgjeNvoKXNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jc+IQTa4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jc+IQTa4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E789AC32782;
	Fri, 12 Jul 2024 22:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824917;
	bh=ph3nxf57+eEj27Vq1+Q3Q1oM3GgD298Heu+x7ajcrgk=;
	h=Date:To:From:Subject:From;
	b=jc+IQTa4xtwIHxuOuAlxZrmnW8X6f1f8f9Jp3nLofFlY1X7xRtliTrB7Wt0ys7nLT
	 MYqWUA/EAP0ScyM69H6VuCpAM27bzve3+YlYpwR8ClYTrhM+B749o3ISPVdKC6doJL
	 nUoSXBCX4eWlGEgcurk+c3Py14wAJSHvzuwzWIUI=
Date: Fri, 12 Jul 2024 15:55:16 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,souravpanda@google.com,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,keescook@chromium.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-add-missing-newline-character-in-the-warning-message.patch removed from -mm tree
Message-Id: <20240712225516.E789AC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: add missing newline character in the warning message
has been removed from the -mm tree.  Its filename was
     lib-add-missing-newline-character-in-the-warning-message.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: lib: add missing newline character in the warning message
Date: Thu, 11 Jul 2024 15:04:55 -0700

Link: https://lkml.kernel.org/r/20240711220457.1751071-1-surenb@google.com
Fixes: 22d407b164ff ("lib: add allocation tagging support for memory allocation profiling")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/alloc_tag.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/alloc_tag.h~lib-add-missing-newline-character-in-the-warning-message
+++ a/include/linux/alloc_tag.h
@@ -122,7 +122,7 @@ static inline void alloc_tag_add_check(u
 		  "alloc_tag was not cleared (got tag for %s:%u)\n",
 		  ref->ct->filename, ref->ct->lineno);
 
-	WARN_ONCE(!tag, "current->alloc_tag not set");
+	WARN_ONCE(!tag, "current->alloc_tag not set\n");
 }
 
 static inline void alloc_tag_sub_check(union codetag_ref *ref)
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-export-memory-allocation-profiling-symbols-used-by-modules.patch


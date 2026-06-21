Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23594370AD3
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067212; cv=none; b=pzfnnyqk6mdPJD9Hcyr+tc9nXET4Uo4p+CAem9h0cjPPlAGAu3j3B/5hI8BycZvUqK2Vlywc1Y8cDaekhSsmz5yMh6JvfLRGx5k3oxA3N2EPrGzc9eEp1/5+SuICfVu1VbZBhE8IV3mpCxlwKDSUXLyYdsfdqJfPYy9FDsCUQqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067212; c=relaxed/simple;
	bh=ekVp/WE0dxElDDfgawGaqfDAW5HqjCjVUPMDjd3pGKw=;
	h=Date:To:From:Subject:Message-Id; b=MLekeb1g3WQffFr4g53ZuhSS5d+MYQVKfqVE95EmNNYjLNOAMl5cOdsN9sV47YItABUhsUPYZKlCLOH6ozr7WZ9DQ7BXVolDuOl+BB+EPxekrvGdltqCg77Eu5olvdG5kgk1AfPYUrBE3x8zNdAa6yx0mCMpH5Vqm3laez5+ifw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f6iUXMBK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f6iUXMBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED42B1F00A3A;
	Sun, 21 Jun 2026 18:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067211;
	bh=wvDXWRTAxgUj3CkLKFlt5pNaK+p87MtyJc3eMYPJ5JE=;
	h=Date:To:From:Subject;
	b=f6iUXMBKbCzacTTEcmU4B8HEGYDccpJkSGsWaygN3dvD5Fb/go75Tj8VCPspO+LiE
	 wx6yi6zJkKVv+t1LPJWqcp2WU3eb9ysQmgTvQXw+3Wv0zHpfFJIPxyr2Zx2gZgJ2jU
	 gJStkDHJde3gmwGPdYi8QaOeD0WC62SYaRbe2Nws=
Date: Sun, 21 Jun 2026 11:40:10 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,ljs@kernel.org,kent.overstreet@linux.dev,david@kernel.org,hao.ge@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-add-hao-ge-as-reviewer-for-codetag-and-alloc_tag.patch removed from -mm tree
Message-Id: <20260621184010.ED42B1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add Hao Ge as reviewer for codetag and alloc_tag
has been removed from the -mm tree.  Its filename was
     maintainers-add-hao-ge-as-reviewer-for-codetag-and-alloc_tag.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hao Ge <hao.ge@linux.dev>
Subject: MAINTAINERS: add Hao Ge as reviewer for codetag and alloc_tag
Date: Tue, 26 May 2026 17:26:41 +0800

I've been contributing to the codetag and alloc_tag subsystems since 2024,
Memory allocation profiling is indeed a great tool and I'd like to stay
involved as a reviewer to keep up with ongoing development and not miss
any of the details.  I'm happy to help review patches and contribute to
the ongoing development of this subsystem.

Link: https://lore.kernel.org/20260526092641.299399-1-hao.ge@linux.dev
Signed-off-by: Hao Ge <hao.ge@linux.dev>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-add-hao-ge-as-reviewer-for-codetag-and-alloc_tag
+++ a/MAINTAINERS
@@ -6349,6 +6349,7 @@ F:	Documentation/process/code-of-conduct
 CODE TAGGING
 M:	Suren Baghdasaryan <surenb@google.com>
 M:	Kent Overstreet <kent.overstreet@linux.dev>
+R:	Hao Ge <hao.ge@linux.dev>
 S:	Maintained
 F:	include/asm-generic/codetag.lds.h
 F:	include/linux/codetag.h
@@ -16706,6 +16707,7 @@ F:	tools/testing/memblock/
 MEMORY ALLOCATION PROFILING
 M:	Suren Baghdasaryan <surenb@google.com>
 M:	Kent Overstreet <kent.overstreet@linux.dev>
+R:	Hao Ge <hao.ge@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/mm/allocation-profiling.rst
_

Patches currently in -mm which might be from hao.ge@linux.dev are



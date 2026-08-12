Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422122C027C
	for <mm-commits@vger.kernel.org>; Wed, 12 Aug 2026 03:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786505119; cv=none; b=HgWxT72SDRXLsjv6/kAStQXvrOKUgp3RUsjeb2TFR3xqrC+itOWgKCRAQKcbdEFN6giHO6tKIPZV1POjPkjqAQjVNRZFaEWGgeqkt2Q0C5NFeIYAFhWvM2+502Ia8pNX+ISXyb3jylE+1mPrqJFnDj7bDYeWLzOeGvmsINz5PRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786505119; c=relaxed/simple;
	bh=UVj8NutcORjwvZHGwOnJolx2V8Lou+B0HK+SBzJyQus=;
	h=Date:To:From:Subject:Message-Id; b=RobGGOwPqy8qWyaw6bz3Sc1OW+sW1DGcVJt/iNqAbYQ9ZLhU2J4LT57hGaTM+hsGuhvO60SZ/zwyNR5vn1wZdRPfEYX8ciLU4fdP9zWdDZCNQz6m4aEWWWcGTHO1rZ3/cNC4omL7n6spm0yOkbwJCQ9WNQ4l6NaU9HyPLrzbcSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T1J4hPd6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T1J4hPd6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CFDE1F000E9;
	Wed, 12 Aug 2026 03:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786505118;
	bh=ioA1i7Yk4XZxTznJE+8GLmAYXotSlvnGtQif1WgvTv8=;
	h=Date:To:From:Subject;
	b=T1J4hPd6FpUqS7uLGBTkHv5tz1JOhDw5LW8gj4fgv3bgtp5NR3s+cklV48RFSZsCv
	 Pt5+1lpG2KtDvCX5n74UrpI7wxz+UZr/jRg2iJFl+jxiXIRJofzKIUK5JLJiXL4o53
	 T5m6BR5473hfK/jt853Lv0olCoSS/rB2HuAm+ISQ=
Date: Tue, 11 Aug 2026 20:25:17 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,shuah@kernel.org,rppt@kernel.org,pratmal@google.com,peterx@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jhubbard@nvidia.com,jgg@ziepe.ca,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-mm-use-pattern-matching-in-gitignore-fix.patch removed from -mm tree
Message-Id: <20260812032518.0CFDE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests-mm-use-pattern-matching-in-gitignore-fix
has been removed from the -mm tree.  Its filename was
     selftests-mm-use-pattern-matching-in-gitignore-fix.patch

This patch was dropped because it was folded into selftests-mm-use-pattern-matching-in-gitignore.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-mm-use-pattern-matching-in-gitignore-fix
Date: Thu Aug  6 04:08:41 PM PDT 2026

fix botched merge resolution

Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Pratyush Mallick <pratmal@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: SJ Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/.gitignore |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/tools/testing/selftests/mm/.gitignore~selftests-mm-use-pattern-matching-in-gitignore-fix
+++ a/tools/testing/selftests/mm/.gitignore
@@ -2,3 +2,9 @@
 *
 !/**/
 !*.c
+!*.h
+!*.sh
+!.gitignore
+!Makefile
+!config
+!settings
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

selftests-mm-use-pattern-matching-in-gitignore.patch
alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch
selftests-mm-fix-soft-dirty-kselftest-supported-check-fix.patch
mm-hmmc-hmm_do_fault-suppress-sparse-warning.patch
mm-hmmc-hmm_do_fault-suppress-sparse-warning-fix.patch
lib-kconfigdebug-make-debug_force_weak_per_cpu-depend-on-s390alpha.patch
selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45736370AD7
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067219; cv=none; b=YuU27ZJ0/YSGTBRhp/h5soLLKMB5TIiadNrWQ/fuInL+VTiiSnVo++atDjYcVBc4MZ5u9IQaRP3VeZ9u0agO/+ZjPbt6RSVaMsRx2OO0mm7LDnDcv+1W0igZEw3dNPv+reNT16Ag6c/hPRwnnBTq9dRYZlHdJ2EfUBDHQrH4KJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067219; c=relaxed/simple;
	bh=pAWbM5tMX94shVNAHenQYyzcGhep4iKV9OsADLpKXl4=;
	h=Date:To:From:Subject:Message-Id; b=pDfE79+a1QlzLQU48C3toOI/ZT83VkkLT+OkyrXSTJiYD7o3LtkeN3ty6ZJUkuKZf5cKA9lyyxDXHAyWfhuCLPwCYSvAYsMtA2ZSHDKTQ6GAwRP4ROa6mTu6xnyJsYDRrl38iB1j3L0BCsob0ZVv7sF9eWS5TiEwL7kqdpn0TQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MIL1ZnKJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MIL1ZnKJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1914D1F00A3A;
	Sun, 21 Jun 2026 18:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067218;
	bh=SjyldUNsrpV7ZkeeIRj59WFDhe5pQzWL9unhBafYLY4=;
	h=Date:To:From:Subject;
	b=MIL1ZnKJo5sBQkP/ro8o6clDB+bbFGSFpNyRM7ac66Igm+5ptMlu8xdABqv2yZbqW
	 MF3A0pAq+jxwXiuXEoOEWsjiwJwBRerc8ZwsUPxLA9u/YKwnpAwqkLN5r3eJSWEqqp
	 Oy27RpRDjfJkkTiT8H1Jz1NEApDkDaQivTJOttg8=
Date: Sun, 21 Jun 2026 11:40:17 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,sam.moelius@trailofbits.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_frag-reject-invalid-cpus-in-page_frag_test.patch removed from -mm tree
Message-Id: <20260621184018.1914D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_frag: reject invalid CPUs in page_frag_test
has been removed from the -mm tree.  Its filename was
     mm-page_frag-reject-invalid-cpus-in-page_frag_test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Samuel Moelius <sam.moelius@trailofbits.com>
Subject: mm/page_frag: reject invalid CPUs in page_frag_test
Date: Fri, 5 Jun 2026 18:41:52 +0000

The page_frag selftest module accepts test_push_cpu and test_pop_cpu as
signed module parameters, then validates them by passing them directly to
cpu_active().

That validation is itself unsafe for negative or out-of-range CPU numbers.
For example, test_push_cpu=-1 is converted to a very large unsigned CPU
number before cpu_active() reaches cpumask_test_cpu(), which trips the
cpumask range check with CONFIG_DEBUG_PER_CPU_MAPS enabled.

Reject CPU values outside [0, nr_cpu_ids) before asking whether the CPU is
active.

Assisted-by: Codex:gpt-5.5-cyber-preview
Link: https://lore.kernel.org/20260605184157.2490353-1-sam.moelius@trailofbits.com
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/page_frag/page_frag_test.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/mm/page_frag/page_frag_test.c~mm-page_frag-reject-invalid-cpus-in-page_frag_test
+++ a/tools/testing/selftests/mm/page_frag/page_frag_test.c
@@ -131,6 +131,8 @@ static int __init page_frag_test_init(vo
 	init_completion(&wait);
 
 	if (test_alloc_len > PAGE_SIZE || test_alloc_len <= 0 ||
+	    test_push_cpu < 0 || test_push_cpu >= nr_cpu_ids ||
+	    test_pop_cpu < 0 || test_pop_cpu >= nr_cpu_ids ||
 	    !cpu_active(test_push_cpu) || !cpu_active(test_pop_cpu))
 		return -EINVAL;
 
_

Patches currently in -mm which might be from sam.moelius@trailofbits.com are



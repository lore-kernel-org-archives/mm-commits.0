Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8A118DB01
	for <mm-commits@vger.kernel.org>; Sat,  6 Jun 2026 01:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780708145; cv=none; b=djKQFkPYbo+RD5+XOA98cRezGjDeGjVKW+GyarX+Qwwme4SQ+ooKWL7+S/TnL7G6dAH2rteZtDh1Jx1ufJhH0kPlUN09RygpJuW8UbEra+Nigiay6+Ln694y0cENdq65sVrXdO+bOGg69anhpdEASf50zSZq/Yn/3Lcqeqs4qzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780708145; c=relaxed/simple;
	bh=tDYwStNa5jgfSh7Ssj+NVmHisZ6zYPx2yGlM2dmuVlU=;
	h=Date:To:From:Subject:Message-Id; b=fXd1qau+UsoiMMOqB3GoIVWpXnqETMkms/EPVAIMOB/Bv/NVdqJS8yf60SZpvWHgBkENpqM1Ey0R3rJu0ec4tDCtpr7zDS6z9BmvoSlHuM74wrn2bxEeUt5zuVJ6k9Ft7tcBoEjV+G8uZMCxWzhazYFtHSoHvDIgBXkaRSYt1mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FYJCENcE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FYJCENcE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38B91F00893;
	Sat,  6 Jun 2026 01:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780708143;
	bh=nDIRdv10vjjrbqMLnaDhfyhCoqCCcWSAEFCuuRR3zc4=;
	h=Date:To:From:Subject;
	b=FYJCENcEK2RwHxtxO/cUEe4+3VKVTZ+gOZqnxTtwLPJyEhpDVln1nDK6OSMYeFH9Z
	 Tcf5rSSm6gSsAjiaIKlDiptWws5YYjq6FIl75avUnNPqk4InbnBxoF77jbl/htfckS
	 ZFm2D6SsWHssJvqmO9xMTdw0Ker/zteNvQNtZyD4=
Date: Fri, 05 Jun 2026 18:09:03 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,sam.moelius@trailofbits.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_frag-reject-invalid-cpus-in-page_frag_test.patch added to mm-new branch
Message-Id: <20260606010903.D38B91F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_frag: reject invalid CPUs in page_frag_test
has been added to the -mm mm-new branch.  Its filename is
     mm-page_frag-reject-invalid-cpus-in-page_frag_test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_frag-reject-invalid-cpus-in-page_frag_test.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-page_frag-reject-invalid-cpus-in-page_frag_test.patch


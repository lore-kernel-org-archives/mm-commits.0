Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D6134751F
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622912; cv=none; b=Hj8RpftgVKQy9PwRGl0qBAdaEpecB3ovyPhD0xBo82KfvUtk6JMX46ZWubuyYybTbaWzGIwuOzZwZey6jFEgBTBnJAaeYWX7VxmcFKlI1jGMIBhyEC6PE5WCnjwrEyul9IKs95uUMoYwxOi/XXJEmPfNmbn/Vbm9+ea4q0ebptE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622912; c=relaxed/simple;
	bh=COFsFnhKMywarDE0T5tKJIakCm/XRwEiV41Jg5Ut2jg=;
	h=Date:To:From:Subject:Message-Id; b=BvPVQSK3D3Ah1VPlfIgPWwT8k7h8nBTyVGwDQxr+gVaQo8zfvGGQNxIJkFLxrqpArzuySm1ktfaISdcte2NnYt+jOh88Fk3bzZh8TAUr81+Q8r1+EAr2vBnC6hvzhNvjKiKe3Irb+J7+aqdUFdjnTrXe0e7KcrGNMRZngAy07YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MxIgLIrb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MxIgLIrb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F411F00A3A;
	Tue, 25 Aug 2026 01:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622910;
	bh=0aTanrnQhffLevNTnRC19A1xkg63Vv+4BRvhxUBvQwc=;
	h=Date:To:From:Subject;
	b=MxIgLIrbpkZm0XE37BIgXID6JxN3IMnQ+dpgI34bKmeQuk9367SL2yFlXSyKCPE7R
	 LlrggwKhLsJXtdMjsup1j2kqrr1fbiB66tdw6+Zc2g2K+OyOTtKj8z36GmpFuuveDY
	 bKFR1sAB1Rip0S8dCjwCSplH0Dv4PVsMUnmofOMw=
Date: Mon, 24 Aug 2026 18:55:10 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,catalin.marinas@arm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-kmemleak-drop-stale-min_unref_scans-default-from-comments.patch removed from -mm tree
Message-Id: <20260825015510.A5F411F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: kmemleak: drop stale min_unref_scans default from comments
has been removed from the -mm tree.  Its filename was
     selftests-mm-kmemleak-drop-stale-min_unref_scans-default-from-comments.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: selftests/mm: kmemleak: drop stale min_unref_scans default from comments
Date: Fri, 31 Jul 2026 03:13:06 -0700

The test writes min_unref_scans explicitly for every case, so its comments
describing 1 as the default are both unnecessary and, since the default is
now conditional, wrong.  Refer to the threshold values directly.

No functional change.

Link: https://lore.kernel.org/20260731-kmemleak_hardened-v2-3-7b9689ac77cb@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/ksft_kmemleak_confirm.sh |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/mm/ksft_kmemleak_confirm.sh~selftests-mm-kmemleak-drop-stale-min_unref_scans-default-from-comments
+++ a/tools/testing/selftests/mm/ksft_kmemleak_confirm.sh
@@ -5,7 +5,7 @@
 # (the min_unref_scans module parameter).
 #
 # kmemleak only reports an object once it has stayed unreferenced for
-# min_unref_scans consecutive scans. The default of 1 reports on the first
+# min_unref_scans consecutive scans. A threshold of 1 reports on the first
 # scan (historical behaviour); higher values filter transient false
 # positives where a live object's only reference is briefly invisible to a
 # single scan (e.g. an RCU tree update in flight while the scan runs). The
@@ -16,8 +16,7 @@
 #   - a freshly allocated object is greyed on its first scan (its checksum
 #     settles then), so nothing can be reported before that priming scan;
 #     each case below primes once first,
-#   - with the default threshold (min_unref_scans=1) one scan after priming
-#     reports the orphans,
+#   - at min_unref_scans=1 one scan after priming reports the orphans,
 #   - raising the threshold to 2 needs two scans after priming: one is not
 #     enough, the second reports,
 #   - the parameter reads back what was written.
@@ -105,9 +104,8 @@ echo 3 > "$PARAM"
 # scan. Every case below runs this priming scan before counting.
 prime() { scan; }
 
-# 1) min_unref_scans=1 (default): one scan after priming reports the
-#    orphans. This also establishes that the helper produces detectable
-#    orphans here.
+# 1) min_unref_scans=1: one scan after priming reports the orphans. This
+#    also establishes that the helper produces detectable orphans here.
 echo 1 > "$PARAM"
 gen_orphans
 prime
_

Patches currently in -mm which might be from leitao@debian.org are



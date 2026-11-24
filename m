Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795540596;
	b=0WMr/YKon4SUHWqq2e610sYYQUvzwvkeAc3lla8Dv1dRPiiF/px/q6bIUGAtVO/1voi/
	 UsTbLV+yKzQr9qVsIZOFmWZKUkIaocsgE7JH4MFKIgtjsqxPIO7sJDw2Yh4ryKGw8+1Hq
	 /Cl6phqrsPRV+e0c55up2EcUA+vldJsJWuxFwuV4GhW5JCkC0Z3fst1WQTNOwW9lvTkFH
	 UOZERvNwFw5fiLYZlkfd+fWhB5ENPz9FVRm3qp7r+NjsjzKWPzSFP/4q5q284x9zGo6WE
	 H1sJ5tFbn4SKU12FBXRfzkEfpM4qzPm4mMVqYttKtdCLqBbX/Tmk5K2KPqU2Vg4Ylfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795540596;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=wXdCOBh0nj1n2ailOStvDOfhZGYzyFg6DkhtiyknnEc=;
	b=WlYUQrMgCEzKidjZ/EPh/r8A+cAAAz4lMk33jsEzm71jfUgTNGycXoBgJUxKdjHl0wpx
	 +2EOR+Ub6hn0M3b0kgFB1uOGTU5B0tjrrVkLXXS1tT7OmWxx8ZlaC01JX6HjO53s3a2rO
	 b7zROmBwC4gWXX2yc7yakXWB/PYlvO3fhHhl8qNVBs0Y8o+Ibjx3f/spbhxmyqhhz25pA
	 qTd0ORnT1ORxU0fieJ9ldCHExqZZUnQISK4bcX9UlFXDknfmZwgrP2Rc4f3LLe+3Dmzcu
	 z2K0TEmfVg1ICX00BOnn/fBiEGQ0xn+QlUfwiUXMwHdugoAlWoiatCYglT4dmkTuXpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="TXjU/rBu";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6BF2606A326
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 17:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=TXjU/rBu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D3E1F000C4;
	Tue, 24 Nov 2026 17:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795540596;
	bh=wXdCOBh0nj1n2ailOStvDOfhZGYzyFg6DkhtiyknnEc=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=TXjU/rBuTZbrXg2YwEo9YodbByqVfBok4xPHlGFSZe71rdmLApIO2PXBtjlQSP0k3
	 PCzYD/D9sBpK5Yy4tgvYlohLL2nbklLYqXTnzAlGZ5le1hsdwCKPjg6akU+49PHWUO
	 y8VOGnNaCP5/yYED2QFdMgYW5R+te5hcN0iT25fw=
Date: Tue, 24 Nov 2026 09:16:35 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,shuah@kernel.org,
	saileshnandanavanam@gmail.com,lienze@kylinos.cn,jm5905938@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124153021.90142-4-sj@kernel.org>
References: <20261124153021.90142-4-sj@kernel.org>
Subject: + selftests-damon-damos_quota-skip-the-last-sample-when-counting-exceeds.patch added to mm-new branch
Message-Id: <20261124171636.05D3E1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/damon/damos_quota: skip the last sample when counting exceeds
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-damos_quota-skip-the-last-sample-when-counting-exceeds.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-damos_quota-skip-the-last-sample-when-counting-exceeds.patch

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
From: Aveline Noir <jm5905938@gmail.com>
Subject: selftests/damon/damos_quota: skip the last sample when counting exceeds
Date: Tue, 24 Nov 2026 07:30:19 -0800

damos_quota.py expects qt_exceeds to be increased for every sample whose
tried_bytes equals the quota.  The kernel increases it only when the next
quota window starts, so the last full window may still be pending when
the workload exits.  The test then fails with an expected count one
higher than the actual one, e.g., 15 < 16.

Do not count the last sample.  Also drop the sorting of the samples, so
that the last one is the latest.

Link: https://patch.msgid.link/20261124153021.90142-4-sj@kernel.org
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
Cc: Enze Li <lienze@kylinos.cn>

 tools/testing/selftests/damon/damos_quota.py |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/damon/damos_quota.py~selftests-damon-damos_quota-skip-the-last-sample-when-counting-exceeds
+++ a/tools/testing/selftests/damon/damos_quota.py
@@ -53,15 +53,16 @@ def main():
         wss_collected.append(scheme.tried_bytes)
         nr_quota_exceeds = scheme.stats.qt_exceeds
 
-    wss_collected.sort()
     nr_expected_quota_exceeds = 0
-    for wss in wss_collected:
+    for idx, wss in enumerate(wss_collected):
         if wss > sz_quota:
             print('quota is not kept: %s > %s' % (wss, sz_quota))
             print('collected samples are as below')
             print('\n'.join(['%d' % wss for wss in wss_collected]))
             exit(1)
-        if wss == sz_quota:
+        # qt_exceeds is updated when the next quota window starts, so skip
+        # the last sample, whose window may still be pending.
+        if wss == sz_quota and idx < len(wss_collected) - 1:
             nr_expected_quota_exceeds += 1
 
     if nr_quota_exceeds < nr_expected_quota_exceeds:
_

Patches currently in -mm which might be from jm5905938@gmail.com are

mm-damon-ops-common-align-mmu-notifier-range-when-clearing-pmd-young-bit.patch
mm-damon-stat-avoid-32-bit-overflow-in-idle-percentiles.patch
mm-damon-pvaddr-skip-folios-already-on-the-migration-target-node.patch
docs-admin-guide-mm-damon-start-fix-grammar.patch
docs-admin-guide-mm-damon-stat-fix-pronoun-agreement.patch
docs-admin-guide-mm-damon-usage-fix-grammar.patch
docs-admin-guide-mm-damon-lru_sort-fix-remaining-grammar.patch
docs-mm-damon-design-fix-grammar-and-typos.patch
docs-mm-damon-api-fix-verb-form.patch
docs-mm-damon-maintainer-profile-fix-subject-verb-agreement.patch
docs-mm-damon-monitoring_intervals_tuning_example-fix-grammar-and-typos.patch
mm-damon-paddr-add-kunit-tests-for-addr_unit-conversion.patch
mm-damon-paddr-add-kunit-tests-for-addr_unit-conversion-fix.patch
mm-hmm-account-for-subpage-offsets-in-device-private-pmds.patch
mm-damon-paddr-skip-non-lru-folios-as-a-whole-in-pageout.patch
mm-damon-core-skip-apply_probes-when-no-probes-are-installed.patch
selftests-damon-damos_quota-skip-the-last-sample-when-counting-exceeds.patch


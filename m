Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0323C4547
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439162; cv=none; b=Do04DV1vJkzVpl81nn9PQU+LlwdXSU1N/YV68/AYr1tsY4h/VkpL4V8pZ0IybEQSrptJM5MRQp9tlo1HDl41+CUFCEI3KZh78frie08MObUqSMADn2x04a05l+jjzeeriibUlGqA9TbNAeV7XNST4zPNmVN/1KTt/9C84h9DNRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439162; c=relaxed/simple;
	bh=4IBP8QApwMhk2ZEnAD2gGxX0whHf2cP4brpqRDfhm5A=;
	h=Date:To:From:Subject:Message-Id; b=CtBcKu0GZuFMpW4PJ+Nb8xrKk2Zv40Z8nFbGACcrGdH8+SFFCh2ctPjI1PqCRaWyoLB+uoPDEGYb6zC90THB3RnpgU8AFCS0lqycqjqEpaIEYxGgmjxGWO3xF8SJPS0xf2mTHdRUjP9vPeGlK7jsxRfT16FNC/9V1huNTx8TQ7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mVUuGnA/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mVUuGnA/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221CD1F00893;
	Tue,  2 Jun 2026 22:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439161;
	bh=+vmSZiqgcKrDMpBKTT2IfQPTBD6VowiuLYwEY3yGmEI=;
	h=Date:To:From:Subject;
	b=mVUuGnA//5aQPvhTy6eej/Np+K+wgXCABJpry9izP2e4+NP8g/Sh9BPSo907PYiOm
	 epv571+kVgezlAeXvsaFUxZd+U67NOKGBYtOfC4zaZvzJg3tlclvuMr7FXTSykBe6P
	 Lai8R5KnEqYW1VEHDAedvwH3juyQgntRjWf1hOlg=
Date: Tue, 02 Jun 2026 15:26:00 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-sysfssh-test-pause-file-existence.patch removed from -mm tree
Message-Id: <20260602222601.221CD1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/sysfs.sh: test pause file existence
has been removed from the -mm tree.  Its filename was
     selftests-damon-sysfssh-test-pause-file-existence.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/sysfs.sh: test pause file existence
Date: Fri, 22 May 2026 08:40:25 -0700

sysfs.sh DAMON selftest is not testing the existence of the 'pause' sysfs
file.  Add the test.

Link: https://lore.kernel.org/20260522154026.80546-15-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.sh |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/damon/sysfs.sh~selftests-damon-sysfssh-test-pause-file-existence
+++ a/tools/testing/selftests/damon/sysfs.sh
@@ -366,6 +366,7 @@ test_context()
 	ensure_file "$context_dir/avail_operations" "exit" 400
 	ensure_file "$context_dir/operations" "exist" 600
 	ensure_file "$context_dir/addr_unit" "exist" 600
+	ensure_file "$context_dir/pause" "exist" 600
 	test_monitoring_attrs "$context_dir/monitoring_attrs"
 	test_targets "$context_dir/targets"
 	test_schemes "$context_dir/schemes"
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
maintainers-add-testing-abi-documents-for-mm.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619D8233522
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836034; cv=none; b=HK+uyL5aO2WHt53dSvGuqaUNISh4J32A0s36/LtqQbYGklt59FUQCLNa11hRfLlfVCXsP1JM4e6laq3nwStu7Lk2R0TOzPm5cCBvv5m5uj0E4cXuAO9kM8ohIl4XnUdTJaOevciCVVEAg8ag+vVQTYiZKs1Ho0HGL3V/NIbTDMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836034; c=relaxed/simple;
	bh=oCjo1Q88LTos1jSrfSslKK05pk70RHlup0bnos4fDH8=;
	h=Date:To:From:Subject:Message-Id; b=DsXYvG6HgIV8Q8Po1i0K1YieqRr/Q7y1V6C8RKJ7nryrSI2ywqkfp8DxkS2mr0G/IPAi3cnAWxSu9FOom0Dx733jR/4tihL0sLXbKl88ohP26TDLwinm4xXYCSfiMSorLVhOdG4hVQurLOW8iqMndZueD+9fnofaDCDBo9sBK2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PVXfjCob; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PVXfjCob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3332FC4CEE7;
	Tue, 14 Jan 2025 06:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836034;
	bh=oCjo1Q88LTos1jSrfSslKK05pk70RHlup0bnos4fDH8=;
	h=Date:To:From:Subject:From;
	b=PVXfjCobXrbGkdCz556v5nLDdJXbPGFGEFDD61gO85YMMj2p+1KCQ/B3j/Kvo5zK6
	 yNe3gV1YlWjk6wGtWLYd1xmoRNbGJvjDCQ+JTpAs3LxBDmgHk/ljDOsCFrsyvWuvno
	 UQTCNoSmHC5EQk84jvi3gzZQteyOH1dua/G5n4a8=
Date: Mon, 13 Jan 2025 22:27:13 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,sj@kernel.org,sfr@canb.auug.org.au,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-damon-tests-vaddr-kunith-reduce-stack-consumption-fix.patch removed from -mm tree
Message-Id: <20250114062714.3332FC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-damon-tests-vaddr-kunith-reduce-stack-consumption-fix
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-vaddr-kunith-reduce-stack-consumption-fix.patch

This patch was dropped because it was folded into mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-damon-tests-vaddr-kunith-reduce-stack-consumption-fix
Date: Mon Dec  9 09:22:25 PM PST 2024

fix build

Cc: SeongJae Park <sj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/vaddr-kunit.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/tests/vaddr-kunit.h~mm-damon-tests-vaddr-kunith-reduce-stack-consumption-fix
+++ a/mm/damon/tests/vaddr-kunit.h
@@ -68,7 +68,7 @@ static void damon_test_three_regions_in_
 	static struct mm_struct mm;
 	struct damon_addr_range regions[3] = {0};
 	/* 10-20-25, 200-210-220, 300-305, 307-330 */
-	static const struct vm_area_struct vmas[] = {
+	static struct vm_area_struct vmas[] = {
 		(struct vm_area_struct) {.vm_start = 10, .vm_end = 20},
 		(struct vm_area_struct) {.vm_start = 20, .vm_end = 25},
 		(struct vm_area_struct) {.vm_start = 200, .vm_end = 210},
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch
mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault-fix.patch
mm-huge_memoryc-rename-shadowed-local.patch
mm-shmem-skip-swapcache-for-swapin-of-synchronous-swap-device-fix.patch
ksm-add-ksm-involvement-information-for-each-process-fix.patch
documentation-filesystems-procrst-fix-possessive-form-of-process.patch


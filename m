Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62FE3FBA7
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282092; cv=none; b=o7b41mMI9CfQaEnUVeMDkm4bFER5ovofXYtYmJVqoybcxi22OjZwdvksOQEp8UIc9C0d2nmGW1jYIZs/C1ZWkiFQz7Puun9xIlU8UgIGGXSrrHCD1JyfXK7FkqDLPgrLU9eAYE6G+s5jgCddrQ8ObrHLYTs27bob2WLifhXToAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282092; c=relaxed/simple;
	bh=Nk/sk9EwAaC07sNJXo1HapwfV2/rAZpz4nEF4wZ+cnY=;
	h=Date:To:From:Subject:Message-Id; b=LM5B+PAPd11ojVYB+Tooo71nZgiJLkq1FG8P6Lwt0eNUqwcFZOUONhql1M+8sSnb46WonDXEjIMs2ULPtyQKnXJHxqx6huZPtoPGL/2mT7C6qsc0GHoh2fk19lvkf8tuBCvp6sr6aKNze/KyaQqrj+oSpMgAVHHw5aYyHMPPFIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TbrF9PMN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TbrF9PMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E65C4CEF8;
	Thu, 27 Nov 2025 22:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282091;
	bh=Nk/sk9EwAaC07sNJXo1HapwfV2/rAZpz4nEF4wZ+cnY=;
	h=Date:To:From:Subject:From;
	b=TbrF9PMNADOXYYKsX4Qy1W60allWDGC0pX7Ym0gZS21p+bo3kZ+pDOaZU6+hTBfmq
	 F3DsiXG/tQ+zrvoMKbot8fBkpQcBNexqRRKfg2hHlsq6NPLGIEcSiiFPMw0Me/egHn
	 fvJiNvbHsM3GO2mq3gRvPvDTmf8XlI8ElsJc2cyM=
Date: Thu, 27 Nov 2025 14:21:30 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,changyuanl@google.com,catalin.marinas@arm.com,ran.xiaokai@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kho-fix-boot-failure-due-to-kmemleak-access-to-non-present-pages-v4.patch removed from -mm tree
Message-Id: <20251127222131.43E65C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho-fix-boot-failure-due-to-kmemleak-access-to-non-present-pages-v4
has been removed from the -mm tree.  Its filename was
     kho-fix-boot-failure-due-to-kmemleak-access-to-non-present-pages-v4.patch

This patch was dropped because it was folded into kho-fix-boot-failure-due-to-kmemleak-access-to-non-present-pages.patch

------------------------------------------------------
From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Subject: kho-fix-boot-failure-due-to-kmemleak-access-to-non-present-pages-v4
Date: Thu, 27 Nov 2025 12:27:00 +0000

add comment

Link: https://lkml.kernel.org/r/20251127122700.103927-1-ranxiaokai627@163.com
Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/kernel/liveupdate/kexec_handover.c~kho-fix-boot-failure-due-to-kmemleak-access-to-non-present-pages-v4
+++ a/kernel/liveupdate/kexec_handover.c
@@ -1370,6 +1370,14 @@ static __init int kho_init(void)
 		unsigned long count = kho_scratch[i].size >> PAGE_SHIFT;
 		unsigned long pfn;
 
+		/*
+		 * When debug_pagealloc is enabled, __free_pages() clears the
+		 * corresponding PRESENT bit in the kernel page table.
+		 * Subsequent kmemleak scans of these pages cause the
+		 * non-PRESENT page faults.
+		 * Mark scratch areas with kmemleak_ignore_phys() to exclude
+		 * them from kmemleak scanning.
+		 */
 		kmemleak_ignore_phys(kho_scratch[i].addr);
 		for (pfn = base_pfn; pfn < base_pfn + count;
 		     pfn += pageblock_nr_pages)
_

Patches currently in -mm which might be from ran.xiaokai@zte.com.cn are

kho-fix-boot-failure-due-to-kmemleak-access-to-non-present-pages.patch


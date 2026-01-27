Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F24321F42
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769487915; cv=none; b=uugGFeFquoKoOWbax5eNVEckBb/ieYFVc4r6FAMLXVflA0yseY7JlZhRMiLowlwNtVq6CIT6xJuSf5vx0FMNKaq803bK1QLWgpHnrv4/pSFN6Zd2pPbHmNOwPBdHnBChfxHHlJEYImKiBLLhcFwWXc1RVv7fyFAUHk6V1UGlLJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769487915; c=relaxed/simple;
	bh=fBags55eZ7g/6PPL6Os6xsKT50wbAvIJ7sVk3bk3K8E=;
	h=Date:To:From:Subject:Message-Id; b=DabcrDezkUiHUaWvPw9twyO8W7Le/hYC2S00elOT59akLa2ubdGr/27jlRh2ocnmfE4P+5VZnmZXB48J4CvJyeOeetetP9aAqmqN3P/QaEBaTfQqB+5qerbNZiRLRipAmcaMHPwwRIGgDvysfYzUX0RLU7rhuMpkPKDuhnkoiR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xqnan9XU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xqnan9XU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BAF6C116C6;
	Tue, 27 Jan 2026 04:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769487915;
	bh=fBags55eZ7g/6PPL6Os6xsKT50wbAvIJ7sVk3bk3K8E=;
	h=Date:To:From:Subject:From;
	b=xqnan9XUJ5mLhr/oI/rsT7n0PVoenHJGOpXQyvT0vHN28YtU/g8sBv1+OPXgfPseC
	 +1kZvSts2s/raro66PWQ0fwjJRMeX8dZZsWJXHhleNJXF3MdXotAGzcoD9y4xx+OrW
	 2lGyRu7hx/Gt5xXYy6kDYoG23GZJJTXhQ+feIR1M=
Date: Mon, 26 Jan 2026 20:25:14 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,catalin.marinas@arm.com,bhe@redhat.com,maqianga@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] arm64-kexec-adjust-the-debug-print-of-kexec_image_info.patch removed from -mm tree
Message-Id: <20260127042515.1BAF6C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64: kexec: adjust the debug print of kexec_image_info
has been removed from the -mm tree.  Its filename was
     arm64-kexec-adjust-the-debug-print-of-kexec_image_info.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Qiang Ma <maqianga@uniontech.com>
Subject: arm64: kexec: adjust the debug print of kexec_image_info
Date: Fri, 19 Dec 2025 17:31:34 +0800

In the previous patch, we move start/head of kimage to the generic code,
so, we remove them to avoid duplicate printing.

Link: https://lkml.kernel.org/r/20251219093134.2268620-5-maqianga@uniontech.com
Signed-off-by: Qiang Ma <maqianga@uniontech.com>
Acked-by: Will Deacon <will@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/machine_kexec.c |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/arm64/kernel/machine_kexec.c~arm64-kexec-adjust-the-debug-print-of-kexec_image_info
+++ a/arch/arm64/kernel/machine_kexec.c
@@ -34,8 +34,6 @@ static void _kexec_image_info(const char
 {
 	kexec_dprintk("%s:%d:\n", func, line);
 	kexec_dprintk("  kexec kimage info:\n");
-	kexec_dprintk("    type:        %d\n", kimage->type);
-	kexec_dprintk("    head:        %lx\n", kimage->head);
 	kexec_dprintk("    kern_reloc: %pa\n", &kimage->arch.kern_reloc);
 	kexec_dprintk("    el2_vectors: %pa\n", &kimage->arch.el2_vectors);
 }
_

Patches currently in -mm which might be from maqianga@uniontech.com are



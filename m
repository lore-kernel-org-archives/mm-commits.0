Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574513B4E8B;
	Mon, 31 Aug 2026 22:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788214470; cv=none; b=u6uDXeuxFEy3wXvZI47MQIziGgn0tWn4/L+EAfI4D1bJKK9Nph3SkoXCAwVztF4KVXRC3lSo+/M4Hizl79Jr52BlEdfGh2krG7O+LC42+xhqunwBoOVOVDuJVgk3Y777GbHBWtsog54bgIQekGcl6ll0OKI2nbaiKVmScepvMjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788214470; c=relaxed/simple;
	bh=ImKZeFh455EgNr8UI3V6d+ah/rLEpssyw3G3a4chF18=;
	h=Date:To:From:Subject:Message-Id; b=WIOW9nMxlkVtHQpFhnXrn9kdeVhZdbY6+vo6ucRJd7yolySgsG2CCmuNqnaAtZPVtjRNwnP7JtEvLH+7913VjAdyVreY4evMxkGCqzFwsaJxAbXabLiV1ZIGNIJeSfhl0mSIryndjtwUpmxLXfHKOijNSMP9TO0SaiYFGQ+GMXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ym552jmj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ym552jmj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D401F000E9;
	Mon, 31 Aug 2026 22:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788214469;
	bh=zcI/G2ziQBBZ+LURweL3RjPmM1dQv+6/QA+OB45oQoo=;
	h=Date:To:From:Subject;
	b=Ym552jmjPoeR8EO8RSK+axi+hKcwrtbFSToGK/ooMbkvvdx51UNb4cu/Ay48yX6f0
	 /j+YbooOWf+2xj8DukVvgklHvI05yBzIqoO8ppF6nt4AU3V7LncXyee+hEHJe9oh5O
	 nA35q6E2wfnCdkqm5XCQZvlBkBkXepA9epJen054=
Date: Mon, 31 Aug 2026 15:14:28 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,hch@lst.de,ebiggers@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + raid6-add-missing-vzeroupper-to-avx2-code.patch added to mm-nonmm-unstable branch
Message-Id: <20260831221429.21D401F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: raid6: add missing vzeroupper to AVX2 code
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     raid6-add-missing-vzeroupper-to-avx2-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/raid6-add-missing-vzeroupper-to-avx2-code.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Eric Biggers <ebiggers@kernel.org>
Subject: raid6: add missing vzeroupper to AVX2 code
Date: Mon, 31 Aug 2026 14:23:08 -0700

Since the AVX2 optimized RAID6 code uses YMM registers, execute vzeroupper
before returning from it.  This is needed to avoid degrading the
performance of any later SSE code that may happen to be executed.

Link: https://lore.kernel.org/20260831212308.213855-1-ebiggers@kernel.org
Fixes: 2c935842bdb4 ("lib/raid6: Add AVX2 optimized gen_syndrome functions")
Fixes: 7056741fd9fc ("lib/raid6: Add AVX2 optimized recovery functions")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/raid/raid6/x86/avx2.c       |    6 ++++++
 lib/raid/raid6/x86/recov_avx2.c |    2 ++
 2 files changed, 8 insertions(+)

--- a/lib/raid/raid6/x86/avx2.c~raid6-add-missing-vzeroupper-to-avx2-code
+++ a/lib/raid/raid6/x86/avx2.c
@@ -67,6 +67,7 @@ static void raid6_avx21_gen_syndrome(int
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -115,6 +116,7 @@ static void raid6_avx21_xor_syndrome(int
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -175,6 +177,7 @@ static void raid6_avx22_gen_syndrome(int
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -243,6 +246,7 @@ static void raid6_avx22_xor_syndrome(int
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -334,6 +338,7 @@ static void raid6_avx24_gen_syndrome(int
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -444,6 +449,7 @@ static void raid6_avx24_xor_syndrome(int
 		asm volatile("vmovntdq %%ymm14,%0" : "=m" (q[d+96]));
 	}
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
--- a/lib/raid/raid6/x86/recov_avx2.c~raid6-add-missing-vzeroupper-to-avx2-code
+++ a/lib/raid/raid6/x86/recov_avx2.c
@@ -176,6 +176,7 @@ static void raid6_2data_recov_avx2(int d
 #endif
 	}
 
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -293,6 +294,7 @@ static void raid6_datap_recov_avx2(int d
 #endif
 	}
 
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
_

Patches currently in -mm which might be from ebiggers@kernel.org are

xor-add-missing-vzeroupper-to-avx-code.patch
raid6-add-missing-vzeroupper-to-avx2-code.patch
raid6-add-missing-vzeroupper-to-avx-512-code.patch


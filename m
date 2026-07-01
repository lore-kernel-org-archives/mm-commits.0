Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02198312807;
	Wed,  1 Jul 2026 05:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.169.211.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782884164; cv=none; b=ft2HMEtmI/H7PJjJXyEoIrEvoQSUizGO4NJs54NumK2OR7eg89t9ewkqKz3qkPrWn6/8Or7FBVgrlA5C+UkhCEHoj8lrH53gwLJQ45Pq64BU4WsRfOL0OeT/8uOhn3rRg69gU+I9tgqI6BV4CGUt4E0KIJPrquJc5kobqHRVbHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782884164; c=relaxed/simple;
	bh=UWJt6zCnVimYsGfotTEwCv76zWxDNKQ+J33ruHF8JzA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VaIAgfunSjOAqtljR9RwnwB0UJg6zUMLilKpNc2+OU8lVfzeqoFp4+pKSp4ZWGIjYwrtDjj+0bRKRYew5SHH6E6rEMI08YEFV9ZO6THvVA2mpD5VhdJRdWt28onPU0c6WM07Mzb07l3AMF2kZp8RV4EuUB+7pQbVU4GsU9Nf6Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=WNy9FH8x; arc=none smtp.client-ip=18.169.211.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="WNy9FH8x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1782884116;
	bh=dcEZBfhi/lVczIlH9+rq8JLNvaqYqBvl5cH/6FKnFvU=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=WNy9FH8xeat6joSpspA7CvBSrOk0hkxy4mrs6vYKRCRFXSenH4gbnNHThuRwodifJ
	 bCrDnTRN9Xc2uw0FIcydPbfAz1ToOx7qhoEPCNBc5DAv1MrmXjM/P0Kwcsl88bjicn
	 djBXJLD9OBLWnCpfwcbWbL/2EknKaiO5lHZVflD8=
X-QQ-mid: esmtpgz10t1782884109ta4ae9f15
X-QQ-Originating-IP: bSSLJF3+nkFUZF09WlUg+1CG3vnlErsn/WOeq+KOQuU=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 01 Jul 2026 13:35:08 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 451476006295476125
EX-QQ-RecipientCnt: 8
From: Wentao Guan <guanwentao@uniontech.com>
To: akpm@linux-foundation.org,
	muchun.song@linux.dev
Cc: david@kernel.org,
	guanwentao@uniontech.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	osalvador@suse.de,
	mm-commits@vger.kernel.org
Subject: [PATCH v2] mm/hugetlb: avoid unnecessary TLB flush for empty folio list in vmemmap optimize
Date: Wed,  1 Jul 2026 13:34:23 +0800
Message-Id: <20260701053422.3664813-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260630231657.4A6E41F000E9@smtp.kernel.org>
References: <20260630231657.4A6E41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: MUT6q7+aWLkM0L5f+qiXVJGCuGuAR+Hmg/OWm6/au65U2fdGDNBjPJII
	ZUNsK3p+/Nahe+kcR5mS4nrIGP502oeqKxVo7S9TTHtjvUF/9uuQ/f9VJBsl+qIdY1tNqPd
	a3G/hjiCVBl8TRYWNA52CP4mEQR867BvvmYrkTkK4BW6LmUdqCmZlQY0jNEXeBOj71+S/9P
	ERIRoGVbtq8Maf10R2sfWqnciZ2JoXG2zvYBJ4KreS62d6rLgx/Mgq52jfTECBeAzpQc7+i
	UdJQu6zfWt9F5GekjB5Sq9J+BBATw4CNHByS43/TqMe6NKh3X4dFSOvpVnn2rA2zFBP7qwL
	E5lUCKOp7QVnPZ4yk5ILFvVGB5ohkUXDoIpHsdcjsSwaCL0bmMjtT4lm3674ezo2gqmax35
	XjEy2WNmNElVPcj3ydMVoh4QT3lJ07BCRMUzufYzoNwIVS1KI764Xzl4BBPD9rbFHGvcap2
	pj/mUvzKk14LnK45l6vaCRCuZFajcKqQDv3Ise/eG8oIIc/IBoIpBIiln3WMOrON6AqjLTh
	m+5mn+CSh/tWeHrppeZLVOlofRhbdELMH+Ll00GPFVKkBzm0xcrwB6gugrJBbPMHcKWz3y0
	3/hmIg6xG3+6yIxxQrYRlGLhrL/JnpN+L48OdU6uCS2pYGeg2DEy4BG0dQyUiIXkYcGdRM3
	SMcDNz42uBt3EfpFGWedVdKHd+m+JJcHcNeK81QczEXIX6odRRxEnlY//VJbwAmgUbRmMYf
	tjwN8yOC5mmrt/+1YRHKver5IJbWP3w8H6azv8G946iVSmQ8Dwp+aZJAGXoU3L3SANkTtSK
	AxADHR6Zn3Y3QZWBnQtu7foL+VgYLvuVsiRKTUjis4ZwoT69mzr65guXi62HJ9dzEeO6Ufs
	UQX0ydu1tVHrK64VuAmJpJx0LFq9taXDsdiBEw+whWn6wmyMO9gpbwSdu1DRnMAD1ol9+5f
	p9EVp0qGlFVZsLpaAzPSVzcHi+nRXmI0F0DiMEFF4o9w9hpzQk/BUd4whrAsEHYEacYIi9u
	ZbR96HBUUF0WAT6gA1tIj81IG1LBYtC68ncwuR39C4iSrukqs5whQvLJh4DjMH/02L3OmVq
	tX6lX8BF9IE6p++TvjLitj7fGpAJdfipiyk2RWQRB9/o7awVcS8ANs=
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0

Since 79359d6d24df ("hugetlb: perform vmemmap optimization on a list of pages")
__hugetlb_vmemmap_optimize_folios() unconditionally issues a final
flush_tlb_all() in its out path.  However, a TLB flush must be paired
with an actual page table modification.

When the input folio list is empty, neither PMD splitting nor PTE
remapping takes place, so no page tables are modified and the flush is
pure overhead.  An empty list is reached in common paths such as
gather_bootmem_prealloc_node() on nodes without bootmem gigantic pages,
hugetlb_pages_alloc_boot_node() when no pages were allocated, and
runtime allocation failure paths in set_max_huge_pages().

Add an early return for empty lists.  This restores the basic invariant
that TLB flushes are only issued when page tables have been modified,
and it also makes the NULL hstate passed by gather_bootmem_prealloc_node()
on an empty list harmless.

Assisted-by: kimi-cli:kimi-k2.7 code
Assisted-by: Github Copilot:gpt-5.2 #Reported-by
Link: https://lore.kernel.org/20260630113857.3319612-1-guanwentao@uniontech.com
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
---
changelog v2:
add reviewed-by and link to v1, and convert fixes to first line note.
---
---
 mm/hugetlb_vmemmap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 133b46dfb09f5..d45d5355d1af1 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -624,6 +624,9 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 	LIST_HEAD(vmemmap_pages);
 	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH;
 
+	if (list_empty(folio_list))
+		return;
+
 	nr_to_optimize = 0;
 	list_for_each_entry(folio, folio_list, lru) {
 		int ret;
-- 
2.30.2


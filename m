Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.227.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793423516;
	b=2O4Q9gHFr4/rGfe18vSLTCqUoRYFGeN79Zy/oqrOgMJstigPXLP0gETXndXJEMGO8oU1
	 Ewam3TIyT6Hr+GQvIq/zlx6ESGwRJgYBBIwhN2QlNw12x0UwqMG92LglEvYZf4bGYx1h1
	 sHBTkN+jpg/tWa6EKHxeyC1qrHAdAI9zOQaNirbgiSqKhXoCV5xHyDN5C1Isi/eXh/w3v
	 XHPBIqa6VZUuRwaiDlw7eVwuDoMZ5a5vlk+pfbS5/JRaDvl42DpfvIpihR8QRwCwAjYv4
	 hgl4uos0hrfv6LKpYpnNvBncIww8UXK1ZydvstgzqEUQEzV8tbmadnt7b32yS6JhWlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793423516;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Date:Message-ID:Subject:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=/Im04bCfxuC5NnQopVhNmYOL00IemUlIAdwN2EaZ0DE=;
	b=xeg3oa4efuXM5QmpRb2TUVJk+ECXJIwHVH5sFlnv+RkwYlcVMAWLpOHhA7SiIlVCzmQ6
	 cKaEbEU7EXI0B8pIoPqWPSttYujb77qDBFBKS9H7iK3RGBhR5dpoYiOnvXZv+x23ZERpJ
	 IvmzSYDOQ2N/TtYNADPnc8YxBp37s8o9Y7TQhExHWSNKA5TyIab6+Rt0j4x9pLFiFOPjb
	 xqSewvEWxN77ma+8KeMtabr3WRfy1k6xektJ2h3hZcew7OCGmiPE0aGpMGPtWC3emIcra
	 1akzDTKO+6CvjS+8X5XwTmnEQL4/STCK1H+KVPXQ5eWR9gLqAOltVVqOzdeSAMjMdwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Xc1F0kzz;
	arc=none smtp.remote-ip=74.125.227.130
Received: from mail-pj2-f2.google.com (mail-pj2-f2.google.com [74.125.227.130])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35656606A31C
	for <mm-commits@vger.kernel.org>; Sat, 31 Oct 2026 05:11:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 35656606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Xc1F0kzz
Received: by mail-pj2-f2.google.com with SMTP id d9443c01a7336-2e651c30dcbso6955655ad.0
        for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 22:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793423515; x=1794028315; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:subject
         :message-id:date:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=/Im04bCfxuC5NnQopVhNmYOL00IemUlIAdwN2EaZ0DE=;
        b=Xc1F0kzzbcyam88SqVbnxLiaz2SYQmjy+DK8KpiOkGdRpsz2lOm3WlEx0ve42+1I82
         R52D8ghT6gvFLXR8YDJ1Yfd2KuoSKfvelSOt2pw1dT7v+49v0eavGeqJBBhtYNtKbeSK
         4IRos4XvNhC3PYXmGebTeBSQonSJ85+qtb875K9lMH7h55/7J2AJpteFWQ57gibviqEc
         Fx+nNvQKn+FIHJCQz+oM2zARNQdSifB0V6lpQ80K/fyC5mAKXvr2vqP4EOs176VcmGh5
         5ZFxC+h/acCJAcBmgto/3jq3WfNtWa4vTD6OVJe35tnKPIzUxYPpnMZjVBH2mHIa1Qqx
         kD+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793423515; x=1794028315;
        h=mime-version:content-transfer-encoding:content-type:subject
         :message-id:date:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/Im04bCfxuC5NnQopVhNmYOL00IemUlIAdwN2EaZ0DE=;
        b=bCUcT/kM4uFJSitPYha+k5bdX+Zgxne2+a5Dp+lgwEj0ruqTZmaRjlPt+gStvpVS0u
         yM2YvBld8l+/cz1rwVqrHYvXIzW9SxMIMwZj+U9LSOBaRZl07axYKvdO9rFzVBye4nwZ
         DBzvHrvNhvph4aPKUukqSF1c1CeziiuuGlzuS2H5dsEl9babS+iry1KOuO9wxu9q1MzI
         HOJHa/6AwTZAF2oNG2CVOboj3dGw/dYqq1r2LJYLKTCYo4AU54endf6D6x+9l5FEq+iV
         /A3DI3XvirlsJN0sGrxY6+SEug5uvbJGWHcAMeRM+D3oyw9ARK8gDBBeVO6ED2AwAOom
         I4Vw==
X-Forwarded-Encrypted: i=1; AKwUvBzB27+W8r91AxlC3hzOg4fuG3QgR0gNZqteCco13nfsYifdC9yHYHQhvxAMGyvpGfVnq9CQvEVKVUcR@vger.kernel.org
X-Gm-Message-State: AFq9FYKXEpPtEV5jBfYeRb4qH91yDWsOs5pg96PDjh6YgVqnMkLMnGvT
	ERbbMB+nxcMTxRvuvE/4dL6LIh9LLrmXuOxzhHQVl4OYOGZOPM2yy3N7
X-Gm-Gg: AYBFou1jmyPF26yHU6s9wONG+F2ZyGuYuqGX75cP5KHAv+Dbj4Q9OCFZe1P2lLv/shw
	RO0KPOnRAbdH8B80CfZqPtdDNYtxDwTULwZ6JTuaKRYo5nYOr+GlSFXGjLM7X+RxoY2VIAMH8RV
	RdZvr7ZAtEi9ddgrK9TjKuY2ud33PNqPSPhMlsNktcEA3QylEgQ6oWcF4kE75UqHOK5igsWe76O
	jhDVUT4988BxF89m04eEL1UHohPoIjYyovfCOu1vo96O/pohz0drMCb3SQCOo5vBbtUk3t+cRy2
	q7U/K+3yTQv1mw2hkatB/Z0r8lMr40VuvnyUrfHaYnAcU64Vxnz/O/kWba+gOFURKCNb47zZ0US
	Av4bZLwKTT25NaT2mp4/afNA26K00PBVTP1jOorlvy7V/0fTsE/n9ll03LpBlEKHdwroUxMzhZh
	TdmQO+izmBwBK95qTRnhjo4sGVmOVNdNRUT/ASD6zpiJ58IC3OnT6httH7vCYMoL3hdbHjScupR
	BSGhpUEb38teIBLRpic6vm1WiDMJHMA+OKChmxGM56X6YtuLOmGRsybOABB5LYX21Vz8FBvMhSG
	vP18f8cXv56UaTfwdIb5LSx7NFTlCVO97Tf742+QuJuI5lwW0L7gRZR3tbC4jVcmkyz/5gPZPbA
	y9D08cAP6oBOZUoEUNGt6566WT7m4pCBW
X-Received: by 2002:a17:903:1ae8:b0:2e9:7e90:8a3 with SMTP id d9443c01a7336-2eb364de7c6mr42312675ad.39.1793423515453;
        Fri, 30 Oct 2026 22:11:55 -0700 (PDT)
Received: from [10.208.43.86] (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eb39052bcbsm12905375ad.10.2026.10.30.22.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 22:11:55 -0700 (PDT)
From: Aveline Noir <jm5905938@gmail.com>
To: jgg@nvidia.com, leonro@nvidia.com, akpm@linux-foundation.org
Cc: airlied@gmail.com, apopple@nvidia.com, balbirs@nvidia.com,
 christian.koenig@amd.com, dri-devel@lists.freedesktop.org,
 Francois Dugast <francois.dugast@intel.com>, intel-xe@lists.freedesktop.org,
 jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matthew Brost <matthew.brost@intel.com>, mm-commits@vger.kernel.org,
 mpenttil@redhat.com, Patchwork <patchwork@emeril.freedesktop.org>,
 SeongJae Park <sj@kernel.org>, thomas.hellstrom@linux.intel.com,
 Vlastimil Babka <vbabka@suse.cz>, ziy@nvidia.com
Date: Sat, 31 Oct 2026 15:07:58 +1100
Message-ID: <179342234355.4.16705453209886955762@gmail.com>
Subject: [PATCH] mm/hmm: account for subpage offsets in device-private PMDs
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

When a query starts inside a device-private PMD owned by
range->dev_private_owner, hmm_vma_handle_absent_pmd() still fills the PFN
array from the folio's first page. The returned PFNs therefore refer to
earlier pages rather than the requested subrange.

Add the query's PMD-relative page offset to the initial PFN, as the
present PMD path already does.

Fixes: 10b9feee2d0d ("mm/hmm: populate PFNs from PMD swap entry")
Signed-off-by: Aveline Noir <jm5905938@gmail.com>

---
Found during a synthetic test_hmm check of device-private THP handling.
Tested PMD-aligned and non-aligned subranges, PMD boundaries, split
PTEs and fake-device data accesses with test_hmm in QEMU TCG; all
executed tests passed with the fix. No real GPU testing was performed.
---
 mm/hmm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/hmm.c b/mm/hmm.c
index 2f1e98c6b644..e89f140d3e5c 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -355,7 +355,8 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 	    range->dev_private_owner) {
 		unsigned long cpu_flags = HMM_PFN_VALID |
 			hmm_pfn_flags_order(PMD_SHIFT - PAGE_SHIFT);
-		unsigned long pfn = softleaf_to_pfn(entry);
+		unsigned long pfn = softleaf_to_pfn(entry) +
+			((start & ~PMD_MASK) >> PAGE_SHIFT);
 		unsigned long i;
 
 		if (softleaf_is_device_private_write(entry))

base-commit: d89e1d186ec9271bf78e62771779e9fc03bf0fc3
-- 
2.56.0


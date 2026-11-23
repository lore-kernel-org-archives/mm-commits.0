Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795415093;
	b=rCGEfMl/buOSPt0QDyaanj/i3UQnnStQL/Q3LYxoXxQO5GLGCwlhnX4pRyVEtfAbr7e3
	 MA2xywF6rTig+WLh9MyKmFU9flEV2Q1yAi/Semy/zN21xiUkdkGRCAs4ofm3u5RTOLIhA
	 JWvFJ/nGFVs6UzASAtcfJUHxE1sxymOqGebIXWx9jUvqN9HyDgf1n9OfxMHjlmce4Ff1Y
	 jxE767XmgZbB4satoQXRauCuRZsBesvjQHinQ48G0HFYxTYnW3HI5HA+7pVvxhzFdIvw5
	 zjembr90nN/5k1R67MM2orbXeZr7AJoLdzcVFOAPNDmB+5yGEEQ9InVkCW3+mdMRldw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795415093;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=wO1t+tgiO8cq1YXIwe5qBnPiu7av5i2q++hV1QLW4ms=;
	b=KdaybDZK80wCXOB7kOvzFu/WbkJTUEyDW3L3DcH6jDtUUM2+VsGv3DhFPqEAbBb1fDPb
	 nDRtm3FtBaMPn0PiyLeLfXx3yMn+CnmCH4CdoRkGPxdxRA9lKNfG77cxB458t0Xy103mK
	 BMwhZm8EBNrYhIiXVIEJ1sKI5IuLSTtPPh39Isn6ukCQqXJ43FWlzfwQ0Zsj1HhW43jUE
	 UedG0UHPrZreL74kFI1z/wVMKpX6i+xUjsX4iqxQNUMvvhExyzj20ROqvUhdaORA1BN0I
	 qPK2BA93p1HpIFu8VjvAPYLFFtS9Ufl/KbbINA0TLb5z/MxqmO5X92u16puNAb13BvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=iwHCT2+K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994B5606A321
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 06:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=iwHCT2+K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB971F000CA;
	Mon, 23 Nov 2026 06:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795415093;
	bh=wO1t+tgiO8cq1YXIwe5qBnPiu7av5i2q++hV1QLW4ms=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=iwHCT2+KKR1YJxMz6jcW2qsz53ENy2S+W84W3Vo2IP5/Ew4ks3o0V9H3ltE0T1ZaZ
	 HaVJBRRaBPkosZRatsyZJHCWEZgIApJfOnkJBtfjYJActFDKNSWpQ4rh1AzRYInJF3
	 VAanMMXp1qBgeo+YpKNDS4mi1h6INiULsOGJXfaI=
Date: Sun, 22 Nov 2026 22:24:52 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,work@onurozkan.dev,
	vbabka@kernel.org,usama.arif@linux.dev,urezki@gmail.com,tmgross@umich.edu,
	tamird@kernel.org,surenb@google.com,sj@kernel.org,shakeel.butt@linux.dev,
	ryan.roberts@arm.com,rppt@kernel.org,qi.zheng@linux.dev,ojeda@kernel.org,
	nico.pache@linux.dev,mhocko@suse.com,lossin@kernel.org,liam@infradead.org,
	lance.yang@linux.dev,kas@kernel.org,hannes@cmpxchg.org,gary@garyguo.net,
	dev.jain@arm.com,david@kernel.org,daniel.almeida@collabora.com,
	dakr@kernel.org,boqun@kernel.org,bjorn3_gh@protonmail.com,
	baolin.wang@linux.alibaba.com,baohua@kernel.org,aliceryhl@google.com,
	a.hindborg@kernel.org,acourbot@nvidia.com,ljs@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261110-drop-reviewerships-v1-2-07c2f06e8dfa@kernel.org>
References: <20261110-drop-reviewerships-v1-2-07c2f06e8dfa@kernel.org>
Subject: [merged mm-hotfixes-stable] maintainers-remove-myself-from-mm-misc-reclaim-reviewership.patch removed from -mm tree
Message-Id: <20261123062453.1CB971F000CA@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: MAINTAINERS: remove myself from MM misc, reclaim reviewership
has been removed from the -mm tree.  Its filename was
     maintainers-remove-myself-from-mm-misc-reclaim-reviewership.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: MAINTAINERS: remove myself from MM misc, reclaim reviewership
Date: Tue, 10 Nov 2026 12:03:08 +0000

Given the current throughput in the kernel resulting from AI-generated
series, I unfortunately lack the bandwidth to generally be able to offer
review except in those areas I maintain.

Therefore, remove myself as a reviewer.

Link: https://patch.msgid.link/20261110-drop-reviewerships-v1-2-07c2f06e8dfa@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: Danilo Krummrich <dakr@kernel.org>
Acked-by: Barry Song <baohua@kernel.org>
Acked-by: SJ Park <sj@kernel.org>
Acked-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Dev Jain <dev.jain@arm.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Boqun Feng <boqun@kernel.org>
Cc: Gary Guo <gary@garyguo.net>
Cc: Björn Roy Baron <bjorn3_gh@protonmail.com>
Cc: Benno Lossin <lossin@kernel.org>
Cc: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Trevor Gross <tmgross@umich.edu>
Cc: Daniel Almeida <daniel.almeida@collabora.com>
Cc: Tamir Duberstein <tamird@kernel.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>
Cc: Onur Özkan <work@onurozkan.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Usama Arif <usama.arif@linux.dev>

 MAINTAINERS |    2 --
 1 file changed, 2 deletions(-)

--- a/MAINTAINERS~maintainers-remove-myself-from-mm-misc-reclaim-reviewership
+++ a/MAINTAINERS
@@ -17674,7 +17674,6 @@ F:	mm/migrate_device.c
 MEMORY MANAGEMENT - MISC
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
-R:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Liam R. Howlett <liam@infradead.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Mike Rapoport <rppt@kernel.org>
@@ -17810,7 +17809,6 @@ R:	David Hildenbrand <david@kernel.org>
 R:	Michal Hocko <mhocko@kernel.org>
 R:	Qi Zheng <qi.zheng@linux.dev>
 R:	Shakeel Butt <shakeel.butt@linux.dev>
-R:	Lorenzo Stoakes <ljs@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	include/trace/events/vmscan.h
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-predicate-vma_assert_stabilised-on-config_debug_vm.patch
mm-only-assert-mmap-locks-if-config_debug_vm-or-lockdep-is-set.patch
mm-only-assert-vma-locks-if-config_debug_vm-is-set.patch
mm-convert-warn_on_onces-to-vm_warn_on_once-in-vma-lock-code.patch
mm-madvise-zap-markers-from-guard-regions.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC89414439
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525515; cv=none; b=TCvcWc9hrgpUOJWtmimljNzemDhI6K4xwcYhSm16kcqzkV27pqIdo2msk5VxjW+XoJgBndvgfsXSPWbjv3zhCKIjkPRAf7iWih9m24cVuN/PWYljhVG7S9rZz/S13MNoRZ34sTPpg6NRxawBWCeVsQQe4PY/SAvWCMkcjBKnoPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525515; c=relaxed/simple;
	bh=wMumZS9AuXU8B8fnKxTy40MrDn4Hm7kTeDOjv1nbWX8=;
	h=Date:To:From:Subject:Message-Id; b=SUyPXN8PiwI7mHkt0+mkuEONXJZa3pLPFOs80Z7n1Aexh0mMMY/Ydc2Hnt9ruArU4KWMAZsXb08CUmQw4BIlEzrghCiJXTprlackI8LSnObeHg47tMwFN8hOD58kCD90aMZWAiylRrk15Eh044vHylgNmDyFDTrfIiHYRIM/DS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y3qmvZxS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y3qmvZxS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2FA11F00898;
	Fri,  9 Oct 2026 05:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525514;
	bh=14mhtSPOcetwtBCOeszCymQIb1i4jABY04QC3QFp/UA=;
	h=Date:To:From:Subject;
	b=Y3qmvZxSWzVlU/8mxqzWmcwBDRy/SOlwDO7J+KVNyOxarsOjM1v7cpHg1mL920rYd
	 yzJ5AkxVw6dUyepgSHQQIwMD825rr44EHRP5PJHHS/R7KUiulmA+N80jVu9cxyvsCY
	 DOnUgRYWMhZVJzo4dB4Bm/k0XjGHvTD/fQ9TrqDA=
Date: Thu, 08 Oct 2026 22:58:33 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-core-api-memory-allocation-clarify-when-to-use-kzalloc_obj-and-kzalloc.patch removed from -mm tree
Message-Id: <20261009055833.E2FA11F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs/core-api: memory-allocation: clarify when to use kzalloc_obj and kzalloc
has been removed from the -mm tree.  Its filename was
     docs-core-api-memory-allocation-clarify-when-to-use-kzalloc_obj-and-kzalloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: docs/core-api: memory-allocation: clarify when to use kzalloc_obj and kzalloc
Date: Mon, 7 Sep 2026 09:36:54 +0300

Make it abundantly clear that in the most cases objects should be
allocated with kzalloc_obj() and buffers should be allocated with
kzalloc().

Link: https://lore.kernel.org/20260907063654.2248617-1-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
---

 Documentation/core-api/memory-allocation.rst |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/Documentation/core-api/memory-allocation.rst~docs-core-api-memory-allocation-clarify-when-to-use-kzalloc_obj-and-kzalloc
+++ a/Documentation/core-api/memory-allocation.rst
@@ -23,12 +23,14 @@ answer, although very likely you should
 
   kzalloc_obj(<VAR_OR_TYPE>);
 
-or
+if you need memory for an object and
 
 ::
 
   kzalloc(<size>, GFP_KERNEL);
 
+if you need memory for a buffer.
+
 Of course there are cases when other allocation APIs and different GFP
 flags must be used.
 
_

Patches currently in -mm which might be from rppt@kernel.org are

docs-mm-describe-set_memory-and-set_direct_map-apis.patch
docs-mm-describe-set_memory-and-set_direct_map-apis-fix.patch
arch-mm-promote-debug_wx-to-check_wx.patch
sh-remove-config_numa-and-realted-configuration-options.patch
sh-mm-remove-numac.patch
sh-mm-drop-allocate_pgdat.patch
sh-remove-setup_bootmem_node-and-plat_mem_setup.patch
sh-drop-dead-code-guarded-by-ifdef-config_numa.patch
sh-drop-include-asm-mmzoneh.patch
init-kconfig-drop-arch_want_numa_variable_locality.patch
sh-init-remove-call-the-memblock_set_node.patch
sh-remove-sparsemem-related-entries-from-kconfig.patch
sh-drop-include-asm-sparsememh.patch


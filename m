Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832349;
	b=LkvLnrbwnblcXqKzU+DYyN4VPaum+RIlz+ryLP9xwShxjPChgfo5VSUNVLXfMPZofk8K
	 g4bDJBj74P7+gP+vABr+9Y2yLJvvDZLEiveMWbL4246r9tm4K2tv0gStoA7M8mXkHMmq+
	 mhjsWssu3CNIJK677q+O9p6jizEQagZT0ALISiYnGB6+XHLqAerGYKUD5yVKXQ/F1Qx+Q
	 R3ZQJmxKlyYyWpXdUaDQ6L4h49Sb6IB4myNcr3b1LAjCx87QIOt4a0FoikV5Uc4ORxxBZ
	 K0gFAEUnUL9Rjz//rbfdE4IDHcXmMZ8cr27e5glr5uVNWS1QYpqQH8BZRI1we+MAQcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832349;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Znvvftn0+Pme/U6H67gHBEz/uirGusXhf4Iw+Ovj1Y0=;
	b=O+LsZZtw0huURhLFLjfgAICWfZloV8VEEHHQnGdU71iY5HHe7/92blZzlqs4aEN/TTOl
	 vf1LSH4ST4Fm/pr8babhX9TdLuIthKqtQ+glH3KiHgXR+0/JZvl8i+wZja6DYJpPPNzKH
	 xXxTBqXx753/XcXRoNPFdxmMgg1R4Olq6bbpVvcZnfaXpKbLsuU9vBnykPY1dQIk/c3MT
	 8rWs2to9OQzcgx+fYPgS/q6AX21MiX2gIMYoKX9UlGsA06NJqErOTCCXWxDp0J+2cqNbX
	 wCaMbNdQ2P5ghg5HiYCIgknJtcRan2rMhRsNe5xT74Hut+ZXAMuLxfsrFBOvIivVe+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=JEDrwHdk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8144606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=JEDrwHdk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B35471F01828;
	Sat, 24 Oct 2026 08:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832348;
	bh=Znvvftn0+Pme/U6H67gHBEz/uirGusXhf4Iw+Ovj1Y0=;
	h=Date:To:From:Subject;
	b=JEDrwHdkee8AXeyuP26dqhNyfGNanDk85N0n/gqDyypTaYAblm0aC7LaV4stcvNwL
	 JKKgNEdCdgEzhAP9t1g7dzaTZqxy7sAgMYy8n8G4wPDfdKvCAXesMq8xsvTiVDH6zS
	 GHQHHuItPwXaqz/blWLS7wexfgCr17wiOZkGvuko=
Date: Sat, 24 Oct 2026 01:59:08 -0700
To: mm-commits@vger.kernel.org,ruirui.yang@linux.dev,kazuhito.hagio@nec.com,devnexen@gmail.com,brads@mainlining.org,baoquan.he@linux.dev,anshuman.khandual@arm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vmcoreinfo-export-section_has_mem_map.patch removed from -mm tree
Message-Id: <20261024085908.B35471F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: vmcoreinfo: export SECTION_HAS_MEM_MAP
has been removed from the -mm tree.  Its filename was
     vmcoreinfo-export-section_has_mem_map.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: vmcoreinfo: export SECTION_HAS_MEM_MAP
Date: Mon, 28 Sep 2026 10:48:21 +0200

The crash tool currently hardcodes SECTION_HAS_MEM_MAP, and makedumpfile
needs similar information (although still relying on
SECTION_MARKED_PRESENT, it should switch to SECTION_HAS_MEM_MAP).

Let's just export the value instead, so tools that work on vmcoreinfo
will not have to guess.

Link: https://lore.kernel.org/20260928-section_has_mem_map-v1-1-4129f6ba2838@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Baoquan He <baoquan.he@linux.dev>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Cc: David Carlier <devnexen@gmail.com>
Cc: Dave Young <ruirui.yang@linux.dev>
Cc: Kazuhito Hagio <kazuhito.hagio@nec.com>
---

 kernel/vmcore_info.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/vmcore_info.c~vmcoreinfo-export-section_has_mem_map
+++ a/kernel/vmcore_info.c
@@ -182,6 +182,7 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_STRUCT_SIZE(mem_section);
 	VMCOREINFO_OFFSET(mem_section, section_mem_map);
 	VMCOREINFO_NUMBER(SECTION_SIZE_BITS);
+	VMCOREINFO_NUMBER(SECTION_HAS_MEM_MAP);
 	VMCOREINFO_NUMBER(MAX_PHYSMEM_BITS);
 #endif
 	VMCOREINFO_STRUCT_SIZE(page);
_

Patches currently in -mm which might be from david@kernel.org are

mm-fix-address-wraparound-when-scanning-large-folio-ptes.patch
mm-hugetlb-disable-pmd-sharing-for-uffd-missing-mode.patch
mm-vma-write-lock-source-vma-before-duplicating-it-in-__split_vma.patch
mm-madvise-preserve-vma_softdirty_bit-when-changing-anonymous-names.patch


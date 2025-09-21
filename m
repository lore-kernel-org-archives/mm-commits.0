Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822E428DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489809; cv=none; b=uJZCPbcGQYXS+NIngaiuKUCS9EeRIy0EAe0PXf7KWGCna3DZDEGrG7zXTHQc9Vvvmzk7O9iM7Vuqbtj0QdCoWYhyaXLixAvmZ9BwnOUhnQFAzMW7wHv56jS0pq7a7Cy0goIW0Rs9LIYV/TwgJxw74pEDXjxV46AdISV6hxb2uGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489809; c=relaxed/simple;
	bh=QXPLQYGK062fGmwXinNIsLjhg3v/VEHKklP5kVH2ZL4=;
	h=Date:To:From:Subject:Message-Id; b=GRIjjg2tjlco46JvFiklTl4KT8Hfg+LWQ3RuP3R4FXt80Sw47S8Ivz/EvlbFd20TKwJ21uLSTnR5rYXUxqzHkaPTlizsxav6A/pFVDRND5/d58uJd/HJ1HfNqpH5JPq+6JNHT1QLIjQquMV8QmmD0R/FtVip1WAGNxCprQndem0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zOvcLV1w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zOvcLV1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313D0C4CEE7;
	Sun, 21 Sep 2025 21:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489809;
	bh=QXPLQYGK062fGmwXinNIsLjhg3v/VEHKklP5kVH2ZL4=;
	h=Date:To:From:Subject:From;
	b=zOvcLV1w50dqJLrN93xNwhZfM6Kdar7IrfKG5cpu4bqUGdJbtTGWKdyoOdcXK/VdU
	 XPuC4UISlq3aPnhmZZF+mkbqddzOKJZPVlbZ+0djyA8mNM6qFY/2bDWoQBiNcQIY7n
	 ukvJ5x4vU+89u2073hESlOJ1h2G3cmC9D34z9Qi8=
Date: Sun, 21 Sep 2025 14:23:28 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,rppt@kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,catalin.marinas@arm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-kconfig-drop-superfluous-select-sparsemem_vmemmap.patch removed from -mm tree
Message-Id: <20250921212329.313D0C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64: Kconfig: drop superfluous "select SPARSEMEM_VMEMMAP"
has been removed from the -mm tree.  Its filename was
     arm64-kconfig-drop-superfluous-select-sparsemem_vmemmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: arm64: Kconfig: drop superfluous "select SPARSEMEM_VMEMMAP"
Date: Mon, 1 Sep 2025 17:03:23 +0200

Now handled by the core automatically once SPARSEMEM_VMEMMAP_ENABLE is
selected.

Link: https://lkml.kernel.org/r/20250901150359.867252-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm64/Kconfig~arm64-kconfig-drop-superfluous-select-sparsemem_vmemmap
+++ a/arch/arm64/Kconfig
@@ -1570,7 +1570,6 @@ source "kernel/Kconfig.hz"
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
 	select SPARSEMEM_VMEMMAP_ENABLE
-	select SPARSEMEM_VMEMMAP
 
 config HW_PERF_EVENTS
 	def_bool y
_

Patches currently in -mm which might be from david@redhat.com are



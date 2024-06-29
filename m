Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77F718C36
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628627; cv=none; b=K5uqCKVF9kMndUq5vecdGYILVcEYjKPZbvSLEtqjeRUxLlXAd7zRMQCEZ6eZylWTOMXVrZQvE6SlZUgjHqMDxMyOzFyDxgAjDqORY/h71Qz4h32Idb3RGNVO92PLU7Eagsm03x3gDY1jNFMeTrui7SE6KZg/yZsS0vh2mHXfbyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628627; c=relaxed/simple;
	bh=26uSsgcMU1w1zmVTyO5sie7p396qdf3tiIEXz+mojic=;
	h=Date:To:From:Subject:Message-Id; b=XfcHZg86s2QUT3K/ADKctkTIvoltIF0I4JhObUrNC1QKw1gCHDWi6tNxF1n2rVtACFXRtNdshIPpMfKrwmwGW/ylWi8KFiHEoda29HfjCPUneGiX6+AeL1tpUVsuPdGuxp7c7crFT8WKvfzzAquwPAoo80/9DX55Cap6Gl4gtpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0E3XgGL6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0E3XgGL6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3253C116B1;
	Sat, 29 Jun 2024 02:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628626;
	bh=26uSsgcMU1w1zmVTyO5sie7p396qdf3tiIEXz+mojic=;
	h=Date:To:From:Subject:From;
	b=0E3XgGL6rxubEgoYM4hQc2EJN32Ol6jSfPnD4nWWr3n8xj0X+rc3PLIS2RfX8rmg9
	 gTWAWSV7123sMRf5Q2Z0gq85FtTbtsTTT25KH4tgGvHPwbeUuUkA9JlginANeQMFnr
	 MxfGEOvNypiso7qCHE7vSCNoxIFvCHlcGjbS9JtI=
Date: Fri, 28 Jun 2024 19:37:06 -0700
To: mm-commits@vger.kernel.org,mpe@ellerman.id.au,kirill.shutemov@linux.intel.com,kbingham@kernel.org,jan.kiszka@siemens.com,kuan-ying.lee@canonical.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-change-the-layout-of-vmemmap.patch removed from -mm tree
Message-Id: <20240629023706.B3253C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/gdb: change the layout of vmemmap
has been removed from the -mm tree.  Its filename was
     scripts-gdb-change-the-layout-of-vmemmap.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Subject: scripts/gdb: change the layout of vmemmap
Date: Wed, 19 Jun 2024 15:49:08 +0800

We need to change the layout of vmemmap in gdb scripts after
commit 32697ff38287 ("arm64: vmemmap: Avoid base2 order of
struct page size to dimension region") changed it.

Link: https://lkml.kernel.org/r/20240619074911.100434-4-kuan-ying.lee@canonical.com
Fixes: 32697ff38287 ("arm64: vmemmap: Avoid base2 order of struct page size to dimension region")
Signed-off-by: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/mm.py |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/scripts/gdb/linux/mm.py~scripts-gdb-change-the-layout-of-vmemmap
+++ a/scripts/gdb/linux/mm.py
@@ -89,10 +89,10 @@ class aarch64_page_ops():
         self.MODULES_VADDR = self._PAGE_END(self.VA_BITS_MIN)
         self.MODULES_END = self.MODULES_VADDR + self.MODULES_VSIZE
 
-        self.VMEMMAP_SHIFT = (self.PAGE_SHIFT - self.STRUCT_PAGE_MAX_SHIFT)
-        self.VMEMMAP_SIZE = ((self._PAGE_END(self.VA_BITS_MIN) - self.PAGE_OFFSET) >> self.VMEMMAP_SHIFT)
-        self.VMEMMAP_START = (-(1 << (self.VA_BITS - self.VMEMMAP_SHIFT))) & 0xffffffffffffffff
-        self.VMEMMAP_END = self.VMEMMAP_START + self.VMEMMAP_SIZE
+        self.VMEMMAP_RANGE = self._PAGE_END(self.VA_BITS_MIN) - self.PAGE_OFFSET
+        self.VMEMMAP_SIZE = (self.VMEMMAP_RANGE >> self.PAGE_SHIFT) * self.struct_page_size
+        self.VMEMMAP_END = (-(1 * 1024 * 1024 * 1024)) & 0xffffffffffffffff
+        self.VMEMMAP_START = self.VMEMMAP_END - self.VMEMMAP_SIZE
 
         self.VMALLOC_START = self.MODULES_END
         self.VMALLOC_END = self.VMEMMAP_START - 256 * 1024 * 1024
_

Patches currently in -mm which might be from kuan-ying.lee@canonical.com are



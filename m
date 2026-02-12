Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1578D2C026E
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 23:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770939992; cv=none; b=Glk+J3VR2dopJ1MHT92fpPUV3ZPGuFy8+TO2vdeFnNC1FtebLAU0pJr/+qKjzNbYqeKxc1EhmQLjeRfnYE3NkkpHu3yzvhEg/Vw4984k2/7JJbaed5fC3F+563VKedJBYErACtQ8Y+tBuSrqO8uw5OU63g2MOxYGWn+X6Q87pKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770939992; c=relaxed/simple;
	bh=WDhLhTG1/FmLo4zfk5hz/zN9anljakgMl12O4TUzn0U=;
	h=Date:To:From:Subject:Message-Id; b=AEi8z01YW3HQ09Cc44+FkHNoh/zgoH7IF8EcGjQ/k6yhgGw6akqW6q7v4iI0EfxBEqW/46tiE16bxB53E0mFhDlOjAeFXepYEjtR6fG+LjKEgWevFOo49BECudViumBrJWm176DejxYmoaI852IxvDAIS1y/bj6NqLrmzmVgaIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qtnrgDsM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qtnrgDsM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EED8C4CEF7;
	Thu, 12 Feb 2026 23:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770939991;
	bh=WDhLhTG1/FmLo4zfk5hz/zN9anljakgMl12O4TUzn0U=;
	h=Date:To:From:Subject:From;
	b=qtnrgDsMqBQcgYhNCwprMYWZ/0E1JiqXyJpLhK677jrLJfNI6xCbP0oNVcEbR4e2d
	 vFEpk4UOjeiLvoD+YDBy+bIAF6+BYcMa7YwMVOnzoCrfMtjWZSt8RhRlwGidvHRzMm
	 CWTTXig19tpfAyb1rqbgjNvMf2ShVFqFr0wV2wGM=
Date: Thu, 12 Feb 2026 15:46:31 -0800
To: mm-commits@vger.kernel.org,jan.kiszka@siemens.com,hsj0512@snu.ac.kr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-implement-x86_page_ops-in-mmpy.patch removed from -mm tree
Message-Id: <20260212234631.8EED8C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/gdb: implement x86_page_ops in mm.py
has been removed from the -mm tree.  Its filename was
     scripts-gdb-implement-x86_page_ops-in-mmpy.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Seongjun Hong <hsj0512@snu.ac.kr>
Subject: scripts/gdb: implement x86_page_ops in mm.py
Date: Mon, 2 Feb 2026 12:42:41 +0900

Implement all member functions of x86_page_ops strictly following the
logic of aarch64_page_ops.

This includes full support for SPARSEMEM and standard page translation
functions.

This fixes compatibility with 'lx-' commands on x86_64, preventing
AttributeErrors when using lx-pfn_to_page and others.

Link: https://lkml.kernel.org/r/20260202034241.649268-1-hsj0512@snu.ac.kr
Signed-off-by: Seongjun Hong <hsj0512@snu.ac.kr>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/constants.py.in |    2 
 scripts/gdb/linux/mm.py           |  173 +++++++++++++++++++++++++++-
 2 files changed, 173 insertions(+), 2 deletions(-)

--- a/scripts/gdb/linux/constants.py.in~scripts-gdb-implement-x86_page_ops-in-mmpy
+++ a/scripts/gdb/linux/constants.py.in
@@ -150,8 +150,8 @@ LX_CONFIG(CONFIG_ARM64_64K_PAGES)
 if IS_BUILTIN(CONFIG_ARM64):
     LX_VALUE(CONFIG_ARM64_PA_BITS)
     LX_VALUE(CONFIG_ARM64_VA_BITS)
-    LX_VALUE(CONFIG_PAGE_SHIFT)
     LX_VALUE(CONFIG_ARCH_FORCE_MAX_ORDER)
+LX_VALUE(CONFIG_PAGE_SHIFT)
 LX_CONFIG(CONFIG_SPARSEMEM)
 LX_CONFIG(CONFIG_SPARSEMEM_EXTREME)
 LX_CONFIG(CONFIG_SPARSEMEM_VMEMMAP)
--- a/scripts/gdb/linux/mm.py~scripts-gdb-implement-x86_page_ops-in-mmpy
+++ a/scripts/gdb/linux/mm.py
@@ -26,8 +26,179 @@ class page_ops():
             raise gdb.GdbError('Only support CONFIG_SPARSEMEM_VMEMMAP now')
         if constants.LX_CONFIG_ARM64 and utils.is_target_arch('aarch64'):
             self.ops = aarch64_page_ops()
+        elif utils.is_target_arch('x86_64') or utils.is_target_arch('x86-64'):
+            self.ops = x86_page_ops()
         else:
-            raise gdb.GdbError('Only support aarch64 now')
+            raise gdb.GdbError('Only support aarch64 and x86_64 now')
+
+class x86_page_ops():
+    def __init__(self):
+        self.struct_page_size = utils.get_page_type().sizeof
+        self.PAGE_SHIFT = constants.LX_CONFIG_PAGE_SHIFT
+        self.PAGE_SIZE = 1 << self.PAGE_SHIFT
+        self.PAGE_MASK = (~(self.PAGE_SIZE - 1)) & ((1 << 64) - 1)
+
+        self.PAGE_OFFSET = int(gdb.parse_and_eval("page_offset_base"))
+        self.VMEMMAP_START = int(gdb.parse_and_eval("vmemmap_base"))
+        self.PHYS_BASE = int(gdb.parse_and_eval("phys_base"))
+        self.START_KERNEL_map = 0xffffffff80000000
+
+        self.KERNEL_START = gdb.parse_and_eval("_text")
+        self.KERNEL_END = gdb.parse_and_eval("_end")
+
+        self.VMALLOC_START = int(gdb.parse_and_eval("vmalloc_base"))
+        if self.VMALLOC_START == 0xffffc90000000000:
+            self.VMALLOC_END = self.VMALLOC_START + (32 * 1024 * 1024 * 1024 * 1024) - 1
+        elif self.VMALLOC_START == 0xffa0000000000000:
+            self.VMALLOC_END = self.VMALLOC_START + (12800 * 1024 * 1024 * 1024 * 1024) - 1
+        else:
+            self.VMALLOC_END = self.VMALLOC_START + (12800 * 1024 * 1024 * 1024 * 1024) - 1
+
+        self.MAX_PHYSMEM_BITS = 46
+        self.SECTION_SIZE_BITS = 27
+        self.MAX_ORDER = 10
+
+        self.SECTIONS_SHIFT = self.MAX_PHYSMEM_BITS - self.SECTION_SIZE_BITS
+        self.NR_MEM_SECTIONS = 1 << self.SECTIONS_SHIFT
+        self.PFN_SECTION_SHIFT = self.SECTION_SIZE_BITS - self.PAGE_SHIFT
+        self.PAGES_PER_SECTION = 1 << self.PFN_SECTION_SHIFT
+        self.PAGE_SECTION_MASK = (~(self.PAGES_PER_SECTION - 1)) & ((1 << 64) - 1)
+
+        if constants.LX_CONFIG_SPARSEMEM_EXTREME:
+            self.SECTIONS_PER_ROOT = self.PAGE_SIZE // gdb.lookup_type("struct mem_section").sizeof
+        else:
+            self.SECTIONS_PER_ROOT = 1
+
+        self.NR_SECTION_ROOTS = DIV_ROUND_UP(self.NR_MEM_SECTIONS, self.SECTIONS_PER_ROOT)
+        self.SECTION_ROOT_MASK = self.SECTIONS_PER_ROOT - 1
+
+        try:
+            self.SECTION_HAS_MEM_MAP = 1 << int(gdb.parse_and_eval('SECTION_HAS_MEM_MAP_BIT'))
+            self.SECTION_IS_EARLY = 1 << int(gdb.parse_and_eval('SECTION_IS_EARLY_BIT'))
+        except:
+            self.SECTION_HAS_MEM_MAP = 1 << 0
+            self.SECTION_IS_EARLY = 1 << 3
+
+        self.SUBSECTION_SHIFT = 21
+        self.PAGES_PER_SUBSECTION = 1 << (self.SUBSECTION_SHIFT - self.PAGE_SHIFT)
+
+        if constants.LX_CONFIG_NUMA and constants.LX_CONFIG_NODES_SHIFT:
+            self.NODE_SHIFT = constants.LX_CONFIG_NODES_SHIFT
+        else:
+            self.NODE_SHIFT = 0
+
+        self.MAX_NUMNODES = 1 << self.NODE_SHIFT
+
+        self.vmemmap = gdb.Value(self.VMEMMAP_START).cast(utils.get_page_type().pointer())
+
+    def kasan_reset_tag(self, addr):
+        return addr
+
+    def SECTION_NR_TO_ROOT(self, sec):
+        return sec // self.SECTIONS_PER_ROOT
+
+    def __nr_to_section(self, nr):
+        root = self.SECTION_NR_TO_ROOT(nr)
+        mem_section = gdb.parse_and_eval("mem_section")
+        return mem_section[root][nr & self.SECTION_ROOT_MASK]
+
+    def pfn_to_section_nr(self, pfn):
+        return pfn >> self.PFN_SECTION_SHIFT
+
+    def section_nr_to_pfn(self, sec):
+        return sec << self.PFN_SECTION_SHIFT
+
+    def __pfn_to_section(self, pfn):
+        return self.__nr_to_section(self.pfn_to_section_nr(pfn))
+
+    def pfn_to_section(self, pfn):
+        return self.__pfn_to_section(pfn)
+
+    def subsection_map_index(self, pfn):
+        return (pfn & ~(self.PAGE_SECTION_MASK)) // self.PAGES_PER_SUBSECTION
+
+    def pfn_section_valid(self, ms, pfn):
+        if constants.LX_CONFIG_SPARSEMEM_VMEMMAP:
+            idx = self.subsection_map_index(pfn)
+            return test_bit(idx, ms['usage']['subsection_map'])
+        else:
+            return True
+
+    def valid_section(self, mem_section):
+        if mem_section != None and (mem_section['section_mem_map'] & self.SECTION_HAS_MEM_MAP):
+            return True
+        return False
+
+    def early_section(self, mem_section):
+        if mem_section != None and (mem_section['section_mem_map'] & self.SECTION_IS_EARLY):
+            return True
+        return False
+
+    def pfn_valid(self, pfn):
+        ms = None
+        if self.PHYS_PFN(self.PFN_PHYS(pfn)) != pfn:
+            return False
+        if self.pfn_to_section_nr(pfn) >= self.NR_MEM_SECTIONS:
+            return False
+        ms = self.__pfn_to_section(pfn)
+
+        if not self.valid_section(ms):
+            return False
+        return self.early_section(ms) or self.pfn_section_valid(ms, pfn)
+
+    def PFN_PHYS(self, pfn):
+        return pfn << self.PAGE_SHIFT
+
+    def PHYS_PFN(self, phys):
+        return phys >> self.PAGE_SHIFT
+
+    def __phys_to_virt(self, pa):
+        return pa + self.PAGE_OFFSET
+
+    def __virt_to_phys(self, va):
+        if va >= self.START_KERNEL_map:
+            return va - self.START_KERNEL_map + self.PHYS_BASE
+        else:
+            return va - self.PAGE_OFFSET
+
+    def virt_to_phys(self, va):
+        return self.__virt_to_phys(va)
+
+    def virt_to_page(self, va):
+        return self.pfn_to_page(self.virt_to_pfn(va))
+
+    def __pa(self, va):
+        return self.__virt_to_phys(va)
+
+    def __va(self, pa):
+        return self.__phys_to_virt(pa)
+
+    def pfn_to_kaddr(self, pfn):
+        return self.__va(pfn << self.PAGE_SHIFT)
+
+    def virt_to_pfn(self, va):
+        return self.PHYS_PFN(self.__virt_to_phys(va))
+
+    def sym_to_pfn(self, x):
+        return self.PHYS_PFN(self.__virt_to_phys(x))
+
+    def page_to_pfn(self, page):
+        return int(page.cast(utils.get_page_type().pointer()) - self.vmemmap)
+
+    def pfn_to_page(self, pfn):
+        return self.vmemmap + pfn
+
+    def page_to_phys(self, page):
+        return self.PFN_PHYS(self.page_to_pfn(page))
+
+    def page_to_virt(self, page):
+        return self.__va(self.page_to_phys(page))
+
+    def page_address(self, page):
+        return self.page_to_virt(page)
+
+    def folio_address(self, folio):
+        return self.page_address(folio['page'].address)
 
 class aarch64_page_ops():
     def __init__(self):
_

Patches currently in -mm which might be from hsj0512@snu.ac.kr are



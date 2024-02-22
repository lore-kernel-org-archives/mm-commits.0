Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B494A18
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560065; cv=none; b=HvELRievY4FAExORtp55au1WKo1ND67l9QK85EqnlfmWUGCzIahgksAu/FmpSTITwFihoh61Vjf8gth1ubLbRUnHjckmex/SpNCGFGYPv9+sweY2KerxpMzJwBYN/qRF+nhaXr582AEfxvocF/o9/N1RhzEYCHj2UkJDGL0/ci0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560065; c=relaxed/simple;
	bh=zgsWKiOGnP6X9bCJwH5aw/n8m0cDaJJUChrMzv98bdY=;
	h=Date:To:From:Subject:Message-Id; b=XAdO6qWChPqlupVLfpiN0YudMQJwX7111toNDA7/CNaBQ6NHsDteX65Puw2UYeVEJ7k9ZFSjj6si+AFwLDWHsBfGhCZJI4CLcPfrV/7AWw0ejE+CN7DrM1EqZZm+nsi63KArHJyvMHDdnnWrB7RARIpenYYmjmANf4mw3LhoVng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dbiERGdD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dbiERGdD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8121BC43394;
	Thu, 22 Feb 2024 00:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560064;
	bh=zgsWKiOGnP6X9bCJwH5aw/n8m0cDaJJUChrMzv98bdY=;
	h=Date:To:From:Subject:From;
	b=dbiERGdD64trQS1pj1q7tpzQ2eyQYA9SZM/f5iFjRieJnaljznMdzjf4OLhXdbKEC
	 WDZfNuEIFqBUCOnxo9dEYOApT3/gcihQpS73uGc+8KKuHWIIA/rZbWfJQ3DKIIUxMa
	 JulbSMYlAaGgoO44VYnvMAxRvw/ANZS620qse464=
Date: Wed, 21 Feb 2024 16:01:04 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,qun-wei.lin@mediatek.com,matthias.bgg@gmail.com,kbingham@kernel.org,jan.kiszka@siemens.com,chinwen.chang@mediatek.com,casper.li@mediatek.com,angelogioacchino.delregno@collabora.com,Kuan-Ying.Lee@mediatek.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] scripts-gdb-vmalloc-fix-vmallocinfo-error.patch removed from -mm tree
Message-Id: <20240222000104.8121BC43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/gdb/vmalloc: fix vmallocinfo error
has been removed from the -mm tree.  Its filename was
     scripts-gdb-vmalloc-fix-vmallocinfo-error.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Subject: scripts/gdb/vmalloc: fix vmallocinfo error
Date: Wed, 7 Feb 2024 16:58:51 +0800

The patch series "Mitigate a vmap lock contention" removes vmap_area_list,
which will break the gdb vmallocinfo command:

(gdb) lx-vmallocinfo
Python Exception <class 'gdb.error'>: No symbol "vmap_area_list" in current context.
Error occurred in Python: No symbol "vmap_area_list" in current context.

So we can instead use vmap_nodes to iterate all vmallocinfo.

Link: https://lkml.kernel.org/r/20240207085856.11190-1-Kuan-Ying.Lee@mediatek.com
Signed-off-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: Casper Li <casper.li@mediatek.com>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Qun-Wei Lin <qun-wei.lin@mediatek.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/vmalloc.py |   56 +++++++++++++++++----------------
 1 file changed, 29 insertions(+), 27 deletions(-)

--- a/scripts/gdb/linux/vmalloc.py~scripts-gdb-vmalloc-fix-vmallocinfo-error
+++ a/scripts/gdb/linux/vmalloc.py
@@ -29,32 +29,34 @@ class LxVmallocInfo(gdb.Command):
         if not constants.LX_CONFIG_MMU:
             raise gdb.GdbError("Requires MMU support")
 
-        vmap_area_list = gdb.parse_and_eval('vmap_area_list')
-        for vmap_area in lists.list_for_each_entry(vmap_area_list, vmap_area_ptr_type, "list"):
-            if not vmap_area['vm']:
-                gdb.write("0x%x-0x%x %10d vm_map_ram\n" % (vmap_area['va_start'], vmap_area['va_end'],
-                    vmap_area['va_end'] - vmap_area['va_start']))
-                continue
-            v = vmap_area['vm']
-            gdb.write("0x%x-0x%x %10d" % (v['addr'], v['addr'] + v['size'], v['size']))
-            if v['caller']:
-                gdb.write(" %s" % str(v['caller']).split(' ')[-1])
-            if v['nr_pages']:
-                gdb.write(" pages=%d" % v['nr_pages'])
-            if v['phys_addr']:
-                gdb.write(" phys=0x%x" % v['phys_addr'])
-            if v['flags'] & constants.LX_VM_IOREMAP:
-                gdb.write(" ioremap")
-            if v['flags'] & constants.LX_VM_ALLOC:
-                gdb.write(" vmalloc")
-            if v['flags'] & constants.LX_VM_MAP:
-                gdb.write(" vmap")
-            if v['flags'] & constants.LX_VM_USERMAP:
-                gdb.write(" user")
-            if v['flags'] & constants.LX_VM_DMA_COHERENT:
-                gdb.write(" dma-coherent")
-            if is_vmalloc_addr(v['pages']):
-                gdb.write(" vpages")
-            gdb.write("\n")
+        nr_vmap_nodes = gdb.parse_and_eval('nr_vmap_nodes')
+        for i in range(0, nr_vmap_nodes):
+            vn = gdb.parse_and_eval('&vmap_nodes[%d]' % i)
+            for vmap_area in lists.list_for_each_entry(vn['busy']['head'], vmap_area_ptr_type, "list"):
+                if not vmap_area['vm']:
+                    gdb.write("0x%x-0x%x %10d vm_map_ram\n" % (vmap_area['va_start'], vmap_area['va_end'],
+                        vmap_area['va_end'] - vmap_area['va_start']))
+                    continue
+                v = vmap_area['vm']
+                gdb.write("0x%x-0x%x %10d" % (v['addr'], v['addr'] + v['size'], v['size']))
+                if v['caller']:
+                    gdb.write(" %s" % str(v['caller']).split(' ')[-1])
+                if v['nr_pages']:
+                    gdb.write(" pages=%d" % v['nr_pages'])
+                if v['phys_addr']:
+                    gdb.write(" phys=0x%x" % v['phys_addr'])
+                if v['flags'] & constants.LX_VM_IOREMAP:
+                    gdb.write(" ioremap")
+                if v['flags'] & constants.LX_VM_ALLOC:
+                    gdb.write(" vmalloc")
+                if v['flags'] & constants.LX_VM_MAP:
+                    gdb.write(" vmap")
+                if v['flags'] & constants.LX_VM_USERMAP:
+                    gdb.write(" user")
+                if v['flags'] & constants.LX_VM_DMA_COHERENT:
+                    gdb.write(" dma-coherent")
+                if is_vmalloc_addr(v['pages']):
+                    gdb.write(" vpages")
+                gdb.write("\n")
 
 LxVmallocInfo()
_

Patches currently in -mm which might be from Kuan-Ying.Lee@mediatek.com are



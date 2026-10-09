Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279CD404BF6
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525433; cv=none; b=Q8mHgAQFWrEbntdYOxUT8aVdpd1R9jLgYm2YbcUBDRTTj1c4m89XoEteA/H+Pz6cBa9XqLqouPXh5BVC64zHj2unkmCxGmOVhykJCMplskIq70C8klp+6oQ1Ld83tdGh3grPMccCPyduCE5njn69WXyvSKxlH5iFgROfkkU+DEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525433; c=relaxed/simple;
	bh=h6WCyfH6lDuawgplTAE5GjmHt3Iik7epfAQkolVy6ZM=;
	h=Date:To:From:Subject:Message-Id; b=J8vrIjRtnbyfcGgCjs7RKvKYcd2vVNjc1V8XKWatfYsT9ZPxPCGIVpnIG6I+N05Z7r+1H2TgpIZf3lFr8UBYtGifapnMoNRj1aKjiGV/UqOmqhiMkCw1+ylX27pZ7nxPIrACo/4B2r9ZgSbGLKs+kDpwHebByCDu+pbdHFVmqjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ibo0M0xh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ibo0M0xh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA7041F00893;
	Fri,  9 Oct 2026 05:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525432;
	bh=STNqHj2mnIGycjM40yzMg01KnJ8HEeogFN8so/ZJ7cY=;
	h=Date:To:From:Subject;
	b=Ibo0M0xhdlZMGu6NK6dXwG3RpIG6ilC4JjzL0ujAgcCEJY/0lAuvq43D7ohcCWJFC
	 e370IWKXtQ0VJGFd9oSdsJmAjuTQFJz46RchuyeUnI97Vb3v28SdcC/jXLf/LCmOSa
	 1lUI2Zq11h/g1ZmacFObGpestpHOgWLwm/P5qzFQ=
Date: Thu, 08 Oct 2026 22:57:11 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,mcgrof@kernel.org,jikos@kernel.org,bentiss@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-add-define_free-for-vfree.patch removed from -mm tree
Message-Id: <20261009055711.EA7041F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: add DEFINE_FREE() for vfree()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-add-define_free-for-vfree.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm/vmalloc: add DEFINE_FREE() for vfree()
Date: Thu, 03 Sep 2026 18:50:01 +0300

...  and use it in hid-core, the only place with a cleanup for a vmalloc()
allocation.

Link: https://lore.kernel.org/20260903-execmem-rox-cache-pmd-v1-v1-4-11beb2a3d249@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Tissoires <bentiss@kernel.org>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
---

 drivers/hid/hid-core.c  |    4 ++--
 include/linux/vmalloc.h |    3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-core.c~mm-vmalloc-add-define_free-for-vfree
+++ a/drivers/hid/hid-core.c
@@ -944,7 +944,7 @@ static int hid_scan_report(struct hid_de
 		hid_parser_reserved
 	};
 
-	struct hid_parser *parser __free(kvfree) = vzalloc(sizeof(*parser));
+	struct hid_parser *parser __free(vfree) = vzalloc(sizeof(*parser));
 	if (!parser)
 		return -ENOMEM;
 
@@ -1265,7 +1265,7 @@ static int hid_parse_collections(struct
 		hid_parser_reserved
 	};
 
-	struct hid_parser *parser __free(kvfree) = vzalloc(sizeof(*parser));
+	struct hid_parser *parser __free(vfree) = vzalloc(sizeof(*parser));
 	if (!parser)
 		return -ENOMEM;
 
--- a/include/linux/vmalloc.h~mm-vmalloc-add-define_free-for-vfree
+++ a/include/linux/vmalloc.h
@@ -3,6 +3,7 @@
 #define _LINUX_VMALLOC_H
 
 #include <linux/alloc_tag.h>
+#include <linux/cleanup.h>
 #include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/init.h>
@@ -215,6 +216,8 @@ void *__must_check vrealloc_node_align_n
 extern void vfree(const void *addr);
 extern void vfree_atomic(const void *addr);
 
+DEFINE_FREE(vfree, void *, if (!IS_ERR_OR_NULL(_T)) vfree(_T))
+
 extern void *vmap(struct page **pages, unsigned int count,
 			unsigned long flags, pgprot_t prot);
 void *vmap_pfn(unsigned long *pfns, unsigned int count, pgprot_t prot);
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


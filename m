Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BEC1B142D;
	Sat,  5 Sep 2026 01:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788573421; cv=none; b=R1jpXsFkL1Yxzu2ZVggBos2WARtFOMlb2L681NGOpwaqg/NyGfcrBlT3yrghsttfohbDFhs+r4rMadDSsNyWstoyKBatnRdIweTo+dAixwyNOF+biZjurypcWsYpHFJozygxl4QNWRq4vop4GY9s0orMMpMjnQ97YTCTRLC6gmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788573421; c=relaxed/simple;
	bh=KZ9vdofRopAkcHbQkzHeq8/AwnKKN3UZ0LnPv1f2igw=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=j4DRY08ws1YO333BD8VgQkkvOpJDM947dxeQ/ziae5/dnpEwmRaOTnQ38oXYcajtkwjYPTYQEeLCz4XxdDKjEWYByjT1dmvXkUg7uPWUxz+pRXVcEcTM3YAtyQBuwIHhHydW1HG+GbbfiPWuzgRLKsyxP1Kik7QRlfFPJKb4ul4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UF2mm+cV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UF2mm+cV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC991F00A3D;
	Sat,  5 Sep 2026 01:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788573419;
	bh=ntf0Gs9o5nHGu8zNmOc2HNk/o4BHxgRxMWIB2pzt8o4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=UF2mm+cVyRVguVIyMXeo1zSa8ehJU05+xgU9XW/yThJCEM5wL9xkyCaKdw0jHiItR
	 jjlazVvNsQVsxEg7fx8vXy0Pm2/cBBXGzBwnBlQJ8tbQKgYlxDlDc8DcvA2HlI8/gM
	 p2QyoWJm+hqRTm26hBZOm1Ozdeh0s+rF3pvjyb2U=
Date: Fri, 4 Sep 2026 18:56:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Gregory Price <gourry@gourry.net>, oe-kbuild-all@lists.linux.dev, David
 Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-new 301/316] mm/memory_hotplug.c:1507:13: warning:
 'node_is_memoryless' defined but not used
Message-Id: <20260904185658.cb3316b1d54ab7320620c26f@linux-foundation.org>
In-Reply-To: <202609050628.ywCLhOj5-lkp@intel.com>
References: <202609050628.ywCLhOj5-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 05 Sep 2026 06:32:19 +0800 kernel test robot <lkp@intel.com> wrote:

> Hi Gregory,
> 
> FYI, the error/warning was bisected to this commit, please ignore it if it's irrelevant.
> 
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   e3fc12b08aadde9cec7b3799ac0e0c9a1aa245c4
> commit: 77a622e07892674da28eb3ad349ddd96df10aded [301/316] mm/memory_hotplug: factor out node_is_memoryless()
> config: x86_64-randconfig-161-20260904 (https://download.01.org/0day-ci/archive/20260905/202609050628.ywCLhOj5-lkp@intel.com/config)
> compiler: gcc-13 (Debian 13.3.0-16) 13.3.0
> smatch: v0.5.0-9187-g5189e3fb
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260905/202609050628.ywCLhOj5-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202609050628.ywCLhOj5-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
> >> mm/memory_hotplug.c:1507:13: warning: 'node_is_memoryless' defined but not used [-Wunused-function]
>     1507 | static bool node_is_memoryless(int nid)
>          |             ^~~~~~~~~~~~~~~~~~

Thanks.  Let me try this:

--- a/mm/memory_hotplug.c~mm-memory_hotplug-factor-out-node_is_memoryless-fix
+++ a/mm/memory_hotplug.c
@@ -1491,36 +1491,6 @@ out:
 	return ret;
 }
 
-static int check_no_memblock_for_node_cb(struct memory_block *mem, void *arg)
-{
-	int nid = *(int *)arg;
-
-	/*
-	 * If a memory block belongs to multiple nodes, the stored nid is not
-	 * reliable. However, such blocks are always online (e.g., cannot get
-	 * offlined) and, therefore, are still spanned by the node.
-	 */
-	return mem->nid == nid ? -EEXIST : 0;
-}
-
-/* Caller must hold the memory hotplug lock for this check. */
-static bool node_is_memoryless(int nid)
-{
-	/*
-	 * A node still spanning pages (especially ZONE_DEVICE) is not
-	 * memoryless.  A node spans memory after move_pfn_range_to_zone(),
-	 * e.g. once a memory block has been onlined.
-	 */
-	if (node_spanned_pages(nid))
-		return false;
-	/*
-	 * Offline memory blocks may not be spanned by the node yet, but they
-	 * link to it in sysfs and can be onlined later, so the node is not
-	 * memoryless while any remain.
-	 */
-	return !for_each_memory_block(&nid, check_no_memblock_for_node_cb);
-}
-
 /*
  * NOTE: The caller must call lock_device_hotplug() to serialize hotplug
  * and online/offline operations (triggered e.g. by sysfs).
@@ -1815,6 +1785,37 @@ bool mhp_range_allowed(u64 start, u64 si
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
+
+static int check_no_memblock_for_node_cb(struct memory_block *mem, void *arg)
+{
+	int nid = *(int *)arg;
+
+	/*
+	 * If a memory block belongs to multiple nodes, the stored nid is not
+	 * reliable. However, such blocks are always online (e.g., cannot get
+	 * offlined) and, therefore, are still spanned by the node.
+	 */
+	return mem->nid == nid ? -EEXIST : 0;
+}
+
+/* Caller must hold the memory hotplug lock for this check. */
+static bool node_is_memoryless(int nid)
+{
+	/*
+	 * A node still spanning pages (especially ZONE_DEVICE) is not
+	 * memoryless.  A node spans memory after move_pfn_range_to_zone(),
+	 * e.g. once a memory block has been onlined.
+	 */
+	if (node_spanned_pages(nid))
+		return false;
+	/*
+	 * Offline memory blocks may not be spanned by the node yet, but they
+	 * link to it in sysfs and can be onlined later, so the node is not
+	 * memoryless while any remain.
+	 */
+	return !for_each_memory_block(&nid, check_no_memblock_for_node_cb);
+}
+
 /*
  * Scan pfn range [start,end) to find movable/migratable pages (LRU and
  * hugetlb folio, movable_ops pages). Will skip over most unmovable
_


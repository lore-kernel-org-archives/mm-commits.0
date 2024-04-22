Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB5F50271
	for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2024 18:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713810181; cv=none; b=a5yV7zYCW9PLG9rcDNq/oC2VusVET+JnlM6GHD+l78RTCeo7N583EwURx8O9wyGssY/ZngctFBnBMpjW6qDYrEx9ZIBBJQDv9f9Re/E2UmtqhqtzmfOk2Wp+acNKzlZ70yCO25f4WlSxHKsdn0W51JphN6yVjH9pKV+IDoEl8BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713810181; c=relaxed/simple;
	bh=kbvXj/wr4AjPOX4DhAsDsV6y1MZXJTrWlC514eOKQTY=;
	h=Date:To:From:Subject:Message-Id; b=b4MS8lOsMNaJvK68gPDC6f9J+wGJSbbmYpckUcIrNXR28CxR0O8PdWXN21ttgYwG34C+KiDAFCIQWANY1/zoYwLjsflIl6fRnwaokVtqSkWeFPEwr5eHoD61paI+BOPgZ0nlyyqOut+zwmKLMFjzbOju6m8MNUmdX+KmfXcxL4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UiT6DdUh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UiT6DdUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC805C113CC;
	Mon, 22 Apr 2024 18:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713810180;
	bh=kbvXj/wr4AjPOX4DhAsDsV6y1MZXJTrWlC514eOKQTY=;
	h=Date:To:From:Subject:From;
	b=UiT6DdUh1Y/z72iTgw6I1JkHhSoI9EJeK3QoPO0NHCKT3AT3qAgrUNnn214fHY2Ww
	 WJ5xouwivzWVaw0AAoJq6EyTyqctAj4FDNfDhUKmrFd31g35ZRH0UltSYsxxG5wk7t
	 i3GQ7gRmexrGBKPSVljvTxf9wGpLlHdXcgZZE37c=
Date: Mon, 22 Apr 2024 11:23:00 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,qiang4.zhang@intel.com,mhiramat@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] bootconfig-use-memblock_free_late-to-free-xbc-memory-to-buddy-fix.patch removed from -mm tree
Message-Id: <20240422182300.AC805C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: bootconfig-use-memblock_free_late-to-free-xbc-memory-to-buddy-fix
has been removed from the -mm tree.  Its filename was
     bootconfig-use-memblock_free_late-to-free-xbc-memory-to-buddy-fix.patch

This patch was dropped because it was folded into bootconfig-use-memblock_free_late-to-free-xbc-memory-to-buddy.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: bootconfig-use-memblock_free_late-to-free-xbc-memory-to-buddy-fix
Date: Tue Apr 16 11:47:35 AM PDT 2024

fix kerneldoc

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Qiang Zhang <qiang4.zhang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bootconfig.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/bootconfig.c~bootconfig-use-memblock_free_late-to-free-xbc-memory-to-buddy-fix
+++ a/lib/bootconfig.c
@@ -901,7 +901,8 @@ static int __init xbc_parse_tree(void)
 }
 
 /**
- * xbc_exit() - Clean up all parsed bootconfig
+ * _xbc_exit() - Clean up all parsed bootconfig
+ * @early: in early xbc init error
  *
  * This clears all data structures of parsed bootconfig on memory.
  * If you need to reuse xbc_init() with new boot config, you can
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

bootconfig-use-memblock_free_late-to-free-xbc-memory-to-buddy.patch
selftests-harness-remove-use-of-line_max-fix.patch
selftests-harness-remove-use-of-line_max-fix-fix.patch
mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries-fix.patch
mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio-fix.patch
sh-remove-use-of-pg_arch_1-on-individual-pages-fix.patch
mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing-fix.patch
mm-allow-anon-exclusive-check-over-hugetlb-tail-pages-fix.patch
arm-mm-drop-vm_fault_badmap-vm_fault_badaccess-checkpatch-fixes.patch
mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios-fix.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch
__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch


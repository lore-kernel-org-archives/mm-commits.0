Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99188290DBB;
	Thu, 14 May 2026 00:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778719228; cv=none; b=i1vWFiays96IqPkiMhBx/fwrKUU+4Qb+NMgVI2uTY7n26a4VFxVxwAnev1dyeZ+RJ+cpZ11+lyF9CahfenlyQrboe1GvPL5P4ljVjLDLZMW6wfY3TAG0wZtodzBvuiTCBa6EqHG22VM0QtDHIporBNH0Xyy4xq2iJFRFSfR+d2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778719228; c=relaxed/simple;
	bh=CeihTzR7q96gBmVd/x4VzHowLuYK1aEesFjLnAAJ5wY=;
	h=Date:To:From:Subject:Message-Id; b=tn9GN3c6aHiTZv262MmJnmSECjn/TUAEhrfbF2IstDN3aauSCw3irqTwLYPnu9HIv4t7cjnhhPAevp0k/OhAS3ayxpELLM+8+Hi6/rKPK/3wQfWRv8c8E30vLH3PIzAP5khLQK9mmbT+VRqxod+DkrzhZSP2AVvqiM8kc2sIa4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PWmrCyPz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PWmrCyPz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71216C19425;
	Thu, 14 May 2026 00:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778719228;
	bh=CeihTzR7q96gBmVd/x4VzHowLuYK1aEesFjLnAAJ5wY=;
	h=Date:To:From:Subject:From;
	b=PWmrCyPz0jG88FxaptuUH8JHzTC86+pgnEyq7Vafr+ryvVxmf4a7o77roFF4pVbKV
	 2TWPUCgVsJ5ohebovHrhllwImicqOcteF9ovZu7YQPFHB7QnH4fMi6So7nCsdrmUEL
	 YRdgexgPxHwAV1lMO/2NtlfLjQYKncs+2gr44i4E=
Date: Wed, 13 May 2026 17:40:27 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.com,stable@vger.kernel.org,kbingham@kernel.org,jan.kiszka@siemens.com,hsj0512@snu.ac.kr,harry@kernel.org,hao.li@linux.dev,florian.fainelli@broadcom.com,illia@yshyn.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] scripts-gdb-mm-cast-untyped-symbols-in-x86_page_ops.patch removed from -mm tree
Message-Id: <20260514004028.71216C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/gdb: mm: cast untyped symbols in x86_page_ops
has been removed from the -mm tree.  Its filename was
     scripts-gdb-mm-cast-untyped-symbols-in-x86_page_ops.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Illia Ostapyshyn <illia@yshyn.com>
Subject: scripts/gdb: mm: cast untyped symbols in x86_page_ops
Date: Mon, 27 Apr 2026 16:24:47 +0200

The symbols phys_base, _text, and _end, used in x86_page_ops are either
defined in assembly or implicitly by the linker.  Thus, they lack type
information and cause a conversion error after gdb.parse_and_eval. 
Explicitly cast these expressions to unsigned long.

Link: https://lore.kernel.org/20260427142448.666117-2-illia@yshyn.com
Fixes: 55f8b4518d14 ("scripts/gdb: implement x86_page_ops in mm.py")
Signed-off-by: Illia Ostapyshyn <illia@yshyn.com>
Cc: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.com>
Cc: Hao Li <hao.li@linux.dev>
Cc: Harry Yoo <harry@kernel.org>
Cc: Seongjun Hong <hsj0512@snu.ac.kr>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/mm.py |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/scripts/gdb/linux/mm.py~scripts-gdb-mm-cast-untyped-symbols-in-x86_page_ops
+++ a/scripts/gdb/linux/mm.py
@@ -40,11 +40,11 @@ class x86_page_ops():
 
         self.PAGE_OFFSET = int(gdb.parse_and_eval("page_offset_base"))
         self.VMEMMAP_START = int(gdb.parse_and_eval("vmemmap_base"))
-        self.PHYS_BASE = int(gdb.parse_and_eval("phys_base"))
+        self.PHYS_BASE = int(gdb.parse_and_eval("(unsigned long) phys_base"))
         self.START_KERNEL_map = 0xffffffff80000000
 
-        self.KERNEL_START = gdb.parse_and_eval("_text")
-        self.KERNEL_END = gdb.parse_and_eval("_end")
+        self.KERNEL_START = gdb.parse_and_eval("(unsigned long) &_text")
+        self.KERNEL_END = gdb.parse_and_eval("(unsigned long) &_end")
 
         self.VMALLOC_START = int(gdb.parse_and_eval("vmalloc_base"))
         if self.VMALLOC_START == 0xffffc90000000000:
_

Patches currently in -mm which might be from illia@yshyn.com are



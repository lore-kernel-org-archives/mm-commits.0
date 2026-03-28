Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9C433557B;
	Sat, 28 Mar 2026 04:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671922; cv=none; b=ILTkhubK8FizFx4neoA1qWKcKGPhJJiTCxKus5ZmhUEC/dUD/GYXqvnHc+YvK49xiwY2sVJdK8wg2W8OvEnbPQkbZfrtEK6oLdQuIKb+7oKETM5pWtT1Fa02IQ1h8aA+3cPNUwTo9A4JdKq6mpmSWccIyK5VJ+gtscDrN8HZMlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671922; c=relaxed/simple;
	bh=8FPl9/q8zv53IgGIRA/JD2ZGMSCaF1t5e0LsHHVCG+c=;
	h=Date:To:From:Subject:Message-Id; b=Xc2YZI2NPGAmn6RVqMM+tUu3tSh/7oAyNOLk6JKH3yxi8Gj93XVGSXAMU0S9a19p20r1XBzNDdCHroEWUPuE7hrPLEYnusFg2e5HYO3tUDUxIvIqSWRhLS/97oqCERdKhFTYu5KM+FffBtTmd7vO9VeG2fqU4jpNZMTsIxQxacc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2PzSyEiB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2PzSyEiB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02CC7C4CEF7;
	Sat, 28 Mar 2026 04:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671922;
	bh=8FPl9/q8zv53IgGIRA/JD2ZGMSCaF1t5e0LsHHVCG+c=;
	h=Date:To:From:Subject:From;
	b=2PzSyEiBrHW6uyPHzlr11BODdwHLb+5fsxgrF1n29trCf/KeQxaGwRcG5xuGgmCZ0
	 5/twDkpLUp1SUgXJZT0mDq6NhH5bVv5fOhug8FK2gnbiSbekir2sEOA6fUpPnGLwvn
	 Vbw5Oe9oA1rg0DywrILUSnxFAWXYb3zocK9YdcIM=
Date: Fri, 27 Mar 2026 21:25:21 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kbingham@kernel.org,johannes.berg@intel.com,jan.kiszka@siemens.com,iii@linux.ibm.com,benjamin.berg@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-symbols-handle-module-path-parameters.patch removed from -mm tree
Message-Id: <20260328042522.02CC7C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/gdb/symbols: handle module path parameters
has been removed from the -mm tree.  Its filename was
     scripts-gdb-symbols-handle-module-path-parameters.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Benjamin Berg <benjamin.berg@intel.com>
Subject: scripts/gdb/symbols: handle module path parameters
Date: Wed, 4 Mar 2026 12:06:43 +0100

commit 581ee79a2547 ("scripts/gdb/symbols: make BPF debug info available
to GDB") added support to make BPF debug information available to GDB. 
However, the argument handling loop was slightly broken, causing it to
fail if further modules were passed.  Fix it to append these passed
modules to the instance variable after expansion.

Link: https://lkml.kernel.org/r/20260304110642.2020614-2-benjamin@sipsolutions.net
Fixes: 581ee79a2547 ("scripts/gdb/symbols: make BPF debug info available to GDB")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/symbols.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/gdb/linux/symbols.py~scripts-gdb-symbols-handle-module-path-parameters
+++ a/scripts/gdb/linux/symbols.py
@@ -298,7 +298,7 @@ are loaded as well."""
             if p == "-bpf":
                 monitor_bpf = True
             else:
-                p.append(os.path.abspath(os.path.expanduser(p)))
+                self.module_paths.append(os.path.abspath(os.path.expanduser(p)))
         self.module_paths.append(os.getcwd())
 
         if self.breakpoint is not None:
_

Patches currently in -mm which might be from benjamin.berg@intel.com are



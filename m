Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B95C27C14E
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 17:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747849753; cv=none; b=tXlHeTevoc1m8HDdA2whMD5b3d8B5NpNdYJqOjV3a3zSlHQJhoihwnj03GiUVmHvGLDXIAkJg3QO7du7AQOLqJ9SzuApnPpRVxiLBtiqSwwV98ONFm8D3CWYrLwyBwZZcN0Q0o6BfHsUbFNi8z1rpXo2+7E5sW9Gn6UrGQds/CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747849753; c=relaxed/simple;
	bh=KGEqqW5Fe1HN7j/q/IaMkmZCw70dxVvcAvWFWxPglU0=;
	h=Date:To:From:Subject:Message-Id; b=SJT/iaTzNzh1g7O+AHWJ1VeEHMO9G5zx+CHBH09qGN+Urn1GzTZPHFY2f88JSqlFwtehKJQJPU83pafCh7KsXMNbejOgbWjNNBkRjnMwyQ/26gmPju1M3+/32VCQ4yGaWMJBrft7wlXU99QkrqlX2aPKrry+4V8fsW5eotLOuWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LNRoffZE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LNRoffZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 275F1C4CEEB;
	Wed, 21 May 2025 17:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747849753;
	bh=KGEqqW5Fe1HN7j/q/IaMkmZCw70dxVvcAvWFWxPglU0=;
	h=Date:To:From:Subject:From;
	b=LNRoffZEdOTo5mDIMTq6ijpzJdhTuK7gvHjAUT7S08WxxUvpIj9wDRRbjqAbYXHsA
	 ToJN5HBH+Iglg2zmwD7cEIXCGp8Ea+/S26K4nThZGIlhuCx2hIRXZ8jhuBEEyZvApG
	 VXgE85ltkDWFLS6QRtc7CPIIReLVFQZOmTHJsCXY=
Date: Wed, 21 May 2025 10:49:12 -0700
To: mm-commits@vger.kernel.org,kbingham@kernel.org,jan.kiszka@siemens.com,hca@linux.ibm.com,gor@linux.ibm.com,agordeev@linux.ibm.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-symbols-factor-out-get_vmlinux.patch removed from -mm tree
Message-Id: <20250521174913.275F1C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/gdb/symbols: factor out get_vmlinux()
has been removed from the -mm tree.  Its filename was
     scripts-gdb-symbols-factor-out-get_vmlinux.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: scripts/gdb/symbols: factor out get_vmlinux()
Date: Thu, 15 May 2025 17:52:11 +0200

Patch series "scripts/gdb/symbols: determine KASLR offset on s390 during
early boot".

I noticed that debugging s390 early boot using the support I introduced in
commit 28939c3e9925 ("scripts/gdb/symbols: determine KASLR offset on
s390") does not work.

The reason is that decompressor does not provide the vmcoreinfo note, so
KASLR offset needs to be extracted in a different way, which this series
implements.  Patches 1-2 are trivial refactorings, and patch 3 is the
implementation.


This patch (of 3):

Move the code that determines the current vmlinux file into a separate
function.  It will be useful later in order to analyze the kernel image in
physical memory during s390 early boot.

Link: https://lkml.kernel.org/r/20250515155811.114392-1-iii@linux.ibm.com
Link: https://lkml.kernel.org/r/20250515155811.114392-2-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/symbols.py |    6 +-----
 scripts/gdb/linux/utils.py   |    9 +++++++++
 2 files changed, 10 insertions(+), 5 deletions(-)

--- a/scripts/gdb/linux/symbols.py~scripts-gdb-symbols-factor-out-get_vmlinux
+++ a/scripts/gdb/linux/symbols.py
@@ -178,11 +178,7 @@ lx-symbols command."""
                 saved_states.append({'breakpoint': bp, 'enabled': bp.enabled})
 
         # drop all current symbols and reload vmlinux
-        orig_vmlinux = 'vmlinux'
-        for obj in gdb.objfiles():
-            if (obj.filename.endswith('vmlinux') or
-                obj.filename.endswith('vmlinux.debug')):
-                orig_vmlinux = obj.filename
+        orig_vmlinux = utils.get_vmlinux()
         gdb.execute("symbol-file", to_string=True)
         kerneloffset = get_kerneloffset()
         if kerneloffset is None:
--- a/scripts/gdb/linux/utils.py~scripts-gdb-symbols-factor-out-get_vmlinux
+++ a/scripts/gdb/linux/utils.py
@@ -251,3 +251,12 @@ def parse_vmcore(s):
     else:
         kerneloffset = int(match.group(1), 16)
     return VmCore(kerneloffset=kerneloffset)
+
+
+def get_vmlinux():
+    vmlinux = 'vmlinux'
+    for obj in gdb.objfiles():
+        if (obj.filename.endswith('vmlinux') or
+            obj.filename.endswith('vmlinux.debug')):
+            vmlinux = obj.filename
+    return vmlinux
_

Patches currently in -mm which might be from iii@linux.ibm.com are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1BD21CA05
	for <mm-commits@vger.kernel.org>; Tue, 20 May 2025 00:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747700373; cv=none; b=jlqa/3TY8xHHatjOQhahf18u4Wa//1xDosYdO3qA2Ra1/bZoFtxijDel1z9sHoGi/HhcNVwTrGKQgzMNZbP6GDoRVUSpfK3anFJqH8reCShmHOPQae/dPGepeYWFsHmKGk+9fl3jcT9eKoCj2AcR32cjFEspD0ltyVm4OO1md3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747700373; c=relaxed/simple;
	bh=Wnl8sXNf4H2/XJfgicbp0vPa98m0OUuaC9YGbig/iTs=;
	h=Date:To:From:Subject:Message-Id; b=KBTa9qzqqkC32/1PAW4aX83I31625zFhtPhjMBVK62Z+dI+Rq9mcSL4dC/rKEl99yc2XCUgPslFc6WhbW4iS9DkJKffOLpmqIYzNFjdDxr/lecsjHOjXBKQzgWoK3VDYSXsHCcLLUoJCZHrx5c/kWE8neH2KcwaNS0IVtxjzN9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fKG++cTl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fKG++cTl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A91ABC4CEE4;
	Tue, 20 May 2025 00:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747700372;
	bh=Wnl8sXNf4H2/XJfgicbp0vPa98m0OUuaC9YGbig/iTs=;
	h=Date:To:From:Subject:From;
	b=fKG++cTlaqdIyK+mFCibwdwPE4lxNXDPijLE/q5yCozLYb1iRsnKB2VBvjW7W5YWo
	 vjZkChjS45i4k+b5uBdAi5vanwuxpEzXGwG89j4drtqiyt8b9V47niKhaq19pcpyDi
	 CovPNeNGBd1jHazEEXf8YwiyRXfzrlWWUi0W0SuU=
Date: Mon, 19 May 2025 17:19:31 -0700
To: mm-commits@vger.kernel.org,kbingham@kernel.org,jan.kiszka@siemens.com,hca@linux.ibm.com,gor@linux.ibm.com,agordeev@linux.ibm.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-symbols-factor-out-get_vmlinux.patch added to mm-nonmm-unstable branch
Message-Id: <20250520001932.A91ABC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/gdb/symbols: factor out get_vmlinux()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-symbols-factor-out-get_vmlinux.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-symbols-factor-out-get_vmlinux.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

scripts-gdb-symbols-factor-out-get_vmlinux.patch
scripts-gdb-symbols-factor-out-pagination_off.patch
scripts-gdb-symbols-determine-kaslr-offset-on-s390-during-early-boot.patch


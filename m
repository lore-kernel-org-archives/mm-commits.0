Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D33253B7A
	for <mm-commits@vger.kernel.org>; Tue, 20 May 2025 00:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747700375; cv=none; b=gnm57RYZzjLjXiMRbl/ijoaKrzzUqzCGTBnPjLOGAG621p9VNpbq1td36yuvbSfrWs4hCV1MFOneTpIwcSfuMY1ZIDSAwt9EuU8dMJjP2S+2B2gTolq8ZnPkbxibSEiiZGTRLqQAKNuf9g4L8nHtDCxACxA6OqjzcA+oEJwCLz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747700375; c=relaxed/simple;
	bh=UVhhMxndtVLLzgIAeBPoSt5k8wP6bos6uqdeFSuF+Es=;
	h=Date:To:From:Subject:Message-Id; b=OK1QR1mqKpSB8p/Z6/ZrGsokNJpAD1vj3iCUQ5frytauEHZLLez+Gj9U1l9eecnnSGN+T6UVATKX4Hr7TtuU1BwTWc7wJ256BEKfIE8YeLwpVra3YulyPl/NkJB+yAtfCMw7Jp0Pxi/rJ9mtmReJCn6jq8gL9TjSdlJ+VH90rHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sSpPlMqD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sSpPlMqD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C2EC4CEE4;
	Tue, 20 May 2025 00:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747700375;
	bh=UVhhMxndtVLLzgIAeBPoSt5k8wP6bos6uqdeFSuF+Es=;
	h=Date:To:From:Subject:From;
	b=sSpPlMqDf5gZ4GJoDVYHyOzQgihUpIhdNrYETj6cHfFIFaB0jhQY8Si2bQtFE4jZ8
	 +9uoTHG2diw/PpJ66WBbiaPIUhR2d4cGee2xYZ97aYOGPNF0oFmxOMEauVS3uD+qqg
	 IQmDgFl0yN/RVnUSyCLk6kg8hCc7OIduxEvh6HjY=
Date: Mon, 19 May 2025 17:19:34 -0700
To: mm-commits@vger.kernel.org,kbingham@kernel.org,jan.kiszka@siemens.com,hca@linux.ibm.com,gor@linux.ibm.com,agordeev@linux.ibm.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-symbols-factor-out-pagination_off.patch added to mm-nonmm-unstable branch
Message-Id: <20250520001934.E9C2EC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/gdb/symbols: factor out pagination_off()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-symbols-factor-out-pagination_off.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-symbols-factor-out-pagination_off.patch

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
Subject: scripts/gdb/symbols: factor out pagination_off()
Date: Thu, 15 May 2025 17:52:12 +0200

Move the code that turns off pagination into a separate function.  It will
be useful later in order to prevent hangs when loading symbols for kernel
image in physical memory during s390 early boot.

Link: https://lkml.kernel.org/r/20250515155811.114392-3-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/symbols.py |   20 +++++++-------------
 scripts/gdb/linux/utils.py   |   11 +++++++++++
 2 files changed, 18 insertions(+), 13 deletions(-)

--- a/scripts/gdb/linux/symbols.py~scripts-gdb-symbols-factor-out-pagination_off
+++ a/scripts/gdb/linux/symbols.py
@@ -38,19 +38,13 @@ if hasattr(gdb, 'Breakpoint'):
             # Disable pagination while reporting symbol (re-)loading.
             # The console input is blocked in this context so that we would
             # get stuck waiting for the user to acknowledge paged output.
-            show_pagination = gdb.execute("show pagination", to_string=True)
-            pagination = show_pagination.endswith("on.\n")
-            gdb.execute("set pagination off")
-
-            if module_name in cmd.loaded_modules:
-                gdb.write("refreshing all symbols to reload module "
-                          "'{0}'\n".format(module_name))
-                cmd.load_all_symbols()
-            else:
-                cmd.load_module_symbols(module)
-
-            # restore pagination state
-            gdb.execute("set pagination %s" % ("on" if pagination else "off"))
+            with utils.pagination_off():
+                if module_name in cmd.loaded_modules:
+                    gdb.write("refreshing all symbols to reload module "
+                              "'{0}'\n".format(module_name))
+                    cmd.load_all_symbols()
+                else:
+                    cmd.load_module_symbols(module)
 
             return False
 
--- a/scripts/gdb/linux/utils.py~scripts-gdb-symbols-factor-out-pagination_off
+++ a/scripts/gdb/linux/utils.py
@@ -260,3 +260,14 @@ def get_vmlinux():
             obj.filename.endswith('vmlinux.debug')):
             vmlinux = obj.filename
     return vmlinux
+
+
+@contextlib.contextmanager
+def pagination_off():
+    show_pagination = gdb.execute("show pagination", to_string=True)
+    pagination = show_pagination.endswith("on.\n")
+    gdb.execute("set pagination off")
+    try:
+        yield
+    finally:
+        gdb.execute("set pagination %s" % ("on" if pagination else "off"))
_

Patches currently in -mm which might be from iii@linux.ibm.com are

scripts-gdb-symbols-factor-out-get_vmlinux.patch
scripts-gdb-symbols-factor-out-pagination_off.patch
scripts-gdb-symbols-determine-kaslr-offset-on-s390-during-early-boot.patch


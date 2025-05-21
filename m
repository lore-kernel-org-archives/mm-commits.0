Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758A522F15E
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 17:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747849754; cv=none; b=mjeS47uAg/4BO3w+pbVbsrA8JKIZo8XbTsMEoBYKxlilpg5/zUbI2sIy5Y28Uuyv1158tPZQissu1K0VJdVPb9teAIRyyPF6iGrp+tJPGdXGrVcSR0RlW8Qm5whfDJ5Kz8XMYF94C9EC7VN5IKFr8meBRhRpXLGH5aTW4OTNg2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747849754; c=relaxed/simple;
	bh=D5vwctG0kQL3BIHf2QAi2uOxm/fjVcSEANxeAah1gFk=;
	h=Date:To:From:Subject:Message-Id; b=XB0WsnbYWPrNCZi/4/XTMOOrVfM8r7hUzyOoZ7BIx50FL61zHLJZTw8fmuppvRdhv09TgQEiboYG7Hqv8HMxf+2zSdF4GejbInHQQcbTOv6V5a0qtcEubOqApvvmUvwqaBnhbr50GB6huIbxMa+vHnp39tsSFIMs+wk4EY22sFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rTQMUUGP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rTQMUUGP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B95C4CEE4;
	Wed, 21 May 2025 17:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747849754;
	bh=D5vwctG0kQL3BIHf2QAi2uOxm/fjVcSEANxeAah1gFk=;
	h=Date:To:From:Subject:From;
	b=rTQMUUGPxuWOZ407HDzTwu4+Seek/Gqfshtdu76Cu752dgq1kYFmmtLpuR1QxjXIJ
	 8p71jOrFpOOc5MXF8nbhdwDHbmh8PZS2myN/Sp64FsuJhoeCDSarrq1pq1ALqT/EXN
	 Up0E4o3xswFtkbpgu9R0vQntxkdtDtT0VYD1v3jM=
Date: Wed, 21 May 2025 10:49:13 -0700
To: mm-commits@vger.kernel.org,kbingham@kernel.org,jan.kiszka@siemens.com,hca@linux.ibm.com,gor@linux.ibm.com,agordeev@linux.ibm.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-symbols-factor-out-pagination_off.patch removed from -mm tree
Message-Id: <20250521174914.49B95C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/gdb/symbols: factor out pagination_off()
has been removed from the -mm tree.  Its filename was
     scripts-gdb-symbols-factor-out-pagination_off.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



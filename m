From: akpm@linux-foundation.org
Subject: [merged] scripts-gdb-ignore-byte-compiled-python-files.patch
 removed from -mm tree
Date: Wed, 18 Feb 2015 11:44:36 -0800
Message-ID: <54e4eba4.WODrge0owcWRPEig%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46263 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432AbbBRToh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:44:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.thompson@linaro.org, andi@firstfloor.org, ben@bwidawsk.net, bp@suse.de, jan.kiszka@siemens.com, jason.wessel@windriver.com, mmarek@suse.cz, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: ignore byte-compiled python files
has been removed from the -mm tree.  Its filename was
     scripts-gdb-ignore-byte-compiled-python-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Thompson <daniel.thompson@linaro.org>
Subject: scripts/gdb: ignore byte-compiled python files

Using the gdb scripts leaves byte-compiled python files in the scripts/
directory.  These should be ignored by git.

[jan.kiszka@siemens.com: drop redundant mrproper rule as suggested by Michal]
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ben Widawsky <ben@bwidawsk.net>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .gitignore                   |    1 +
 scripts/gdb/linux/.gitignore |    2 ++
 2 files changed, 3 insertions(+)

diff -puN .gitignore~scripts-gdb-ignore-byte-compiled-python-files .gitignore
--- a/.gitignore~scripts-gdb-ignore-byte-compiled-python-files
+++ a/.gitignore
@@ -43,6 +43,7 @@ Module.symvers
 /TAGS
 /linux
 /vmlinux
+/vmlinux-gdb.py
 /vmlinuz
 /System.map
 /Module.markers
diff -puN /dev/null scripts/gdb/linux/.gitignore
--- /dev/null
+++ a/scripts/gdb/linux/.gitignore
@@ -0,0 +1,2 @@
+*.pyc
+*.pyo
_

Patches currently in -mm which might be from daniel.thompson@linaro.org are

origin.patch
debug-prevent-entering-debug-mode-on-panic-exception.patch
linux-next.patch


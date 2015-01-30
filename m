From: akpm@linux-foundation.org
Subject: + scripts-gdb-ignore-byte-compiled-python-files.patch added to
 -mm tree
Date: Fri, 30 Jan 2015 15:37:01 -0800
Message-ID: <54cc159d.t0YFrf4VmP4auWc/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49135 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763145AbbA3XhC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Jan 2015 18:37:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.thompson@linaro.org, andi@firstfloor.org, ben@bwidawsk.net, bp@suse.de, jan.kiszka@siemens.com, jason.wessel@windriver.com, mmarek@suse.cz, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: ignore byte-compiled python files
has been added to the -mm tree.  Its filename is
     scripts-gdb-ignore-byte-compiled-python-files.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-ignore-byte-compiled-python-files.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-ignore-byte-compiled-python-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

debug-prevent-entering-debug-mode-on-panic-exception.patch
scripts-gdb-ignore-byte-compiled-python-files.patch
linux-next.patch


From: akpm@linux-foundation.org
Subject: + mm-process_vm_access-move-config-option-into-init-kconfig.patch added to -mm tree
Date: Tue, 27 May 2014 13:52:15 -0700
Message-ID: <5384faff.sSyZsvXp63U8A/xf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbaE0UwQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 May 2014 16:52:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, hughd@google.com, davidlohr@hp.com, cyeoh@au1.ibm.com, koct9i@gmail.com

Subject: + mm-process_vm_access-move-config-option-into-init-kconfig.patch added to -mm tree
To: koct9i@gmail.com,cyeoh@au1.ibm.com,davidlohr@hp.com,hughd@google.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Tue, 27 May 2014 13:52:15 -0700


The patch titled
     Subject: mm/process_vm_access: move config option into init/Kconfig
has been added to the -mm tree.  Its filename is
     mm-process_vm_access-move-config-option-into-init-kconfig.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-process_vm_access-move-config-option-into-init-kconfig.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-process_vm_access-move-config-option-into-init-kconfig.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: mm/process_vm_access: move config option into init/Kconfig

CONFIG_CROSS_MEMORY_ATTACH adds couple syscalls: process_vm_readv and
process_vm_writev, it's a kind of IPC for copying data between processes. 
Currently this option is placed inside "Processor type and features".

This patch moves it into "General setup" (where all other arch-independed
syscalls and ipc features are placed) and changes prompt string to less
cryptic.

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Christopher Yeoh <cyeoh@au1.ibm.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |   10 ++++++++++
 mm/Kconfig   |   10 ----------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff -puN init/Kconfig~mm-process_vm_access-move-config-option-into-init-kconfig init/Kconfig
--- a/init/Kconfig~mm-process_vm_access-move-config-option-into-init-kconfig
+++ a/init/Kconfig
@@ -261,6 +261,16 @@ config POSIX_MQUEUE_SYSCTL
 	depends on SYSCTL
 	default y
 
+config CROSS_MEMORY_ATTACH
+	bool "Enable process_vm_readv/writev syscalls"
+	depends on MMU
+	default y
+	help
+	  Enabling this option adds the system calls process_vm_readv and
+	  process_vm_writev which allow a process with the correct privileges
+	  to directly read from or write to to another process's address space.
+	  See the man page for more details.
+
 config FHANDLE
 	bool "open by fhandle syscalls"
 	select EXPORTFS
diff -puN mm/Kconfig~mm-process_vm_access-move-config-option-into-init-kconfig mm/Kconfig
--- a/mm/Kconfig~mm-process_vm_access-move-config-option-into-init-kconfig
+++ a/mm/Kconfig
@@ -430,16 +430,6 @@ choice
 	  benefit.
 endchoice
 
-config CROSS_MEMORY_ATTACH
-	bool "Cross Memory Support"
-	depends on MMU
-	default y
-	help
-	  Enabling this option adds the system calls process_vm_readv and
-	  process_vm_writev which allow a process with the correct privileges
-	  to directly read from or write to to another process's address space.
-	  See the man page for more details.

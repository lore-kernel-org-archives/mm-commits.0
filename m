From: akpm@linux-foundation.org
Subject: [merged]
 mm-process_vm_access-move-config-option-into-init-kconfig.patch removed
 from -mm tree
Date: Thu, 05 Jun 2014 12:53:23 -0700
Message-ID: <5390cab3.+GTcopdpGd7VFZzH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56590 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbaFETxY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:53:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, hughd@google.com, davidlohr@hp.com, cyeoh@au1.ibm.com, koct9i@gmail.com

Subject: [merged] mm-process_vm_access-move-config-option-into-init-kconfig.patch removed from -mm tree
To: koct9i@gmail.com,cyeoh@au1.ibm.com,davidlohr@hp.com,hughd@google.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:53:23 -0700


The patch titled
     Subject: mm/process_vm_access: move config option into init/Kconfig
has been removed from the -mm tree.  Its filename was
     mm-process_vm_access-move-config-option-into-init-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -436,16 +436,6 @@ choice
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

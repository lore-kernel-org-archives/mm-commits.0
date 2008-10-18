From: akpm@linux-foundation.org
Subject: - taint-fix-kernel-doc.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:12:26 -0700
Message-ID: <200810182312.m9INCQ4B027997@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751369AbYJRXN0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:13:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, andi@firstfloor.org, mm-commits@vger.kernel.org


The patch titled
     taint: fix kernel-doc
has been removed from the -mm tree.  Its filename was
     taint-fix-kernel-doc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: taint: fix kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

Move print_tainted() kernel-doc to avoid the following error:

Error(/var/linsrc/mmotm-2008-1002-1617//kernel/panic.c:155): cannot understand prototype: 'struct tnt '

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff -puN kernel/panic.c~taint-fix-kernel-doc kernel/panic.c
--- a/kernel/panic.c~taint-fix-kernel-doc
+++ a/kernel/panic.c
@@ -143,21 +143,6 @@ NORET_TYPE void panic(const char * fmt, 
 
 EXPORT_SYMBOL(panic);
 
-/**
- *	print_tainted - return a string to represent the kernel taint state.
- *
- *  'P' - Proprietary module has been loaded.
- *  'F' - Module has been forcibly loaded.
- *  'S' - SMP with CPUs not designed for SMP.
- *  'R' - User forced a module unload.
- *  'M' - System experienced a machine check exception.
- *  'B' - System has hit bad_page.
- *  'U' - Userspace-defined naughtiness.
- *  'A' - ACPI table overridden.
- *  'W' - Taint on warning.
- *
- *	The string is overwritten by the next call to print_taint().
- */
 
 struct tnt {
 	u8 bit;
@@ -178,6 +163,21 @@ static const struct tnt tnts[] = {
 	{ TAINT_WARN, 'W', ' ' },
 };
 
+/**
+ *	print_tainted - return a string to represent the kernel taint state.
+ *
+ *  'P' - Proprietary module has been loaded.
+ *  'F' - Module has been forcibly loaded.
+ *  'S' - SMP with CPUs not designed for SMP.
+ *  'R' - User forced a module unload.
+ *  'M' - System experienced a machine check exception.
+ *  'B' - System has hit bad_page.
+ *  'U' - Userspace-defined naughtiness.
+ *  'A' - ACPI table overridden.
+ *  'W' - Taint on warning.
+ *
+ *	The string is overwritten by the next call to print_taint().
+ */
 const char *print_tainted(void)
 {
 	static char buf[ARRAY_SIZE(tnts) + sizeof("Tainted: ") + 1];
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
memory_probe-fix-wrong-sysfs-file-attribute.patch
memory_probe-fix-wrong-sysfs-file-attribute-fix.patch


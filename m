From: akpm@linux-foundation.org
Subject: [withdrawn] exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch removed from -mm tree
Date: Wed, 09 Feb 2011 18:08:10 -0800
Message-ID: <201102100208.p1A28AhJ002406@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753618Ab1BJCJ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Feb 2011 21:09:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddaney@caviumnetworks.com, akpm@linux-foundation.org, arnd@arndb.de, benh@kernel.crashing.org, cmetcalf@tilera.com, davem@davemloft.net, deller@gmx.de, heiko.carstens@de.ibm.com, hpa@


The patch titled
     exec_domain: establish a Linux32 domain on CONFIG_COMPAT systems
has been removed from the -mm tree.  Its filename was
     exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: exec_domain: establish a Linux32 domain on CONFIG_COMPAT systems
From: David Daney <ddaney@caviumnetworks.com>

If PER_LINUX32 is set calling sys_personality, we will try to find the
corresponding exec_domain.  This causes us to try to load a module for
personality-8.  After running the userspace module loader and failing to
find the module, we fall back to the default.

We can avoid the failed module loading overhead by building-in the
linux32_exec_domain for systems that have CONFIG_COMPAT.

I noticed this on MIPS64 systems, but it is a general problem and applies
to x86 among others.  Admittedly sys_personality() is probably not in the
hot path of many programs, but the overhead of the extra exec_domain is
fairly small.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: David Miller <davem@davemloft.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exec_domain.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN kernel/exec_domain.c~exec_domain-establish-a-linux32-domain-on-config_compat-systems kernel/exec_domain.c
--- a/kernel/exec_domain.c~exec_domain-establish-a-linux32-domain-on-config_compat-systems
+++ a/kernel/exec_domain.c
@@ -34,6 +34,17 @@ static unsigned long ident_map[32] = {
 	24,	25,	26,	27,	28,	29,	30,	31
 };
 
+#ifdef CONFIG_COMPAT
+static struct exec_domain linux32_exec_domain = {
+	.name		= "Linux32",		/* name */
+	.handler	= default_handler,	/* lcall7 causes a seg fault. */
+	.pers_low	= PER_LINUX32,
+	.pers_high	= PER_LINUX32,
+	.signal_map	= ident_map,		/* Identity map signals. */
+	.signal_invmap	= ident_map,		/*  - both ways. */
+};
+#endif
+
 struct exec_domain default_exec_domain = {
 	.name		= "Linux",		/* name */
 	.handler	= default_handler,	/* lcall7 causes a seg fault. */
@@ -41,6 +52,9 @@ struct exec_domain default_exec_domain =
 	.pers_high	= 0,			/* PER_LINUX personality. */
 	.signal_map	= ident_map,		/* Identity map signals. */
 	.signal_invmap	= ident_map,		/*  - both ways. */
+#ifdef CONFIG_COMPAT
+	.next		= &linux32_exec_domain,
+#endif
 };
 
 
_

Patches currently in -mm which might be from ddaney@caviumnetworks.com are

linux-next.patch
binfmt_elf-quiet-gcc-46-set-but-not-used-warning-in-load_elf_binary.patch


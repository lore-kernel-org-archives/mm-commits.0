From: akpm@linux-foundation.org
Subject: [merged] um-disable-config_cmpxchg_local.patch removed from -mm tree
Date: Mon, 18 Apr 2011 11:03:14 -0700
Message-ID: <201104181759.p3IHxPiU016151@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756220Ab1DRSAE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Apr 2011 14:00:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@nod.at, penberg@kernel.org, slyich@gmail.com, mm-commits@vger.kernel.org


The patch titled
     um: disable CONFIG_CMPXCHG_LOCAL
has been removed from the -mm tree.  Its filename was
     um-disable-config_cmpxchg_local.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: disable CONFIG_CMPXCHG_LOCAL
From: Richard Weinberger <richard@nod.at>

Commit 8a5ec0ba "Lockless (and preemptless) fastpaths for slub" makes use
of this_cpu_cmpxchg_double() which needs this_cpu_cmpxchg16b_emu() on
x86_64.  Implementing cmpxchg16b emulation for UML would introduce too
much complexity.  So just disable it.

Signed-off-by: Richard Weinberger <richard@nod.at>
Reported-by: Sergei Trofimovich <slyich@gmail.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig.x86 |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN arch/um/Kconfig.x86~um-disable-config_cmpxchg_local arch/um/Kconfig.x86
--- a/arch/um/Kconfig.x86~um-disable-config_cmpxchg_local
+++ a/arch/um/Kconfig.x86
@@ -4,6 +4,10 @@ menu "UML-specific options"
 
 menu "Host processor type and features"
 
+config CMPXCHG_LOCAL
+	bool
+	default n
+
 source "arch/x86/Kconfig.cpu"
 
 endmenu
_

Patches currently in -mm which might be from richard@nod.at are

origin.patch


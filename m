From: akpm@linux-foundation.org
Subject: [merged]
 cris-make-etrax_arch_v10-select-tty-for-use-in-debugport.patch removed from -mm tree
Date: Tue, 08 Apr 2014 14:31:45 -0700
Message-ID: <53446ac1.1y2uVzWUHKd03vLD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525AbaDHVbq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:31:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, starvik@axis.com, sfr@canb.auug.org.au, jesper.nilsson@axis.com, josh@joshtriplett.org

Subject: [merged] cris-make-etrax_arch_v10-select-tty-for-use-in-debugport.patch removed from -mm tree
To: josh@joshtriplett.org,jesper.nilsson@axis.com,sfr@canb.auug.org.au,starvik@axis.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:31:45 -0700


The patch titled
     Subject: cris: make ETRAX_ARCH_V10 select TTY for use in debugport
has been removed from the -mm tree.  Its filename was
     cris-make-etrax_arch_v10-select-tty-for-use-in-debugport.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Josh Triplett <josh@joshtriplett.org>
Subject: cris: make ETRAX_ARCH_V10 select TTY for use in debugport

Fix breakage which will be exposed by the patch "kconfig: make allnoconfig
disable options behind EMBEDDED and EXPERT".

arch/cris/arch-v10/kernel/debugport.c, compiled in unconditionally with
ETRAX_ARCH_V10, requires TTY, so select TTY to avoid a build failure.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/cris/Kconfig~cris-make-etrax_arch_v10-select-tty-for-use-in-debugport arch/cris/Kconfig
--- a/arch/cris/Kconfig~cris-make-etrax_arch_v10-select-tty-for-use-in-debugport
+++ a/arch/cris/Kconfig
@@ -138,6 +138,7 @@ config ETRAX_ARCH_V10
        bool
        default y if ETRAX100LX || ETRAX100LX_V2
        default n if !(ETRAX100LX || ETRAX100LX_V2)
+       select TTY
 
 config ETRAX_ARCH_V32
        bool
_

Patches currently in -mm which might be from josh@joshtriplett.org are

origin.patch


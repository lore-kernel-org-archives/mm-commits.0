From: akpm@linux-foundation.org
Subject: [merged]
 ia64-select-config_tty-for-use-of-tty_write_message-in-unaligned.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 14:32:49 -0700
Message-ID: <53446b01.IXNf/K+fC0Q7SSRS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57037 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757536AbaDHVcu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:32:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tony.luck@intel.com, sfr@canb.auug.org.au, josh@joshtriplett.org

Subject: [merged] ia64-select-config_tty-for-use-of-tty_write_message-in-unaligned.patch removed from -mm tree
To: josh@joshtriplett.org,sfr@canb.auug.org.au,tony.luck@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:32:49 -0700


The patch titled
     Subject: ia64: select CONFIG_TTY for use of tty_write_message in unaligned
has been removed from the -mm tree.  Its filename was
     ia64-select-config_tty-for-use-of-tty_write_message-in-unaligned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Josh Triplett <josh@joshtriplett.org>
Subject: ia64: select CONFIG_TTY for use of tty_write_message in unaligned

Fix breakage which will be exposed by the patch "kconfig: make allnoconfig
disable options behind EMBEDDED and EXPERT".

arch/ia64/kernel/unaligned.c uses tty_write_message to print an
unaligned access exception to the TTY of the current user process.
Enable TTY to prevent a build error.

Minimal fix, on the basis that few people on ia64 will care deeply about
kernel size enough to turn off TTY.  Ideally, I'd instead suggest
dropping the tty_write_message entirely, and just leaving the printk.
Bonus: no need to sprintf first.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/ia64/Kconfig~ia64-select-config_tty-for-use-of-tty_write_message-in-unaligned arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~ia64-select-config_tty-for-use-of-tty_write_message-in-unaligned
+++ a/arch/ia64/Kconfig
@@ -21,6 +21,7 @@ config IA64
 	select HAVE_FUNCTION_TRACER
 	select HAVE_DMA_ATTRS
 	select HAVE_KVM
+	select TTY
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_DMA_API_DEBUG
 	select HAVE_MEMBLOCK
_

Patches currently in -mm which might be from josh@joshtriplett.org are

origin.patch


From: akpm@linux-foundation.org
Subject: - use-warn-in-arch-x86-mm-ioremapc.patch removed from -mm tree
Date: Fri, 22 Aug 2008 15:55:50 -0700
Message-ID: <200808222255.m7MMtoln020857@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753111AbYHVW4f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Aug 2008 18:56:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Use WARN() in arch/x86/mm/ioremap.c
has been removed from the -mm tree.  Its filename was
     use-warn-in-arch-x86-mm-ioremapc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Use WARN() in arch/x86/mm/ioremap.c
From: Arjan van de Ven <arjan@linux.intel.com>

Use WARN() instead of a printk+WARN_ON() pair; this way the message becomes
part of the warning section for better reporting/collection.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/ioremap.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN arch/x86/mm/ioremap.c~use-warn-in-arch-x86-mm-ioremapc arch/x86/mm/ioremap.c
--- a/arch/x86/mm/ioremap.c~use-warn-in-arch-x86-mm-ioremapc
+++ a/arch/x86/mm/ioremap.c
@@ -553,13 +553,11 @@ static int __init check_early_ioremap_le
 {
 	if (!early_ioremap_nested)
 		return 0;

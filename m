From: akpm@linux-foundation.org
Subject: [merged]
 reboot-remove-stable-friendly-pf_thread_bound-define.patch removed from -mm tree
Date: Tue, 09 Jul 2013 16:22:09 -0700
Message-ID: <51dc9b21.iYjNulF5aixz+Vgj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39237 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab3GIXWK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:22:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rmk+kernel@arm.linux.org.uk, rja@sgi.com, mingo@kernel.org, hpa@zytor.com, gxt@mprc.pku.edu.cn, holt@sgi.com

Subject: [merged] reboot-remove-stable-friendly-pf_thread_bound-define.patch removed from -mm tree
To: holt@sgi.com,gxt@mprc.pku.edu.cn,hpa@zytor.com,mingo@kernel.org,rja@sgi.com,rmk+kernel@arm.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:22:09 -0700


The patch titled
     Subject: reboot: remove -stable friendly PF_THREAD_BOUND define
has been removed from the -mm tree.  Its filename was
     reboot-remove-stable-friendly-pf_thread_bound-define.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Robin Holt <holt@sgi.com>
Subject: reboot: remove -stable friendly PF_THREAD_BOUND define

Remove the prior patch's #define for easier backporting to the stable
releases.

Signed-off-by: Robin Holt <holt@sgi.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN kernel/sys.c~reboot-remove-stable-friendly-pf_thread_bound-define kernel/sys.c
--- a/kernel/sys.c~reboot-remove-stable-friendly-pf_thread_bound-define
+++ a/kernel/sys.c
@@ -362,11 +362,6 @@ int unregister_reboot_notifier(struct no
 }
 EXPORT_SYMBOL(unregister_reboot_notifier);
 
-/* Add backwards compatibility for stable trees. */
-#ifndef PF_NO_SETAFFINITY
-#define PF_NO_SETAFFINITY		PF_THREAD_BOUND
-#endif

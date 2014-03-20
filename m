From: akpm@linux-foundation.org
Subject: [merged]
 pstore-skip-zero-size-persistent-ram-buffer-in-traverse.patch removed from
 -mm tree
Date: Thu, 20 Mar 2014 12:42:46 -0700
Message-ID: <532b44b6.heEBQMc6UgmgzhDO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33483 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933089AbaCTTmr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Mar 2014 15:42:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yanmin_zhang@linux.intel.com, tony.luck@intel.com, keescook@chromium.org, ccross@android.com, shuox.liu@intel.com

Subject: [merged] pstore-skip-zero-size-persistent-ram-buffer-in-traverse.patch removed from -mm tree
To: shuox.liu@intel.com,ccross@android.com,keescook@chromium.org,tony.luck@intel.com,yanmin_zhang@linux.intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 20 Mar 2014 12:42:46 -0700


The patch titled
     Subject: pstore: skip zero size persistent ram buffer in traverse
has been removed from the -mm tree.  Its filename was
     pstore-skip-zero-size-persistent-ram-buffer-in-traverse.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Liu ShuoX <shuox.liu@intel.com>
Subject: pstore: skip zero size persistent ram buffer in traverse

In ramoops_pstore_read, a valid prz pointer with zero size buffer will
break traverse of all persistent ram buffers.  The latter buffer might be
lost.

Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Colin Cross <ccross@android.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pstore/ram.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/pstore/ram.c~pstore-skip-zero-size-persistent-ram-buffer-in-traverse fs/pstore/ram.c
--- a/fs/pstore/ram.c~pstore-skip-zero-size-persistent-ram-buffer-in-traverse
+++ a/fs/pstore/ram.c
@@ -120,12 +120,12 @@ ramoops_get_next_prz(struct persistent_r
 
 	prz = przs[i];
 
-	if (update) {
-		/* Update old/shadowed buffer. */
+	/* Update old/shadowed buffer. */
+	if (update)
 		persistent_ram_save_old(prz);
-		if (!persistent_ram_old_size(prz))
-			return NULL;
-	}
+
+	if (!persistent_ram_old_size(prz))
+		return NULL;
 
 	*typep = type;
 	*id = i;
_

Patches currently in -mm which might be from shuox.liu@intel.com are

linux-next.patch


From: akpm@linux-foundation.org
Subject: + pstore-skip-zero-size-persistent-ram-buffer-in-traverse.patch
 added to -mm tree
Date: Tue, 04 Mar 2014 13:50:26 -0800
Message-ID: <53164aa2.s3EyP8aIzyWtJX+M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42583 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072AbaCDVu1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 16:50:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yanmin_zhang@linux.intel.com, tony.luck@intel.com, keescook@chromium.org, ccross@android.com, shuox.liu@intel.com

Subject: + pstore-skip-zero-size-persistent-ram-buffer-in-traverse.patch added to -mm tree
To: shuox.liu@intel.com,ccross@android.com,keescook@chromium.org,tony.luck@intel.com,yanmin_zhang@linux.intel.com
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 13:50:26 -0800


The patch titled
     Subject: pstore: skip zero size persistent ram buffer in traverse
has been added to the -mm tree.  Its filename is
     pstore-skip-zero-size-persistent-ram-buffer-in-traverse.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pstore-skip-zero-size-persistent-ram-buffer-in-traverse.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pstore-skip-zero-size-persistent-ram-buffer-in-traverse.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -119,12 +119,12 @@ ramoops_get_next_prz(struct persistent_r
 
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

pstore-reset-ftrace_read_cnt-at-ramoops_pstore_open.patch
pstore-skip-zero-size-persistent-ram-buffer-in-traverse.patch


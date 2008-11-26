From: akpm@linux-foundation.org
Subject: - quota-remove-compatibility-function-sb_any_quota_enabled.patch removed from -mm tree
Date: Wed, 26 Nov 2008 12:27:21 -0800
Message-ID: <200811262027.mAQKRLHx000486@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60382 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752473AbYKZUhl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Nov 2008 15:37:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     quota: remove compatibility function sb_any_quota_enabled()
has been removed from the -mm tree.  Its filename was
     quota-remove-compatibility-function-sb_any_quota_enabled.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota: remove compatibility function sb_any_quota_enabled()
From: Jan Kara <jack@suse.cz>

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/quotaops.h |    6 ------
 1 file changed, 6 deletions(-)

diff -puN include/linux/quotaops.h~quota-remove-compatibility-function-sb_any_quota_enabled include/linux/quotaops.h
--- a/include/linux/quotaops.h~quota-remove-compatibility-function-sb_any_quota_enabled
+++ a/include/linux/quotaops.h
@@ -116,9 +116,6 @@ static inline int sb_any_quota_active(st
 	       sb_has_quota_active(sb, GRPQUOTA);
 }
 
-/* For backward compatibility until we remove all users */
-#define sb_any_quota_enabled(sb) sb_any_quota_active(sb)
-
 /*
  * Operations supported for diskquotas.
  */
@@ -262,9 +259,6 @@ static inline int sb_any_quota_active(st
 	return 0;
 }
 
-/* For backward compatibility until we remove all users */
-#define sb_any_quota_enabled(sb) sb_any_quota_active(sb)

From: akpm@linux-foundation.org
Subject: + bio-remove-unused-macro-bip_vec_idx.patch added to -mm tree
Date: Tue, 24 Jun 2014 14:58:21 -0700
Message-ID: <53a9f47d.JXDlzVdlivYEsfqv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37195 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbaFXV6V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jun 2014 17:58:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guz.fnst@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/bio.h: remove unused macro bip_vec_idx()
has been added to the -mm tree.  Its filename is
     bio-remove-unused-macro-bip_vec_idx.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bio-remove-unused-macro-bip_vec_idx.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bio-remove-unused-macro-bip_vec_idx.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: include/linux/bio.h: remove unused macro bip_vec_idx()

Macro bip_vec_idx() was used by bio integrity originally, but no longer
used now. So remove it.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bio.h |    4 ----
 1 file changed, 4 deletions(-)

diff -puN include/linux/bio.h~bio-remove-unused-macro-bip_vec_idx include/linux/bio.h
--- a/include/linux/bio.h~bio-remove-unused-macro-bip_vec_idx
+++ a/include/linux/bio.h
@@ -644,10 +644,6 @@ struct biovec_slab {
 
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
 
-
-
-#define bip_vec_idx(bip, idx)	(&(bip->bip_vec[(idx)]))

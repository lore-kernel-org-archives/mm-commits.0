From: akpm@linux-foundation.org
Subject: [to-be-updated]
 pstore-reset-ftrace_read_cnt-at-ramoops_pstore_open.patch removed from -mm
 tree
Date: Mon, 10 Mar 2014 11:59:28 -0700
Message-ID: <531e0b90.iOH4qgEcA/4mC2do%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39961 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbaCJS73 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Mar 2014 14:59:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yanmin_zhang@linux.intel.com, tony.luck@intel.com, keescook@chromium.org, ccross@android.com, shuox.liu@intel.com

Subject: [to-be-updated] pstore-reset-ftrace_read_cnt-at-ramoops_pstore_open.patch removed from -mm tree
To: shuox.liu@intel.com,ccross@android.com,keescook@chromium.org,tony.luck@intel.com,yanmin_zhang@linux.intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 10 Mar 2014 11:59:28 -0700


The patch titled
     Subject: pstore: reset ftrace_read_cnt at ramoops_pstore_open
has been removed from the -mm tree.  Its filename was
     pstore-reset-ftrace_read_cnt-at-ramoops_pstore_open.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Liu ShuoX <shuox.liu@intel.com>
Subject: pstore: reset ftrace_read_cnt at ramoops_pstore_open

ftrace_read_cnt must be reset in open to support getting the records
multiple times.

Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Colin Cross <ccross@android.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pstore/ram.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/pstore/ram.c~pstore-reset-ftrace_read_cnt-at-ramoops_pstore_open fs/pstore/ram.c
--- a/fs/pstore/ram.c~pstore-reset-ftrace_read_cnt-at-ramoops_pstore_open
+++ a/fs/pstore/ram.c
@@ -101,6 +101,7 @@ static int ramoops_pstore_open(struct ps
 
 	cxt->dump_read_cnt = 0;
 	cxt->console_read_cnt = 0;
+	cxt->ftrace_read_cnt = 0;
 	return 0;
 }
 
_

Patches currently in -mm which might be from shuox.liu@intel.com are

pstore-clarify-clearing-of-_read_cnt-in-ramoops_context.patch
pstore-skip-zero-size-persistent-ram-buffer-in-traverse.patch


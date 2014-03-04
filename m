From: akpm@linux-foundation.org
Subject: + pstore-reset-ftrace_read_cnt-at-ramoops_pstore_open.patch added to -mm tree
Date: Tue, 04 Mar 2014 13:50:25 -0800
Message-ID: <53164aa1.pMXPWgRVedGNWa7F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42579 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072AbaCDVu0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 16:50:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yanmin_zhang@linux.intel.com, tony.luck@intel.com, keescook@chromium.org, ccross@android.com, shuox.liu@intel.com

Subject: + pstore-reset-ftrace_read_cnt-at-ramoops_pstore_open.patch added to -mm tree
To: shuox.liu@intel.com,ccross@android.com,keescook@chromium.org,tony.luck@intel.com,yanmin_zhang@linux.intel.com
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 13:50:25 -0800


The patch titled
     Subject: pstore: reset ftrace_read_cnt at ramoops_pstore_open
has been added to the -mm tree.  Its filename is
     pstore-reset-ftrace_read_cnt-at-ramoops_pstore_open.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pstore-reset-ftrace_read_cnt-at-ramoops_pstore_open.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pstore-reset-ftrace_read_cnt-at-ramoops_pstore_open.patch

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
Subject: pstore: reset ftrace_read_cnt at ramoops_pstore_open

ftrace_read_cnt need to be reset in open to support mutli times
getting the records.

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

pstore-reset-ftrace_read_cnt-at-ramoops_pstore_open.patch
pstore-skip-zero-size-persistent-ram-buffer-in-traverse.patch


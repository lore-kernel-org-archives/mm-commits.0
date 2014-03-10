From: akpm@linux-foundation.org
Subject: + pstore-clarify-clearing-of-_read_cnt-in-ramoops_context.patch
 added to -mm tree
Date: Mon, 10 Mar 2014 11:59:22 -0700
Message-ID: <531e0b8a.VGtqP/kgq3Sqwdga%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39956 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbaCJS7X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Mar 2014 14:59:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yanmin_zhang@linux.intel.com, tony.luck@intel.com, keescook@chromium.org, ccross@android.com, shuox.liu@intel.com

Subject: + pstore-clarify-clearing-of-_read_cnt-in-ramoops_context.patch added to -mm tree
To: shuox.liu@intel.com,ccross@android.com,keescook@chromium.org,tony.luck@intel.com,yanmin_zhang@linux.intel.com
From: akpm@linux-foundation.org
Date: Mon, 10 Mar 2014 11:59:22 -0700


The patch titled
     Subject: pstore: clarify clearing of _read_cnt in ramoops_context
has been added to the -mm tree.  Its filename is
     pstore-clarify-clearing-of-_read_cnt-in-ramoops_context.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pstore-clarify-clearing-of-_read_cnt-in-ramoops_context.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pstore-clarify-clearing-of-_read_cnt-in-ramoops_context.patch

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
Subject: pstore: clarify clearing of _read_cnt in ramoops_context

*_read_cnt in ramoops_context need to be cleared during pstore ->open to
support mutli times getting the records.  The patch added missed
ftrace_read_cnt clearing and removed duplicate clearing in ramoops_probe.

Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Colin Cross <ccross@android.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pstore/ram.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/pstore/ram.c~pstore-clarify-clearing-of-_read_cnt-in-ramoops_context fs/pstore/ram.c
--- a/fs/pstore/ram.c~pstore-clarify-clearing-of-_read_cnt-in-ramoops_context
+++ a/fs/pstore/ram.c
@@ -86,6 +86,7 @@ struct ramoops_context {
 	struct persistent_ram_ecc_info ecc_info;
 	unsigned int max_dump_cnt;
 	unsigned int dump_write_cnt;
+	/* _read_cnt need clear on ramoops_pstore_open */
 	unsigned int dump_read_cnt;
 	unsigned int console_read_cnt;
 	unsigned int ftrace_read_cnt;
@@ -101,6 +102,7 @@ static int ramoops_pstore_open(struct ps
 
 	cxt->dump_read_cnt = 0;
 	cxt->console_read_cnt = 0;
+	cxt->ftrace_read_cnt = 0;
 	return 0;
 }
 
@@ -428,7 +430,6 @@ static int ramoops_probe(struct platform
 	if (pdata->ftrace_size && !is_power_of_2(pdata->ftrace_size))
 		pdata->ftrace_size = rounddown_pow_of_two(pdata->ftrace_size);
 
-	cxt->dump_read_cnt = 0;
 	cxt->size = pdata->mem_size;
 	cxt->phys_addr = pdata->mem_address;
 	cxt->record_size = pdata->record_size;
_

Patches currently in -mm which might be from shuox.liu@intel.com are

pstore-clarify-clearing-of-_read_cnt-in-ramoops_context.patch
pstore-reset-ftrace_read_cnt-at-ramoops_pstore_open.patch
pstore-skip-zero-size-persistent-ram-buffer-in-traverse.patch


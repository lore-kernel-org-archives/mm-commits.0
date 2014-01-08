From: akpm@linux-foundation.org
Subject: +
 mm-prevent-setting-of-a-value-less-than-0-to-min_free_kbytes.patch added to -mm tree
Date: Wed, 08 Jan 2014 14:23:51 -0800
Message-ID: <52cdcff7.QsZDkr+X/gtyodjE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43362 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757101AbaAHWXw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jan 2014 17:23:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, hanpt@linux.vnet.ibm.com

Subject: + mm-prevent-setting-of-a-value-less-than-0-to-min_free_kbytes.patch added to -mm tree
To: hanpt@linux.vnet.ibm.com,mhocko@suse.cz
From: akpm@linux-foundation.org
Date: Wed, 08 Jan 2014 14:23:51 -0800


The patch titled
     Subject: mm: prevent setting of a value less than 0 to min_free_kbytes
has been added to the -mm tree.  Its filename is
     mm-prevent-setting-of-a-value-less-than-0-to-min_free_kbytes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-prevent-setting-of-a-value-less-than-0-to-min_free_kbytes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-prevent-setting-of-a-value-less-than-0-to-min_free_kbytes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Han Pingtian <hanpt@linux.vnet.ibm.com>
Subject: mm: prevent setting of a value less than 0 to min_free_kbytes

If echo -1 > /proc/vm/sys/min_free_kbytes, the system will hang.  Changing
proc_dointvec() to proc_dointvec_minmax() in the
min_free_kbytes_sysctl_handler() can prevent this to happen.

mhocko said:

: You can still do echo $BIG_VALUE > /proc/vm/sys/min_free_kbytes and make
: your machine unusable but I agree that proc_dointvec_minmax is more
: suitable here as we already have:
: 
: 	.proc_handler   = min_free_kbytes_sysctl_handler,
: 	.extra1         = &zero,
: 
: It used to work properly but then 6fce56ec91b5 ("sysctl: Remove references
: to ctl_name and strategy from the generic sysctl table") has removed
: sysctl_intvec strategy and so extra1 is ignored.

Signed-off-by: Han Pingtian <hanpt@linux.vnet.ibm.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-prevent-setting-of-a-value-less-than-0-to-min_free_kbytes mm/page_alloc.c
--- a/mm/page_alloc.c~mm-prevent-setting-of-a-value-less-than-0-to-min_free_kbytes
+++ a/mm/page_alloc.c
@@ -5767,7 +5767,12 @@ module_init(init_per_zone_wmark_min)
 int min_free_kbytes_sysctl_handler(ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
-	proc_dointvec(table, write, buffer, length, ppos);
+	int rc;
+
+	rc = proc_dointvec_minmax(table, write, buffer, length, ppos);
+	if (rc)
+		return rc;
+
 	if (write) {
 		user_min_free_kbytes = min_free_kbytes;
 		setup_per_zone_wmarks();
_

Patches currently in -mm which might be from hanpt@linux.vnet.ibm.com are

mm-prevent-setting-of-a-value-less-than-0-to-min_free_kbytes.patch


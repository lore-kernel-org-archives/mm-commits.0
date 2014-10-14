From: akpm@linux-foundation.org
Subject: [merged] wireless-hostap-proc-print-properly-escaped-ssid.patch
 removed from -mm tree
Date: Tue, 14 Oct 2014 11:22:58 -0700
Message-ID: <543d6a02.DPsJSbY+k04Vqazh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44592 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524AbaJNSW5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:22:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, gregkh@linuxfoundation.org, joe@perches.com, johannes@sipsolutions.net, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: wireless: hostap: proc: print properly escaped SSID
has been removed from the -mm tree.  Its filename was
     wireless-hostap-proc-print-properly-escaped-ssid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: wireless: hostap: proc: print properly escaped SSID

Instead of substituting non-printable characters by '_' let's print SSID
properly escaped by using recently added %*pE specifier.

[akpm@linux-foundation.org: fix printk type warning]
[akpm@linux-foundation.org: remove now-unused local `i']
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "John W . Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/hostap/hostap_proc.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/net/wireless/hostap/hostap_proc.c~wireless-hostap-proc-print-properly-escaped-ssid drivers/net/wireless/hostap/hostap_proc.c
--- a/drivers/net/wireless/hostap/hostap_proc.c~wireless-hostap-proc-print-properly-escaped-ssid
+++ a/drivers/net/wireless/hostap/hostap_proc.c
@@ -168,7 +168,6 @@ static int prism2_bss_list_proc_show(str
 	local_info_t *local = m->private;
 	struct list_head *ptr = v;
 	struct hostap_bss_info *bss;
-	int i;
 
 	if (ptr == &local->bss_list) {
 		seq_printf(m, "#BSSID\tlast_update\tcount\tcapab_info\tSSID(txt)\t"
@@ -181,9 +180,7 @@ static int prism2_bss_list_proc_show(str
 		   bss->bssid, bss->last_update,
 		   bss->count, bss->capab_info);
 
-	for (i = 0; i < bss->ssid_len; i++)
-		seq_putc(m,bss->ssid[i] >= 32 && bss->ssid[i] < 127 ?
-			   bss->ssid[i] : '_');
+	seq_printf(m, "%*pE", (int)bss->ssid_len, bss->ssid);
 
 	seq_putc(m, '\t');
 	seq_printf(m, "%*phN", (int)bss->ssid_len, bss->ssid);
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

origin.patch
linux-next.patch


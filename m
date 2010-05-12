From: akpm@linux-foundation.org
Subject: [folded] serial-apbuartc-fix-two-problems-related-to-grlib_apbuart_configure-update.patch removed from -mm tree
Date: Wed, 12 May 2010 15:33:18 -0700
Message-ID: <201005122233.o4CMXI7N024740@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36840 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758384Ab0ELWd1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 May 2010 18:33:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miguel.ojeda.sandonis@gmail.com, davem@davemloft.net, greg@kroah.com, kristoffer@gaisler.com, mm-commits@vger.kernel.org


The patch titled
     serial-apbuartc-fix-two-problems-related-to-grlib_apbuart_configure-update.
has been removed from the -mm tree.  Its filename was
     serial-apbuartc-fix-two-problems-related-to-grlib_apbuart_configure-update.patch

This patch was dropped because it was folded into serial-apbuartc-fix-two-problems-related-to-grlib_apbuart_configure.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial-apbuartc-fix-two-problems-related-to-grlib_apbuart_configure-update.
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>

Changes:
1. Added the grlib_apbuart_port_nr = 0 line.
2. Returned -ENODEV instead of 0 in the "no ports found branch" in
init(), because if compiled as a module, exit() will try to unregister
things that were not registered. In addition, this will alert the users
that modprobe'd.
3. Deleted the unused __FILE__ argument of the previous patch (oops
sorry :).

Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Kristoffer Glembo <kristoffer@gaisler.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/apbuart.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/serial/apbuart.c~serial-apbuartc-fix-two-problems-related-to-grlib_apbuart_configure-update drivers/serial/apbuart.c
--- a/drivers/serial/apbuart.c~serial-apbuartc-fix-two-problems-related-to-grlib_apbuart_configure-update
+++ a/drivers/serial/apbuart.c
@@ -615,8 +615,10 @@ static void grlib_apbuart_configure(void
 	rp = of_find_node_by_path("/");
 	rp = of_get_next_child(rp, NULL);
 	prop = of_get_property(rp, "clock-frequency", NULL);
-	if (prop == NULL)
+	if (prop == NULL) {
+		grlib_apbuart_port_nr = 0;
 		return;
+	}
 	freq_khz = *prop;
 
 	line = 0;
@@ -672,9 +674,8 @@ static int __init grlib_apbuart_init(voi
 	/* Find all APBUARTS in device the tree and initialize their ports */
 	grlib_apbuart_configure();
 	if (grlib_apbuart_port_nr == 0) {
-		printk(KERN_INFO "Serial: GRLIB APBUART: No ports found.\n",
-			__FILE__);
-		return 0;
+		printk(KERN_INFO "Serial: GRLIB APBUART: No ports found.\n");
+		return -ENODEV;
 	}
 
 	printk(KERN_INFO "Serial: GRLIB APBUART driver\n");
_

Patches currently in -mm which might be from miguel.ojeda.sandonis@gmail.com are

serial-apbuartc-fix-two-problems-related-to-grlib_apbuart_configure.patch
serial-apbuartc-fix-two-problems-related-to-grlib_apbuart_configure-update.patch
auxdisplay-section-cleanup-in-cfag12864bfb-driver.patch


From: akpm@linux-foundation.org
Subject: [alternative-merged] serial-apbuartc-fix-two-problems-related-to-grlib_apbuart_configure.patch removed from -mm tree
Date: Wed, 19 May 2010 10:16:20 -0400
Message-ID: <201005191717.o4JHHjxZ024947@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753035Ab0ESRSo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 13:18:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miguel.ojeda.sandonis@gmail.com, davem@davemloft.net, greg@kroah.com, kristoffer@gaisler.com, mm-commits@vger.kernel.org


The patch titled
     serial: apbuart.c: fix two problems related to grlib_apbuart_configure()
has been removed from the -mm tree.  Its filename was
     serial-apbuartc-fix-two-problems-related-to-grlib_apbuart_configure.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: apbuart.c: fix two problems related to grlib_apbuart_configure()
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>

I found two problems using the Simics' sunfire target, so maybe the
following does not occur in real machines.

1. At grlib_apbuart_configure() in apbuart.c, prop can be NULL if
   "clock-frequency" doesn't exist in the OF tree:

        /* Get bus frequency */
        rp = of_find_node_by_path("/");
        rp = of_get_next_child(rp, NULL);
        prop = of_get_property(rp, "clock-frequency", NULL);
        freq_khz = *prop;

2. In addition, apbuart.c does not check if there aren't any ports
   configured after calls to grlib_apbuart_configure(), so other oops will
   occur if no port was configured (e.g.  uart_set_options() because of
   port->ops).

In order to solve that, I added a check after both of the calls to
grlib_apbuart_configure().

The patch that I provide below prevents both problems in the Simics'
sunfire target.

Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Acked-by: Kristoffer Glembo <kristoffer@gaisler.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/apbuart.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN drivers/serial/apbuart.c~serial-apbuartc-fix-two-problems-related-to-grlib_apbuart_configure drivers/serial/apbuart.c
--- a/drivers/serial/apbuart.c~serial-apbuartc-fix-two-problems-related-to-grlib_apbuart_configure
+++ a/drivers/serial/apbuart.c
@@ -525,6 +525,9 @@ static void grlib_apbuart_configure(void
 static int __init apbuart_console_init(void)
 {
 	grlib_apbuart_configure();
+	if (grlib_apbuart_port_nr == 0)
+		return 0;
+
 	register_console(&grlib_apbuart_console);
 	return 0;
 }
@@ -612,6 +615,10 @@ static void grlib_apbuart_configure(void
 	rp = of_find_node_by_path("/");
 	rp = of_get_next_child(rp, NULL);
 	prop = of_get_property(rp, "clock-frequency", NULL);
+	if (prop == NULL) {
+		grlib_apbuart_port_nr = 0;
+		return;
+	}
 	freq_khz = *prop;
 
 	line = 0;
@@ -666,6 +673,10 @@ static int __init grlib_apbuart_init(voi
 
 	/* Find all APBUARTS in device the tree and initialize their ports */
 	grlib_apbuart_configure();
+	if (grlib_apbuart_port_nr == 0) {
+		printk(KERN_INFO "Serial: GRLIB APBUART: No ports found.\n");
+		return -ENODEV;
+	}
 
 	printk(KERN_INFO "Serial: GRLIB APBUART driver\n");
 
_

Patches currently in -mm which might be from miguel.ojeda.sandonis@gmail.com are

serial-apbuartc-fix-two-problems-related-to-grlib_apbuart_configure.patch
auxdisplay-section-cleanup-in-cfag12864bfb-driver.patch


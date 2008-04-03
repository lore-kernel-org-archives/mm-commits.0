From: akpm@linux-foundation.org
Subject: + drivers-atm-ambassadorc-stop-inlining-largish-static-functions.patch added to -mm tree
Date: Thu, 03 Apr 2008 12:31:06 -0700
Message-ID: <200804031931.m33JV6Sn018593@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40049 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756056AbYDCTbJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2008 15:31:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vda.linux@googlemail.com


The patch titled
     drivers/atm/ambassador.c: stop inlining largish static functions
has been added to the -mm tree.  Its filename is
     drivers-atm-ambassadorc-stop-inlining-largish-static-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/atm/ambassador.c: stop inlining largish static functions
From: Denys Vlasenko <vda.linux@googlemail.com>

drivers/atm/ambassador.c has unusually large number of static inline functions
- 22.

I looked through them and half of them seem to be too big to warrant inlining.

This patch removes "inline" from these static functions (regardless of number
of callsites - gcc nowadays auto-inlines statics with one callsite).

Size difference for 32bit x86:
   text    data     bss     dec     hex filename
  10209    8488       4   18701    490d linux-2.6-ALLYES/drivers/atm/ambassador.o
   9462    8488       4   17954    4622 linux-2.6.inline-ALLYES/drivers/atm/ambassador.o

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/atm/ambassador.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN drivers/atm/ambassador.c~drivers-atm-ambassadorc-stop-inlining-largish-static-functions drivers/atm/ambassador.c
--- a/drivers/atm/ambassador.c~drivers-atm-ambassadorc-stop-inlining-largish-static-functions
+++ a/drivers/atm/ambassador.c
@@ -437,7 +437,7 @@ static inline void dump_skb (char * pref
 
 /* see limitations under Hardware Features */
 
-static inline int check_area (void * start, size_t length) {
+static int check_area (void * start, size_t length) {
   // assumes length > 0
   const u32 fourmegmask = -1 << 22;
   const u32 twofivesixmask = -1 << 8;
@@ -456,7 +456,7 @@ static inline int check_area (void * sta
 
 /********** free an skb (as per ATM device driver documentation) **********/
 
-static inline void amb_kfree_skb (struct sk_buff * skb) {
+static void amb_kfree_skb (struct sk_buff * skb) {
   if (ATM_SKB(skb)->vcc->pop) {
     ATM_SKB(skb)->vcc->pop (ATM_SKB(skb)->vcc, skb);
   } else {
@@ -466,7 +466,7 @@ static inline void amb_kfree_skb (struct
 
 /********** TX completion **********/
 
-static inline void tx_complete (amb_dev * dev, tx_out * tx) {
+static void tx_complete (amb_dev * dev, tx_out * tx) {
   tx_simple * tx_descr = bus_to_virt (tx->handle);
   struct sk_buff * skb = tx_descr->skb;
   
@@ -643,7 +643,7 @@ static int command_do (amb_dev * dev, co
 
 /********** TX queue pair **********/
 
-static inline int tx_give (amb_dev * dev, tx_in * tx) {
+static int tx_give (amb_dev * dev, tx_in * tx) {
   amb_txq * txq = &dev->txq;
   unsigned long flags;
   
@@ -675,7 +675,7 @@ static inline int tx_give (amb_dev * dev
   }
 }
 
-static inline int tx_take (amb_dev * dev) {
+static int tx_take (amb_dev * dev) {
   amb_txq * txq = &dev->txq;
   unsigned long flags;
   
@@ -703,7 +703,7 @@ static inline int tx_take (amb_dev * dev
 
 /********** RX queue pairs **********/
 
-static inline int rx_give (amb_dev * dev, rx_in * rx, unsigned char pool) {
+static int rx_give (amb_dev * dev, rx_in * rx, unsigned char pool) {
   amb_rxq * rxq = &dev->rxq[pool];
   unsigned long flags;
   
@@ -728,7 +728,7 @@ static inline int rx_give (amb_dev * dev
   }
 }
 
-static inline int rx_take (amb_dev * dev, unsigned char pool) {
+static int rx_take (amb_dev * dev, unsigned char pool) {
   amb_rxq * rxq = &dev->rxq[pool];
   unsigned long flags;
   
@@ -761,7 +761,7 @@ static inline int rx_take (amb_dev * dev
 /********** RX Pool handling **********/
 
 /* pre: buffers_wanted = 0, post: pending = 0 */
-static inline void drain_rx_pool (amb_dev * dev, unsigned char pool) {
+static void drain_rx_pool (amb_dev * dev, unsigned char pool) {
   amb_rxq * rxq = &dev->rxq[pool];
   
   PRINTD (DBG_FLOW|DBG_POOL, "drain_rx_pool %p %hu", dev, pool);
@@ -796,7 +796,7 @@ static void drain_rx_pools (amb_dev * de
     drain_rx_pool (dev, pool);
 }
 
-static inline void fill_rx_pool (amb_dev * dev, unsigned char pool,
+static void fill_rx_pool (amb_dev * dev, unsigned char pool,
                                  gfp_t priority)
 {
   rx_in rx;
@@ -846,7 +846,7 @@ static void fill_rx_pools (amb_dev * dev
 
 /********** enable host interrupts **********/
 
-static inline void interrupts_on (amb_dev * dev) {
+static void interrupts_on (amb_dev * dev) {
   wr_plain (dev, offsetof(amb_mem, interrupt_control),
 	    rd_plain (dev, offsetof(amb_mem, interrupt_control))
 	    | AMB_INTERRUPT_BITS);
@@ -854,7 +854,7 @@ static inline void interrupts_on (amb_de
 
 /********** disable host interrupts **********/
 
-static inline void interrupts_off (amb_dev * dev) {
+static void interrupts_off (amb_dev * dev) {
   wr_plain (dev, offsetof(amb_mem, interrupt_control),
 	    rd_plain (dev, offsetof(amb_mem, interrupt_control))
 	    &~ AMB_INTERRUPT_BITS);
_

Patches currently in -mm which might be from vda.linux@googlemail.com are

git-net.patch
wavelan_cs-stop-inlining-largish-static-functions.patch
drivers-atm-ambassadorc-stop-inlining-largish-static-functions.patch
sound-pci-rme9652-hdspmc-stop-inlining-largish-static-functions.patch


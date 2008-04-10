From: akpm@linux-foundation.org
Subject: - wavelan_cs-stop-inlining-largish-static-functions.patch removed from -mm tree
Date: Thu, 10 Apr 2008 13:01:41 -0700
Message-ID: <200804102001.m3AK1fsi014996@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752918AbYDJULd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Apr 2008 16:11:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vda.linux@googlemail.com, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     wavelan_cs: stop inlining largish static functions
has been removed from the -mm tree.  Its filename was
     wavelan_cs-stop-inlining-largish-static-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: wavelan_cs: stop inlining largish static functions
From: Denys Vlasenko <vda.linux@googlemail.com>

drivers/net/wireless/wavelan_cs.c has unusually large number
of static inline functions - 27.

I looked through them and 20 of them do not seem to warrant inlining.  Some
are really big; others call mdelay(1) or busy-wait for a bit to be set in a
hardware register - it's pointless to optimize such functions for speed.

This patch removes "inline" from these static function (regardless of number
of callsites - gcc nowadays auto-inlines statics with one callsite).

Size difference for 32bit x86:

   text    data     bss     dec     hex filename
  17020     372       8   17400    43f8 linux-2.6-ALLYES/drivers/net/wireless/wavelan_cs.o
  14032     356       8   14396    383c linux-2.6.inline-ALLYES/drivers/net/wireless/wavelan_cs.o

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/wavelan_cs.c   |   47 ++++++++++++--------------
 drivers/net/wireless/wavelan_cs.p.h |   26 +++++++-------
 2 files changed, 36 insertions(+), 37 deletions(-)

diff -puN drivers/net/wireless/wavelan_cs.c~wavelan_cs-stop-inlining-largish-static-functions drivers/net/wireless/wavelan_cs.c
--- a/drivers/net/wireless/wavelan_cs.c~wavelan_cs-stop-inlining-largish-static-functions
+++ a/drivers/net/wireless/wavelan_cs.c
@@ -102,7 +102,7 @@ hacr_write(u_long	base,
  * Write to card's Host Adapter Command Register. Include a delay for
  * those times when it is needed.
  */
-static inline void
+static void
 hacr_write_slow(u_long	base,
 		u_char	hacr)
 {
@@ -255,7 +255,7 @@ update_psa_checksum(struct net_device *	
 /*
  * Write 1 byte to the MMC.
  */
-static inline void
+static void
 mmc_out(u_long		base,
 	u_short		o,
 	u_char		d)
@@ -275,7 +275,7 @@ mmc_out(u_long		base,
  * Routine to write bytes to the Modem Management Controller.
  * We start by the end because it is the way it should be !
  */
-static inline void
+static void
 mmc_write(u_long	base,
 	  u_char	o,
 	  u_char *	b,
@@ -293,7 +293,7 @@ mmc_write(u_long	base,
  * Read 1 byte from the MMC.
  * Optimised version for 1 byte, avoid using memory...
  */
-static inline u_char
+static u_char
 mmc_in(u_long	base,
        u_short	o)
 {
@@ -318,7 +318,7 @@ mmc_in(u_long	base,
  * (code has just been moved in the above function)
  * We start by the end because it is the way it should be !
  */
-static inline void
+static void
 mmc_read(u_long		base,
 	 u_char		o,
 	 u_char *	b,
@@ -350,9 +350,8 @@ mmc_encr(u_long		base)	/* i/o port of th
 /*------------------------------------------------------------------*/
 /*
  * Wait for the frequency EEprom to complete a command...
- * I hope this one will be optimally inlined...
  */
-static inline void
+static void
 fee_wait(u_long		base,	/* i/o port of the card */
 	 int		delay,	/* Base delay to wait for */
 	 int		number)	/* Number of time to wait */
@@ -738,9 +737,9 @@ static void wv_roam_handover(wavepoint_h
 }
 
 /* Called when a WavePoint beacon is received */
-static inline void wl_roam_gather(struct net_device *  dev,
-				  u_char *  hdr,   /* Beacon header */
-				  u_char *  stats) /* SNR, Signal quality 
+static void wl_roam_gather(struct net_device *  dev,
+			   u_char *  hdr,   /* Beacon header */
+			   u_char *  stats) /* SNR, Signal quality
 						      of packet */
 {
   wavepoint_beacon *beacon= (wavepoint_beacon *)hdr; /* Rcvd. Beacon */
@@ -794,7 +793,7 @@ out:
 static inline int WAVELAN_BEACON(unsigned char *data)
 {
   wavepoint_beacon *beacon= (wavepoint_beacon *)data;
-  static wavepoint_beacon beacon_template={0xaa,0xaa,0x03,0x08,0x00,0x0e,0x20,0x03,0x00};
+  static const wavepoint_beacon beacon_template={0xaa,0xaa,0x03,0x08,0x00,0x0e,0x20,0x03,0x00};
   
   if(memcmp(beacon,&beacon_template,9)==0)
     return 1;
@@ -980,7 +979,7 @@ read_ringbuf(struct net_device *	dev,
  * wavelan_interrupt is not an option...), so you may experience
  * some delay sometime...
  */
-static inline void
+static void
 wv_82593_reconfig(struct net_device *	dev)
 {
   net_local *		lp = netdev_priv(dev);
@@ -1233,7 +1232,7 @@ wv_local_show(struct net_device *	dev)
 /*
  * Dump packet header (and content if necessary) on the screen
  */
-static inline void
+static void
 wv_packet_info(u_char *		p,		/* Packet to dump */
 	       int		length,		/* Length of the packet */
 	       char *		msg1,		/* Name of the device */
@@ -1272,7 +1271,7 @@ wv_packet_info(u_char *		p,		/* Packet t
  * This is the information which is displayed by the driver at startup
  * There  is a lot of flag to configure it at your will...
  */
-static inline void
+static void
 wv_init_info(struct net_device *	dev)
 {
   unsigned int	base = dev->base_addr;
@@ -1509,7 +1508,7 @@ wavelan_set_mac_address(struct net_devic
  * Frequency setting (for hardware able of it)
  * It's a bit complicated and you don't really want to look into it...
  */
-static inline int
+static int
 wv_set_frequency(u_long		base,	/* i/o port of the card */
 		 iw_freq *	frequency)
 {
@@ -1706,7 +1705,7 @@ wv_set_frequency(u_long		base,	/* i/o po
 /*
  * Give the list of available frequencies
  */
-static inline int
+static int
 wv_frequency_list(u_long	base,	/* i/o port of the card */
 		  iw_freq *	list,	/* List of frequency to fill */
 		  int		max)	/* Maximum number of frequencies */
@@ -2759,7 +2758,7 @@ wavelan_get_wireless_stats(struct net_de
  * frame pointer and verify that the frame seem correct
  * (called by wv_packet_rcv())
  */
-static inline int
+static int
 wv_start_of_frame(struct net_device *	dev,
 		  int		rfp,	/* end of frame */
 		  int		wrap)	/* start of buffer */
@@ -2821,7 +2820,7 @@ wv_start_of_frame(struct net_device *	de
  * Note: if any errors occur, the packet is "dropped on the floor"
  * (called by wv_packet_rcv())
  */
-static inline void
+static void
 wv_packet_read(struct net_device *		dev,
 	       int		fd_p,
 	       int		sksize)
@@ -2922,7 +2921,7 @@ wv_packet_read(struct net_device *		dev,
  * (called by wavelan_interrupt())
  * Note : the spinlock is already grabbed for us and irq are disabled.
  */
-static inline void
+static void
 wv_packet_rcv(struct net_device *	dev)
 {
   unsigned int	base = dev->base_addr;
@@ -3056,7 +3055,7 @@ wv_packet_rcv(struct net_device *	dev)
  * the transmit.
  * (called in wavelan_packet_xmit())
  */
-static inline void
+static void
 wv_packet_write(struct net_device *	dev,
 		void *		buf,
 		short		length)
@@ -3180,7 +3179,7 @@ wavelan_packet_xmit(struct sk_buff *	skb
  * Routine to initialize the Modem Management Controller.
  * (called by wv_hw_config())
  */
-static inline int
+static int
 wv_mmc_init(struct net_device *	dev)
 {
   unsigned int	base = dev->base_addr;
@@ -3699,7 +3698,7 @@ wv_82593_config(struct net_device *	dev)
  * wavelan.
  * (called by wv_config())
  */
-static inline int
+static int
 wv_pcmcia_reset(struct net_device *	dev)
 {
   int		i;
@@ -3864,7 +3863,7 @@ wv_hw_config(struct net_device *	dev)
  *	2. Start the LAN controller's receive unit
  * (called by wavelan_event(), wavelan_watchdog() and wavelan_open())
  */
-static inline void
+static void
 wv_hw_reset(struct net_device *	dev)
 {
   net_local *	lp = netdev_priv(dev);
@@ -3895,7 +3894,7 @@ wv_hw_reset(struct net_device *	dev)
  * device available to the system.
  * (called by wavelan_event())
  */
-static inline int
+static int
 wv_pcmcia_config(struct pcmcia_device *	link)
 {
   struct net_device *	dev = (struct net_device *) link->priv;
diff -puN drivers/net/wireless/wavelan_cs.p.h~wavelan_cs-stop-inlining-largish-static-functions drivers/net/wireless/wavelan_cs.p.h
--- a/drivers/net/wireless/wavelan_cs.p.h~wavelan_cs-stop-inlining-largish-static-functions
+++ a/drivers/net/wireless/wavelan_cs.p.h
@@ -637,7 +637,7 @@ struct net_local
 /* ----------------- MODEM MANAGEMENT SUBROUTINES ----------------- */
 static inline u_char		/* data */
 	hasr_read(u_long);	/* Read the host interface : base address */
-static inline void
+static void
 	hacr_write(u_long,	/* Write to host interface : base address */
 		   u_char),	/* data */
 	hacr_write_slow(u_long,
@@ -651,7 +651,7 @@ static void
 		  int,		/* Offset in psa */
 		  u_char *,	/* Buffer in memory */
 		  int);		/* Length of buffer */
-static inline void
+static void
 	mmc_out(u_long,		/* Write 1 byte to the Modem Manag Control */
 		u_short,
 		u_char),
@@ -659,10 +659,10 @@ static inline void
 		  u_char,
 		  u_char *,
 		  int);
-static inline u_char		/* Read 1 byte from the MMC */
+static u_char			/* Read 1 byte from the MMC */
 	mmc_in(u_long,
 	       u_short);
-static inline void
+static void
 	mmc_read(u_long,	/* Read n bytes from the MMC */
 		 u_char,
 		 u_char *,
@@ -688,10 +688,10 @@ static int
 		     int,
 		     char *,
 		     int);
-static inline void
+static void
 	wv_82593_reconfig(struct net_device *);	/* Reconfigure the controller */
 /* ------------------- DEBUG & INFO SUBROUTINES ------------------- */
-static inline void
+static void
 	wv_init_info(struct net_device *);	/* display startup info */
 /* ------------------- IOCTL, STATS & RECONFIG ------------------- */
 static en_stats	*
@@ -699,17 +699,17 @@ static en_stats	*
 static iw_stats *
 	wavelan_get_wireless_stats(struct net_device *);
 /* ----------------------- PACKET RECEPTION ----------------------- */
-static inline int
+static int
 	wv_start_of_frame(struct net_device *,	/* Seek beggining of current frame */
 			  int,	/* end of frame */
 			  int);	/* start of buffer */
-static inline void
+static void
 	wv_packet_read(struct net_device *,	/* Read a packet from a frame */
 		       int,
 		       int),
 	wv_packet_rcv(struct net_device *);	/* Read all packets waiting */
 /* --------------------- PACKET TRANSMISSION --------------------- */
-static inline void
+static void
 	wv_packet_write(struct net_device *,	/* Write a packet to the Tx buffer */
 			void *,
 			short);
@@ -717,20 +717,20 @@ static int
 	wavelan_packet_xmit(struct sk_buff *,	/* Send a packet */
 			    struct net_device *);
 /* -------------------- HARDWARE CONFIGURATION -------------------- */
-static inline int
+static int
 	wv_mmc_init(struct net_device *);	/* Initialize the modem */
 static int
 	wv_ru_stop(struct net_device *),	/* Stop the i82593 receiver unit */
 	wv_ru_start(struct net_device *);	/* Start the i82593 receiver unit */
 static int
 	wv_82593_config(struct net_device *);	/* Configure the i82593 */
-static inline int
+static int
 	wv_pcmcia_reset(struct net_device *);	/* Reset the pcmcia interface */
 static int
 	wv_hw_config(struct net_device *);	/* Reset & configure the whole hardware */
-static inline void
+static void
 	wv_hw_reset(struct net_device *);	/* Same, + start receiver unit */
-static inline int
+static int
 	wv_pcmcia_config(struct pcmcia_device *);	/* Configure the pcmcia interface */
 static void
 	wv_pcmcia_release(struct pcmcia_device *);/* Remove a device */
_

Patches currently in -mm which might be from vda.linux@googlemail.com are

sound-pci-rme9652-hdspmc-stop-inlining-largish-static-functions.patch
git-net.patch


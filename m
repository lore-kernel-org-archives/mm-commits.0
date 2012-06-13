From: akpm@linux-foundation.org
Subject: [merged] staging-wlags49_h2-remove-direct-declarations-of-kern_level-prefixes.patch removed from -mm tree
Date: Wed, 13 Jun 2012 12:14:57 -0700
Message-ID: <20120613191458.2FCF4A017E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:64306 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab2FMTO7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jun 2012 15:14:59 -0400
Received: by vbnl22 with SMTP id l22so95928vbn.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Jun 2012 12:14:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, greg@kroah.com, kay.sievers@vrfy.org, pe1dnn@amsat.org, mm-commits@vger.kernel.org


The patch titled
     Subject: staging: wlags49_h2: remove direct declarations of KERN_<LEVEL> prefixes
has been removed from the -mm tree.  Its filename was
     staging-wlags49_h2-remove-direct-declarations-of-kern_level-prefixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: staging: wlags49_h2: remove direct declarations of KERN_<LEVEL> prefixes

Use the standard KERN_<LEVEL> #defines instead of "<.>"

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Henk de Groot <pe1dnn@amsat.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/wlags49_h2/hcf.c     |    8 ++++----
 drivers/staging/wlags49_h2/wl_main.c |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/staging/wlags49_h2/hcf.c~staging-wlags49_h2-remove-direct-declarations-of-kern_level-prefixes drivers/staging/wlags49_h2/hcf.c
--- a/drivers/staging/wlags49_h2/hcf.c~staging-wlags49_h2-remove-direct-declarations-of-kern_level-prefixes
+++ a/drivers/staging/wlags49_h2/hcf.c
@@ -705,7 +705,7 @@ hcf_action( IFBP ifbp, hcf_16 action )
 			// 800 us latency before FW switches to high power
 			MSF_WAIT(800);                              // MSF-defined function to wait n microseconds.
 //OOR			if ( ifbp->IFB_DSLinkStat & CFG_LINK_STAT_DS_OOR ) { // OutOfRange
-//				printk( "<5>ACT_INT_OFF: Deepsleep phase terminated, enable and go to AwaitConnection\n" );     //;?remove me 1 day
+//				printk(KERN_NOTICE "ACT_INT_OFF: Deepsleep phase terminated, enable and go to AwaitConnection\n" );     //;?remove me 1 day
 //				hcf_cntl( ifbp, HCF_CNTL_ENABLE );
 //			}
 //			ifbp->IFB_DSLinkStat &= ~( CFG_LINK_STAT_DS_IR | CFG_LINK_STAT_DS_OOR); //clear IR/OOR state
@@ -2979,7 +2979,7 @@ hcf_service_nic( IFBP ifbp, wci_bufp buf
 			ltv.typ = CFG_DDS_TICK_TIME;
 			ltv.tick_time = ( ( ifbp->IFB_DSLinkStat & CFG_LINK_STAT_TIMER ) + 0x10 ) *64; //78 is more right
 			hcf_put_info( ifbp, (LTVP)&ltv );
-			printk( "<5>Preparing for sleep, link_status: %04X, timer : %d\n",
+			printk(KERN_NOTICE "Preparing for sleep, link_status: %04X, timer : %d\n",
 				ifbp->IFB_DSLinkStat, ltv.tick_time );//;?remove me 1 day
 			ifbp->IFB_TickCnt++; //;?just to make sure we do not keep on printing above message
 			if ( ltv.tick_time < 300 * 125 ) ifbp->IFB_DSLinkStat += 0x0010;
@@ -4221,11 +4221,11 @@ isr_info( IFBP ifbp )
 // /*4*/    if ( info[1] == CFG_LINK_STAT ) {
 //          ifbp->IFB_DSLinkStat = IPW( HREG_DATA_1 ) | CFG_LINK_STAT_CHANGE;   //corrupts BAP !! ;?
 //          ifbp->IFB_LinkStat = ifbp->IFB_DSLinkStat & CFG_LINK_STAT_FW; //;? to be obsoleted
-//          printk( "<4>linkstatus: %04x\n", ifbp->IFB_DSLinkStat );        //;?remove me 1 day
+//          printk(KERN_ERR "linkstatus: %04x\n", ifbp->IFB_DSLinkStat );        //;?remove me 1 day
 // #if (HCF_SLEEP) & HCF_DDS
 //          if ( ( ifbp->IFB_DSLinkStat & CFG_LINK_STAT_CONNECTED ) == 0 ) {    //even values are disconnected etc.
 //              ifbp->IFB_TickCnt = 0;              //start 2 second period (with 1 tick uncertanty)
-//              printk( "<5>isr_info: AwaitConnection phase started, IFB_TickCnt = 0\n" );      //;?remove me 1 day
+//              printk(KERN_NOTICE "isr_info: AwaitConnection phase started, IFB_TickCnt = 0\n" );      //;?remove me 1 day
 //          }
 // #endif // HCF_DDS
 //      }
diff -puN drivers/staging/wlags49_h2/wl_main.c~staging-wlags49_h2-remove-direct-declarations-of-kern_level-prefixes drivers/staging/wlags49_h2/wl_main.c
--- a/drivers/staging/wlags49_h2/wl_main.c~staging-wlags49_h2-remove-direct-declarations-of-kern_level-prefixes
+++ a/drivers/staging/wlags49_h2/wl_main.c
@@ -3822,7 +3822,7 @@ static int write_int(struct file *file, 
 		lp->timer_oor.data = (unsigned long)lp;
 		lp->timer_oor.expires = RUN_AT( 3 * HZ );
 		add_timer( &lp->timer_oor );
-		printk( "<5>wl_enable: %ld\n", jiffies );		//;?remove me 1 day
+		printk(KERN_NOTICE "wl_enable: %ld\n", jiffies );		//;?remove me 1 day
 #endif //DN554
 #ifdef DN554
 /*******************************************************************************
@@ -3852,7 +3852,7 @@ void timer_oor( u_long arg )
     DBG_ENTER( DbgInfo );
     DBG_PARAM( DbgInfo, "arg", "0x%08lx", arg );
 
-	printk( "<5>timer_oor: %ld 0x%04X\n", jiffies, lp->timer_oor_cnt );		//;?remove me 1 day
+	printk(KERN_NOTICE "timer_oor: %ld 0x%04X\n", jiffies, lp->timer_oor_cnt );		//;?remove me 1 day
 	lp->timer_oor_cnt += 10;
     if ( (lp->timer_oor_cnt & ~DS_OOR) > 300 ) {
 		lp->timer_oor_cnt = 300;
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
printk-add-generic-functions-to-find-kern_level-headers.patch
printk-add-kern_levelsh-to-make-kern_level-available-for-asm-use.patch
arch-remove-direct-definitions-of-kern_level-uses.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
sound-use-printk_get_level-and-printk_skip_level.patch
printk-convert-the-format-for-kern_level-to-a-2-byte-pattern.patch
printk-only-look-for-prefix-levels-in-kernel-messages.patch
printk-remove-the-now-unnecessary-c-annotation-for-kern_cont.patch
vsprintf-add-%pmr-for-bluetooth-mac-address.patch


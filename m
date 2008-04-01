From: akpm@linux-foundation.org
Subject: - drivers-s390-replace-remaining-__function__-occurrences.patch removed from -mm tree
Date: Tue, 01 Apr 2008 14:38:32 -0700
Message-ID: <200804012138.m31LcWAJ014933@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753364AbYDAVj0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2008 17:39:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     drivers/s390: replace remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     drivers-s390-replace-remaining-__function__-occurrences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/s390: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/block/dasd.c        |    4 
 drivers/s390/char/tape_34xx.c    |    2 
 drivers/s390/char/vmwatchdog.c   |    4 
 drivers/s390/char/zcore.c        |    2 
 drivers/s390/cio/device_status.c |    2 
 drivers/s390/crypto/zcrypt_api.h |    8 
 drivers/s390/net/claw.c          |  344 ++++++++++++++---------------
 drivers/s390/net/netiucv.c       |   96 ++++----
 drivers/s390/s390mach.c          |    8 
 drivers/s390/scsi/zfcp_def.h     |    2 
 10 files changed, 236 insertions(+), 236 deletions(-)

diff -puN drivers/s390/block/dasd.c~drivers-s390-replace-remaining-__function__-occurrences drivers/s390/block/dasd.c
--- a/drivers/s390/block/dasd.c~drivers-s390-replace-remaining-__function__-occurrences
+++ a/drivers/s390/block/dasd.c
@@ -980,12 +980,12 @@ void dasd_int_handler(struct ccw_device 
 			break;
 		case -ETIMEDOUT:
 			printk(KERN_WARNING"%s(%s): request timed out\n",
-			       __FUNCTION__, cdev->dev.bus_id);
+			       __func__, cdev->dev.bus_id);
 			//FIXME - dasd uses own timeout interface...
 			break;
 		default:
 			printk(KERN_WARNING"%s(%s): unknown error %ld\n",
-			       __FUNCTION__, cdev->dev.bus_id, PTR_ERR(irb));
+			       __func__, cdev->dev.bus_id, PTR_ERR(irb));
 		}
 		return;
 	}
diff -puN drivers/s390/char/tape_34xx.c~drivers-s390-replace-remaining-__function__-occurrences drivers/s390/char/tape_34xx.c
--- a/drivers/s390/char/tape_34xx.c~drivers-s390-replace-remaining-__function__-occurrences
+++ a/drivers/s390/char/tape_34xx.c
@@ -394,7 +394,7 @@ tape_34xx_unit_check(struct tape_device 
 			return tape_34xx_erp_failed(request, -ENOSPC);
 		default:
 			PRINT_ERR("Invalid op in %s:%i\n",
-				  __FUNCTION__, __LINE__);
+				  __func__, __LINE__);
 			return tape_34xx_erp_failed(request, 0);
 		}
 	}
diff -puN drivers/s390/char/vmwatchdog.c~drivers-s390-replace-remaining-__function__-occurrences drivers/s390/char/vmwatchdog.c
--- a/drivers/s390/char/vmwatchdog.c~drivers-s390-replace-remaining-__function__-occurrences
+++ a/drivers/s390/char/vmwatchdog.c
@@ -96,7 +96,7 @@ static int vmwdt_keepalive(void)
 
 	if (ret) {
 		printk(KERN_WARNING "%s: problem setting interval %d, "
-			"cmd %s\n", __FUNCTION__, vmwdt_interval,
+			"cmd %s\n", __func__, vmwdt_interval,
 			vmwdt_cmd);
 	}
 	return ret;
@@ -107,7 +107,7 @@ static int vmwdt_disable(void)
 	int ret = __diag288(wdt_cancel, 0, "", 0);
 	if (ret) {
 		printk(KERN_WARNING "%s: problem disabling watchdog\n",
-			__FUNCTION__);
+			__func__);
 	}
 	return ret;
 }
diff -puN drivers/s390/char/zcore.c~drivers-s390-replace-remaining-__function__-occurrences drivers/s390/char/zcore.c
--- a/drivers/s390/char/zcore.c~drivers-s390-replace-remaining-__function__-occurrences
+++ a/drivers/s390/char/zcore.c
@@ -224,7 +224,7 @@ static int __init init_cpu_info(enum arc
 
 	sa = kmalloc(sizeof(*sa), GFP_KERNEL);
 	if (!sa) {
-		ERROR_MSG("kmalloc failed: %s: %i\n",__FUNCTION__, __LINE__);
+		ERROR_MSG("kmalloc failed: %s: %i\n",__func__, __LINE__);
 		return -ENOMEM;
 	}
 	if (memcpy_hsa_kernel(sa, sys_info.sa_base, sys_info.sa_size) < 0) {
diff -puN drivers/s390/cio/device_status.c~drivers-s390-replace-remaining-__function__-occurrences drivers/s390/cio/device_status.c
--- a/drivers/s390/cio/device_status.c~drivers-s390-replace-remaining-__function__-occurrences
+++ a/drivers/s390/cio/device_status.c
@@ -62,7 +62,7 @@ ccw_device_path_notoper(struct ccw_devic
 	stsch (sch->schid, &sch->schib);
 
 	CIO_MSG_EVENT(0, "%s(0.%x.%04x) - path(s) %02x are "
-		      "not operational \n", __FUNCTION__,
+		      "not operational \n", __func__,
 		      sch->schid.ssid, sch->schid.sch_no,
 		      sch->schib.pmcw.pnom);
 
diff -puN drivers/s390/crypto/zcrypt_api.h~drivers-s390-replace-remaining-__function__-occurrences drivers/s390/crypto/zcrypt_api.h
--- a/drivers/s390/crypto/zcrypt_api.h~drivers-s390-replace-remaining-__function__-occurrences
+++ a/drivers/s390/crypto/zcrypt_api.h
@@ -43,17 +43,17 @@
 #define DEV_NAME	"zcrypt"
 
 #define PRINTK(fmt, args...) \
-	printk(KERN_DEBUG DEV_NAME ": %s -> " fmt, __FUNCTION__ , ## args)
+	printk(KERN_DEBUG DEV_NAME ": %s -> " fmt, __func__ , ## args)
 #define PRINTKN(fmt, args...) \
 	printk(KERN_DEBUG DEV_NAME ": " fmt, ## args)
 #define PRINTKW(fmt, args...) \
-	printk(KERN_WARNING DEV_NAME ": %s -> " fmt, __FUNCTION__ , ## args)
+	printk(KERN_WARNING DEV_NAME ": %s -> " fmt, __func__ , ## args)
 #define PRINTKC(fmt, args...) \
-	printk(KERN_CRIT DEV_NAME ": %s -> " fmt, __FUNCTION__ , ## args)
+	printk(KERN_CRIT DEV_NAME ": %s -> " fmt, __func__ , ## args)
 
 #ifdef ZCRYPT_DEBUG
 #define PDEBUG(fmt, args...) \
-	printk(KERN_DEBUG DEV_NAME ": %s -> " fmt, __FUNCTION__ , ## args)
+	printk(KERN_DEBUG DEV_NAME ": %s -> " fmt, __func__ , ## args)
 #else
 #define PDEBUG(fmt, args...) do {} while (0)
 #endif
diff -puN drivers/s390/net/claw.c~drivers-s390-replace-remaining-__function__-occurrences drivers/s390/net/claw.c
--- a/drivers/s390/net/claw.c~drivers-s390-replace-remaining-__function__-occurrences
+++ a/drivers/s390/net/claw.c
@@ -299,7 +299,7 @@ claw_probe(struct ccwgroup_device *cgdev
 	struct claw_privbk *privptr=NULL;
 
 #ifdef FUNCTRACE
-	printk(KERN_INFO "%s Enter\n",__FUNCTION__);
+	printk(KERN_INFO "%s Enter\n",__func__);
 #endif
 	CLAW_DBF_TEXT(2,setup,"probe");
 	if (!get_device(&cgdev->dev))
@@ -313,7 +313,7 @@ claw_probe(struct ccwgroup_device *cgdev
 		probe_error(cgdev);
 		put_device(&cgdev->dev);
 		printk(KERN_WARNING "Out of memory %s %s Exit Line %d \n",
-			cgdev->cdev[0]->dev.bus_id,__FUNCTION__,__LINE__);
+			cgdev->cdev[0]->dev.bus_id,__func__,__LINE__);
 		CLAW_DBF_TEXT_(2,setup,"probex%d",-ENOMEM);
 		return -ENOMEM;
 	}
@@ -323,7 +323,7 @@ claw_probe(struct ccwgroup_device *cgdev
                 probe_error(cgdev);
 		put_device(&cgdev->dev);
 		printk(KERN_WARNING "Out of memory %s %s Exit Line %d \n",
-			cgdev->cdev[0]->dev.bus_id,__FUNCTION__,__LINE__);
+			cgdev->cdev[0]->dev.bus_id,__func__,__LINE__);
 		CLAW_DBF_TEXT_(2,setup,"probex%d",-ENOMEM);
                 return -ENOMEM;
         }
@@ -340,7 +340,7 @@ claw_probe(struct ccwgroup_device *cgdev
 		probe_error(cgdev);
 		put_device(&cgdev->dev);
 		printk(KERN_WARNING "add_files failed %s %s Exit Line %d \n",
-			cgdev->cdev[0]->dev.bus_id,__FUNCTION__,__LINE__);
+			cgdev->cdev[0]->dev.bus_id,__func__,__LINE__);
 		CLAW_DBF_TEXT_(2,setup,"probex%d",rc);
 		return rc;
 	}
@@ -351,7 +351,7 @@ claw_probe(struct ccwgroup_device *cgdev
 	cgdev->dev.driver_data = privptr;
 #ifdef FUNCTRACE
         printk(KERN_INFO "claw:%s exit on line %d, "
-		"rc = 0\n",__FUNCTION__,__LINE__);
+		"rc = 0\n",__func__,__LINE__);
 #endif
 	CLAW_DBF_TEXT(2,setup,"prbext 0");
 
@@ -371,7 +371,7 @@ claw_tx(struct sk_buff *skb, struct net_
         struct chbk *p_ch;
 
 #ifdef FUNCTRACE
-        printk(KERN_INFO "%s:%s enter\n",dev->name,__FUNCTION__);
+        printk(KERN_INFO "%s:%s enter\n",dev->name,__func__);
 #endif
 	CLAW_DBF_TEXT(4,trace,"claw_tx");
         p_ch=&privptr->channel[WRITE];
@@ -381,7 +381,7 @@ claw_tx(struct sk_buff *skb, struct net_
                 privptr->stats.tx_dropped++;
 #ifdef FUNCTRACE
                 printk(KERN_INFO "%s: %s() exit on line %d, rc = EIO\n",
-			dev->name,__FUNCTION__, __LINE__);
+			dev->name,__func__, __LINE__);
 #endif
 		CLAW_DBF_TEXT_(2,trace,"clawtx%d",-EIO);
                 return -EIO;
@@ -398,7 +398,7 @@ claw_tx(struct sk_buff *skb, struct net_
         spin_unlock_irqrestore(get_ccwdev_lock(p_ch->cdev), saveflags);
 #ifdef FUNCTRACE
         printk(KERN_INFO "%s:%s exit on line %d, rc = %d\n",
-		dev->name, __FUNCTION__, __LINE__, rc);
+		dev->name, __func__, __LINE__, rc);
 #endif
 	CLAW_DBF_TEXT_(4,trace,"clawtx%d",rc);
         return rc;
@@ -460,7 +460,7 @@ claw_pack_skb(struct claw_privbk *privpt
 #ifdef IOTRACE
 		printk(KERN_INFO "%s: %s() Packed %d len %d\n",
 			p_env->ndev->name,
-			__FUNCTION__,pkt_cnt,new_skb->len);
+			__func__,pkt_cnt,new_skb->len);
 #endif
 	}
 	CLAW_DBF_TEXT(4,trace,"PackSKBx");
@@ -478,7 +478,7 @@ claw_change_mtu(struct net_device *dev, 
 	struct claw_privbk  *privptr=dev->priv;
 	int buff_size;
 #ifdef FUNCTRACE
-        printk(KERN_INFO "%s:%s Enter  \n",dev->name,__FUNCTION__);
+        printk(KERN_INFO "%s:%s Enter  \n",dev->name,__func__);
 #endif
 #ifdef DEBUGMSG
         printk(KERN_INFO "variable dev =\n");
@@ -491,14 +491,14 @@ claw_change_mtu(struct net_device *dev, 
 #ifdef FUNCTRACE
                 printk(KERN_INFO "%s:%s Exit on line %d, rc=EINVAL\n",
 		dev->name,
-		__FUNCTION__, __LINE__);
+		__func__, __LINE__);
 #endif
                 return -EINVAL;
         }
         dev->mtu = new_mtu;
 #ifdef FUNCTRACE
         printk(KERN_INFO "%s:%s Exit on line %d\n",dev->name,
-	__FUNCTION__, __LINE__);
+	__func__, __LINE__);
 #endif
         return 0;
 }  /*   end of claw_change_mtu */
@@ -522,7 +522,7 @@ claw_open(struct net_device *dev)
         struct ccwbk *p_buf;
 
 #ifdef FUNCTRACE
-        printk(KERN_INFO "%s:%s Enter  \n",dev->name,__FUNCTION__);
+        printk(KERN_INFO "%s:%s Enter  \n",dev->name,__func__);
 #endif
 	CLAW_DBF_TEXT(4,trace,"open");
 	if (!dev || (dev->name[0] == 0x00)) {
@@ -537,7 +537,7 @@ claw_open(struct net_device *dev)
         	if (rc) {
                 	printk(KERN_INFO "%s:%s Exit on line %d, rc=ENOMEM\n",
 			dev->name,
-			__FUNCTION__, __LINE__);
+			__func__, __LINE__);
 			CLAW_DBF_TEXT(2,trace,"openmem");
                 	return -ENOMEM;
         	}
@@ -661,7 +661,7 @@ claw_open(struct net_device *dev)
                 claw_clear_busy(dev);
 #ifdef FUNCTRACE
                 printk(KERN_INFO "%s:%s Exit on line %d, rc=EIO\n",
-		dev->name,__FUNCTION__,__LINE__);
+		dev->name,__func__,__LINE__);
 #endif
 		CLAW_DBF_TEXT(2,trace,"open EIO");
                 return -EIO;
@@ -673,7 +673,7 @@ claw_open(struct net_device *dev)
 
 #ifdef FUNCTRACE
         printk(KERN_INFO "%s:%s Exit on line %d, rc=0\n",
-		dev->name,__FUNCTION__,__LINE__);
+		dev->name,__func__,__LINE__);
 #endif
 	CLAW_DBF_TEXT(4,trace,"openok");
         return 0;
@@ -696,7 +696,7 @@ claw_irq_handler(struct ccw_device *cdev
 
 
 #ifdef FUNCTRACE
-        printk(KERN_INFO "%s enter  \n",__FUNCTION__);
+        printk(KERN_INFO "%s enter  \n",__func__);
 #endif
 	CLAW_DBF_TEXT(4,trace,"clawirq");
         /* Bypass all 'unsolicited interrupts' */
@@ -706,7 +706,7 @@ claw_irq_handler(struct ccw_device *cdev
                         cdev->dev.bus_id,irb->scsw.cstat, irb->scsw.dstat);
 #ifdef FUNCTRACE
                 printk(KERN_INFO "claw: %s() "
-			"exit on line %d\n",__FUNCTION__,__LINE__);
+			"exit on line %d\n",__func__,__LINE__);
 #endif
 		CLAW_DBF_TEXT(2,trace,"badirq");
                 return;
@@ -752,7 +752,7 @@ claw_irq_handler(struct ccw_device *cdev
 #endif
 #ifdef FUNCTRACE
 		printk(KERN_INFO "%s:%s Exit on line %d\n",
-		dev->name,__FUNCTION__,__LINE__);
+		dev->name,__func__,__LINE__);
 #endif
 		CLAW_DBF_TEXT(2,trace,"chanchk");
                 /* return; */
@@ -777,7 +777,7 @@ claw_irq_handler(struct ccw_device *cdev
 	     		(SCSW_STCTL_ALERT_STATUS | SCSW_STCTL_STATUS_PEND)))) {
 #ifdef FUNCTRACE
                                 printk(KERN_INFO "%s:%s Exit on line %d\n",
-					dev->name,__FUNCTION__,__LINE__);
+					dev->name,__func__,__LINE__);
 #endif
                                 return;
                         }
@@ -788,7 +788,7 @@ claw_irq_handler(struct ccw_device *cdev
 #endif
 #ifdef FUNCTRACE
                         printk(KERN_INFO "%s:%s Exit on line %d\n",
-				dev->name,__FUNCTION__,__LINE__);
+				dev->name,__func__,__LINE__);
 #endif
 			CLAW_DBF_TEXT(4,trace,"stop");
                         return;
@@ -804,7 +804,7 @@ claw_irq_handler(struct ccw_device *cdev
 	     		(SCSW_STCTL_ALERT_STATUS | SCSW_STCTL_STATUS_PEND)))) {
 #ifdef FUNCTRACE
 				printk(KERN_INFO "%s:%s Exit on line %d\n",
-					dev->name,__FUNCTION__,__LINE__);
+					dev->name,__func__,__LINE__);
 #endif
 				CLAW_DBF_TEXT(4,trace,"haltio");
                                 return;
@@ -838,7 +838,7 @@ claw_irq_handler(struct ccw_device *cdev
 #endif
 #ifdef FUNCTRACE
                         printk(KERN_INFO "%s:%s Exit on line %d\n",
-				dev->name,__FUNCTION__,__LINE__);
+				dev->name,__func__,__LINE__);
 #endif
 			CLAW_DBF_TEXT(4,trace,"haltio");
                         return;
@@ -858,7 +858,7 @@ claw_irq_handler(struct ccw_device *cdev
                                 }
 #ifdef FUNCTRACE
 				printk(KERN_INFO "%s:%s Exit on line %d\n",
-					dev->name,__FUNCTION__,__LINE__);
+					dev->name,__func__,__LINE__);
 #endif
 					CLAW_DBF_TEXT(4,trace,"notrdy");
                                         return;
@@ -874,7 +874,7 @@ claw_irq_handler(struct ccw_device *cdev
 				}
 #ifdef FUNCTRACE
 				printk(KERN_INFO "%s:%s Exit on line %d\n",
-					dev->name,__FUNCTION__,__LINE__);
+					dev->name,__func__,__LINE__);
 #endif
 				CLAW_DBF_TEXT(4,trace,"PCI_read");
                                 return;
@@ -885,7 +885,7 @@ claw_irq_handler(struct ccw_device *cdev
 	     		 (SCSW_STCTL_ALERT_STATUS | SCSW_STCTL_STATUS_PEND)))) {
 #ifdef FUNCTRACE
 				printk(KERN_INFO "%s:%s Exit on line %d\n",
-					dev->name,__FUNCTION__,__LINE__);
+					dev->name,__func__,__LINE__);
 #endif
 				CLAW_DBF_TEXT(4,trace,"SPend_rd");
                                 return;
@@ -906,7 +906,7 @@ claw_irq_handler(struct ccw_device *cdev
 #endif
 #ifdef FUNCTRACE
 			printk(KERN_INFO "%s:%s Exit on line %d\n",
-				dev->name,__FUNCTION__,__LINE__);
+				dev->name,__func__,__LINE__);
 #endif
 			CLAW_DBF_TEXT(4,trace,"RdIRQXit");
                         return;
@@ -929,7 +929,7 @@ claw_irq_handler(struct ccw_device *cdev
                                 }
 #ifdef FUNCTRACE
 				printk(KERN_INFO "%s:%s Exit on line %d\n",
-					dev->name,__FUNCTION__,__LINE__);
+					dev->name,__func__,__LINE__);
 #endif
 				CLAW_DBF_TEXT(4,trace,"rstrtwrt");
                                 return;
@@ -946,7 +946,7 @@ claw_irq_handler(struct ccw_device *cdev
 	     		(SCSW_STCTL_ALERT_STATUS | SCSW_STCTL_STATUS_PEND)))) {
 #ifdef FUNCTRACE
 				printk(KERN_INFO "%s:%s Exit on line %d\n",
-					dev->name,__FUNCTION__,__LINE__);
+					dev->name,__func__,__LINE__);
 #endif
 				CLAW_DBF_TEXT(4,trace,"writeUE");
                                 return;
@@ -969,7 +969,7 @@ claw_irq_handler(struct ccw_device *cdev
 #endif
 #ifdef FUNCTRACE
 			printk(KERN_INFO "%s:%s Exit on line %d\n",
-				dev->name,__FUNCTION__,__LINE__);
+				dev->name,__func__,__LINE__);
 #endif
 			CLAW_DBF_TEXT(4,trace,"StWtExit");
                         return;
@@ -978,7 +978,7 @@ claw_irq_handler(struct ccw_device *cdev
 				"state=%d\n",dev->name,p_ch->claw_state);
 #ifdef FUNCTRACE
 			printk(KERN_INFO "%s:%s Exit on line %d\n",
-				dev->name,__FUNCTION__,__LINE__);
+				dev->name,__func__,__LINE__);
 #endif
 			CLAW_DBF_TEXT(2,trace,"badIRQ");
                         return;
@@ -1001,7 +1001,7 @@ claw_irq_tasklet ( unsigned long data )
 	p_ch = (struct chbk *) data;
         dev = (struct net_device *)p_ch->ndev;
 #ifdef FUNCTRACE
-        printk(KERN_INFO "%s:%s Enter  \n",dev->name,__FUNCTION__);
+        printk(KERN_INFO "%s:%s Enter  \n",dev->name,__func__);
 #endif
 #ifdef DEBUGMSG
         printk(KERN_INFO "%s: variable p_ch =\n",dev->name);
@@ -1021,7 +1021,7 @@ claw_irq_tasklet ( unsigned long data )
 	CLAW_DBF_TEXT(4,trace,"TskletXt");
 #ifdef FUNCTRACE
 	printk(KERN_INFO "%s:%s Exit on line %d\n",
-		dev->name,__FUNCTION__,__LINE__);
+		dev->name,__func__,__LINE__);
 #endif
         return;
 }       /*    end of claw_irq_bh    */
@@ -1048,7 +1048,7 @@ claw_release(struct net_device *dev)
         if (!privptr)
                 return 0;
 #ifdef FUNCTRACE
-        printk(KERN_INFO "%s:%s Enter  \n",dev->name,__FUNCTION__);
+        printk(KERN_INFO "%s:%s Enter  \n",dev->name,__func__);
 #endif
 	CLAW_DBF_TEXT(4,trace,"release");
 #ifdef DEBUGMSG
@@ -1090,7 +1090,7 @@ claw_release(struct net_device *dev)
 	if(privptr->buffs_alloc != 1) {
 #ifdef FUNCTRACE
 	printk(KERN_INFO "%s:%s Exit on line %d\n",
-		dev->name,__FUNCTION__,__LINE__);
+		dev->name,__func__,__LINE__);
 #endif
 		CLAW_DBF_TEXT(4,trace,"none2fre");
 		return 0;
@@ -1171,7 +1171,7 @@ claw_release(struct net_device *dev)
         }
 #ifdef FUNCTRACE
 	printk(KERN_INFO "%s:%s Exit on line %d\n",
-		dev->name,__FUNCTION__,__LINE__);
+		dev->name,__func__,__LINE__);
 #endif
 	CLAW_DBF_TEXT(4,trace,"rlsexit");
         return 0;
@@ -1192,7 +1192,7 @@ claw_write_retry ( struct chbk *p_ch )
 
 
 #ifdef FUNCTRACE
-        printk(KERN_INFO "%s:%s Enter\n",dev->name,__FUNCTION__);
+        printk(KERN_INFO "%s:%s Enter\n",dev->name,__func__);
         printk(KERN_INFO "claw: variable p_ch =\n");
         dumpit((char *) p_ch, sizeof(struct chbk));
 #endif
@@ -1200,20 +1200,20 @@ claw_write_retry ( struct chbk *p_ch )
         if (p_ch->claw_state == CLAW_STOP) {
 #ifdef FUNCTRACE
 		printk(KERN_INFO "%s:%s Exit on line %d\n",
-			dev->name,__FUNCTION__,__LINE__);
+			dev->name,__func__,__LINE__);
 #endif
         	return;
         }
 #ifdef DEBUGMSG
         printk( KERN_INFO "%s:%s  state-%02x\n" ,
 		dev->name,
-		__FUNCTION__,
+		__func__,
 		p_ch->claw_state);
 #endif
 	claw_strt_out_IO( dev );
 #ifdef FUNCTRACE
 	printk(KERN_INFO "%s:%s Exit on line %d\n",
-		dev->name,__FUNCTION__,__LINE__);
+		dev->name,__func__,__LINE__);
 #endif
 	CLAW_DBF_TEXT(4,trace,"rtry_xit");
         return;
@@ -1235,7 +1235,7 @@ claw_write_next ( struct chbk * p_ch )
 	int	rc;
 
 #ifdef FUNCTRACE
-        printk(KERN_INFO "%s:%s Enter  \n",p_ch->ndev->name,__FUNCTION__);
+        printk(KERN_INFO "%s:%s Enter  \n",p_ch->ndev->name,__func__);
         printk(KERN_INFO "%s: variable p_ch =\n",p_ch->ndev->name);
         dumpit((char *) p_ch, sizeof(struct chbk));
 #endif
@@ -1262,7 +1262,7 @@ claw_write_next ( struct chbk * p_ch )
 
 #ifdef FUNCTRACE
 	printk(KERN_INFO "%s:%s Exit on line %d\n",
-		dev->name,__FUNCTION__,__LINE__);
+		dev->name,__func__,__LINE__);
 #endif
         return;
 }      /* end of claw_write_next      */
@@ -1276,7 +1276,7 @@ static void
 claw_timer ( struct chbk * p_ch )
 {
 #ifdef FUNCTRACE
-        printk(KERN_INFO "%s:%s Entry\n",p_ch->ndev->name,__FUNCTION__);
+        printk(KERN_INFO "%s:%s Entry\n",p_ch->ndev->name,__func__);
         printk(KERN_INFO "%s: variable p_ch =\n",p_ch->ndev->name);
         dumpit((char *) p_ch, sizeof(struct chbk));
 #endif
@@ -1285,7 +1285,7 @@ claw_timer ( struct chbk * p_ch )
         wake_up(&p_ch->wait);
 #ifdef FUNCTRACE
 	printk(KERN_INFO "%s:%s Exit on line %d\n",
-		p_ch->ndev->name,__FUNCTION__,__LINE__);
+		p_ch->ndev->name,__func__,__LINE__);
 #endif
         return;
 }      /* end of claw_timer  */
@@ -1312,7 +1312,7 @@ pages_to_order_of_mag(int num_of_pages)
 	int	order_of_mag=1;		/* assume 2 pages */
 	int	nump=2;
 #ifdef FUNCTRACE
-        printk(KERN_INFO "%s Enter pages = %d \n",__FUNCTION__,num_of_pages);
+        printk(KERN_INFO "%s Enter pages = %d \n",__func__,num_of_pages);
 #endif
 	CLAW_DBF_TEXT_(5,trace,"pages%d",num_of_pages);
 	if (num_of_pages == 1)   {return 0; }  /* magnitude of 0 = 1 page */
@@ -1327,7 +1327,7 @@ pages_to_order_of_mag(int num_of_pages)
 	if (order_of_mag > 9) { order_of_mag = 9; }  /* I know it's paranoid */
 #ifdef FUNCTRACE
         printk(KERN_INFO "%s Exit on line %d, order = %d\n",
-	__FUNCTION__,__LINE__, order_of_mag);
+	__func__,__LINE__, order_of_mag);
 #endif
 	CLAW_DBF_TEXT_(5,trace,"mag%d",order_of_mag);
 	return order_of_mag;
@@ -1349,7 +1349,7 @@ add_claw_reads(struct net_device *dev, s
         struct ccwbk*  p_buf;
 #endif
 #ifdef FUNCTRACE
-        printk(KERN_INFO "%s:%s Enter  \n",dev->name,__FUNCTION__);
+        printk(KERN_INFO "%s:%s Enter  \n",dev->name,__func__);
 #endif
 #ifdef DEBUGMSG
         printk(KERN_INFO "dev\n");
@@ -1369,7 +1369,7 @@ add_claw_reads(struct net_device *dev, s
         if ( p_first==NULL) {
 #ifdef FUNCTRACE
 		printk(KERN_INFO "%s:%s Exit on line %d\n",
-			dev->name,__FUNCTION__,__LINE__);
+			dev->name,__func__,__LINE__);
 #endif
 		CLAW_DBF_TEXT(4,trace,"addexit");
                 return 0;
@@ -1400,9 +1400,9 @@ add_claw_reads(struct net_device *dev, s
         if ( privptr-> p_read_active_first ==NULL ) {
 #ifdef DEBUGMSG
                 printk(KERN_INFO "%s:%s p_read_active_first == NULL \n",
-			dev->name,__FUNCTION__);
+			dev->name,__func__);
                 printk(KERN_INFO "%s:%s Read active first/last changed \n",
-			dev->name,__FUNCTION__);
+			dev->name,__func__);
 #endif
                 privptr-> p_read_active_first= p_first;  /*    set new first */
                 privptr-> p_read_active_last = p_last;   /*    set new last  */
@@ -1411,7 +1411,7 @@ add_claw_reads(struct net_device *dev, s
 
 #ifdef DEBUGMSG
                 printk(KERN_INFO "%s:%s Read in progress \n",
-		dev->name,__FUNCTION__);
+		dev->name,__func__);
 #endif
                 /* set up TIC ccw  */
                 temp_ccw.cda= (__u32)__pa(&p_first->read);
@@ -1450,15 +1450,15 @@ add_claw_reads(struct net_device *dev, s
                 privptr->p_read_active_last=p_last;
         } /* end of if ( privptr-> p_read_active_first ==NULL)  */
 #ifdef IOTRACE
-        printk(KERN_INFO "%s:%s  dump p_last CCW BK \n",dev->name,__FUNCTION__);
+        printk(KERN_INFO "%s:%s  dump p_last CCW BK \n",dev->name,__func__);
         dumpit((char *)p_last, sizeof(struct ccwbk));
-        printk(KERN_INFO "%s:%s  dump p_end CCW BK \n",dev->name,__FUNCTION__);
+        printk(KERN_INFO "%s:%s  dump p_end CCW BK \n",dev->name,__func__);
         dumpit((char *)p_end, sizeof(struct endccw));
 
-        printk(KERN_INFO "%s:%s dump p_first CCW BK \n",dev->name,__FUNCTION__);
+        printk(KERN_INFO "%s:%s dump p_first CCW BK \n",dev->name,__func__);
         dumpit((char *)p_first, sizeof(struct ccwbk));
         printk(KERN_INFO "%s:%s Dump Active CCW chain \n",
-		dev->name,__FUNCTION__);
+		dev->name,__func__);
         p_buf=privptr->p_read_active_first;
         while (p_buf!=NULL) {
                 dumpit((char *)p_buf, sizeof(struct ccwbk));
@@ -1467,7 +1467,7 @@ add_claw_reads(struct net_device *dev, s
 #endif
 #ifdef FUNCTRACE
 	printk(KERN_INFO "%s:%s Exit on line %d\n",
-		dev->name,__FUNCTION__,__LINE__);
+		dev->name,__func__,__LINE__);
 #endif
 	CLAW_DBF_TEXT(4,trace,"addexit");
         return 0;
@@ -1483,7 +1483,7 @@ ccw_check_return_code(struct ccw_device 
 {
 #ifdef FUNCTRACE
         printk(KERN_INFO "%s: %s() > enter  \n",
-		cdev->dev.bus_id,__FUNCTION__);
+		cdev->dev.bus_id,__func__);
 #endif
 	CLAW_DBF_TEXT(4,trace,"ccwret");
 #ifdef DEBUGMSG
@@ -1516,7 +1516,7 @@ ccw_check_return_code(struct ccw_device 
         }
 #ifdef FUNCTRACE
         printk(KERN_INFO "%s: %s() > exit on line %d\n",
-		cdev->dev.bus_id,__FUNCTION__,__LINE__);
+		cdev->dev.bus_id,__func__,__LINE__);
 #endif
 	CLAW_DBF_TEXT(4,trace,"ccwret");
 }    /*    end of ccw_check_return_code   */
@@ -1531,7 +1531,7 @@ ccw_check_unit_check(struct chbk * p_ch,
 	struct net_device *dev = p_ch->ndev;
 
 #ifdef FUNCTRACE
-        printk(KERN_INFO "%s: %s() > enter\n",dev->name,__FUNCTION__);
+        printk(KERN_INFO "%s: %s() > enter\n",dev->name,__func__);
 #endif
 #ifdef DEBUGMSG
         printk(KERN_INFO "%s: variable dev =\n",dev->name);
@@ -1578,7 +1578,7 @@ ccw_check_unit_check(struct chbk * p_ch,
 
 #ifdef FUNCTRACE
         printk(KERN_INFO "%s: %s() exit on line %d\n",
-		dev->name,__FUNCTION__,__LINE__);
+		dev->name,__func__,__LINE__);
 #endif
 }   /*    end of ccw_check_unit_check    */
 
@@ -1706,7 +1706,7 @@ find_link(struct net_device *dev, char *
 	int    rc=0;
 
 #ifdef FUNCTRACE
-        printk(KERN_INFO "%s:%s > enter  \n",dev->name,__FUNCTION__);
+        printk(KERN_INFO "%s:%s > enter  \n",dev->name,__func__);
 #endif
 	CLAW_DBF_TEXT(2,setup,"findlink");
 #ifdef DEBUGMSG
@@ -1739,7 +1739,7 @@ find_link(struct net_device *dev, char *
 
 #ifdef FUNCTRACE
         printk(KERN_INFO "%s:%s Exit on line %d\n",
-		dev->name,__FUNCTION__,__LINE__);
+		dev->name,__func__,__LINE__);
 #endif
         return 0;
 }    /*    end of find_link    */
@@ -1773,7 +1773,7 @@ claw_hw_tx(struct sk_buff *skb, struct n
         struct ccwbk                   *p_buf;
 #endif
 #ifdef FUNCTRACE
-        printk(KERN_INFO "%s: %s() > enter\n",dev->name,__FUNCTION__);
+        printk(KERN_INFO "%s: %s() > enter\n",dev->name,__func__);
 #endif
 	CLAW_DBF_TEXT(4,trace,"hw_tx");
 #ifdef DEBUGMSG
@@ -1787,7 +1787,7 @@ claw_hw_tx(struct sk_buff *skb, struct n
         p_ch=(struct chbk *)&privptr->channel[WRITE];
 	p_env =privptr->p_env;
 #ifdef IOTRACE
-        printk(KERN_INFO "%s: %s() dump sk_buff  \n",dev->name,__FUNCTION__);
+        printk(KERN_INFO "%s: %s() dump sk_buff  \n",dev->name,__func__);
         dumpit((char *)skb ,sizeof(struct sk_buff));
 #endif
 	claw_free_wrt_buf(dev);	/* Clean up free chain if posible */
@@ -1877,7 +1877,7 @@ claw_hw_tx(struct sk_buff *skb, struct n
         while (len_of_data > 0) {
 #ifdef DEBUGMSG
                 printk(KERN_INFO "%s: %s() length-of-data is %ld \n",
-			dev->name ,__FUNCTION__,len_of_data);
+			dev->name ,__func__,len_of_data);
                 dumpit((char *)pDataAddress ,64);
 #endif
                 p_this_ccw=privptr->p_write_free_chain;  /* get a block */
@@ -1913,7 +1913,7 @@ claw_hw_tx(struct sk_buff *skb, struct n
                 p_last_ccw=p_this_ccw;      /* save new last block */
 #ifdef IOTRACE
 		printk(KERN_INFO "%s: %s() > CCW and Buffer %ld bytes long \n",
-			dev->name,__FUNCTION__,bytesInThisBuffer);
+			dev->name,__func__,bytesInThisBuffer);
                 dumpit((char *)p_this_ccw, sizeof(struct ccwbk));
                 dumpit((char *)p_this_ccw->p_buffer, 64);
 #endif
@@ -1998,7 +1998,7 @@ claw_hw_tx(struct sk_buff *skb, struct n
 
 #ifdef IOTRACE
         printk(KERN_INFO "%s: %s() >  Dump Active CCW chain \n",
-		dev->name,__FUNCTION__);
+		dev->name,__func__);
         p_buf=privptr->p_write_active_first;
         while (p_buf!=NULL) {
                 dumpit((char *)p_buf, sizeof(struct ccwbk));
@@ -2018,7 +2018,7 @@ claw_hw_tx(struct sk_buff *skb, struct n
         /*      if write free count is zero , set NOBUFFER       */
 #ifdef DEBUGMSG
         printk(KERN_INFO "%s: %s() > free_count is %d\n",
-		dev->name,__FUNCTION__,
+		dev->name,__func__,
 		(int) privptr->write_free_count );
 #endif
 	if (privptr->write_free_count==0) {
@@ -2029,7 +2029,7 @@ Done2:
 Done:
 #ifdef FUNCTRACE
         printk(KERN_INFO "%s: %s() > exit on line %d, rc = %d \n",
-		dev->name,__FUNCTION__,__LINE__, rc);
+		dev->name,__func__,__LINE__, rc);
 #endif
 	return(rc);
 }    /*    end of claw_hw_tx    */
@@ -2063,7 +2063,7 @@ init_ccw_bk(struct net_device *dev)
         addr_t   real_TIC_address;
         int i,j;
 #ifdef FUNCTRACE
-        printk(KERN_INFO "%s: %s() enter  \n",dev->name,__FUNCTION__);
+        printk(KERN_INFO "%s: %s() enter  \n",dev->name,__func__);
 #endif
 	CLAW_DBF_TEXT(4,trace,"init_ccw");
 #ifdef DEBUGMSG
@@ -2097,15 +2097,15 @@ init_ccw_bk(struct net_device *dev)
 #ifdef DEBUGMSG
         printk(KERN_INFO "%s: %s() "
 		"ccw_blocks_required=%d\n",
-		dev->name,__FUNCTION__,
+		dev->name,__func__,
 		ccw_blocks_required);
         printk(KERN_INFO "%s: %s() "
 		"PAGE_SIZE=0x%x\n",
-		dev->name,__FUNCTION__,
+		dev->name,__func__,
 		(unsigned int)PAGE_SIZE);
         printk(KERN_INFO "%s: %s() > "
 		"PAGE_MASK=0x%x\n",
-		dev->name,__FUNCTION__,
+		dev->name,__func__,
 		(unsigned int)PAGE_MASK);
 #endif
         /*
@@ -2117,10 +2117,10 @@ init_ccw_bk(struct net_device *dev)
 
 #ifdef DEBUGMSG
         printk(KERN_INFO "%s: %s() > ccw_blocks_perpage=%d\n",
-		dev->name,__FUNCTION__,
+		dev->name,__func__,
 		ccw_blocks_perpage);
         printk(KERN_INFO "%s: %s() > ccw_pages_required=%d\n",
-		dev->name,__FUNCTION__,
+		dev->name,__func__,
 		ccw_pages_required);
 #endif
         /*
@@ -2156,29 +2156,29 @@ init_ccw_bk(struct net_device *dev)
 #ifdef DEBUGMSG
         if (privptr->p_env->read_size < PAGE_SIZE) {
             printk(KERN_INFO "%s: %s() reads_perpage=%d\n",
-	    	dev->name,__FUNCTION__,
+	    	dev->name,__func__,
 		claw_reads_perpage);
         }
         else {
             printk(KERN_INFO "%s: %s() pages_perread=%d\n",
-	    	dev->name,__FUNCTION__,
+	    	dev->name,__func__,
 		privptr->p_buff_pages_perread);
         }
         printk(KERN_INFO "%s: %s() read_pages=%d\n",
-		dev->name,__FUNCTION__,
+		dev->name,__func__,
 		claw_read_pages);
         if (privptr->p_env->write_size < PAGE_SIZE) {
             printk(KERN_INFO "%s: %s() writes_perpage=%d\n",
-	    	dev->name,__FUNCTION__,
+	    	dev->name,__func__,
 		claw_writes_perpage);
         }
         else {
             printk(KERN_INFO "%s: %s() pages_perwrite=%d\n",
-	    	dev->name,__FUNCTION__,
+	    	dev->name,__func__,
 		privptr->p_buff_pages_perwrite);
         }
         printk(KERN_INFO "%s: %s() write_pages=%d\n",
-		dev->name,__FUNCTION__,
+		dev->name,__func__,
 		claw_write_pages);
 #endif
 
@@ -2194,12 +2194,12 @@ init_ccw_bk(struct net_device *dev)
                         printk(KERN_INFO "%s: %s()  "
 				"__get_free_pages for CCWs failed : "
 				"pages is %d\n",
-                                dev->name,__FUNCTION__,
+                                dev->name,__func__,
 				ccw_pages_required );
 #ifdef FUNCTRACE
                         printk(KERN_INFO "%s: %s() > "
 				"exit on line %d, rc = ENOMEM\n",
-				dev->name,__FUNCTION__,
+				dev->name,__func__,
 				 __LINE__);
 #endif
                         return -ENOMEM;
@@ -2218,7 +2218,7 @@ init_ccw_bk(struct net_device *dev)
         /*                              Initialize ending CCW block       */
 #ifdef DEBUGMSG
         printk(KERN_INFO "%s: %s() begin initialize ending CCW blocks\n",
-		dev->name,__FUNCTION__);
+		dev->name,__func__);
 #endif
 
         p_endccw=privptr->p_end_ccw;
@@ -2276,7 +2276,7 @@ init_ccw_bk(struct net_device *dev)
 
 #ifdef IOTRACE
         printk(KERN_INFO "%s: %s() dump claw ending CCW BK \n",
-		dev->name,__FUNCTION__);
+		dev->name,__func__);
         dumpit((char *)p_endccw, sizeof(struct endccw));
 #endif
 
@@ -2287,7 +2287,7 @@ init_ccw_bk(struct net_device *dev)
 
 #ifdef DEBUGMSG
         printk(KERN_INFO "%s: %s()  Begin build a chain of CCW buffer \n",
-		dev->name,__FUNCTION__);
+		dev->name,__func__);
 #endif
         p_buff=privptr->p_buff_ccw;
 
@@ -2306,7 +2306,7 @@ init_ccw_bk(struct net_device *dev)
 #ifdef DEBUGMSG
         printk(KERN_INFO "%s: %s() "
 		"End build a chain of CCW buffer \n",
-			dev->name,__FUNCTION__);
+			dev->name,__func__);
         p_buf=p_free_chain;
         while (p_buf!=NULL) {
                 dumpit((char *)p_buf, sizeof(struct ccwbk));
@@ -2321,7 +2321,7 @@ init_ccw_bk(struct net_device *dev)
 #ifdef DEBUGMSG
         printk(KERN_INFO "%s: %s() "
 		"Begin initialize ClawSignalBlock \n",
-		dev->name,__FUNCTION__);
+		dev->name,__func__);
 #endif
         if (privptr->p_claw_signal_blk==NULL) {
                 privptr->p_claw_signal_blk=p_free_chain;
@@ -2334,7 +2334,7 @@ init_ccw_bk(struct net_device *dev)
 #ifdef DEBUGMSG
         printk(KERN_INFO "%s: %s() >  End initialize "
 	 	"ClawSignalBlock\n",
-		dev->name,__FUNCTION__);
+		dev->name,__func__);
         dumpit((char *)privptr->p_claw_signal_blk, sizeof(struct ccwbk));
 #endif
 
@@ -2349,14 +2349,14 @@ init_ccw_bk(struct net_device *dev)
                 if (privptr->p_buff_write==NULL) {
                         printk(KERN_INFO "%s: %s() __get_free_pages for write"
 				" bufs failed : get is for %d pages\n",
-                                dev->name,__FUNCTION__,claw_write_pages );
+                                dev->name,__func__,claw_write_pages );
                         free_pages((unsigned long)privptr->p_buff_ccw,
 			   (int)pages_to_order_of_mag(privptr->p_buff_ccw_num));
                         privptr->p_buff_ccw=NULL;
 #ifdef FUNCTRACE
                         printk(KERN_INFO "%s: %s() > exit on line %d,"
 			 	"rc = ENOMEM\n",
-				dev->name,__FUNCTION__,__LINE__);
+				dev->name,__func__,__LINE__);
 #endif
                         return -ENOMEM;
                 }
@@ -2369,7 +2369,7 @@ init_ccw_bk(struct net_device *dev)
 			ccw_pages_required * PAGE_SIZE);
 #ifdef DEBUGMSG
                 printk(KERN_INFO "%s: %s() Begin build claw write free "
-			"chain \n",dev->name,__FUNCTION__);
+			"chain \n",dev->name,__func__);
 #endif
                 privptr->p_write_free_chain=NULL;
 
@@ -2409,14 +2409,14 @@ init_ccw_bk(struct net_device *dev)
 #ifdef IOTRACE
                    printk(KERN_INFO "%s:%s __get_free_pages "
 		    "for writes buf: get for %d pages\n",
-		    dev->name,__FUNCTION__,
+		    dev->name,__func__,
 		    privptr->p_buff_pages_perwrite);
 #endif
                    if (p_buff==NULL) {
 			printk(KERN_INFO "%s:%s __get_free_pages "
 			 	"for writes buf failed : get is for %d pages\n",
 				dev->name,
-				__FUNCTION__,
+				__func__,
 				privptr->p_buff_pages_perwrite );
                         free_pages((unsigned long)privptr->p_buff_ccw,
 			      (int)pages_to_order_of_mag(
@@ -2433,7 +2433,7 @@ init_ccw_bk(struct net_device *dev)
 #ifdef FUNCTRACE
                         printk(KERN_INFO "%s: %s exit on line %d, rc = ENOMEM\n",
 			dev->name,
-			__FUNCTION__,
+			__func__,
 			__LINE__);
 #endif
                         return -ENOMEM;
@@ -2466,7 +2466,7 @@ init_ccw_bk(struct net_device *dev)
 
 #ifdef DEBUGMSG
         printk(KERN_INFO "%s:%s  End build claw write free chain \n",
-	dev->name,__FUNCTION__);
+	dev->name,__func__);
         p_buf=privptr->p_write_free_chain;
         while (p_buf!=NULL) {
                 dumpit((char *)p_buf, sizeof(struct ccwbk));
@@ -2485,7 +2485,7 @@ init_ccw_bk(struct net_device *dev)
                         printk(KERN_INFO "%s: %s() "
 			 	"__get_free_pages for read buf failed : "
 			 	"get is for %d pages\n",
-                                dev->name,__FUNCTION__,claw_read_pages );
+                                dev->name,__func__,claw_read_pages );
                         free_pages((unsigned long)privptr->p_buff_ccw,
 				(int)pages_to_order_of_mag(
 					privptr->p_buff_ccw_num));
@@ -2497,7 +2497,7 @@ init_ccw_bk(struct net_device *dev)
                         privptr->p_buff_write=NULL;
 #ifdef FUNCTRACE
                         printk(KERN_INFO "%s: %s() > exit on line %d, rc ="
-				" ENOMEM\n",dev->name,__FUNCTION__,__LINE__);
+				" ENOMEM\n",dev->name,__func__,__LINE__);
 #endif
                         return -ENOMEM;
                 }
@@ -2509,7 +2509,7 @@ init_ccw_bk(struct net_device *dev)
                 */
 #ifdef DEBUGMSG
                 printk(KERN_INFO "%s: %s() Begin build claw read free chain \n",
-			dev->name,__FUNCTION__);
+			dev->name,__func__);
 #endif
                 p_buff=privptr->p_buff_read;
                 for (i=0 ; i< privptr->p_env->read_buffers ; i++) {
@@ -2590,7 +2590,7 @@ init_ccw_bk(struct net_device *dev)
 
 #ifdef DEBUGMSG
         printk(KERN_INFO "%s: %s() Begin build claw read free chain \n",
-		dev->name,__FUNCTION__);
+		dev->name,__func__);
 #endif
                 for (i=0 ; i< privptr->p_env->read_buffers ; i++) {
                         p_buff = (void *)__get_free_pages(__GFP_DMA,
@@ -2598,7 +2598,7 @@ init_ccw_bk(struct net_device *dev)
                         if (p_buff==NULL) {
                                 printk(KERN_INFO "%s: %s() __get_free_pages for read "
 					"buf failed : get is for %d pages\n",
-					dev->name,__FUNCTION__,
+					dev->name,__func__,
                                         privptr->p_buff_pages_perread );
                                 free_pages((unsigned long)privptr->p_buff_ccw,
 					(int)pages_to_order_of_mag(privptr->p_buff_ccw_num));
@@ -2622,7 +2622,7 @@ init_ccw_bk(struct net_device *dev)
                                 privptr->p_buff_write=NULL;
 #ifdef FUNCTRACE
                                 printk(KERN_INFO "%s: %s() exit on line %d, rc = ENOMEM\n",
-					dev->name,__FUNCTION__,
+					dev->name,__func__,
 					__LINE__);
 #endif
                                 return -ENOMEM;
@@ -2695,7 +2695,7 @@ init_ccw_bk(struct net_device *dev)
         }       /*  pBuffread = NULL */
 #ifdef DEBUGMSG
         printk(KERN_INFO "%s: %s() >  End build claw read free chain \n",
-		dev->name,__FUNCTION__);
+		dev->name,__func__);
         p_buf=p_first_CCWB;
         while (p_buf!=NULL) {
                 dumpit((char *)p_buf, sizeof(struct ccwbk));
@@ -2707,7 +2707,7 @@ init_ccw_bk(struct net_device *dev)
 	privptr->buffs_alloc = 1;
 #ifdef FUNCTRACE
         printk(KERN_INFO "%s: %s() exit on line %d\n",
-		dev->name,__FUNCTION__,__LINE__);
+		dev->name,__func__,__LINE__);
 #endif
         return 0;
 }    /*    end of init_ccw_bk */
@@ -2723,11 +2723,11 @@ probe_error( struct ccwgroup_device *cgd
 {
   struct claw_privbk *privptr;
 #ifdef FUNCTRACE
-        printk(KERN_INFO "%s enter  \n",__FUNCTION__);
+        printk(KERN_INFO "%s enter  \n",__func__);
 #endif
 	CLAW_DBF_TEXT(4,trace,"proberr");
 #ifdef DEBUGMSG
-        printk(KERN_INFO "%s variable cgdev =\n",__FUNCTION__);
+        printk(KERN_INFO "%s variable cgdev =\n",__func__);
         dumpit((char *) cgdev, sizeof(struct ccwgroup_device));
 #endif
         privptr=(struct claw_privbk *)cgdev->dev.driver_data;
@@ -2741,7 +2741,7 @@ probe_error( struct ccwgroup_device *cgd
         }
 #ifdef FUNCTRACE
         printk(KERN_INFO "%s > exit on line %d\n",
-		 __FUNCTION__,__LINE__);
+		 __func__,__LINE__);
 #endif
 
         return;
@@ -2772,7 +2772,7 @@ claw_process_control( struct net_device 
         struct chbk *p_ch = NULL;
 #ifdef FUNCTRACE
         printk(KERN_INFO "%s: %s() > enter  \n",
-		dev->name,__FUNCTION__);
+		dev->name,__func__);
 #endif
 	CLAW_DBF_TEXT(2,setup,"clw_cntl");
 #ifdef DEBUGMSG
@@ -2794,7 +2794,7 @@ claw_process_control( struct net_device 
 #ifdef FUNCTRACE
                 printk(KERN_INFO "%s: %s() > "
 			"exit on line %d, rc=0\n",
-			dev->name,__FUNCTION__,__LINE__);
+			dev->name,__func__,__LINE__);
 #endif
                 return 0;
         }
@@ -3057,7 +3057,7 @@ claw_process_control( struct net_device 
 
 #ifdef FUNCTRACE
         printk(KERN_INFO "%s: %s() exit on line %d, rc = 0\n",
-		dev->name,__FUNCTION__,__LINE__);
+		dev->name,__func__,__LINE__);
 #endif
 
         return 0;
@@ -3080,7 +3080,7 @@ claw_send_control(struct net_device *dev
         struct sk_buff 			*skb;
 
 #ifdef FUNCTRACE
-        printk(KERN_INFO "%s:%s > enter  \n",dev->name,__FUNCTION__);
+        printk(KERN_INFO "%s:%s > enter  \n",dev->name,__func__);
 #endif
 	CLAW_DBF_TEXT(2,setup,"sndcntl");
 #ifdef DEBUGMSG
@@ -3143,10 +3143,10 @@ claw_send_control(struct net_device *dev
         skb = dev_alloc_skb(sizeof(struct clawctl));
         if (!skb) {
                 printk(  "%s:%s low on mem, returning...\n",
-			dev->name,__FUNCTION__);
+			dev->name,__func__);
 #ifdef DEBUG
                 printk(KERN_INFO "%s:%s Exit, rc = ENOMEM\n",
-			dev->name,__FUNCTION__);
+			dev->name,__func__);
 #endif
                 return -ENOMEM;
         }
@@ -3162,7 +3162,7 @@ claw_send_control(struct net_device *dev
         	claw_hw_tx(skb, dev, 0);
 #ifdef FUNCTRACE
         printk(KERN_INFO "%s:%s Exit on line %d\n",
-		dev->name,__FUNCTION__,__LINE__);
+		dev->name,__func__,__LINE__);
 #endif
 
         return 0;
@@ -3180,7 +3180,7 @@ claw_snd_conn_req(struct net_device *dev
         struct clawctl 	   *p_ctl;
 
 #ifdef FUNCTRACE
-        printk(KERN_INFO "%s:%s Enter  \n",dev->name,__FUNCTION__);
+        printk(KERN_INFO "%s:%s Enter  \n",dev->name,__func__);
 #endif
 	CLAW_DBF_TEXT(2,setup,"snd_conn");
 #ifdef  DEBUGMSG
@@ -3193,7 +3193,7 @@ claw_snd_conn_req(struct net_device *dev
         if ( privptr->system_validate_comp==0x00 ) {
 #ifdef FUNCTRACE
                 printk(KERN_INFO "%s:%s Exit on line %d, rc = 1\n",
-			dev->name,__FUNCTION__,__LINE__);
+			dev->name,__func__,__LINE__);
 #endif
                 return rc;
         }
@@ -3209,7 +3209,7 @@ claw_snd_conn_req(struct net_device *dev
        			HOST_APPL_NAME, privptr->p_env->api_type);
 #ifdef FUNCTRACE
         printk(KERN_INFO "%s:%s Exit on line %d, rc = %d\n",
-		dev->name,__FUNCTION__,__LINE__, rc);
+		dev->name,__func__,__LINE__, rc);
 #endif
         return rc;
 
@@ -3228,7 +3228,7 @@ claw_snd_disc(struct net_device *dev, st
         struct conncmd *  p_connect;
 
 #ifdef FUNCTRACE
-        printk(KERN_INFO "%s:%s Enter\n",dev->name,__FUNCTION__);
+        printk(KERN_INFO "%s:%s Enter\n",dev->name,__func__);
 #endif
 	CLAW_DBF_TEXT(2,setup,"snd_dsc");
 #ifdef  DEBUGMSG
@@ -3244,7 +3244,7 @@ claw_snd_disc(struct net_device *dev, st
                 p_connect->host_name, p_connect->WS_name);
 #ifdef FUNCTRACE
         printk(KERN_INFO "%s:%s Exit on line %d, rc = %d\n",
-		dev->name,__FUNCTION__, __LINE__, rc);
+		dev->name,__func__, __LINE__, rc);
 #endif
         return rc;
 }     /*   end of claw_snd_disc    */
@@ -3265,7 +3265,7 @@ claw_snd_sys_validate_rsp(struct net_dev
 
 #ifdef FUNCTRACE
         printk(KERN_INFO "%s:%s Enter\n",
-		dev->name,__FUNCTION__);
+		dev->name,__func__);
 #endif
 	CLAW_DBF_TEXT(2,setup,"chkresp");
 #ifdef DEBUGMSG
@@ -3285,7 +3285,7 @@ claw_snd_sys_validate_rsp(struct net_dev
 		p_env->adapter_name  );
 #ifdef FUNCTRACE
         printk(KERN_INFO "%s:%s Exit on line %d, rc = %d\n",
-		dev->name,__FUNCTION__,__LINE__, rc);
+		dev->name,__func__,__LINE__, rc);
 #endif
         return rc;
 }     /*    end of claw_snd_sys_validate_rsp    */
@@ -3301,7 +3301,7 @@ claw_strt_conn_req(struct net_device *de
         int rc;
 
 #ifdef FUNCTRACE
-        printk(KERN_INFO "%s:%s Enter\n",dev->name,__FUNCTION__);
+        printk(KERN_INFO "%s:%s Enter\n",dev->name,__func__);
 #endif
 	CLAW_DBF_TEXT(2,setup,"conn_req");
 #ifdef DEBUGMSG
@@ -3311,7 +3311,7 @@ claw_strt_conn_req(struct net_device *de
         rc=claw_snd_conn_req(dev, 1);
 #ifdef FUNCTRACE
         printk(KERN_INFO "%s:%s Exit on line %d, rc = %d\n",
-		dev->name,__FUNCTION__,__LINE__, rc);
+		dev->name,__func__,__LINE__, rc);
 #endif
         return rc;
 }    /*   end of claw_strt_conn_req   */
@@ -3327,13 +3327,13 @@ net_device_stats *claw_stats(struct net_
 {
         struct claw_privbk *privptr;
 #ifdef FUNCTRACE
-        printk(KERN_INFO "%s:%s Enter\n",dev->name,__FUNCTION__);
+        printk(KERN_INFO "%s:%s Enter\n",dev->name,__func__);
 #endif
 	CLAW_DBF_TEXT(4,trace,"stats");
         privptr = dev->priv;
 #ifdef FUNCTRACE
         printk(KERN_INFO "%s:%s Exit on line %d\n",
-		dev->name,__FUNCTION__,__LINE__);
+		dev->name,__func__,__LINE__);
 #endif
         return &privptr->stats;
 }     /*   end of claw_stats   */
@@ -3366,7 +3366,7 @@ unpack_read(struct net_device *dev )
 	int     p=0;
 
 #ifdef FUNCTRACE
-        printk(KERN_INFO "%s:%s enter  \n",dev->name,__FUNCTION__);
+        printk(KERN_INFO "%s:%s enter  \n",dev->name,__func__);
 #endif
 	CLAW_DBF_TEXT(4,trace,"unpkread");
         p_first_ccw=NULL;
@@ -3408,7 +3408,7 @@ unpack_read(struct net_device *dev )
                 if ((p_this_ccw->header.opcode & MORE_to_COME_FLAG)!=0) {
 #ifdef DEBUGMSG
                         printk(KERN_INFO "%s: %s > More_to_come is ON\n",
-			dev->name,__FUNCTION__);
+			dev->name,__func__);
 #endif
                         mtc_this_frm=1;
                         if (p_this_ccw->header.length!=
@@ -3435,7 +3435,7 @@ unpack_read(struct net_device *dev )
 #ifdef DEBUGMSG
                         printk(KERN_INFO "%s:%s goto next "
 				"frame from MoretoComeSkip \n",
-				dev->name,__FUNCTION__);
+				dev->name,__func__);
 #endif
                         goto NextFrame;
                 }
@@ -3445,7 +3445,7 @@ unpack_read(struct net_device *dev )
 #ifdef DEBUGMSG
                         printk(KERN_INFO "%s:%s goto next "
 				"frame from claw_process_control \n",
-				dev->name,__FUNCTION__);
+				dev->name,__func__);
 #endif
 			CLAW_DBF_TEXT(4,trace,"UnpkCntl");
                         goto NextFrame;
@@ -3468,7 +3468,7 @@ unpack_next:
                 if (privptr->mtc_logical_link<0) {
 #ifdef DEBUGMSG
                 printk(KERN_INFO "%s: %s mtc_logical_link < 0  \n",
-			dev->name,__FUNCTION__);
+			dev->name,__func__);
 #endif
 
                 /*
@@ -3487,7 +3487,7 @@ unpack_next:
                         printk(KERN_INFO "%s: %s > goto next "
 				"frame from MoretoComeSkip \n",
 				dev->name,
-				__FUNCTION__);
+				__func__);
                         printk(KERN_INFO "      bytes_to_mov %d > (MAX_ENVELOPE_"
 				"SIZE-privptr->mtc_offset %d)\n",
 				bytes_to_mov,(MAX_ENVELOPE_SIZE- privptr->mtc_offset));
@@ -3505,13 +3505,13 @@ unpack_next:
 		}
 #ifdef DEBUGMSG
                 printk(KERN_INFO "%s: %s() received data \n",
-			dev->name,__FUNCTION__);
+			dev->name,__func__);
 		if (p_env->packing == DO_PACKED)
 			dumpit((char *)p_packd+sizeof(struct clawph),32);
 		else
 	                dumpit((char *)p_this_ccw->p_buffer, 32);
 		printk(KERN_INFO "%s: %s() bytelength %d \n",
-			dev->name,__FUNCTION__,bytes_to_mov);
+			dev->name,__func__,bytes_to_mov);
 #endif
                 if (mtc_this_frm==0) {
                         len_of_data=privptr->mtc_offset+bytes_to_mov;
@@ -3530,13 +3530,13 @@ unpack_next:
 #ifdef DEBUGMSG
                                 printk(KERN_INFO "%s: %s() netif_"
 					"rx(skb) completed \n",
-					dev->name,__FUNCTION__);
+					dev->name,__func__);
 #endif
                         }
                         else {
                                 privptr->stats.rx_dropped++;
                                 printk(KERN_WARNING "%s: %s() low on memory\n",
-				dev->name,__FUNCTION__);
+				dev->name,__func__);
                         }
                         privptr->mtc_offset=0;
                         privptr->mtc_logical_link=-1;
@@ -3575,10 +3575,10 @@ NextFrame:
 
 #ifdef IOTRACE
         printk(KERN_INFO "%s:%s processed frame is %d \n",
-		dev->name,__FUNCTION__,i);
+		dev->name,__func__,i);
         printk(KERN_INFO "%s:%s  F:%lx L:%lx\n",
 		dev->name,
-		__FUNCTION__,
+		__func__,
 		(unsigned long)p_first_ccw,
 		(unsigned long)p_last_ccw);
 #endif
@@ -3588,7 +3588,7 @@ NextFrame:
         claw_strt_read(dev, LOCK_YES);
 #ifdef FUNCTRACE
         printk(KERN_INFO "%s: %s exit on line %d\n",
-		dev->name, __FUNCTION__, __LINE__);
+		dev->name, __func__, __LINE__);
 #endif
         return;
 }     /*  end of unpack_read   */
@@ -3610,7 +3610,7 @@ claw_strt_read (struct net_device *dev, 
         p_ch=&privptr->channel[READ];
 
 #ifdef FUNCTRACE
-        printk(KERN_INFO "%s:%s Enter  \n",dev->name,__FUNCTION__);
+        printk(KERN_INFO "%s:%s Enter  \n",dev->name,__func__);
         printk(KERN_INFO "%s: variable lock = %d, dev =\n",dev->name, lock);
         dumpit((char *) dev, sizeof(struct net_device));
 #endif
@@ -3626,7 +3626,7 @@ claw_strt_read (struct net_device *dev, 
         }
 #ifdef DEBUGMSG
         printk(KERN_INFO "%s:%s state-%02x\n" ,
-		dev->name,__FUNCTION__, p_ch->claw_state);
+		dev->name,__func__, p_ch->claw_state);
 #endif
         if (lock==LOCK_YES) {
                 spin_lock_irqsave(get_ccwdev_lock(p_ch->cdev), saveflags);
@@ -3634,7 +3634,7 @@ claw_strt_read (struct net_device *dev, 
         if (test_and_set_bit(0, (void *)&p_ch->IO_active) == 0) {
 #ifdef DEBUGMSG
                 printk(KERN_INFO "%s: HOT READ started in %s\n" ,
-			dev->name,__FUNCTION__);
+			dev->name,__func__);
                 p_clawh=(struct clawh *)privptr->p_claw_signal_blk;
                 dumpit((char *)&p_clawh->flag , 1);
 #endif
@@ -3650,7 +3650,7 @@ claw_strt_read (struct net_device *dev, 
 	else {
 #ifdef DEBUGMSG
 		printk(KERN_INFO "%s: No READ started by %s() In progress\n" ,
-			dev->name,__FUNCTION__);
+			dev->name,__func__);
 #endif
 		CLAW_DBF_TEXT(2,trace,"ReadAct");
 	}
@@ -3660,7 +3660,7 @@ claw_strt_read (struct net_device *dev, 
         }
 #ifdef FUNCTRACE
         printk(KERN_INFO "%s:%s Exit on line %d\n",
-		dev->name,__FUNCTION__,__LINE__);
+		dev->name,__func__,__LINE__);
 #endif
 	CLAW_DBF_TEXT(4,trace,"StRdExit");
         return;
@@ -3681,7 +3681,7 @@ claw_strt_out_IO( struct net_device *dev
         struct ccwbk   	*p_first_ccw;
 
 #ifdef FUNCTRACE
-        printk(KERN_INFO "%s:%s Enter\n",dev->name,__FUNCTION__);
+        printk(KERN_INFO "%s:%s Enter\n",dev->name,__func__);
 #endif
 	if (!dev) {
 		return;
@@ -3691,7 +3691,7 @@ claw_strt_out_IO( struct net_device *dev
 
 #ifdef DEBUGMSG
         printk(KERN_INFO "%s:%s state-%02x\n" ,
-		dev->name,__FUNCTION__,p_ch->claw_state);
+		dev->name,__func__,p_ch->claw_state);
 #endif
         CLAW_DBF_TEXT(4,trace,"strt_io");
         p_first_ccw=privptr->p_write_active_first;
@@ -3701,14 +3701,14 @@ claw_strt_out_IO( struct net_device *dev
         if (p_first_ccw == NULL) {
 #ifdef FUNCTRACE
                 printk(KERN_INFO "%s:%s Exit on line %d\n",
-			dev->name,__FUNCTION__,__LINE__);
+			dev->name,__func__,__LINE__);
 #endif
                 return;
         }
         if (test_and_set_bit(0, (void *)&p_ch->IO_active) == 0) {
                 parm = (unsigned long) p_ch;
 #ifdef DEBUGMSG
-                printk(KERN_INFO "%s:%s do_io \n" ,dev->name,__FUNCTION__);
+                printk(KERN_INFO "%s:%s do_io \n" ,dev->name,__func__);
                 dumpit((char *)p_first_ccw, sizeof(struct ccwbk));
 #endif
 		CLAW_DBF_TEXT(2,trace,"StWrtIO");
@@ -3721,7 +3721,7 @@ claw_strt_out_IO( struct net_device *dev
         dev->trans_start = jiffies;
 #ifdef FUNCTRACE
 	printk(KERN_INFO "%s:%s Exit on line %d\n",
-		dev->name,__FUNCTION__,__LINE__);
+		dev->name,__func__,__LINE__);
 #endif
 
         return;
@@ -3745,7 +3745,7 @@ claw_free_wrt_buf( struct net_device *de
         struct ccwbk*p_buf;
 #endif
 #ifdef FUNCTRACE
-        printk(KERN_INFO "%s:%s Enter\n",dev->name,__FUNCTION__);
+        printk(KERN_INFO "%s:%s Enter\n",dev->name,__func__);
         printk(KERN_INFO "%s: free count = %d  variable dev =\n",
 		dev->name,privptr->write_free_count);
 #endif
@@ -3798,7 +3798,7 @@ claw_free_wrt_buf( struct net_device *de
                 privptr->p_write_active_last=NULL;
 #ifdef DEBUGMSG
                 printk(KERN_INFO "%s:%s p_write_"
-			"active_first==NULL\n",dev->name,__FUNCTION__);
+			"active_first==NULL\n",dev->name,__func__);
 #endif
         }
 #ifdef IOTRACE
@@ -3819,7 +3819,7 @@ claw_free_wrt_buf( struct net_device *de
 	CLAW_DBF_TEXT_(4,trace,"FWC=%d",privptr->write_free_count);
 #ifdef FUNCTRACE
         printk(KERN_INFO "%s:%s Exit on line %d free_count =%d\n",
-		dev->name,__FUNCTION__, __LINE__,privptr->write_free_count);
+		dev->name,__func__, __LINE__,privptr->write_free_count);
 #endif
         return;
 }
@@ -3833,7 +3833,7 @@ claw_free_netdevice(struct net_device * 
 {
 	struct claw_privbk *privptr;
 #ifdef FUNCTRACE
-        printk(KERN_INFO "%s:%s Enter\n",dev->name,__FUNCTION__);
+        printk(KERN_INFO "%s:%s Enter\n",dev->name,__func__);
 #endif
 	CLAW_DBF_TEXT(2,setup,"free_dev");
 
@@ -3854,7 +3854,7 @@ claw_free_netdevice(struct net_device * 
 #endif
 	CLAW_DBF_TEXT(2,setup,"feee_ok");
 #ifdef FUNCTRACE
-        printk(KERN_INFO "%s:%s Exit\n",dev->name,__FUNCTION__);
+        printk(KERN_INFO "%s:%s Exit\n",dev->name,__func__);
 #endif
 }
 
@@ -3867,13 +3867,13 @@ static void
 claw_init_netdevice(struct net_device * dev)
 {
 #ifdef FUNCTRACE
-        printk(KERN_INFO "%s:%s Enter\n",dev->name,__FUNCTION__);
+        printk(KERN_INFO "%s:%s Enter\n",dev->name,__func__);
 #endif
 	CLAW_DBF_TEXT(2,setup,"init_dev");
 	CLAW_DBF_TEXT_(2,setup,"%s",dev->name);
 	if (!dev) {
         printk(KERN_WARNING "claw:%s BAD Device exit line %d\n",
-		__FUNCTION__,__LINE__);
+		__func__,__LINE__);
 		CLAW_DBF_TEXT(2,setup,"baddev");
 		return;
 	}
@@ -3889,7 +3889,7 @@ claw_init_netdevice(struct net_device * 
 	dev->tx_queue_len = 1300;
 	dev->flags = IFF_POINTOPOINT | IFF_NOARP;
 #ifdef FUNCTRACE
-        printk(KERN_INFO "%s:%s Exit\n",dev->name,__FUNCTION__);
+        printk(KERN_INFO "%s:%s Exit\n",dev->name,__func__);
 #endif
 	CLAW_DBF_TEXT(2,setup,"initok");
 	return;
@@ -3909,7 +3909,7 @@ add_channel(struct ccw_device *cdev,int 
 	struct ccw_dev_id dev_id;
 
 #ifdef FUNCTRACE
-        printk(KERN_INFO "%s:%s Enter\n",cdev->dev.bus_id,__FUNCTION__);
+        printk(KERN_INFO "%s:%s Enter\n",cdev->dev.bus_id,__func__);
 #endif
 	CLAW_DBF_TEXT_(2,setup,"%s",cdev->dev.bus_id);
 	privptr->channel[i].flag  = i+1;   /* Read is 1 Write is 2 */
@@ -3920,16 +3920,16 @@ add_channel(struct ccw_device *cdev,int 
 	p_ch->devno = dev_id.devno;
 	if ((p_ch->irb = kzalloc(sizeof (struct irb),GFP_KERNEL)) == NULL) {
 		printk(KERN_WARNING "%s Out of memory in %s for irb\n",
-			p_ch->id,__FUNCTION__);
+			p_ch->id,__func__);
 #ifdef FUNCTRACE
         	printk(KERN_INFO "%s:%s Exit on line %d\n",
-			p_ch->id,__FUNCTION__,__LINE__);
+			p_ch->id,__func__,__LINE__);
 #endif
 		return -ENOMEM;
 	}
 #ifdef FUNCTRACE
         	printk(KERN_INFO "%s:%s Exit on line %d\n",
-			cdev->dev.bus_id,__FUNCTION__,__LINE__);
+			cdev->dev.bus_id,__func__,__LINE__);
 #endif
 	return 0;
 }
@@ -3952,7 +3952,7 @@ claw_new_device(struct ccwgroup_device *
 	int ret;
 	struct ccw_dev_id dev_id;
 
-	pr_debug("%s() called\n", __FUNCTION__);
+	pr_debug("%s() called\n", __func__);
 	printk(KERN_INFO "claw: add for %s\n",cgdev->cdev[READ]->dev.bus_id);
 	CLAW_DBF_TEXT(2,setup,"new_dev");
 	privptr = cgdev->dev.driver_data;
@@ -3990,7 +3990,7 @@ claw_new_device(struct ccwgroup_device *
 	}
 	dev = alloc_netdev(0,"claw%d",claw_init_netdevice);
 	if (!dev) {
-		printk(KERN_WARNING "%s:alloc_netdev failed\n",__FUNCTION__);
+		printk(KERN_WARNING "%s:alloc_netdev failed\n",__func__);
 		goto out;
 	}
 	dev->priv = privptr;
@@ -4065,7 +4065,7 @@ claw_shutdown_device(struct ccwgroup_dev
 	struct net_device *ndev;
 	int	ret;
 
-	pr_debug("%s() called\n", __FUNCTION__);
+	pr_debug("%s() called\n", __func__);
 	CLAW_DBF_TEXT_(2,setup,"%s",cgdev->dev.bus_id);
 	priv = cgdev->dev.driver_data;
 	if (!priv)
@@ -4095,15 +4095,15 @@ claw_remove_device(struct ccwgroup_devic
 {
 	struct claw_privbk *priv;
 
-	pr_debug("%s() called\n", __FUNCTION__);
+	pr_debug("%s() called\n", __func__);
 	CLAW_DBF_TEXT_(2,setup,"%s",cgdev->dev.bus_id);
 	priv = cgdev->dev.driver_data;
 	if (!priv) {
-		printk(KERN_WARNING "claw: %s() no Priv exiting\n",__FUNCTION__);
+		printk(KERN_WARNING "claw: %s() no Priv exiting\n",__func__);
 		return;
 	}
 	printk(KERN_INFO "claw: %s() called %s will be removed.\n",
-			__FUNCTION__,cgdev->cdev[0]->dev.bus_id);
+			__func__,cgdev->cdev[0]->dev.bus_id);
 	if (cgdev->state == CCWGROUP_ONLINE)
 		claw_shutdown_device(cgdev);
 	claw_remove_files(&cgdev->dev);
@@ -4346,7 +4346,7 @@ static struct attribute_group claw_attr_
 static int
 claw_add_files(struct device *dev)
 {
-	pr_debug("%s() called\n", __FUNCTION__);
+	pr_debug("%s() called\n", __func__);
 	CLAW_DBF_TEXT(2,setup,"add_file");
 	return sysfs_create_group(&dev->kobj, &claw_attr_group);
 }
@@ -4354,7 +4354,7 @@ claw_add_files(struct device *dev)
 static void
 claw_remove_files(struct device *dev)
 {
-	pr_debug("%s() called\n", __FUNCTION__);
+	pr_debug("%s() called\n", __func__);
 	CLAW_DBF_TEXT(2,setup,"rem_file");
 	sysfs_remove_group(&dev->kobj, &claw_attr_group);
 }
@@ -4385,12 +4385,12 @@ claw_init(void)
 	printk(KERN_INFO "claw: starting driver\n");
 
 #ifdef FUNCTRACE
-        printk(KERN_INFO "claw: %s() enter \n",__FUNCTION__);
+        printk(KERN_INFO "claw: %s() enter \n",__func__);
 #endif
 	ret = claw_register_debug_facility();
 	if (ret) {
 		printk(KERN_WARNING "claw: %s() debug_register failed %d\n",
-			__FUNCTION__,ret);
+			__func__,ret);
 		return ret;
 	}
 	CLAW_DBF_TEXT(2,setup,"init_mod");
@@ -4398,10 +4398,10 @@ claw_init(void)
 	if (ret) {
 		claw_unregister_debug_facility();
 		printk(KERN_WARNING "claw; %s() cu3088 register failed %d\n",
-			__FUNCTION__,ret);
+			__func__,ret);
 	}
 #ifdef FUNCTRACE
-        printk(KERN_INFO "claw: %s() exit \n",__FUNCTION__);
+        printk(KERN_INFO "claw: %s() exit \n",__func__);
 #endif
 	return ret;
 }
diff -puN /dev/null /dev/null
diff -puN drivers/s390/net/netiucv.c~drivers-s390-replace-remaining-__function__-occurrences drivers/s390/net/netiucv.c
--- a/drivers/s390/net/netiucv.c~drivers-s390-replace-remaining-__function__-occurrences
+++ a/drivers/s390/net/netiucv.c
@@ -670,7 +670,7 @@ static void conn_action_rx(fsm_instance 
 	struct netiucv_priv *privptr = netdev_priv(conn->netdev);
 	int rc;
 
-	IUCV_DBF_TEXT(trace, 4, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 4, __func__);
 
 	if (!conn->netdev) {
 		iucv_message_reject(conn->path, msg);
@@ -718,7 +718,7 @@ static void conn_action_txdone(fsm_insta
 	struct ll_header header;
 	int rc;
 
-	IUCV_DBF_TEXT(trace, 4, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 4, __func__);
 
 	if (conn && conn->netdev)
 		privptr = netdev_priv(conn->netdev);
@@ -799,7 +799,7 @@ static void conn_action_connaccept(fsm_i
 	struct netiucv_priv *privptr = netdev_priv(netdev);
 	int rc;
 
-	IUCV_DBF_TEXT(trace, 3, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 3, __func__);
 
 	conn->path = path;
 	path->msglim = NETIUCV_QUEUELEN_DEFAULT;
@@ -821,7 +821,7 @@ static void conn_action_connreject(fsm_i
 	struct iucv_event *ev = arg;
 	struct iucv_path *path = ev->data;
 
-	IUCV_DBF_TEXT(trace, 3, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 3, __func__);
 	iucv_path_sever(path, NULL);
 }
 
@@ -831,7 +831,7 @@ static void conn_action_connack(fsm_inst
 	struct net_device *netdev = conn->netdev;
 	struct netiucv_priv *privptr = netdev_priv(netdev);
 
-	IUCV_DBF_TEXT(trace, 3, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 3, __func__);
 	fsm_deltimer(&conn->timer);
 	fsm_newstate(fi, CONN_STATE_IDLE);
 	netdev->tx_queue_len = conn->path->msglim;
@@ -842,7 +842,7 @@ static void conn_action_conntimsev(fsm_i
 {
 	struct iucv_connection *conn = arg;
 
-	IUCV_DBF_TEXT(trace, 3, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 3, __func__);
 	fsm_deltimer(&conn->timer);
 	iucv_path_sever(conn->path, NULL);
 	fsm_newstate(fi, CONN_STATE_STARTWAIT);
@@ -854,7 +854,7 @@ static void conn_action_connsever(fsm_in
 	struct net_device *netdev = conn->netdev;
 	struct netiucv_priv *privptr = netdev_priv(netdev);
 
-	IUCV_DBF_TEXT(trace, 3, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 3, __func__);
 
 	fsm_deltimer(&conn->timer);
 	iucv_path_sever(conn->path, NULL);
@@ -870,7 +870,7 @@ static void conn_action_start(fsm_instan
 	struct iucv_connection *conn = arg;
 	int rc;
 
-	IUCV_DBF_TEXT(trace, 3, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 3, __func__);
 
 	fsm_newstate(fi, CONN_STATE_STARTWAIT);
 	PRINT_DEBUG("%s('%s'): connecting ...\n",
@@ -948,7 +948,7 @@ static void conn_action_stop(fsm_instanc
 	struct net_device *netdev = conn->netdev;
 	struct netiucv_priv *privptr = netdev_priv(netdev);
 
-	IUCV_DBF_TEXT(trace, 3, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 3, __func__);
 
 	fsm_deltimer(&conn->timer);
 	fsm_newstate(fi, CONN_STATE_STOPPED);
@@ -1024,7 +1024,7 @@ static void dev_action_start(fsm_instanc
 	struct net_device   *dev = arg;
 	struct netiucv_priv *privptr = netdev_priv(dev);
 
-	IUCV_DBF_TEXT(trace, 3, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 3, __func__);
 
 	fsm_newstate(fi, DEV_STATE_STARTWAIT);
 	fsm_event(privptr->conn->fsm, CONN_EVENT_START, privptr->conn);
@@ -1044,7 +1044,7 @@ dev_action_stop(fsm_instance *fi, int ev
 	struct netiucv_priv *privptr = netdev_priv(dev);
 	struct iucv_event   ev;
 
-	IUCV_DBF_TEXT(trace, 3, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 3, __func__);
 
 	ev.conn = privptr->conn;
 
@@ -1066,7 +1066,7 @@ dev_action_connup(fsm_instance *fi, int 
 	struct net_device   *dev = arg;
 	struct netiucv_priv *privptr = netdev_priv(dev);
 
-	IUCV_DBF_TEXT(trace, 3, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 3, __func__);
 
 	switch (fsm_getstate(fi)) {
 		case DEV_STATE_STARTWAIT:
@@ -1097,7 +1097,7 @@ dev_action_connup(fsm_instance *fi, int 
 static void
 dev_action_conndown(fsm_instance *fi, int event, void *arg)
 {
-	IUCV_DBF_TEXT(trace, 3, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 3, __func__);
 
 	switch (fsm_getstate(fi)) {
 		case DEV_STATE_RUNNING:
@@ -1288,7 +1288,7 @@ static int netiucv_tx(struct sk_buff *sk
 	struct netiucv_priv *privptr = netdev_priv(dev);
 	int rc;
 
-	IUCV_DBF_TEXT(trace, 4, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 4, __func__);
 	/**
 	 * Some sanity checks ...
 	 */
@@ -1344,7 +1344,7 @@ static struct net_device_stats *netiucv_
 {
 	struct netiucv_priv *priv = netdev_priv(dev);
 
-	IUCV_DBF_TEXT(trace, 5, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 5, __func__);
 	return &priv->stats;
 }
 
@@ -1360,7 +1360,7 @@ static struct net_device_stats *netiucv_
  */
 static int netiucv_change_mtu(struct net_device * dev, int new_mtu)
 {
-	IUCV_DBF_TEXT(trace, 3, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 3, __func__);
 	if (new_mtu < 576 || new_mtu > NETIUCV_MTU_MAX) {
 		IUCV_DBF_TEXT(setup, 2, "given MTU out of valid range\n");
 		return -EINVAL;
@@ -1378,7 +1378,7 @@ static ssize_t user_show(struct device *
 {
 	struct netiucv_priv *priv = dev->driver_data;
 
-	IUCV_DBF_TEXT(trace, 5, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 5, __func__);
 	return sprintf(buf, "%s\n", netiucv_printname(priv->conn->userid));
 }
 
@@ -1393,7 +1393,7 @@ static ssize_t user_write(struct device 
 	int 	i;
 	struct iucv_connection *cp;
 
-	IUCV_DBF_TEXT(trace, 3, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 3, __func__);
 	if (count > 9) {
 		PRINT_WARN("netiucv: username too long (%d)!\n", (int) count);
 		IUCV_DBF_TEXT_(setup, 2,
@@ -1449,7 +1449,7 @@ static ssize_t buffer_show (struct devic
 			    char *buf)
 {	struct netiucv_priv *priv = dev->driver_data;
 
-	IUCV_DBF_TEXT(trace, 5, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 5, __func__);
 	return sprintf(buf, "%d\n", priv->conn->max_buffsize);
 }
 
@@ -1461,7 +1461,7 @@ static ssize_t buffer_write (struct devi
 	char         *e;
 	int          bs1;
 
-	IUCV_DBF_TEXT(trace, 3, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 3, __func__);
 	if (count >= 39)
 		return -EINVAL;
 
@@ -1513,7 +1513,7 @@ static ssize_t dev_fsm_show (struct devi
 {
 	struct netiucv_priv *priv = dev->driver_data;
 
-	IUCV_DBF_TEXT(trace, 5, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 5, __func__);
 	return sprintf(buf, "%s\n", fsm_getstate_str(priv->fsm));
 }
 
@@ -1524,7 +1524,7 @@ static ssize_t conn_fsm_show (struct dev
 {
 	struct netiucv_priv *priv = dev->driver_data;
 
-	IUCV_DBF_TEXT(trace, 5, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 5, __func__);
 	return sprintf(buf, "%s\n", fsm_getstate_str(priv->conn->fsm));
 }
 
@@ -1535,7 +1535,7 @@ static ssize_t maxmulti_show (struct dev
 {
 	struct netiucv_priv *priv = dev->driver_data;
 
-	IUCV_DBF_TEXT(trace, 5, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 5, __func__);
 	return sprintf(buf, "%ld\n", priv->conn->prof.maxmulti);
 }
 
@@ -1545,7 +1545,7 @@ static ssize_t maxmulti_write (struct de
 {
 	struct netiucv_priv *priv = dev->driver_data;
 
-	IUCV_DBF_TEXT(trace, 4, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 4, __func__);
 	priv->conn->prof.maxmulti = 0;
 	return count;
 }
@@ -1557,7 +1557,7 @@ static ssize_t maxcq_show (struct device
 {
 	struct netiucv_priv *priv = dev->driver_data;
 
-	IUCV_DBF_TEXT(trace, 5, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 5, __func__);
 	return sprintf(buf, "%ld\n", priv->conn->prof.maxcqueue);
 }
 
@@ -1566,7 +1566,7 @@ static ssize_t maxcq_write (struct devic
 {
 	struct netiucv_priv *priv = dev->driver_data;
 
-	IUCV_DBF_TEXT(trace, 4, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 4, __func__);
 	priv->conn->prof.maxcqueue = 0;
 	return count;
 }
@@ -1578,7 +1578,7 @@ static ssize_t sdoio_show (struct device
 {
 	struct netiucv_priv *priv = dev->driver_data;
 
-	IUCV_DBF_TEXT(trace, 5, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 5, __func__);
 	return sprintf(buf, "%ld\n", priv->conn->prof.doios_single);
 }
 
@@ -1587,7 +1587,7 @@ static ssize_t sdoio_write (struct devic
 {
 	struct netiucv_priv *priv = dev->driver_data;
 
-	IUCV_DBF_TEXT(trace, 4, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 4, __func__);
 	priv->conn->prof.doios_single = 0;
 	return count;
 }
@@ -1599,7 +1599,7 @@ static ssize_t mdoio_show (struct device
 {
 	struct netiucv_priv *priv = dev->driver_data;
 
-	IUCV_DBF_TEXT(trace, 5, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 5, __func__);
 	return sprintf(buf, "%ld\n", priv->conn->prof.doios_multi);
 }
 
@@ -1608,7 +1608,7 @@ static ssize_t mdoio_write (struct devic
 {
 	struct netiucv_priv *priv = dev->driver_data;
 
-	IUCV_DBF_TEXT(trace, 5, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 5, __func__);
 	priv->conn->prof.doios_multi = 0;
 	return count;
 }
@@ -1620,7 +1620,7 @@ static ssize_t txlen_show (struct device
 {
 	struct netiucv_priv *priv = dev->driver_data;
 
-	IUCV_DBF_TEXT(trace, 5, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 5, __func__);
 	return sprintf(buf, "%ld\n", priv->conn->prof.txlen);
 }
 
@@ -1629,7 +1629,7 @@ static ssize_t txlen_write (struct devic
 {
 	struct netiucv_priv *priv = dev->driver_data;
 
-	IUCV_DBF_TEXT(trace, 4, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 4, __func__);
 	priv->conn->prof.txlen = 0;
 	return count;
 }
@@ -1641,7 +1641,7 @@ static ssize_t txtime_show (struct devic
 {
 	struct netiucv_priv *priv = dev->driver_data;
 
-	IUCV_DBF_TEXT(trace, 5, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 5, __func__);
 	return sprintf(buf, "%ld\n", priv->conn->prof.tx_time);
 }
 
@@ -1650,7 +1650,7 @@ static ssize_t txtime_write (struct devi
 {
 	struct netiucv_priv *priv = dev->driver_data;
 
-	IUCV_DBF_TEXT(trace, 4, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 4, __func__);
 	priv->conn->prof.tx_time = 0;
 	return count;
 }
@@ -1662,7 +1662,7 @@ static ssize_t txpend_show (struct devic
 {
 	struct netiucv_priv *priv = dev->driver_data;
 
-	IUCV_DBF_TEXT(trace, 5, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 5, __func__);
 	return sprintf(buf, "%ld\n", priv->conn->prof.tx_pending);
 }
 
@@ -1671,7 +1671,7 @@ static ssize_t txpend_write (struct devi
 {
 	struct netiucv_priv *priv = dev->driver_data;
 
-	IUCV_DBF_TEXT(trace, 4, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 4, __func__);
 	priv->conn->prof.tx_pending = 0;
 	return count;
 }
@@ -1683,7 +1683,7 @@ static ssize_t txmpnd_show (struct devic
 {
 	struct netiucv_priv *priv = dev->driver_data;
 
-	IUCV_DBF_TEXT(trace, 5, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 5, __func__);
 	return sprintf(buf, "%ld\n", priv->conn->prof.tx_max_pending);
 }
 
@@ -1692,7 +1692,7 @@ static ssize_t txmpnd_write (struct devi
 {
 	struct netiucv_priv *priv = dev->driver_data;
 
-	IUCV_DBF_TEXT(trace, 4, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 4, __func__);
 	priv->conn->prof.tx_max_pending = 0;
 	return count;
 }
@@ -1732,7 +1732,7 @@ static int netiucv_add_files(struct devi
 {
 	int ret;
 
-	IUCV_DBF_TEXT(trace, 3, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 3, __func__);
 	ret = sysfs_create_group(&dev->kobj, &netiucv_attr_group);
 	if (ret)
 		return ret;
@@ -1744,7 +1744,7 @@ static int netiucv_add_files(struct devi
 
 static void netiucv_remove_files(struct device *dev)
 {
-	IUCV_DBF_TEXT(trace, 3, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 3, __func__);
 	sysfs_remove_group(&dev->kobj, &netiucv_stat_attr_group);
 	sysfs_remove_group(&dev->kobj, &netiucv_attr_group);
 }
@@ -1756,7 +1756,7 @@ static int netiucv_register_device(struc
 	int ret;
 
 
-	IUCV_DBF_TEXT(trace, 3, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 3, __func__);
 
 	if (dev) {
 		snprintf(dev->bus_id, BUS_ID_SIZE, "net%s", ndev->name);
@@ -1792,7 +1792,7 @@ out_unreg:
 
 static void netiucv_unregister_device(struct device *dev)
 {
-	IUCV_DBF_TEXT(trace, 3, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 3, __func__);
 	netiucv_remove_files(dev);
 	device_unregister(dev);
 }
@@ -1857,7 +1857,7 @@ out:
  */
 static void netiucv_remove_connection(struct iucv_connection *conn)
 {
-	IUCV_DBF_TEXT(trace, 3, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 3, __func__);
 	write_lock_bh(&iucv_connection_rwlock);
 	list_del_init(&conn->list);
 	write_unlock_bh(&iucv_connection_rwlock);
@@ -1881,7 +1881,7 @@ static void netiucv_free_netdevice(struc
 {
 	struct netiucv_priv *privptr = netdev_priv(dev);
 
-	IUCV_DBF_TEXT(trace, 3, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 3, __func__);
 
 	if (!dev)
 		return;
@@ -1963,7 +1963,7 @@ static ssize_t conn_write(struct device_
 	struct netiucv_priv *priv;
 	struct iucv_connection *cp;
 
-	IUCV_DBF_TEXT(trace, 3, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 3, __func__);
 	if (count>9) {
 		PRINT_WARN("netiucv: username too long (%d)!\n", (int)count);
 		IUCV_DBF_TEXT(setup, 2, "conn_write: too long\n");
@@ -2048,7 +2048,7 @@ static ssize_t remove_write (struct devi
 	const char *p;
         int i;
 
-        IUCV_DBF_TEXT(trace, 3, __FUNCTION__);
+        IUCV_DBF_TEXT(trace, 3, __func__);
 
         if (count >= IFNAMSIZ)
                 count = IFNAMSIZ - 1;;
@@ -2116,7 +2116,7 @@ static void __exit netiucv_exit(void)
 	struct netiucv_priv *priv;
 	struct device *dev;
 
-	IUCV_DBF_TEXT(trace, 3, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 3, __func__);
 	while (!list_empty(&iucv_connection_list)) {
 		cp = list_entry(iucv_connection_list.next,
 				struct iucv_connection, list);
@@ -2146,7 +2146,7 @@ static int __init netiucv_init(void)
 	rc = iucv_register(&netiucv_handler, 1);
 	if (rc)
 		goto out_dbf;
-	IUCV_DBF_TEXT(trace, 3, __FUNCTION__);
+	IUCV_DBF_TEXT(trace, 3, __func__);
 	netiucv_driver.groups = netiucv_drv_attr_groups;
 	rc = driver_register(&netiucv_driver);
 	if (rc) {
diff -puN drivers/s390/s390mach.c~drivers-s390-replace-remaining-__function__-occurrences drivers/s390/s390mach.c
--- a/drivers/s390/s390mach.c~drivers-s390-replace-remaining-__function__-occurrences
+++ a/drivers/s390/s390mach.c
@@ -59,15 +59,15 @@ repeat:
 
 			printk(KERN_WARNING"%s: Code does not support more "
 			       "than two chained crws; please report to "
-			       "linux390@de.ibm.com!\n", __FUNCTION__);
+			       "linux390@de.ibm.com!\n", __func__);
 			ccode = stcrw(&tmp_crw);
 			printk(KERN_WARNING"%s: crw reports slct=%d, oflw=%d, "
 			       "chn=%d, rsc=%X, anc=%d, erc=%X, rsid=%X\n",
-			       __FUNCTION__, tmp_crw.slct, tmp_crw.oflw,
+			       __func__, tmp_crw.slct, tmp_crw.oflw,
 			       tmp_crw.chn, tmp_crw.rsc, tmp_crw.anc,
 			       tmp_crw.erc, tmp_crw.rsid);
 			printk(KERN_WARNING"%s: This was crw number %x in the "
-			       "chain\n", __FUNCTION__, chain);
+			       "chain\n", __func__, chain);
 			if (ccode != 0)
 				break;
 			chain = tmp_crw.chn ? chain + 1 : 0;
@@ -83,7 +83,7 @@ repeat:
 		       crw[chain].rsid);
 		/* Check for overflows. */
 		if (crw[chain].oflw) {
-			pr_debug("%s: crw overflow detected!\n", __FUNCTION__);
+			pr_debug("%s: crw overflow detected!\n", __func__);
 			css_schedule_eval_all();
 			chain = 0;
 			continue;
diff -puN drivers/s390/scsi/zfcp_def.h~drivers-s390-replace-remaining-__function__-occurrences drivers/s390/scsi/zfcp_def.h
--- a/drivers/s390/scsi/zfcp_def.h~drivers-s390-replace-remaining-__function__-occurrences
+++ a/drivers/s390/scsi/zfcp_def.h
@@ -539,7 +539,7 @@ struct zfcp_rc_entry {
 
 /* logging routine for zfcp */
 #define _ZFCP_LOG(fmt, args...) \
-	printk(KERN_ERR ZFCP_NAME": %s(%d): " fmt, __FUNCTION__, \
+	printk(KERN_ERR ZFCP_NAME": %s(%d): " fmt, __func__, \
 	       __LINE__ , ##args)
 
 #define ZFCP_LOG(level, fmt, args...) \
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
git-x86.patch
git-alsa-tiwai.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
cifs-remove-global_extern-macro.patch
git-powerpc.patch
power-replace-remaining-__function__-occurrences.patch
git-dvb.patch
git-dlm.patch
git-ieee1394.patch
git-infiniband.patch
input-replace-remaining-__function__-occurrences.patch
git-jfs.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
git-mips.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
mtd-replace-remaining-__function__-occurrences.patch
git-net.patch
blackfin-replace-remaining-__function__-occurences.patch
git-nfsd.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
git-selinux.patch
git-s390.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-chc-fix-sparse-shadowed-variable-warnings.patch
block-replace-remaining-__function__-occurrences.patch
git-watchdog.patch
mac80211-tkipcc-michaelc-use-kernel-bit-rotation-helpers.patch
mac80211-tkipc-remove-opencoded-swab16-in-tkip_s.patch
mac80211-tkipc-eliminate-the-hi16-lo16-functions.patch
mac80211-tkipc-remove-mk16-hi8-lo8-helpers.patch
mac80211-michaelc-replace-macro-with-function.patch
mac80211-michaelc-use-unaligned-byteorder-helpers.patch
mac80211-michaelc-fold-initial-xor-into-block-helper.patch
xfs-replace-remaining-__function__-occurrences.patch
xfs-replace-__inline-with-inline.patch
xtensa-replace-remaining-__function__-occurences.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
alpha-remove-remaining-__function__-occurences.patch
alpha-replace-__inline-with-inline.patch
m68k-replace-remaining-__function__-occurences.patch
uml-replace-remaining-__function__-occurences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
firmware-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
char-make-functions-static-in-synclinkmpc.patch
spi-replace-remaining-__function__-occurrences.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
isdn-replace-remaining-__function__-occurrences.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
rtc-replace-remaining-__function__-occurrences.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
video-replace-remaining-__function__-occurrences.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
md-replace-remaining-__function__-occurrences.patch
ext2-replace-remaining-__function__-occurrences.patch
ext3-replace-remaining-__function__-occurrences.patch
jbd-replace-remaining-__function__-occurrences.patch
ufs-replace-remaining-__function__-occurrences.patch
ufs-replace-__inline-with-inline.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
reiserfs-replace-remaining-__function__-occurrences.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
ext4-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch


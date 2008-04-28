From: akpm@linux-foundation.org
Subject: - capi-fix-sparse-warnings-using-integer-as-null-pointer.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:56:39 -0700
Message-ID: <200804282156.m3SLudxa018251@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39934 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936420AbYD1V44 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:56:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, jeff@garzik.org, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     capi: fix sparse warnings using integer as NULL pointer
has been removed from the -mm tree.  Its filename was
     capi-fix-sparse-warnings-using-integer-as-null-pointer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: capi: fix sparse warnings using integer as NULL pointer
From: Harvey Harrison <harvey.harrison@gmail.com>

drivers/isdn/capi/kcapi.c:829:30: warning: Using plain integer as NULL pointer
drivers/isdn/capi/kcapi.c:838:27: warning: Using plain integer as NULL pointer
drivers/isdn/capi/kcapi.c:954:17: warning: Using plain integer as NULL pointer
drivers/isdn/capi/kcapi.c:1007:37: warning: Using plain integer as NULL pointer
drivers/isdn/capi/kcapi.c:1009:33: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capiutil.c:453:24: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capilib.c:47:30: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capi.c:353:29: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capi.c:369:15: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capi.c:486:48: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capi.c:515:46: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capi.c:541:47: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capi.c:692:47: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capi.c:699:49: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capi.c:704:14: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capi.c:943:53: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capi.c:948:32: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capi.c:969:42: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capi.c:989:48: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capi.c:1026:69: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capi.c:1028:19: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capi.c:1061:20: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capi.c:1529:37: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capi.c:1531:33: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capidrv.c:338:15: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capidrv.c:758:32: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capidrv.c:880:40: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capidrv.c:407:15: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capidrv.c:429:49: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capidrv.c:407:15: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capidrv.c:444:49: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capidrv.c:429:49: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capidrv.c:429:49: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capidrv.c:429:49: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capidrv.c:429:49: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capidrv.c:429:49: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capidrv.c:1664:61: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capidrv.c:1969:37: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capidrv.c:2294:37: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capidrv.c:2297:33: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capidrv.c:2338:37: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capidrv.c:2341:33: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capifs.c:192:37: warning: Using plain integer as NULL pointer
drivers/isdn/capi/capifs.c:194:33: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Karsten Keil <kkeil@suse.de>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/capi/capi.c     |   34 ++++++++++++++++-----------------
 drivers/isdn/capi/capidrv.c  |   24 +++++++++++------------
 drivers/isdn/capi/capifs.c   |    4 +--
 drivers/isdn/capi/capilib.c  |    2 -
 drivers/isdn/capi/capiutil.c |    2 -
 drivers/isdn/capi/kcapi.c    |   10 ++++-----
 6 files changed, 38 insertions(+), 38 deletions(-)

diff -puN drivers/isdn/capi/capi.c~capi-fix-sparse-warnings-using-integer-as-null-pointer drivers/isdn/capi/capi.c
--- a/drivers/isdn/capi/capi.c~capi-fix-sparse-warnings-using-integer-as-null-pointer
+++ a/drivers/isdn/capi/capi.c
@@ -350,7 +350,7 @@ static void capincci_free(struct capidev
 		if (ncci == 0xffffffff || np->ncci == ncci) {
 			*pp = (*pp)->next;
 #ifdef CONFIG_ISDN_CAPI_MIDDLEWARE
-			if ((mp = np->minorp) != 0) {
+			if ((mp = np->minorp) != NULL) {
 #if defined(CONFIG_ISDN_CAPI_CAPIFS) || defined(CONFIG_ISDN_CAPI_CAPIFS_MODULE)
 				capifs_free_ncci(mp->minor);
 #endif
@@ -366,7 +366,7 @@ static void capincci_free(struct capidev
 			}
 #endif /* CONFIG_ISDN_CAPI_MIDDLEWARE */
 			kfree(np);
-			if (*pp == 0) return;
+			if (*pp == NULL) return;
 		} else {
 			pp = &(*pp)->next;
 		}
@@ -483,7 +483,7 @@ static int handle_recv_skb(struct capimi
 #endif
 		goto bad;
 	}
-	if ((nskb = gen_data_b3_resp_for(mp, skb)) == 0) {
+	if ((nskb = gen_data_b3_resp_for(mp, skb)) == NULL) {
 		printk(KERN_ERR "capi: gen_data_b3_resp failed\n");
 		goto bad;
 	}
@@ -512,7 +512,7 @@ bad:
 static void handle_minor_recv(struct capiminor *mp)
 {
 	struct sk_buff *skb;
-	while ((skb = skb_dequeue(&mp->inqueue)) != 0) {
+	while ((skb = skb_dequeue(&mp->inqueue)) != NULL) {
 		unsigned int len = skb->len;
 		mp->inbytes -= len;
 		if (handle_recv_skb(mp, skb) < 0) {
@@ -538,7 +538,7 @@ static int handle_minor_send(struct capi
 		return 0;
 	}
 
-	while ((skb = skb_dequeue(&mp->outqueue)) != 0) {
+	while ((skb = skb_dequeue(&mp->outqueue)) != NULL) {
 		datahandle = mp->datahandle;
 		len = (u16)skb->len;
 		skb_push(skb, CAPI_DATA_B3_REQ_LEN);
@@ -689,19 +689,19 @@ capi_read(struct file *file, char __user
 	if (!cdev->ap.applid)
 		return -ENODEV;
 
-	if ((skb = skb_dequeue(&cdev->recvqueue)) == 0) {
+	if ((skb = skb_dequeue(&cdev->recvqueue)) == NULL) {
 
 		if (file->f_flags & O_NONBLOCK)
 			return -EAGAIN;
 
 		for (;;) {
 			interruptible_sleep_on(&cdev->recvwait);
-			if ((skb = skb_dequeue(&cdev->recvqueue)) != 0)
+			if ((skb = skb_dequeue(&cdev->recvqueue)) != NULL)
 				break;
 			if (signal_pending(current))
 				break;
 		}
-		if (skb == 0)
+		if (skb == NULL)
 			return -ERESTARTNOHAND;
 	}
 	if (skb->len > count) {
@@ -940,12 +940,12 @@ capi_ioctl(struct inode *inode, struct f
 				return -EFAULT;
 
 			mutex_lock(&cdev->ncci_list_mtx);
-			if ((nccip = capincci_find(cdev, (u32) ncci)) == 0) {
+			if ((nccip = capincci_find(cdev, (u32) ncci)) == NULL) {
 				mutex_unlock(&cdev->ncci_list_mtx);
 				return 0;
 			}
 #ifdef CONFIG_ISDN_CAPI_MIDDLEWARE
-			if ((mp = nccip->minorp) != 0) {
+			if ((mp = nccip->minorp) != NULL) {
 				count += atomic_read(&mp->ttyopencount);
 			}
 #endif /* CONFIG_ISDN_CAPI_MIDDLEWARE */
@@ -966,7 +966,7 @@ capi_ioctl(struct inode *inode, struct f
 				return -EFAULT;
 			mutex_lock(&cdev->ncci_list_mtx);
 			nccip = capincci_find(cdev, (u32) ncci);
-			if (!nccip || (mp = nccip->minorp) == 0) {
+			if (!nccip || (mp = nccip->minorp) == NULL) {
 				mutex_unlock(&cdev->ncci_list_mtx);
 				return -ESRCH;
 			}
@@ -986,7 +986,7 @@ capi_open(struct inode *inode, struct fi
 	if (file->private_data)
 		return -EEXIST;
 
-	if ((file->private_data = capidev_alloc()) == 0)
+	if ((file->private_data = capidev_alloc()) == NULL)
 		return -ENOMEM;
 
 	return nonseekable_open(inode, file);
@@ -1023,9 +1023,9 @@ static int capinc_tty_open(struct tty_st
 	struct capiminor *mp;
 	unsigned long flags;
 
-	if ((mp = capiminor_find(iminor(file->f_path.dentry->d_inode))) == 0)
+	if ((mp = capiminor_find(iminor(file->f_path.dentry->d_inode))) == NULL)
 		return -ENXIO;
-	if (mp->nccip == 0)
+	if (mp->nccip == NULL)
 		return -ENXIO;
 
 	tty->driver_data = (void *)mp;
@@ -1058,7 +1058,7 @@ static void capinc_tty_close(struct tty_
 #ifdef _DEBUG_REFCOUNT
 		printk(KERN_DEBUG "capinc_tty_close ocount=%d\n", atomic_read(&mp->ttyopencount));
 #endif
-		if (mp->nccip == 0)
+		if (mp->nccip == NULL)
 			capiminor_free(mp);
 	}
 
@@ -1526,9 +1526,9 @@ static int __init capi_init(void)
 	char *compileinfo;
 	int major_ret;
 
-	if ((p = strchr(revision, ':')) != 0 && p[1]) {
+	if ((p = strchr(revision, ':')) != NULL && p[1]) {
 		strlcpy(rev, p + 2, sizeof(rev));
-		if ((p = strchr(rev, '$')) != 0 && p > rev)
+		if ((p = strchr(rev, '$')) != NULL && p > rev)
 		   *(p-1) = 0;
 	} else
 		strcpy(rev, "1.0");
diff -puN drivers/isdn/capi/capidrv.c~capi-fix-sparse-warnings-using-integer-as-null-pointer drivers/isdn/capi/capidrv.c
--- a/drivers/isdn/capi/capidrv.c~capi-fix-sparse-warnings-using-integer-as-null-pointer
+++ a/drivers/isdn/capi/capidrv.c
@@ -335,7 +335,7 @@ static capidrv_plci *new_plci(capidrv_co
 
 	plcip = kzalloc(sizeof(capidrv_plci), GFP_ATOMIC);
 
-	if (plcip == 0)
+	if (plcip == NULL)
 		return NULL;
 
 	plcip->state = ST_PLCI_NONE;
@@ -404,7 +404,7 @@ static inline capidrv_ncci *new_ncci(cap
 
 	nccip = kzalloc(sizeof(capidrv_ncci), GFP_ATOMIC);
 
-	if (nccip == 0)
+	if (nccip == NULL)
 		return NULL;
 
 	nccip->ncci = ncci;
@@ -426,7 +426,7 @@ static inline capidrv_ncci *find_ncci(ca
 	capidrv_plci *plcip;
 	capidrv_ncci *p;
 
-	if ((plcip = find_plci_by_ncci(card, ncci)) == 0)
+	if ((plcip = find_plci_by_ncci(card, ncci)) == NULL)
 		return NULL;
 
 	for (p = plcip->ncci_list; p; p = p->next)
@@ -441,7 +441,7 @@ static inline capidrv_ncci *find_ncci_by
 	capidrv_plci *plcip;
 	capidrv_ncci *p;
 
-	if ((plcip = find_plci_by_ncci(card, ncci)) == 0)
+	if ((plcip = find_plci_by_ncci(card, ncci)) == NULL)
 		return NULL;
 
 	for (p = plcip->ncci_list; p; p = p->next)
@@ -755,7 +755,7 @@ static inline int new_bchan(capidrv_cont
 {
 	int i;
 	for (i = 0; i < card->nbchan; i++) {
-		if (card->bchans[i].plcip == 0) {
+		if (card->bchans[i].plcip == NULL) {
 			card->bchans[i].disconnecting = 0;
 			return i;
 		}
@@ -877,7 +877,7 @@ static void handle_incoming_call(capidrv
 		return;
 	}
 	bchan = &card->bchans[chan];
-	if ((plcip = new_plci(card, chan)) == 0) {
+	if ((plcip = new_plci(card, chan)) == NULL) {
 		printk(KERN_ERR "capidrv-%d: incoming call: no memory, sorry.\n", card->contrnr);
 		return;
 	}
@@ -1661,7 +1661,7 @@ static int capidrv_command(isdn_ctrl * c
 					      NULL,	/* Useruserdata */
 					      NULL	/* Facilitydataarray */
 			    );
-			if ((plcip = new_plci(card, (c->arg % card->nbchan))) == 0) {
+			if ((plcip = new_plci(card, (c->arg % card->nbchan))) == NULL) {
 				cmd.command = ISDN_STAT_DHUP;
 				cmd.driver = card->myid;
 				cmd.arg = (c->arg % card->nbchan);
@@ -1966,7 +1966,7 @@ static void enable_dchannel_trace(capidr
 			card->name, errcode);
 	   return;
 	}
-	if (strstr(manufacturer, "AVM") == 0) {
+	if (strstr(manufacturer, "AVM") == NULL) {
 	   printk(KERN_ERR "%s: not from AVM, no d-channel trace possible (%s)\n",
 			card->name, manufacturer);
 	   return;
@@ -2291,10 +2291,10 @@ static int __init capidrv_init(void)
 	u32 ncontr, contr;
 	u16 errcode;
 
-	if ((p = strchr(revision, ':')) != 0 && p[1]) {
+	if ((p = strchr(revision, ':')) != NULL && p[1]) {
 		strncpy(rev, p + 2, sizeof(rev));
 		rev[sizeof(rev)-1] = 0;
-		if ((p = strchr(rev, '$')) != 0 && p > rev)
+		if ((p = strchr(rev, '$')) != NULL && p > rev)
 		   *(p-1) = 0;
 	} else
 		strcpy(rev, "1.0");
@@ -2335,10 +2335,10 @@ static void __exit capidrv_exit(void)
 	char rev[32];
 	char *p;
 
-	if ((p = strchr(revision, ':')) != 0) {
+	if ((p = strchr(revision, ':')) != NULL) {
 		strncpy(rev, p + 1, sizeof(rev));
 		rev[sizeof(rev)-1] = 0;
-		if ((p = strchr(rev, '$')) != 0)
+		if ((p = strchr(rev, '$')) != NULL)
 			*p = 0;
 	} else {
 		strcpy(rev, " ??? ");
diff -puN drivers/isdn/capi/capifs.c~capi-fix-sparse-warnings-using-integer-as-null-pointer drivers/isdn/capi/capifs.c
--- a/drivers/isdn/capi/capifs.c~capi-fix-sparse-warnings-using-integer-as-null-pointer
+++ a/drivers/isdn/capi/capifs.c
@@ -189,9 +189,9 @@ static int __init capifs_init(void)
 	char *p;
 	int err;
 
-	if ((p = strchr(revision, ':')) != 0 && p[1]) {
+	if ((p = strchr(revision, ':')) != NULL && p[1]) {
 		strlcpy(rev, p + 2, sizeof(rev));
-		if ((p = strchr(rev, '$')) != 0 && p > rev)
+		if ((p = strchr(rev, '$')) != NULL && p > rev)
 		   *(p-1) = 0;
 	} else
 		strcpy(rev, "1.0");
diff -puN drivers/isdn/capi/capilib.c~capi-fix-sparse-warnings-using-integer-as-null-pointer drivers/isdn/capi/capilib.c
--- a/drivers/isdn/capi/capilib.c~capi-fix-sparse-warnings-using-integer-as-null-pointer
+++ a/drivers/isdn/capi/capilib.c
@@ -44,7 +44,7 @@ static inline void mq_init(struct capili
 static inline int mq_enqueue(struct capilib_ncci * np, u16 msgid)
 {
 	struct capilib_msgidqueue *mq;
-	if ((mq = np->msgidfree) == 0)
+	if ((mq = np->msgidfree) == NULL)
 		return 0;
 	np->msgidfree = mq->next;
 	mq->msgid = msgid;
diff -puN drivers/isdn/capi/capiutil.c~capi-fix-sparse-warnings-using-integer-as-null-pointer drivers/isdn/capi/capiutil.c
--- a/drivers/isdn/capi/capiutil.c~capi-fix-sparse-warnings-using-integer-as-null-pointer
+++ a/drivers/isdn/capi/capiutil.c
@@ -450,7 +450,7 @@ static void pars_2_message(_cmsg * cmsg)
 			cmsg->l += 4;
 			break;
 		case _CSTRUCT:
-			if (*(u8 **) OFF == 0) {
+			if (*(u8 **) OFF == NULL) {
 				*(cmsg->m + cmsg->l) = '\0';
 				cmsg->l++;
 			} else if (**(_cstruct *) OFF != 0xff) {
diff -puN drivers/isdn/capi/kcapi.c~capi-fix-sparse-warnings-using-integer-as-null-pointer drivers/isdn/capi/kcapi.c
--- a/drivers/isdn/capi/kcapi.c~capi-fix-sparse-warnings-using-integer-as-null-pointer
+++ a/drivers/isdn/capi/kcapi.c
@@ -826,7 +826,7 @@ static int old_capi_manufacturer(unsigne
 		card = capi_ctr_get(card);
 		if (!card)
 			return -ESRCH;
-		if (card->load_firmware == 0) {
+		if (card->load_firmware == NULL) {
 			printk(KERN_DEBUG "kcapi: load: no load function\n");
 			return -ESRCH;
 		}
@@ -835,7 +835,7 @@ static int old_capi_manufacturer(unsigne
 			printk(KERN_DEBUG "kcapi: load: invalid parameter: length of t4file is %d ?\n", ldef.t4file.len);
 			return -EINVAL;
 		}
-		if (ldef.t4file.data == 0) {
+		if (ldef.t4file.data == NULL) {
 			printk(KERN_DEBUG "kcapi: load: invalid parameter: dataptr is 0\n");
 			return -EINVAL;
 		}
@@ -951,7 +951,7 @@ int capi20_manufacturer(unsigned int cmd
 			if (strcmp(driver->name, cdef.driver) == 0)
 				break;
 		}
-		if (driver == 0) {
+		if (driver == NULL) {
 			printk(KERN_ERR "kcapi: driver \"%s\" not loaded.\n",
 					cdef.driver);
 			return -ESRCH;
@@ -1004,9 +1004,9 @@ static int __init kcapi_init(void)
 		return ret;
         kcapi_proc_init();
 
-	if ((p = strchr(revision, ':')) != 0 && p[1]) {
+	if ((p = strchr(revision, ':')) != NULL && p[1]) {
 		strlcpy(rev, p + 2, sizeof(rev));
-		if ((p = strchr(rev, '$')) != 0 && p > rev)
+		if ((p = strchr(rev, '$')) != NULL && p > rev)
 		   *(p-1) = 0;
 	} else
 		strcpy(rev, "1.0");
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
git-kvm.patch
git-mips.patch
git-nfsd.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
power-replace-remaining-__function__-occurrences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
firmware-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
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
kernel-add-common-infrastructure-for-unaligned-access.patch
kernel-move-arches-to-use-common-unaligned-access.patch
drivers-block-use-get_unaligned_-helpers.patch
hid-core-use-get_unaligned_-helpers.patch
char-use-get_unaligned_-helpers.patch
input-use-get_unaligned_-helpers.patch
mmc-use-get-put_unaligned_-helpers.patch
net-use-get-put_unaligned_-helpers.patch
wireless-use-get-put_unaligned_-helpers.patch
pcmcia-use-get-put_unaligned_-helpers.patch
usb-use-get-put_unaligned_-helpers.patch
video-use-get-put_unaligned_-helpers.patch
fat-use-get-put_unaligned_-helpers.patch
hfsplus-use-get-put_unaligned_-helpers.patch
isofs-use-get-put_unaligned_-helpers.patch
ncpfs-use-get-put_unaligned_-helpers.patch
ncpfs-use-get-put_unaligned_-helpers-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch


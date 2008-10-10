From: akpm@linux-foundation.org
Subject: + revert-usb-usb-remove-warn-macro-from-usbh.patch added to -mm tree
Date: Thu, 09 Oct 2008 17:16:42 -0700
Message-ID: <200810100031.m9A0V8Re013813@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750984AbYJJAbM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2008 20:31:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, greg@kroah.com


The patch titled
     revert usb-usb-remove-warn-macro-from-usbh
has been added to the -mm tree.  Its filename is
     revert-usb-usb-remove-warn-macro-from-usbh.patch

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
Subject: revert usb-usb-remove-warn-macro-from-usbh
From: Andrew Morton <akpm@linux-foundation.org>

I have neither the time nor the inclination to repair all the bustage from
this.

Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/usbhid/hid-core.c                     |   17 ++---
 drivers/hid/usbhid/usbkbd.c                       |    3 -
 drivers/input/joystick/iforce/iforce-ff.c         |   36 ++++--------
 drivers/input/joystick/iforce/iforce-main.c       |   14 ++--
 drivers/input/joystick/iforce/iforce-packets.c    |    8 +-
 drivers/input/joystick/iforce/iforce-usb.c        |    2 
 drivers/input/misc/ati_remote.c                   |   14 ++--
 drivers/input/tablet/aiptek.c                     |   13 +---
 drivers/media/radio/dsbr100.c                     |   13 +---
 drivers/media/video/dabusb.c                      |    4 -
 drivers/media/video/ov511.c                       |   19 ++----
 drivers/media/video/usbvideo/konicawc.c           |    8 +-
 drivers/media/video/usbvideo/quickcam_messenger.c |   14 ++--
 drivers/net/irda/stir4200.c                       |   10 +--
 drivers/net/usb/catc.c                            |    5 -
 drivers/net/usb/kaweth.c                          |    8 +-
 drivers/net/usb/rtl8150.c                         |   16 ++---
 drivers/usb/atm/usbatm.c                          |   10 +--
 drivers/usb/atm/usbatm.h                          |   10 ---
 drivers/usb/atm/xusbatm.c                         |    2 
 drivers/usb/core/devio.c                          |    3 -
 drivers/usb/core/inode.c                          |    6 --
 drivers/usb/core/message.c                        |    3 -
 drivers/usb/image/mdc800.c                        |    8 +-
 drivers/usb/misc/usblcd.c                         |    2 
 drivers/usb/misc/uss720.c                         |    7 +-
 include/linux/usb.h                               |    2 
 27 files changed, 106 insertions(+), 151 deletions(-)

diff -puN drivers/hid/usbhid/hid-core.c~revert-usb-usb-remove-warn-macro-from-usbh drivers/hid/usbhid/hid-core.c
--- a/drivers/hid/usbhid/hid-core.c~revert-usb-usb-remove-warn-macro-from-usbh
+++ a/drivers/hid/usbhid/hid-core.c
@@ -213,8 +213,7 @@ static void hid_irq_in(struct urb *urb)
 		hid_io_error(hid);
 		return;
 	default:		/* error */
-			dev_warn(&urb->dev->dev, "input irq status %d "
-				 "received\n", urb->status);
+		warn("input irq status %d received", urb->status);
 	}
 
 	status = usb_submit_urb(urb, GFP_ATOMIC);
@@ -328,8 +327,7 @@ static void hid_irq_out(struct urb *urb)
 	case -ENOENT:
 		break;
 	default:		/* error */
-			dev_warn(&urb->dev->dev, "output irq status %d "
-				 "received\n", urb->status);
+		warn("output irq status %d received", urb->status);
 	}
 
 	spin_lock_irqsave(&usbhid->outlock, flags);
@@ -382,8 +380,7 @@ static void hid_ctrl(struct urb *urb)
 	case -EPIPE:		/* report not available */
 		break;
 	default:		/* error */
-			dev_warn(&urb->dev->dev, "ctrl urb status %d "
-				 "received\n", urb->status);
+		warn("ctrl urb status %d received", urb->status);
 	}
 
 	if (unplug)
@@ -421,7 +418,7 @@ void usbhid_submit_report(struct hid_dev
 
 		if ((head = (usbhid->outhead + 1) & (HID_OUTPUT_FIFO_SIZE - 1)) == usbhid->outtail) {
 			spin_unlock_irqrestore(&usbhid->outlock, flags);
-			dev_warn(hid->dev, "output queue full\n");
+			warn("output queue full");
 			return;
 		}
 
@@ -447,7 +444,7 @@ void usbhid_submit_report(struct hid_dev
 
 	if ((head = (usbhid->ctrlhead + 1) & (HID_CONTROL_FIFO_SIZE - 1)) == usbhid->ctrltail) {
 		spin_unlock_irqrestore(&usbhid->ctrllock, flags);
-		dev_warn(hid->dev, "control queue full\n");
+		warn("control queue full");
 		return;
 	}
 
@@ -485,7 +482,7 @@ static int usb_hidinput_input_event(stru
 		return -1;
 
 	if ((offset = hidinput_find_field(hid, type, code, &field)) == -1) {
-		dev_warn(&dev->dev, "event field not found\n");
+		warn("event field not found");
 		return -1;
 	}
 
@@ -588,7 +585,7 @@ void usbhid_init_reports(struct hid_devi
 	}
 
 	if (err)
-		dev_warn(hid->dev, "timeout initializing reports\n");
+		warn("timeout initializing reports");
 }
 
 /*
diff -puN drivers/hid/usbhid/usbkbd.c~revert-usb-usb-remove-warn-macro-from-usbh drivers/hid/usbhid/usbkbd.c
--- a/drivers/hid/usbhid/usbkbd.c~revert-usb-usb-remove-warn-macro-from-usbh
+++ a/drivers/hid/usbhid/usbkbd.c
@@ -159,8 +159,7 @@ static void usb_kbd_led(struct urb *urb)
 	struct usb_kbd *kbd = urb->context;
 
 	if (urb->status)
-		dev_warn(&urb->dev->dev, "led urb status %d received\n",
-			 urb->status);
+		warn("led urb status %d received", urb->status);
 
 	if (*(kbd->leds) == kbd->newleds)
 		return;
diff -puN drivers/input/joystick/iforce/iforce-ff.c~revert-usb-usb-remove-warn-macro-from-usbh drivers/input/joystick/iforce/iforce-ff.c
--- a/drivers/input/joystick/iforce/iforce-ff.c~revert-usb-usb-remove-warn-macro-from-usbh
+++ a/drivers/input/joystick/iforce/iforce-ff.c
@@ -197,16 +197,13 @@ static unsigned char find_button(struct 
  * Analyse the changes in an effect, and tell if we need to send an condition
  * parameter packet
  */
-static int need_condition_modifier(struct iforce *iforce,
-				   struct ff_effect *old,
-				   struct ff_effect *new)
+static int need_condition_modifier(struct ff_effect *old, struct ff_effect *new)
 {
 	int ret = 0;
 	int i;
 
 	if (new->type != FF_SPRING && new->type != FF_FRICTION) {
-		dev_warn(&iforce->dev->dev, "bad effect type in %s\n",
-			 __func__);
+		warn("bad effect type in need_condition_modifier");
 		return 0;
 	}
 
@@ -225,13 +222,10 @@ static int need_condition_modifier(struc
  * Analyse the changes in an effect, and tell if we need to send a magnitude
  * parameter packet
  */
-static int need_magnitude_modifier(struct iforce *iforce,
-				   struct ff_effect *old,
-				   struct ff_effect *effect)
+static int need_magnitude_modifier(struct ff_effect *old, struct ff_effect *effect)
 {
 	if (effect->type != FF_CONSTANT) {
-		dev_warn(&iforce->dev->dev, "bad effect type in %s\n",
-			 __func__);
+		warn("bad effect type in need_envelope_modifier");
 		return 0;
 	}
 
@@ -242,8 +236,7 @@ static int need_magnitude_modifier(struc
  * Analyse the changes in an effect, and tell if we need to send an envelope
  * parameter packet
  */
-static int need_envelope_modifier(struct iforce *iforce, struct ff_effect *old,
-				  struct ff_effect *effect)
+static int need_envelope_modifier(struct ff_effect *old, struct ff_effect *effect)
 {
 	switch (effect->type) {
 	case FF_CONSTANT:
@@ -263,8 +256,7 @@ static int need_envelope_modifier(struct
 		break;
 
 	default:
-		dev_warn(&iforce->dev->dev, "bad effect type in %s\n",
-			 __func__);
+		warn("bad effect type in need_envelope_modifier");
 	}
 
 	return 0;
@@ -274,12 +266,10 @@ static int need_envelope_modifier(struct
  * Analyse the changes in an effect, and tell if we need to send a periodic
  * parameter effect
  */
-static int need_period_modifier(struct iforce *iforce, struct ff_effect *old,
-				struct ff_effect *new)
+static int need_period_modifier(struct ff_effect *old, struct ff_effect *new)
 {
 	if (new->type != FF_PERIODIC) {
-		dev_warn(&iforce->dev->dev, "bad effect type in %s\n",
-			 __func__);
+		warn("bad effect type in need_period_modifier");
 		return 0;
 	}
 	return (old->u.periodic.period != new->u.periodic.period
@@ -365,7 +355,7 @@ int iforce_upload_periodic(struct iforce
 	int param2_err = 1;
 	int core_err = 0;
 
-	if (!old || need_period_modifier(iforce, old, effect)) {
+	if (!old || need_period_modifier(old, effect)) {
 		param1_err = make_period_modifier(iforce, mod1_chunk,
 			old != NULL,
 			effect->u.periodic.magnitude, effect->u.periodic.offset,
@@ -375,7 +365,7 @@ int iforce_upload_periodic(struct iforce
 		set_bit(FF_MOD1_IS_USED, core_effect->flags);
 	}
 
-	if (!old || need_envelope_modifier(iforce, old, effect)) {
+	if (!old || need_envelope_modifier(old, effect)) {
 		param2_err = make_envelope_modifier(iforce, mod2_chunk,
 			old !=NULL,
 			effect->u.periodic.envelope.attack_length,
@@ -435,7 +425,7 @@ int iforce_upload_constant(struct iforce
 	int param2_err = 1;
 	int core_err = 0;
 
-	if (!old || need_magnitude_modifier(iforce, old, effect)) {
+	if (!old || need_magnitude_modifier(old, effect)) {
 		param1_err = make_magnitude_modifier(iforce, mod1_chunk,
 			old != NULL,
 			effect->u.constant.level);
@@ -444,7 +434,7 @@ int iforce_upload_constant(struct iforce
 		set_bit(FF_MOD1_IS_USED, core_effect->flags);
 	}
 
-	if (!old || need_envelope_modifier(iforce, old, effect)) {
+	if (!old || need_envelope_modifier(old, effect)) {
 		param2_err = make_envelope_modifier(iforce, mod2_chunk,
 			old != NULL,
 			effect->u.constant.envelope.attack_length,
@@ -497,7 +487,7 @@ int iforce_upload_condition(struct iforc
 		default: return -1;
 	}
 
-	if (!old || need_condition_modifier(iforce, old, effect)) {
+	if (!old || need_condition_modifier(old, effect)) {
 		param_err = make_condition_modifier(iforce, mod1_chunk,
 			old != NULL,
 			effect->u.condition[0].right_saturation,
diff -puN drivers/input/joystick/iforce/iforce-main.c~revert-usb-usb-remove-warn-macro-from-usbh drivers/input/joystick/iforce/iforce-main.c
--- a/drivers/input/joystick/iforce/iforce-main.c~revert-usb-usb-remove-warn-macro-from-usbh
+++ a/drivers/input/joystick/iforce/iforce-main.c
@@ -218,9 +218,7 @@ static void iforce_release(struct input_
 		/* Check: no effects should be present in memory */
 		for (i = 0; i < dev->ff->max_effects; i++) {
 			if (test_bit(FF_CORE_IS_USED, iforce->core_effects[i].flags)) {
-				dev_warn(&dev->dev,
-					"%s: Device still owns effects\n",
-					__func__);
+				warn("iforce_release: Device still owns effects");
 				break;
 			}
 		}
@@ -337,26 +335,26 @@ int iforce_init_device(struct iforce *if
 	if (!iforce_get_id_packet(iforce, "M"))
 		input_dev->id.vendor = (iforce->edata[2] << 8) | iforce->edata[1];
 	else
-		dev_warn(&iforce->dev->dev, "Device does not respond to id packet M\n");
+		warn("Device does not respond to id packet M");
 
 	if (!iforce_get_id_packet(iforce, "P"))
 		input_dev->id.product = (iforce->edata[2] << 8) | iforce->edata[1];
 	else
-		dev_warn(&iforce->dev->dev, "Device does not respond to id packet P\n");
+		warn("Device does not respond to id packet P");
 
 	if (!iforce_get_id_packet(iforce, "B"))
 		iforce->device_memory.end = (iforce->edata[2] << 8) | iforce->edata[1];
 	else
-		dev_warn(&iforce->dev->dev, "Device does not respond to id packet B\n");
+		warn("Device does not respond to id packet B");
 
 	if (!iforce_get_id_packet(iforce, "N"))
 		ff_effects = iforce->edata[1];
 	else
-		dev_warn(&iforce->dev->dev, "Device does not respond to id packet N\n");
+		warn("Device does not respond to id packet N");
 
 	/* Check if the device can store more effects than the driver can really handle */
 	if (ff_effects > IFORCE_EFFECTS_MAX) {
-		dev_warn(&iforce->dev->dev, "Limiting number of effects to %d (device reports %d)\n",
+		warn("Limiting number of effects to %d (device reports %d)",
 		       IFORCE_EFFECTS_MAX, ff_effects);
 		ff_effects = IFORCE_EFFECTS_MAX;
 	}
diff -puN drivers/input/joystick/iforce/iforce-packets.c~revert-usb-usb-remove-warn-macro-from-usbh drivers/input/joystick/iforce/iforce-packets.c
--- a/drivers/input/joystick/iforce/iforce-packets.c~revert-usb-usb-remove-warn-macro-from-usbh
+++ a/drivers/input/joystick/iforce/iforce-packets.c
@@ -65,8 +65,7 @@ int iforce_send_packet(struct iforce *if
 
 
 	if (CIRC_SPACE(head, tail, XMIT_SIZE) < n+2) {
-		dev_warn(&iforce->dev->dev,
-			 "not enough space in xmit buffer to send new packet\n");
+		warn("not enough space in xmit buffer to send new packet");
 		spin_unlock_irqrestore(&iforce->xmit_lock, flags);
 		return -1;
 	}
@@ -149,7 +148,7 @@ static int mark_core_as_ready(struct ifo
 			return 0;
 		}
 	}
-	dev_warn(&iforce->dev->dev, "unused effect %04x updated !!!\n", addr);
+	warn("unused effect %04x updated !!!", addr);
 	return -1;
 }
 
@@ -160,8 +159,7 @@ void iforce_process_packet(struct iforce
 	static int being_used = 0;
 
 	if (being_used)
-		dev_warn(&iforce->dev->dev,
-			 "re-entrant call to iforce_process %d\n", being_used);
+		warn("re-entrant call to iforce_process %d", being_used);
 	being_used++;
 
 #ifdef CONFIG_JOYSTICK_IFORCE_232
diff -puN drivers/input/joystick/iforce/iforce-usb.c~revert-usb-usb-remove-warn-macro-from-usbh drivers/input/joystick/iforce/iforce-usb.c
--- a/drivers/input/joystick/iforce/iforce-usb.c~revert-usb-usb-remove-warn-macro-from-usbh
+++ a/drivers/input/joystick/iforce/iforce-usb.c
@@ -64,7 +64,7 @@ void iforce_usb_xmit(struct iforce *ifor
 
 	if ( (n=usb_submit_urb(iforce->out, GFP_ATOMIC)) ) {
 		clear_bit(IFORCE_XMIT_RUNNING, iforce->xmit_flags);
-		dev_warn(&iforce->dev->dev, "usb_submit_urb failed %d\n", n);
+		warn("usb_submit_urb failed %d\n", n);
 	}
 
 	/* The IFORCE_XMIT_RUNNING bit is not cleared here. That's intended.
diff -puN drivers/input/misc/ati_remote.c~revert-usb-usb-remove-warn-macro-from-usbh drivers/input/misc/ati_remote.c
--- a/drivers/input/misc/ati_remote.c~revert-usb-usb-remove-warn-macro-from-usbh
+++ a/drivers/input/misc/ati_remote.c
@@ -285,6 +285,7 @@ static const struct {
 };
 
 /* Local function prototypes */
+static void ati_remote_dump		(unsigned char *data, unsigned int actual_length);
 static int ati_remote_open		(struct input_dev *inputdev);
 static void ati_remote_close		(struct input_dev *inputdev);
 static int ati_remote_sendpacket	(struct ati_remote *ati_remote, u16 cmd, unsigned char *data);
@@ -306,16 +307,15 @@ static struct usb_driver ati_remote_driv
 /*
  *	ati_remote_dump_input
  */
-static void ati_remote_dump(struct device *dev, unsigned char *data,
-			    unsigned int len)
+static void ati_remote_dump(unsigned char *data, unsigned int len)
 {
 	if ((len == 1) && (data[0] != (unsigned char)0xff) && (data[0] != 0x00))
-		dev_warn(dev, "Weird byte 0x%02x\n", data[0]);
+		warn("Weird byte 0x%02x", data[0]);
 	else if (len == 4)
-		dev_warn(dev, "Weird key %02x %02x %02x %02x\n",
+		warn("Weird key %02x %02x %02x %02x",
 		     data[0], data[1], data[2], data[3]);
 	else
-		dev_warn(dev, "Weird data, len=%d %02x %02x %02x %02x %02x %02x ...\n",
+		warn("Weird data, len=%d %02x %02x %02x %02x %02x %02x ...",
 		     len, data[0], data[1], data[2], data[3], data[4], data[5]);
 }
 
@@ -470,7 +470,7 @@ static void ati_remote_input_report(stru
 	/* Deal with strange looking inputs */
 	if ( (urb->actual_length != 4) || (data[0] != 0x14) ||
 		((data[3] & 0x0f) != 0x00) ) {
-		ati_remote_dump(&urb->dev->dev, data, urb->actual_length);
+		ati_remote_dump(data, urb->actual_length);
 		return;
 	}
 
@@ -814,7 +814,7 @@ static void ati_remote_disconnect(struct
 	ati_remote = usb_get_intfdata(interface);
 	usb_set_intfdata(interface, NULL);
 	if (!ati_remote) {
-		dev_warn(&interface->dev, "%s - null device?\n", __func__);
+		warn("%s - null device?\n", __func__);
 		return;
 	}
 
diff -puN drivers/input/tablet/aiptek.c~revert-usb-usb-remove-warn-macro-from-usbh drivers/input/tablet/aiptek.c
--- a/drivers/input/tablet/aiptek.c~revert-usb-usb-remove-warn-macro-from-usbh
+++ a/drivers/input/tablet/aiptek.c
@@ -1706,21 +1706,20 @@ aiptek_probe(struct usb_interface *intf,
 	aiptek = kzalloc(sizeof(struct aiptek), GFP_KERNEL);
 	inputdev = input_allocate_device();
 	if (!aiptek || !inputdev) {
-		dev_warn(&intf->dev,
-			 "cannot allocate memory or input device\n");
+		warn("aiptek: cannot allocate memory or input device");
 		goto fail1;
         }
 
 	aiptek->data = usb_buffer_alloc(usbdev, AIPTEK_PACKET_LENGTH,
 					GFP_ATOMIC, &aiptek->data_dma);
         if (!aiptek->data) {
-		dev_warn(&intf->dev, "cannot allocate usb buffer\n");
+		warn("aiptek: cannot allocate usb buffer");
 		goto fail1;
 	}
 
 	aiptek->urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!aiptek->urb) {
-	        dev_warn(&intf->dev, "cannot allocate urb\n");
+	        warn("aiptek: cannot allocate urb");
 		goto fail2;
 	}
 
@@ -1865,8 +1864,7 @@ aiptek_probe(struct usb_interface *intf,
 	 */
 	err = sysfs_create_group(&intf->dev.kobj, &aiptek_attribute_group);
 	if (err) {
-		dev_warn(&intf->dev, "cannot create sysfs group err: %d\n",
-			 err);
+		warn("aiptek: cannot create sysfs group err: %d", err);
 		goto fail3;
         }
 
@@ -1874,8 +1872,7 @@ aiptek_probe(struct usb_interface *intf,
 	 */
 	err = input_register_device(aiptek->inputdev);
 	if (err) {
-		dev_warn(&intf->dev,
-			 "input_register_device returned err: %d\n", err);
+		warn("aiptek: input_register_device returned err: %d", err);
 		goto fail4;
         }
 	return 0;
diff -puN drivers/media/radio/dsbr100.c~revert-usb-usb-remove-warn-macro-from-usbh drivers/media/radio/dsbr100.c
--- a/drivers/media/radio/dsbr100.c~revert-usb-usb-remove-warn-macro-from-usbh
+++ a/drivers/media/radio/dsbr100.c
@@ -310,7 +310,7 @@ static int vidioc_s_frequency(struct fil
 
 	radio->curfreq = f->frequency;
 	if (dsbr100_setfreq(radio, radio->curfreq)==-1)
-		dev_warn(&radio->usbdev->dev, "Set frequency failed\n");
+		warn("Set frequency failed");
 	return 0;
 }
 
@@ -361,12 +361,10 @@ static int vidioc_s_ctrl(struct file *fi
 	case V4L2_CID_AUDIO_MUTE:
 		if (ctrl->value) {
 			if (dsbr100_stop(radio)==-1)
-				dev_warn(&radio->usbdev->dev,
-					 "Radio did not respond properly\n");
+				warn("Radio did not respond properly");
 		} else {
 			if (dsbr100_start(radio)==-1)
-				dev_warn(&radio->usbdev->dev,
-					 "Radio did not respond properly\n");
+				warn("Radio did not respond properly");
 		}
 		return 0;
 	}
@@ -414,8 +412,7 @@ static int usb_dsbr100_open(struct inode
 	radio->muted = 1;
 
 	if (dsbr100_start(radio)<0) {
-		dev_warn(&radio->usbdev->dev,
-			 "Radio did not start up properly\n");
+		warn("Radio did not start up properly");
 		radio->users = 0;
 		unlock_kernel();
 		return -EIO;
@@ -500,7 +497,7 @@ static int usb_dsbr100_probe(struct usb_
 	radio->curfreq = FREQ_MIN*FREQ_MUL;
 	video_set_drvdata(radio->videodev, radio);
 	if (video_register_device(radio->videodev, VFL_TYPE_RADIO, radio_nr) < 0) {
-		dev_warn(&intf->dev, "Could not register video device\n");
+		warn("Could not register video device");
 		video_device_release(radio->videodev);
 		kfree(radio->transfer_buffer);
 		kfree(radio);
diff -puN drivers/media/video/dabusb.c~revert-usb-usb-remove-warn-macro-from-usbh drivers/media/video/dabusb.c
--- a/drivers/media/video/dabusb.c~revert-usb-usb-remove-warn-macro-from-usbh
+++ a/drivers/media/video/dabusb.c
@@ -192,7 +192,7 @@ static void dabusb_iso_complete (struct 
 					err("dabusb_iso_complete: invalid len %d", len);
 			}
 			else
-				dev_warn(&purb->dev->dev, "dabusb_iso_complete: corrupted packet status: %d\n", purb->iso_frame_desc[i].status);
+				warn("dabusb_iso_complete: corrupted packet status: %d", purb->iso_frame_desc[i].status);
 		if (dst != purb->actual_length)
 			err("dst!=purb->actual_length:%d!=%d", dst, purb->actual_length);
 	}
@@ -289,7 +289,7 @@ static int dabusb_bulk (pdabusb_t s, pbu
 	}
 
 	if( ret == -EPIPE ) {
-		dev_warn(&s->usbdev->dev, "CLEAR_FEATURE request to remove STALL condition.\n");
+		warn("CLEAR_FEATURE request to remove STALL condition.");
 		if(usb_clear_halt(s->usbdev, usb_pipeendpoint(pipe)))
 			err("request failed");
 	}
diff -puN drivers/media/video/ov511.c~revert-usb-usb-remove-warn-macro-from-usbh drivers/media/video/ov511.c
--- a/drivers/media/video/ov511.c~revert-usb-usb-remove-warn-macro-from-usbh
+++ a/drivers/media/video/ov511.c
@@ -1098,10 +1098,9 @@ ov51x_clear_snapshot(struct usb_ov511 *o
 		reg_w(ov, R51x_SYS_SNAP, 0x02);
 		reg_w(ov, R51x_SYS_SNAP, 0x00);
 	} else if (ov->bclass == BCL_OV518) {
-		dev_warn(&ov->dev->dev,
-			 "snapshot reset not supported yet on OV518(+)\n");
+		warn("snapshot reset not supported yet on OV518(+)");
 	} else {
-		dev_err(&ov->dev->dev, "clear snap: invalid bridge type\n");
+		err("clear snap: invalid bridge type");
 	}
 }
 
@@ -1116,16 +1115,14 @@ ov51x_check_snapshot(struct usb_ov511 *o
 	if (ov->bclass == BCL_OV511) {
 		ret = reg_r(ov, R51x_SYS_SNAP);
 		if (ret < 0) {
-			dev_err(&ov->dev->dev,
-				"Error checking snspshot status (%d)\n", ret);
+			err("Error checking snspshot status (%d)", ret);
 		} else if (ret & 0x08) {
 			status = 1;
 		}
 	} else if (ov->bclass == BCL_OV518) {
-		dev_warn(&ov->dev->dev,
-			 "snapshot check not supported yet on OV518(+)\n");
+		warn("snapshot check not supported yet on OV518(+)");
 	} else {
-		dev_err(&ov->dev->dev, "clear snap: invalid bridge type\n");
+		err("check snap: invalid bridge type");
 	}
 
 	return status;
@@ -5213,8 +5210,7 @@ saa7111a_configure(struct usb_ov511 *ov)
 	if (ov->bclass == BCL_OV511)
 		reg_w(ov, 0x11, 0x00);
 	else
-		dev_warn(&ov->dev->dev,
-			 "SAA7111A not yet supported with OV518/OV518+\n");
+		warn("SAA7111A not yet supported with OV518/OV518+");
 
 	return 0;
 }
@@ -5452,8 +5448,7 @@ ov518_configure(struct usb_ov511 *ov)
 	 * required. OV518 has no uncompressed mode, to save RAM. */
 	if (!dumppix && !ov->compress) {
 		ov->compress = 1;
-		dev_warn(&ov->dev->dev,
-			 "Compression required with OV518...enabling\n");
+		warn("Compression required with OV518...enabling");
 	}
 
 	if (ov->bridge == BRG_OV518) {
diff -puN drivers/media/video/usbvideo/konicawc.c~revert-usb-usb-remove-warn-macro-from-usbh drivers/media/video/usbvideo/konicawc.c
--- a/drivers/media/video/usbvideo/konicawc.c~revert-usb-usb-remove-warn-macro-from-usbh
+++ a/drivers/media/video/usbvideo/konicawc.c
@@ -229,8 +229,7 @@ static void konicawc_register_input(stru
 
 	cam->input = input_dev = input_allocate_device();
 	if (!input_dev) {
-		dev_warn(&dev->dev,
-			 "Not enough memory for camera's input device\n");
+		warn("Not enough memory for camera's input device\n");
 		return;
 	}
 
@@ -244,9 +243,8 @@ static void konicawc_register_input(stru
 
 	error = input_register_device(cam->input);
 	if (error) {
-		dev_warn(&dev->dev,
-			 "Failed to register camera's input device, err: %d\n",
-			 error);
+		warn("Failed to register camera's input device, err: %d\n",
+		     error);
 		input_free_device(cam->input);
 		cam->input = NULL;
 	}
diff -puN drivers/media/video/usbvideo/quickcam_messenger.c~revert-usb-usb-remove-warn-macro-from-usbh drivers/media/video/usbvideo/quickcam_messenger.c
--- a/drivers/media/video/usbvideo/quickcam_messenger.c~revert-usb-usb-remove-warn-macro-from-usbh
+++ a/drivers/media/video/usbvideo/quickcam_messenger.c
@@ -93,7 +93,7 @@ static void qcm_register_input(struct qc
 
 	cam->input = input_dev = input_allocate_device();
 	if (!input_dev) {
-		dev_warn(&dev->dev, "insufficient mem for cam input device\n");
+		warn("insufficient mem for cam input device");
 		return;
 	}
 
@@ -107,9 +107,8 @@ static void qcm_register_input(struct qc
 
 	error = input_register_device(cam->input);
 	if (error) {
-		dev_warn(&dev->dev,
-			 "Failed to register camera's input device, err: %d\n",
-			 error);
+		warn("Failed to register camera's input device, err: %d\n",
+		     error);
 		input_free_device(cam->input);
 		cam->input = NULL;
 	}
@@ -588,9 +587,8 @@ static int qcm_compress_iso(struct uvd *
 			dataurb->iso_frame_desc[i].offset;
 
 		if (st < 0) {
-			dev_warn(&uvd->dev->dev,
-				 "Data error: packet=%d. len=%d. status=%d.\n",
-				 i, n, st);
+			warn("Data error: packet=%d. len=%d. status=%d.",
+			      i, n, st);
 			uvd->stats.iso_err_count++;
 			continue;
 		}
@@ -701,7 +699,7 @@ static void qcm_stop_data(struct uvd *uv
 
 	ret = qcm_camera_off(uvd);
 	if (ret)
-		dev_warn(&uvd->dev->dev, "couldn't turn the cam off.\n");
+		warn("couldn't turn the cam off.");
 
 	uvd->streaming = 0;
 
diff -puN drivers/net/irda/stir4200.c~revert-usb-usb-remove-warn-macro-from-usbh drivers/net/irda/stir4200.c
--- a/drivers/net/irda/stir4200.c~revert-usb-usb-remove-warn-macro-from-usbh
+++ a/drivers/net/irda/stir4200.c
@@ -506,7 +506,7 @@ static int change_speed(struct stir_cb *
 			goto found;
 	}
 
-	dev_warn(&stir->netdev->dev, "invalid speed %d\n", speed);
+	warn("%s: invalid speed %d", stir->netdev->name, speed);
 	return -EINVAL;
 
  found:
@@ -598,8 +598,8 @@ static int fifo_txwait(struct stir_cb *s
 		err = read_reg(stir, REG_FIFOCTL, stir->fifo_status, 
 				   FIFO_REGS_SIZE);
 		if (unlikely(err != FIFO_REGS_SIZE)) {
-			dev_warn(&stir->netdev->dev,
-				 "FIFO register read error: %d\n", err);
+			warn("%s: FIFO register read error: %d",
+			     stir->netdev->name, err);
 
 			return err;
 		}
@@ -836,8 +836,8 @@ static void stir_rcv_irq(struct urb *urb
 
 	/* in case of error, the kernel thread will restart us */
 	if (err) {
-		dev_warn(&stir->netdev->dev, "usb receive submit error: %d\n",
-			 err);
+		warn("%s: usb receive submit error: %d",
+			stir->netdev->name, err);
 		stir->receiving = 0;
 		wake_up_process(stir->thread);
 	}
diff -puN drivers/net/usb/catc.c~revert-usb-usb-remove-warn-macro-from-usbh drivers/net/usb/catc.c
--- a/drivers/net/usb/catc.c~revert-usb-usb-remove-warn-macro-from-usbh
+++ a/drivers/net/usb/catc.c
@@ -456,7 +456,7 @@ static void catc_tx_timeout(struct net_d
 {
 	struct catc *catc = netdev_priv(netdev);
 
-	dev_warn(&netdev->dev, "Transmit timed out.\n");
+	warn("Transmit timed out.");
 	usb_unlink_urb(catc->tx_urb);
 }
 
@@ -847,8 +847,7 @@ static int catc_probe(struct usb_interfa
 			dbg("64k Memory\n");
 			break;
 		default:
-			dev_warn(&intf->dev,
-				 "Couldn't detect memory size, assuming 32k\n");
+			warn("Couldn't detect memory size, assuming 32k");
 		case 0x87654321:
 			catc_set_reg(catc, TxBufCount, 4);
 			catc_set_reg(catc, RxBufCount, 16);
diff -puN drivers/net/usb/kaweth.c~revert-usb-usb-remove-warn-macro-from-usbh drivers/net/usb/kaweth.c
--- a/drivers/net/usb/kaweth.c~revert-usb-usb-remove-warn-macro-from-usbh
+++ a/drivers/net/usb/kaweth.c
@@ -832,7 +832,7 @@ static int kaweth_start_xmit(struct sk_b
 
 	if((res = usb_submit_urb(kaweth->tx_urb, GFP_ATOMIC)))
 	{
-		dev_warn(&net->dev, "kaweth failed tx_urb %d\n", res);
+		warn("kaweth failed tx_urb %d", res);
 skip:
 		kaweth->stats.tx_errors++;
 
@@ -924,7 +924,7 @@ static void kaweth_tx_timeout(struct net
 {
 	struct kaweth_device *kaweth = netdev_priv(net);
 
-	dev_warn(&net->dev, "%s: Tx timed out. Resetting.\n", net->name);
+	warn("%s: Tx timed out. Resetting.", net->name);
 	kaweth->stats.tx_errors++;
 	net->trans_start = jiffies;
 
@@ -1209,7 +1209,7 @@ static void kaweth_disconnect(struct usb
 
 	usb_set_intfdata(intf, NULL);
 	if (!kaweth) {
-		dev_warn(&intf->dev, "unregistering non-existant device\n");
+		warn("unregistering non-existant device");
 		return;
 	}
 	netdev = kaweth->net;
@@ -1269,7 +1269,7 @@ static int usb_start_wait_urb(struct urb
 
 	if (!wait_event_timeout(awd.wqh, awd.done, timeout)) {
                 // timeout
-                dev_warn(&urb->dev->dev, "usb_control/bulk_msg: timeout\n");
+                warn("usb_control/bulk_msg: timeout");
                 usb_kill_urb(urb);  // remove urb safely
                 status = -ETIMEDOUT;
         }
diff -puN drivers/net/usb/rtl8150.c~revert-usb-usb-remove-warn-macro-from-usbh drivers/net/usb/rtl8150.c
--- a/drivers/net/usb/rtl8150.c~revert-usb-usb-remove-warn-macro-from-usbh
+++ a/drivers/net/usb/rtl8150.c
@@ -221,7 +221,7 @@ static void ctrl_callback(struct urb *ur
 	case -ENOENT:
 		break;
 	default:
-		dev_warn(&urb->dev->dev, "ctrl urb status %d\n", urb->status);
+		warn("ctrl urb status %d", urb->status);
 	}
 	dev = urb->context;
 	clear_bit(RX_REG_SET, &dev->flags);
@@ -441,10 +441,10 @@ static void read_bulk_callback(struct ur
 	case -ENOENT:
 		return;	/* the urb is in unlink state */
 	case -ETIME:
-		dev_warn(&urb->dev->dev, "may be reset is needed?..\n");
+		warn("may be reset is needed?..");
 		goto goon;
 	default:
-		dev_warn(&urb->dev->dev, "Rx status %d\n", urb->status);
+		warn("Rx status %d", urb->status);
 		goto goon;
 	}
 
@@ -665,7 +665,7 @@ static int enable_net_traffic(rtl8150_t 
 	u8 cr, tcr, rcr, msr;
 
 	if (!rtl8150_reset(dev)) {
-		dev_warn(&dev->udev->dev, "device reset failed\n");
+		warn("%s - device reset failed", __FUNCTION__);
 	}
 	/* RCR bit7=1 attach Rx info at the end;  =0 HW CRC (which is broken) */
 	rcr = 0x9e;
@@ -699,7 +699,7 @@ static struct net_device_stats *rtl8150_
 static void rtl8150_tx_timeout(struct net_device *netdev)
 {
 	rtl8150_t *dev = netdev_priv(netdev);
-	dev_warn(&netdev->dev, "Tx timeout.\n");
+	warn("%s: Tx timeout.", netdev->name);
 	usb_unlink_urb(dev->tx_urb);
 	dev->stats.tx_errors++;
 }
@@ -740,7 +740,7 @@ static int rtl8150_start_xmit(struct sk_
 		if (res == -ENODEV)
 			netif_device_detach(dev->netdev);
 		else {
-			dev_warn(&netdev->dev, "failed tx_urb %d\n", res);
+			warn("failed tx_urb %d\n", res);
 			dev->stats.tx_errors++;
 			netif_start_queue(netdev);
 		}
@@ -783,7 +783,7 @@ static int rtl8150_open(struct net_devic
 	if ((res = usb_submit_urb(dev->rx_urb, GFP_KERNEL))) {
 		if (res == -ENODEV)
 			netif_device_detach(dev->netdev);
-		dev_warn(&netdev->dev, "rx_urb submit failed: %d\n", res);
+		warn("%s: rx_urb submit failed: %d", __FUNCTION__, res);
 		return res;
 	}
 	usb_fill_int_urb(dev->intr_urb, dev->udev, usb_rcvintpipe(dev->udev, 3),
@@ -792,7 +792,7 @@ static int rtl8150_open(struct net_devic
 	if ((res = usb_submit_urb(dev->intr_urb, GFP_KERNEL))) {
 		if (res == -ENODEV)
 			netif_device_detach(dev->netdev);
-		dev_warn(&netdev->dev, "intr_urb submit failed: %d\n", res);
+		warn("%s: intr_urb submit failed: %d", __FUNCTION__, res);
 		usb_kill_urb(dev->rx_urb);
 		return res;
 	}
diff -puN drivers/usb/atm/usbatm.c~revert-usb-usb-remove-warn-macro-from-usbh drivers/usb/atm/usbatm.c
--- a/drivers/usb/atm/usbatm.c~revert-usb-usb-remove-warn-macro-from-usbh
+++ a/drivers/usb/atm/usbatm.c
@@ -344,7 +344,7 @@ static void usbatm_extract_one_cell(stru
 				__func__, sarb->len, vcc);
 		/* discard cells already received */
 		skb_trim(sarb, 0);
-		UDSL_ASSERT(instance, sarb->tail + ATM_CELL_PAYLOAD <= sarb->end);
+		UDSL_ASSERT(sarb->tail + ATM_CELL_PAYLOAD <= sarb->end);
 	}
 
 	memcpy(skb_tail_pointer(sarb), source + ATM_CELL_HEADER, ATM_CELL_PAYLOAD);
@@ -432,7 +432,7 @@ static void usbatm_extract_cells(struct 
 		unsigned char *cell_buf = instance->cell_buf;
 		unsigned int space_left = stride - buf_usage;
 
-		UDSL_ASSERT(instance, buf_usage <= stride);
+		UDSL_ASSERT(buf_usage <= stride);
 
 		if (avail_data >= space_left) {
 			/* add new data and process cell */
@@ -475,7 +475,7 @@ static unsigned int usbatm_write_cells(s
 	unsigned int stride = instance->tx_channel.stride;
 
 	vdbg("%s: skb->len=%d, avail_space=%u", __func__, skb->len, avail_space);
-	UDSL_ASSERT(instance, !(avail_space % stride));
+	UDSL_ASSERT(!(avail_space % stride));
 
 	for (bytes_written = 0; bytes_written < avail_space && ctrl->len;
 	     bytes_written += stride, target += stride) {
@@ -547,7 +547,7 @@ static void usbatm_rx_process(unsigned l
 				if (!urb->iso_frame_desc[i].status) {
 					unsigned int actual_length = urb->iso_frame_desc[i].actual_length;
 
-					UDSL_ASSERT(instance, actual_length <= packet_size);
+					UDSL_ASSERT(actual_length <= packet_size);
 
 					if (!merge_length)
 						merge_start = (unsigned char *)urb->transfer_buffer + urb->iso_frame_desc[i].offset;
@@ -1188,7 +1188,7 @@ int usbatm_usb_probe(struct usb_interfac
 		struct urb *urb;
 		unsigned int iso_packets = usb_pipeisoc(channel->endpoint) ? channel->buf_size / channel->packet_size : 0;
 
-		UDSL_ASSERT(instance, !usb_pipeisoc(channel->endpoint) || usb_pipein(channel->endpoint));
+		UDSL_ASSERT(!usb_pipeisoc(channel->endpoint) || usb_pipein(channel->endpoint));
 
 		urb = usb_alloc_urb(iso_packets, GFP_KERNEL);
 		if (!urb) {
diff -puN drivers/usb/atm/usbatm.h~revert-usb-usb-remove-warn-macro-from-usbh drivers/usb/atm/usbatm.h
--- a/drivers/usb/atm/usbatm.h~revert-usb-usb-remove-warn-macro-from-usbh
+++ a/drivers/usb/atm/usbatm.h
@@ -40,15 +40,9 @@
 */
 
 #ifdef DEBUG
-#define UDSL_ASSERT(instance, x)	BUG_ON(!(x))
+#define UDSL_ASSERT(x)	BUG_ON(!(x))
 #else
-#define UDSL_ASSERT(instance, x)					\
-	do {	\
-		if (!(x))						\
-			dev_warn(&(instance)->usb_intf->dev,		\
-				 "failed assertion '%s' at line %d",	\
-				 __stringify(x), __LINE__);		\
-	} while(0)
+#define UDSL_ASSERT(x)	do { if (!(x)) warn("failed assertion '%s' at line %d", __stringify(x), __LINE__); } while(0)
 #endif
 
 #define usb_err(instance, format, arg...)	\
diff -puN drivers/usb/atm/xusbatm.c~revert-usb-usb-remove-warn-macro-from-usbh drivers/usb/atm/xusbatm.c
--- a/drivers/usb/atm/xusbatm.c~revert-usb-usb-remove-warn-macro-from-usbh
+++ a/drivers/usb/atm/xusbatm.c
@@ -193,7 +193,7 @@ static int __init xusbatm_init(void)
 	    num_vendor != num_product ||
 	    num_vendor != num_rx_endpoint ||
 	    num_vendor != num_tx_endpoint) {
-		printk(KERN_WARNING "xusbatm: malformed module parameters\n");
+		warn("malformed module parameters");
 		return -EINVAL;
 	}
 
diff -puN drivers/usb/core/devio.c~revert-usb-usb-remove-warn-macro-from-usbh drivers/usb/core/devio.c
--- a/drivers/usb/core/devio.c~revert-usb-usb-remove-warn-macro-from-usbh
+++ a/drivers/usb/core/devio.c
@@ -413,8 +413,7 @@ static void driver_disconnect(struct usb
 	if (likely(ifnum < 8*sizeof(ps->ifclaimed)))
 		clear_bit(ifnum, &ps->ifclaimed);
 	else
-		dev_warn(&intf->dev, "interface number %u out of range\n",
-			 ifnum);
+		warn("interface number %u out of range", ifnum);
 
 	usb_set_intfdata(intf, NULL);
 
diff -puN drivers/usb/core/inode.c~revert-usb-usb-remove-warn-macro-from-usbh drivers/usb/core/inode.c
--- a/drivers/usb/core/inode.c~revert-usb-usb-remove-warn-macro-from-usbh
+++ a/drivers/usb/core/inode.c
@@ -240,9 +240,7 @@ static void update_sb(struct super_block
 				update_special(bus);
 				break;
 			default:
-				printk(KERN_WARNING "usbfs: Unknown node %s "
-				       "mode %x found on remount!\n",
-				       bus->d_name.name, bus->d_inode->i_mode);
+				warn("Unknown node %s mode %x found on remount!\n",bus->d_name.name,bus->d_inode->i_mode);
 				break;
 			}
 		}
@@ -261,7 +259,7 @@ static int remount(struct super_block *s
 		return 0;
 
 	if (parse_options(sb, data)) {
-		printk(KERN_WARNING "usbfs: mount parameter error.\n");
+		warn("usbfs: mount parameter error:");
 		return -EINVAL;
 	}
 
diff -puN drivers/usb/core/message.c~revert-usb-usb-remove-warn-macro-from-usbh drivers/usb/core/message.c
--- a/drivers/usb/core/message.c~revert-usb-usb-remove-warn-macro-from-usbh
+++ a/drivers/usb/core/message.c
@@ -1204,8 +1204,7 @@ int usb_set_interface(struct usb_device 
 
 	alt = usb_altnum_to_altsetting(iface, alternate);
 	if (!alt) {
-		dev_warn(&dev->dev, "selecting invalid altsetting %d",
-			 alternate);
+		warn("selecting invalid altsetting %d", alternate);
 		return -EINVAL;
 	}
 
diff -puN drivers/usb/image/mdc800.c~revert-usb-usb-remove-warn-macro-from-usbh drivers/usb/image/mdc800.c
--- a/drivers/usb/image/mdc800.c~revert-usb-usb-remove-warn-macro-from-usbh
+++ a/drivers/usb/image/mdc800.c
@@ -361,8 +361,7 @@ static int mdc800_usb_waitForIRQ (int mo
 	
 	if (mdc800->state == NOT_CONNECTED)
 	{
-		printk(KERN_WARNING "mdc800: Camera gets disconnected "
-		       "during waiting for irq.\n");
+		warn ("Camera gets disconnected during waiting for irq.");
 		mdc800->camera_request_ready=0;
 		return -2;
 	}
@@ -444,7 +443,7 @@ static int mdc800_usb_probe (struct usb_
 
 	if (mdc800->dev != NULL)
 	{
-		dev_warn(&intf->dev, "only one Mustek MDC800 is supported.\n");
+		warn ("only one Mustek MDC800 is supported.");
 		return -ENODEV;
 	}
 
@@ -702,8 +701,7 @@ static ssize_t mdc800_device_read (struc
 	}
 	if (mdc800->state == WORKING)
 	{
-		printk(KERN_WARNING "mdc800: Illegal State \"working\""
-		       "reached during read ?!\n");
+		warn ("Illegal State \"working\" reached during read ?!");
 		mutex_unlock(&mdc800->io_lock);
 		return -EBUSY;
 	}
diff -puN drivers/usb/misc/usblcd.c~revert-usb-usb-remove-warn-macro-from-usbh drivers/usb/misc/usblcd.c
--- a/drivers/usb/misc/usblcd.c~revert-usb-usb-remove-warn-macro-from-usbh
+++ a/drivers/usb/misc/usblcd.c
@@ -311,7 +311,7 @@ static int lcd_probe(struct usb_interfac
 	dev->interface = interface;
 
 	if (le16_to_cpu(dev->udev->descriptor.idProduct) != 0x0001) {
-		dev_warn(&interface->dev, "USBLCD model not supported.\n");
+		warn(KERN_INFO "USBLCD model not supported.");
 		return -ENODEV;
 	}
 	
diff -puN drivers/usb/misc/uss720.c~revert-usb-usb-remove-warn-macro-from-usbh drivers/usb/misc/uss720.c
--- a/drivers/usb/misc/uss720.c~revert-usb-usb-remove-warn-macro-from-usbh
+++ a/drivers/usb/misc/uss720.c
@@ -228,12 +228,11 @@ static int get_1284_register(struct parp
 		ret = rq->urb->status;
 		*val = priv->reg[(reg >= 9) ? 0 : regindex[reg]];
 		if (ret)
-			printk(KERN_WARNING "get_1284_register: "
-			       "usb error %d\n", ret);
+			warn("get_1284_register: usb error %d", ret);
 		kref_put(&rq->ref_count, destroy_async);
 		return ret;
 	}
-	printk(KERN_WARNING "get_1284_register timeout\n");
+	warn("get_1284_register timeout");
 	kill_all_async_requests_priv(priv);
 	return -EIO;
 }
@@ -717,7 +716,7 @@ static int uss720_probe(struct usb_inter
 	spin_lock_init(&priv->asynclock);
 	INIT_LIST_HEAD(&priv->asynclist);
 	if (!(pp = parport_register_port(0, PARPORT_IRQ_NONE, PARPORT_DMA_NONE, &parport_uss720_ops))) {
-		printk(KERN_WARNING "uss720: could not register parport\n");
+		warn("could not register parport");
 		goto probe_abort;
 	}
 
diff -puN include/linux/usb.h~revert-usb-usb-remove-warn-macro-from-usbh include/linux/usb.h
--- a/include/linux/usb.h~revert-usb-usb-remove-warn-macro-from-usbh
+++ a/include/linux/usb.h
@@ -1722,6 +1722,8 @@ extern void usb_unregister_notify(struct
 	format "\n" , ## arg)
 #define info(format, arg...) printk(KERN_INFO KBUILD_MODNAME ": " \
 	format "\n" , ## arg)
+#define warn(format, arg...) printk(KERN_WARNING KBUILD_MODNAME ": " \
+	format "\n" , ## arg)
 
 #endif  /* __KERNEL__ */
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-remove-the-might_sleep-from-lock_page.patch
git-tip.patch
markers-make-marker_synchronize_unregister-a-macro.patch
git-powerpc.patch
git-sparc.patch
git-xtensa.patch
git-pci.patch
git-hid.patch
git-v4l-dvb.patch
git-v4l-dvb-git-rejects.patch
git-nfs.patch
git-nfsd.patch
git-dlm.patch
git-scsi.patch
git-tests-fixup.patch
git-ext4.patch
git-ext4-vs-git-ocfs2.patch
git-async_tx.patch
git-net.patch
git-net-conflicts.patch
git-mtd.patch
git-vfs-vs-git-ext4.patch
git-sound.patch
git-sound-vs-git-arm.patch
git-input.patch
git-block.patch
git-block-reject-fix.patch
git-pcmcia-git-rejects.patch
git-battery.patch
git-battery-rejects.patch
git-slab-versus-git-tip.patch
git-md-rejects.patch
git-mfd.patch
git-drm.patch
revert-usb-usb-remove-info-macro-from-usbh.patch
revert-usb-usb-remove-warn-macro-from-usbh.patch
usb-usb-remove-warn-macro-from-usbh-vs-git-hid-fix.patch
usb-usb-remove-info-macro-from-usbh-more-borkage.patch
drivers-mfd-ucb1400_corec-needs-gpio.patch
drivers-mfd-ucb1400_corec-further-unbork.patch
arch-x86-kernel-early_printkc-remove-unused-enable_debug_console.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
libata-blackfin-pata-driver-add-proper-pm-operation-into-atapi-driver.patch
misdn-misc-timerdev-fixes-fix.patch
drivers-net-sfc-falconc-fix-min-warnings.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
drivers-scsi-sdh-use-inlined-c-functions-not-macros.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch-fix.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch
mm-vmallocc-revert-git-tip-change.patch
mm-rewrite-vmap-layer-fix.patch
mm-rewrite-vmap-layer-fix-fix.patch
mm-rewrite-vmap-layer-fix-fix-fix.patch
revert-mm-vmallocc-revert-git-tip-change.patch
h8300-generic_bug-support-checkpatch-fixes.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation-cleanup.patch
container-freezer-add-tif_freeze-flag-to-all-architectures-fix.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process-fix.patch
eeepc-laptop-use-standard-interfaces-fix-fix.patch
separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix.patch
separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix-fix.patch
make-taint-bit-reliable-v3-fix.patch
kernel-sysc-improve-code-generation.patch
compat-generic-compat-get-settimeofday-checkpatch-fixes.patch
hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms-cleanup.patch
drivers-hwmon-applesmcc-remove-unneeded-casts.patch
allow-recursion-in-binfmt_script-and-binfmt_misc-fix.patch
serial-make-uart_ports-ioport-unsigned-long-fix.patch
autofs4-track-uid-and-gid-of-last-mount-requester-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-2.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-fix-3.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip-fix.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
viafb-viafbmodes-viafbtxt-fix-fix.patch
viafb-accelc-accelh-checkpatch-fixes.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
fbdev-kconfig-update-fix.patch
fbdev-allow-more-chip-revisions-in-epson-s1d13-video-driver-cleanups.patch
ext2-avoid-printk-floods-in-the-face-of-directory-corruption-checkpatch-fixes.patch
ext3-fix-ext3_dx_readdir-hash-collision-handling-checkpatch-fixes.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
message-queues-increase-range-limits-checkpatch-fixes.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
tpm-addition-of-pnp_remove-checkpatch-fixes.patch
w1-be-able-to-manually-add-and-remove-slaves-fix.patch
w1-new-driver-ds2431-chip-fix.patch
gru-driver-minor-updates-fix.patch
drivers-rtc-rtc-bq4802c-dont-use-bin_2_bcd-and-bcd_2_bin.patch
x86-sysfs-kill-owner-field-from-attribute-fix.patch
x86-sysfs-kill-owner-field-from-attribute-fix-3.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch


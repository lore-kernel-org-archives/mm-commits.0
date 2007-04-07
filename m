From: akpm@linux-foundation.org
Subject: + unify-the-input-subsystem-event-forwarding.patch added to -mm tree
Date: Fri, 06 Apr 2007 18:32:30 -0700
Message-ID: <200704070132.l371WUYL024872@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41989 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964917AbXDGBeW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 21:34:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: malattia@linux.it, lenb@kernel.org, stelian@popies.net


The patch titled
     sony-laptop: unify the input subsystem event forwarding
has been added to the -mm tree.  Its filename is
     unify-the-input-subsystem-event-forwarding.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sony-laptop: unify the input subsystem event forwarding
From: Mattia Dongili <malattia@linux.it>

SNC and SPIC events are forwarded to the same input devices.

Signed-off-by: Mattia Dongili <malattia@linux.it>
Cc: Len Brown <lenb@kernel.org>
Cc: Stelian Pop <stelian@popies.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sony-laptop.c |  541 +++++++++++++++++------------------
 1 file changed, 276 insertions(+), 265 deletions(-)

diff -puN drivers/misc/sony-laptop.c~unify-the-input-subsystem-event-forwarding drivers/misc/sony-laptop.c
--- a/drivers/misc/sony-laptop.c~unify-the-input-subsystem-event-forwarding
+++ a/drivers/misc/sony-laptop.c
@@ -97,18 +97,266 @@ MODULE_PARM_DESC(no_spic,
 static int compat;		/* = 0 */
 module_param(compat, int, 0444);
 MODULE_PARM_DESC(compat,
-		 "set this if you want to enable backward compatibility mode");
-
-static int force_jog;		/* = 0 */
-module_param(force_jog, int, 0444);
-MODULE_PARM_DESC(force_jog,
-		 "set this if the driver doesn't detect your jogdial");
+		 "set this if you want to enable backward compatibility mode for SPIC");
 
 static unsigned long mask = 0xffffffff;
 module_param(mask, ulong, 0644);
 MODULE_PARM_DESC(mask,
 		 "set this to the mask of event you want to enable (see doc)");
 
+/*********** Input Devices ***********/
+
+#define SONY_LAPTOP_BUF_SIZE	128
+struct sony_laptop_input_s {
+	atomic_t		users;
+	struct input_dev	*jog_dev;
+	struct input_dev	*key_dev;
+	struct kfifo		*fifo;
+	spinlock_t		fifo_lock;
+	struct workqueue_struct	*wq;
+};
+static struct sony_laptop_input_s sony_laptop_input = {
+	.users = ATOMIC_INIT(0),
+};
+
+struct sony_laptop_keypress {
+	struct input_dev *dev;
+	int key;
+};
+
+/* Correspondance table between sonypi events and input layer events */
+static struct {
+	int sonypiev;
+	int inputev;
+} sony_laptop_inputkeys[] = {
+	{ SONYPI_EVENT_CAPTURE_PRESSED,	 	KEY_CAMERA },
+	{ SONYPI_EVENT_FNKEY_ONLY, 		KEY_FN },
+	{ SONYPI_EVENT_FNKEY_ESC, 		KEY_FN_ESC },
+	{ SONYPI_EVENT_FNKEY_F1, 		KEY_FN_F1 },
+	{ SONYPI_EVENT_FNKEY_F2, 		KEY_FN_F2 },
+	{ SONYPI_EVENT_FNKEY_F3, 		KEY_FN_F3 },
+	{ SONYPI_EVENT_FNKEY_F4, 		KEY_FN_F4 },
+	{ SONYPI_EVENT_FNKEY_F5, 		KEY_FN_F5 },
+	{ SONYPI_EVENT_FNKEY_F6, 		KEY_FN_F6 },
+	{ SONYPI_EVENT_FNKEY_F7, 		KEY_FN_F7 },
+	{ SONYPI_EVENT_FNKEY_F8, 		KEY_FN_F8 },
+	{ SONYPI_EVENT_FNKEY_F9,		KEY_FN_F9 },
+	{ SONYPI_EVENT_FNKEY_F10,		KEY_FN_F10 },
+	{ SONYPI_EVENT_FNKEY_F11, 		KEY_FN_F11 },
+	{ SONYPI_EVENT_FNKEY_F12,		KEY_FN_F12 },
+	{ SONYPI_EVENT_FNKEY_1, 		KEY_FN_1 },
+	{ SONYPI_EVENT_FNKEY_2, 		KEY_FN_2 },
+	{ SONYPI_EVENT_FNKEY_D,			KEY_FN_D },
+	{ SONYPI_EVENT_FNKEY_E,			KEY_FN_E },
+	{ SONYPI_EVENT_FNKEY_F,			KEY_FN_F },
+	{ SONYPI_EVENT_FNKEY_S,			KEY_FN_S },
+	{ SONYPI_EVENT_FNKEY_B,			KEY_FN_B },
+	{ SONYPI_EVENT_BLUETOOTH_PRESSED, 	KEY_BLUE },
+	{ SONYPI_EVENT_BLUETOOTH_ON, 		KEY_BLUE },
+	{ SONYPI_EVENT_PKEY_P1, 		KEY_PROG1 },
+	{ SONYPI_EVENT_PKEY_P2, 		KEY_PROG2 },
+	{ SONYPI_EVENT_PKEY_P3, 		KEY_PROG3 },
+	{ SONYPI_EVENT_BACK_PRESSED, 		KEY_BACK },
+	{ SONYPI_EVENT_HELP_PRESSED, 		KEY_HELP },
+	{ SONYPI_EVENT_ZOOM_PRESSED, 		KEY_ZOOM },
+	{ SONYPI_EVENT_THUMBPHRASE_PRESSED, 	BTN_THUMB },
+	{ 0, 0 },
+};
+
+/* release buttons after a short delay if pressed */
+static void do_sony_laptop_release_key(struct work_struct *work)
+{
+	struct sony_laptop_keypress kp;
+
+	while (kfifo_get(sony_laptop_input.fifo, (unsigned char *)&kp,
+			 sizeof(kp)) == sizeof(kp)) {
+		msleep(10);
+		input_report_key(kp.dev, kp.key, 0);
+		input_sync(kp.dev);
+	}
+}
+static DECLARE_WORK(sony_laptop_release_key_work,
+		do_sony_laptop_release_key);
+
+/* forward event to the input subsytem */
+static void sony_laptop_report_input_event(u8 event)
+{
+	struct input_dev *jog_dev = sony_laptop_input.jog_dev;
+	struct input_dev *key_dev = sony_laptop_input.key_dev;
+	struct sony_laptop_keypress kp = { NULL };
+	int i;
+
+	if (event == SONYPI_EVENT_FNKEY_RELEASED) {
+		/* Nothing, not all VAIOs generate this event */
+		return;
+	}
+
+	/* report events */
+	switch (event) {
+	/* jog_dev events */
+	case SONYPI_EVENT_JOGDIAL_UP:
+	case SONYPI_EVENT_JOGDIAL_UP_PRESSED:
+		input_report_rel(jog_dev, REL_WHEEL, 1);
+		input_sync(jog_dev);
+		return;
+
+	case SONYPI_EVENT_JOGDIAL_DOWN:
+	case SONYPI_EVENT_JOGDIAL_DOWN_PRESSED:
+		input_report_rel(jog_dev, REL_WHEEL, -1);
+		input_sync(jog_dev);
+		return;
+
+	/* key_dev events */
+	case SONYPI_EVENT_JOGDIAL_PRESSED:
+		kp.key = BTN_MIDDLE;
+		kp.dev = jog_dev;
+		break;
+
+	default:
+		for (i = 0; sony_laptop_inputkeys[i].sonypiev; i++)
+			if (event == sony_laptop_inputkeys[i].sonypiev) {
+				kp.dev = key_dev;
+				kp.key = sony_laptop_inputkeys[i].inputev;
+				break;
+			}
+		break;
+	}
+
+	if (kp.dev) {
+		input_report_key(kp.dev, kp.key, 1);
+		input_sync(kp.dev);
+		kfifo_put(sony_laptop_input.fifo,
+			  (unsigned char *)&kp, sizeof(kp));
+
+		if (!work_pending(&sony_laptop_release_key_work))
+			queue_work(sony_laptop_input.wq,
+					&sony_laptop_release_key_work);
+	} else
+		dprintk("unknown input event %.2x\n", event);
+}
+
+static int sony_laptop_setup_input(void)
+{
+	struct input_dev *jog_dev;
+	struct input_dev *key_dev;
+	int i;
+	int error;
+
+	/* don't run again if already initialized */
+	if (atomic_add_return(1, &sony_laptop_input.users) > 1)
+		return 0;
+
+	/* kfifo */
+	spin_lock_init(&sony_laptop_input.fifo_lock);
+	sony_laptop_input.fifo =
+		kfifo_alloc(SONY_LAPTOP_BUF_SIZE, GFP_KERNEL,
+			    &sony_laptop_input.fifo_lock);
+	if (IS_ERR(sony_laptop_input.fifo)) {
+		printk(KERN_ERR DRV_PFX "kfifo_alloc failed\n");
+		error = PTR_ERR(sony_laptop_input.fifo);
+		goto err_dec_users;
+	}
+
+	/* init workqueue */
+	sony_laptop_input.wq = create_singlethread_workqueue("sony-laptop");
+	if (!sony_laptop_input.wq) {
+		printk(KERN_ERR DRV_PFX
+				"Unabe to create workqueue.\n");
+		error = -ENXIO;
+		goto err_free_kfifo;
+	}
+
+	/* input keys */
+	key_dev = input_allocate_device();
+	if (!key_dev) {
+		error = -ENOMEM;
+		goto err_destroy_wq;
+	}
+
+	key_dev->name = "Sony Vaio Keys";
+	key_dev->id.bustype = BUS_ISA;
+	key_dev->id.vendor = PCI_VENDOR_ID_SONY;
+
+	/* Initialize the Input Drivers: special keys */
+	key_dev->evbit[0] = BIT(EV_KEY);
+	for (i = 0; sony_laptop_inputkeys[i].sonypiev; i++)
+		if (sony_laptop_inputkeys[i].inputev)
+			set_bit(sony_laptop_inputkeys[i].inputev,
+					key_dev->keybit);
+
+	error = input_register_device(key_dev);
+	if (error)
+		goto err_free_keydev;
+
+	sony_laptop_input.key_dev = key_dev;
+
+	/* jogdial */
+	jog_dev = input_allocate_device();
+	if (!jog_dev) {
+		error = -ENOMEM;
+		goto err_unregister_keydev;
+	}
+
+	jog_dev->name = "Sony Vaio Jogdial";
+	jog_dev->id.bustype = BUS_ISA;
+	jog_dev->id.vendor = PCI_VENDOR_ID_SONY;
+
+	jog_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REL);
+	jog_dev->keybit[LONG(BTN_MOUSE)] = BIT(BTN_MIDDLE);
+	jog_dev->relbit[0] = BIT(REL_WHEEL);
+
+	error = input_register_device(jog_dev);
+	if (error)
+		goto err_free_jogdev;
+
+	sony_laptop_input.jog_dev = jog_dev;
+
+	return 0;
+
+err_free_jogdev:
+	input_free_device(jog_dev);
+
+err_unregister_keydev:
+	input_unregister_device(key_dev);
+	/* to avoid kref underflow below at input_free_device */
+	key_dev = NULL;
+
+err_free_keydev:
+	input_free_device(key_dev);
+
+err_destroy_wq:
+	destroy_workqueue(sony_laptop_input.wq);
+
+err_free_kfifo:
+	kfifo_free(sony_laptop_input.fifo);
+
+err_dec_users:
+	atomic_dec(&sony_laptop_input.users);
+	return error;
+}
+
+static void sony_laptop_remove_input(void)
+{
+	/* cleanup only after the last user has gone */
+	if (!atomic_dec_and_test(&sony_laptop_input.users))
+		return;
+
+	/* flush workqueue first */
+	flush_workqueue(sony_laptop_input.wq);
+
+	/* destroy input devs */
+	input_unregister_device(sony_laptop_input.key_dev);
+	sony_laptop_input.key_dev = NULL;
+
+	if (sony_laptop_input.jog_dev) {
+		input_unregister_device(sony_laptop_input.jog_dev);
+		sony_laptop_input.jog_dev = NULL;
+	}
+
+	destroy_workqueue(sony_laptop_input.wq);
+	kfifo_free(sony_laptop_input.fifo);
+}
+
 /*********** Platform Device ***********/
 
 static atomic_t sony_pf_users = ATOMIC_INIT(0);
@@ -428,6 +676,7 @@ static struct backlight_ops sony_backlig
 static void sony_acpi_notify(acpi_handle handle, u32 event, void *data)
 {
 	dprintk("sony_acpi_notify, event: %d\n", event);
+	sony_laptop_report_input_event(event);
 	acpi_bus_generate_event(sony_nc_acpi_device, 1, event);
 }
 
@@ -490,13 +739,21 @@ static int sony_nc_add(struct acpi_devic
 		}
 	}
 
+	/* setup input devices and helper fifo */
+	result = sony_laptop_setup_input();
+	if (result) {
+		printk(KERN_ERR DRV_PFX
+				"Unabe to create input devices.\n");
+		goto outwalk;
+	}
+
 	status = acpi_install_notify_handler(sony_nc_acpi_handle,
 					     ACPI_DEVICE_NOTIFY,
 					     sony_acpi_notify, NULL);
 	if (ACPI_FAILURE(status)) {
 		printk(LOG_PFX "unable to install notify handler\n");
 		result = -ENODEV;
-		goto outwalk;
+		goto outinput;
 	}
 
 	if (ACPI_SUCCESS(acpi_get_handle(sony_nc_acpi_handle, "GBRT", &handle))) {
@@ -568,6 +825,7 @@ static int sony_nc_add(struct acpi_devic
 		device_remove_file(&sony_pf_device->dev, &item->devattr);
 	}
 	sony_pf_remove();
+
       outbacklight:
 	if (sony_backlight_device)
 		backlight_device_unregister(sony_backlight_device);
@@ -577,6 +835,10 @@ static int sony_nc_add(struct acpi_devic
 					    sony_acpi_notify);
 	if (ACPI_FAILURE(status))
 		printk(LOG_PFX "unable to remove notify handler\n");
+
+      outinput:
+	sony_laptop_remove_input();
+
       outwalk:
 	return result;
 }
@@ -602,6 +864,7 @@ static int sony_nc_remove(struct acpi_de
 	}
 
 	sony_pf_remove();
+	sony_laptop_remove_input();
 
 	printk(KERN_INFO SONY_NC_DRIVER_NAME " successfully removed\n");
 
@@ -626,13 +889,8 @@ static struct acpi_driver sony_nc_driver
 #define SONYPI_DEVICE_TYPE2	0x00000002
 #define SONYPI_DEVICE_TYPE3	0x00000004
 
-#define SONY_EC_JOGB		0x82
-#define SONY_EC_JOGB_MASK	0x02
-
 #define SONY_PIC_EV_MASK	0xff
 
-#define SONYPI_BUF_SIZE	128
-
 struct sony_pic_ioport {
 	struct acpi_resource_io	io;
 	struct list_head	list;
@@ -650,12 +908,6 @@ struct sony_pic_dev {
 	struct sony_pic_ioport	*cur_ioport;
 	struct list_head	interrupts;
 	struct list_head	ioports;
-
-	struct input_dev	*input_jog_dev;
-	struct input_dev	*input_key_dev;
-	struct kfifo		*input_fifo;
-	spinlock_t		input_fifo_lock;
-	struct workqueue_struct	*sony_pic_wq;
 };
 
 static struct sony_pic_dev spic_dev = {
@@ -929,250 +1181,9 @@ static u8 sony_pic_call2(u8 dev, u8 fn)
 	return v1;
 }
 
-/*****************
- *
- * INPUT Device
- *
- *****************/
-struct sony_pic_keypress {
-	struct input_dev *dev;
-	int key;
-};
-
-/* Correspondance table between sonypi events and input layer events */
-static struct {
-	int sonypiev;
-	int inputev;
-} sony_pic_inputkeys[] = {
-	{ SONYPI_EVENT_CAPTURE_PRESSED,	 	KEY_CAMERA },
-	{ SONYPI_EVENT_FNKEY_ONLY, 		KEY_FN },
-	{ SONYPI_EVENT_FNKEY_ESC, 		KEY_FN_ESC },
-	{ SONYPI_EVENT_FNKEY_F1, 		KEY_FN_F1 },
-	{ SONYPI_EVENT_FNKEY_F2, 		KEY_FN_F2 },
-	{ SONYPI_EVENT_FNKEY_F3, 		KEY_FN_F3 },
-	{ SONYPI_EVENT_FNKEY_F4, 		KEY_FN_F4 },
-	{ SONYPI_EVENT_FNKEY_F5, 		KEY_FN_F5 },
-	{ SONYPI_EVENT_FNKEY_F6, 		KEY_FN_F6 },
-	{ SONYPI_EVENT_FNKEY_F7, 		KEY_FN_F7 },
-	{ SONYPI_EVENT_FNKEY_F8, 		KEY_FN_F8 },
-	{ SONYPI_EVENT_FNKEY_F9,		KEY_FN_F9 },
-	{ SONYPI_EVENT_FNKEY_F10,		KEY_FN_F10 },
-	{ SONYPI_EVENT_FNKEY_F11, 		KEY_FN_F11 },
-	{ SONYPI_EVENT_FNKEY_F12,		KEY_FN_F12 },
-	{ SONYPI_EVENT_FNKEY_1, 		KEY_FN_1 },
-	{ SONYPI_EVENT_FNKEY_2, 		KEY_FN_2 },
-	{ SONYPI_EVENT_FNKEY_D,			KEY_FN_D },
-	{ SONYPI_EVENT_FNKEY_E,			KEY_FN_E },
-	{ SONYPI_EVENT_FNKEY_F,			KEY_FN_F },
-	{ SONYPI_EVENT_FNKEY_S,			KEY_FN_S },
-	{ SONYPI_EVENT_FNKEY_B,			KEY_FN_B },
-	{ SONYPI_EVENT_BLUETOOTH_PRESSED, 	KEY_BLUE },
-	{ SONYPI_EVENT_BLUETOOTH_ON, 		KEY_BLUE },
-	{ SONYPI_EVENT_PKEY_P1, 		KEY_PROG1 },
-	{ SONYPI_EVENT_PKEY_P2, 		KEY_PROG2 },
-	{ SONYPI_EVENT_PKEY_P3, 		KEY_PROG3 },
-	{ SONYPI_EVENT_BACK_PRESSED, 		KEY_BACK },
-	{ SONYPI_EVENT_HELP_PRESSED, 		KEY_HELP },
-	{ SONYPI_EVENT_ZOOM_PRESSED, 		KEY_ZOOM },
-	{ SONYPI_EVENT_THUMBPHRASE_PRESSED, 	BTN_THUMB },
-	{ 0, 0 },
-};
-
-/* release buttons after a short delay if pressed */
-static void do_sony_pic_release_key(struct work_struct *work)
-{
-	struct sony_pic_keypress kp;
-
-	while (kfifo_get(spic_dev.input_fifo, (unsigned char *)&kp,
-			 sizeof(kp)) == sizeof(kp)) {
-		msleep(10);
-		input_report_key(kp.dev, kp.key, 0);
-		input_sync(kp.dev);
-	}
-}
-static DECLARE_WORK(sony_pic_release_key_work,
-		do_sony_pic_release_key);
-
-/* forward event to the input subsytem */
-static void sony_pic_report_input_event(u8 event)
-{
-	struct input_dev *jog_dev = spic_dev.input_jog_dev;
-	struct input_dev *key_dev = spic_dev.input_key_dev;
-	struct sony_pic_keypress kp = { NULL };
-	int i;
-
-	if (event == SONYPI_EVENT_FNKEY_RELEASED) {
-		/* Nothing, not all VAIOs generate this event */
-		return;
-	}
-
-	/* report jog_dev events */
-	if (jog_dev) {
-		switch (event) {
-		case SONYPI_EVENT_JOGDIAL_UP:
-		case SONYPI_EVENT_JOGDIAL_UP_PRESSED:
-			input_report_rel(jog_dev, REL_WHEEL, 1);
-			input_sync(jog_dev);
-			return;
-
-		case SONYPI_EVENT_JOGDIAL_DOWN:
-		case SONYPI_EVENT_JOGDIAL_DOWN_PRESSED:
-			input_report_rel(jog_dev, REL_WHEEL, -1);
-			input_sync(jog_dev);
-			return;
-
-		default:
-			break;
-		}
-	}
-
-	switch (event) {
-	case SONYPI_EVENT_JOGDIAL_PRESSED:
-		kp.key = BTN_MIDDLE;
-		kp.dev = jog_dev;
-		break;
-
-	default:
-		for (i = 0; sony_pic_inputkeys[i].sonypiev; i++)
-			if (event == sony_pic_inputkeys[i].sonypiev) {
-				kp.dev = key_dev;
-				kp.key = sony_pic_inputkeys[i].inputev;
-				break;
-			}
-		break;
-	}
-
-	if (kp.dev) {
-		input_report_key(kp.dev, kp.key, 1);
-		input_sync(kp.dev);
-		kfifo_put(spic_dev.input_fifo,
-			  (unsigned char *)&kp, sizeof(kp));
-
-		if (!work_pending(&sony_pic_release_key_work))
-			queue_work(spic_dev.sony_pic_wq,
-					&sony_pic_release_key_work);
-	}
-}
-
-static int sony_pic_setup_input(void)
-{
-	struct input_dev *jog_dev;
-	struct input_dev *key_dev;
-	int i;
-	int error;
-	u8 jog_present = 0;
-
-	/* kfifo */
-	spin_lock_init(&spic_dev.input_fifo_lock);
-	spic_dev.input_fifo =
-		kfifo_alloc(SONYPI_BUF_SIZE, GFP_KERNEL,
-			    &spic_dev.input_fifo_lock);
-	if (IS_ERR(spic_dev.input_fifo)) {
-		printk(KERN_ERR "sonypi: kfifo_alloc failed\n");
-		return PTR_ERR(spic_dev.input_fifo);
-	}
-
-	/* init workqueue */
-	spic_dev.sony_pic_wq = create_singlethread_workqueue("sony-pic");
-	if (!spic_dev.sony_pic_wq) {
-		printk(KERN_ERR DRV_PFX
-				"Unabe to create workqueue.\n");
-		error = -ENXIO;
-		goto err_free_kfifo;
-	}
-
-	/* input keys */
-	key_dev = input_allocate_device();
-	if (!key_dev) {
-		error = -ENOMEM;
-		goto err_destroy_wq;
-	}
-
-	key_dev->name = "Sony Vaio Keys";
-	key_dev->id.bustype = BUS_ISA;
-	key_dev->id.vendor = PCI_VENDOR_ID_SONY;
-
-	/* Initialize the Input Drivers: special keys */
-	key_dev->evbit[0] = BIT(EV_KEY);
-	for (i = 0; sony_pic_inputkeys[i].sonypiev; i++)
-		if (sony_pic_inputkeys[i].inputev)
-			set_bit(sony_pic_inputkeys[i].inputev, key_dev->keybit);
-
-	error = input_register_device(key_dev);
-	if (error)
-		goto err_free_keydev;
-
-	spic_dev.input_key_dev = key_dev;
-
-	/* jogdial - really reliable ? */
-	ec_read(SONY_EC_JOGB, &jog_present);
-	if (jog_present & SONY_EC_JOGB_MASK || force_jog) {
-		jog_dev = input_allocate_device();
-		if (!jog_dev) {
-			error = -ENOMEM;
-			goto err_unregister_keydev;
-		}
-
-		jog_dev->name = "Sony Vaio Jogdial";
-		jog_dev->id.bustype = BUS_ISA;
-		jog_dev->id.vendor = PCI_VENDOR_ID_SONY;
-
-		jog_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REL);
-		jog_dev->keybit[LONG(BTN_MOUSE)] = BIT(BTN_MIDDLE);
-		jog_dev->relbit[0] = BIT(REL_WHEEL);
-
-		error = input_register_device(jog_dev);
-		if (error)
-			goto err_free_jogdev;
-
-		spic_dev.input_jog_dev = jog_dev;
-	}
-
-	return 0;
-
-err_free_jogdev:
-	input_free_device(jog_dev);
-
-err_unregister_keydev:
-	input_unregister_device(key_dev);
-	/* to avoid kref underflow below at input_free_device */
-	key_dev = NULL;
-
-err_free_keydev:
-	input_free_device(key_dev);
-
-err_destroy_wq:
-	destroy_workqueue(spic_dev.sony_pic_wq);
-
-err_free_kfifo:
-	kfifo_free(spic_dev.input_fifo);
-
-	return error;
-}
-
-static void sony_pic_remove_input(void)
-{
-	/* flush workqueue first */
-	flush_workqueue(spic_dev.sony_pic_wq);
-
-	/* destroy input devs */
-	input_unregister_device(spic_dev.input_key_dev);
-	spic_dev.input_key_dev = NULL;
-
-	if (spic_dev.input_jog_dev) {
-		input_unregister_device(spic_dev.input_jog_dev);
-		spic_dev.input_jog_dev = NULL;
-	}
-
-	destroy_workqueue(spic_dev.sony_pic_wq);
-	kfifo_free(spic_dev.input_fifo);
-}
-
-/********************
- *
+/*
  * ACPI callbacks
- *
- ********************/
+ */
 static acpi_status
 sony_pic_read_possible_resource(struct acpi_resource *resource, void *context)
 {
@@ -1409,7 +1420,7 @@ static irqreturn_t sony_pic_irq(int irq,
 	return IRQ_HANDLED;
 
 found:
-	sony_pic_report_input_event(device_event);
+	sony_laptop_report_input_event(device_event);
 	acpi_bus_generate_event(spic_dev.acpi_dev, 1, device_event);
 
 	return IRQ_HANDLED;
@@ -1434,7 +1445,7 @@ static int sony_pic_remove(struct acpi_d
 	release_region(spic_dev.cur_ioport->io.minimum,
 			spic_dev.cur_ioport->io.address_length);
 
-	sony_pic_remove_input();
+	sony_laptop_remove_input();
 
 	list_for_each_entry_safe(io, tmp_io, &spic_dev.ioports, list) {
 		list_del(&io->list);
@@ -1474,7 +1485,7 @@ static int sony_pic_add(struct acpi_devi
 	}
 
 	/* setup input devices and helper fifo */
-	result = sony_pic_setup_input();
+	result = sony_laptop_setup_input();
 	if (result) {
 		printk(KERN_ERR DRV_PFX
 				"Unabe to create input devices.\n");
@@ -1535,7 +1546,7 @@ err_release_region:
 			spic_dev.cur_ioport->io.address_length);
 
 err_remove_input:
-	sony_pic_remove_input();
+	sony_laptop_remove_input();
 
 err_free_resources:
 	list_for_each_entry_safe(io, tmp_io, &spic_dev.ioports, list) {
_

Patches currently in -mm which might be from malattia@linux.it are

remove-acpi-references-from-variable-and-function-names.patch
prepare-the-platform-driver-for-multiple-users.patch
add-debug-macros-also-used-by-the-sonypi-reimplementation.patch
add-sny6001-device-handling-sonypi-reimplementation.patch
unify-the-input-subsystem-event-forwarding.patch
additional-platform-attributes-coming-from-sny6001.patch
sanitize-printks.patch
update-documentation-and-kconfig-help.patch
git-cpufreq.patch

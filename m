From: akpm@linux-foundation.org
Subject: - drivers-add-lcd-support-update-5.patch removed from -mm tree
Date: Sat, 10 Feb 2007 00:10:28 -0800
Message-ID: <200702100810.l1A8AScg006938@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39264 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766AbXBJIKc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 03:10:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maxextreme@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers: add LCD support (update 5)
has been removed from the -mm tree.  Its filename was
     drivers-add-lcd-support-update-5.patch

This patch was dropped because it was folded into drivers-add-lcd-suppo=
rt-3.patch

------------------------------------------------------
Subject: drivers: add LCD support (update 5)
=46rom: Miguel Ojeda Sandonis <maxextreme@gmail.com>

 - New exported functions for cfag12864b useful for future modules,
   feature adding and avoiding conflicts.
    =B7 cfag12864b_getrate()   - Returns the refreshing rate (hertzs).
    =B7 cfag12864b_enable()    - Enable refreshing.
         Return 0 if successful. Anyone was using the LCD.
         Return !=3D 0 if failed. Someone is using the LCD.
    =B7 cfag12864b_disable()   - Disable refreshing.
    =B7 cfag12864b_isenabled() - Returns 0 if refreshing is not enabled=
=2E
         Return 0 if refreshing is not enabled. Anyone is using the LCD=
=2E
         Return !=3D 0 if refresing is enabled. Someone is using the LC=
D.

       This way, cfag12864b doesn't waste CPU time until some module re=
quest refreshing.
     Also, when a module is over working with the LCD, it should disabl=
e it,
     so other modules can take the control, and CPU time isn't waste.

       In addition, a module which wants to uses the LCD should check i=
f there
     is anyone using it (enable will return !=3D0 if so).

       Modules which only want to read it the buffer can use isenabled(=
) to check if
     there is any module using it so they can take useful information, =
for example.

       Finally, now a nodule has a way to know what the refreshing rate=
 is
     by calling getrate();

 - Improved headers (cfag12864b.h and ks0108.h)
    =B7 Now every exported function is briefly explained.

 - Fixed code related to destroying the workqueue:
    =B7 Now the workqueue is destroyed safely without any sleeping.

 - Adds an userspace example program at Documentation/auxdisplay/cfag12=
864b-example

 - Fixed GPL headers to be only v2 as "License: GPLv2" header line
   and "MODULE_LICENSE" states.

 - Cleaned #includes to be alphabetically ordered.

 Documentation/auxdisplay/ks0108               |    2
 drivers/auxdisplay/ks0108.c                   |   17

Signed-off-by: Miguel Ojeda Sandonis <maxextreme@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/auxdisplay/cfag12864b           |   28 -
 Documentation/auxdisplay/cfag12864b-example.c |  282 ++++++++++++++++
 Documentation/auxdisplay/ks0108               |    2=20
 drivers/auxdisplay/cfag12864b.c               |  100 ++++-
 drivers/auxdisplay/cfag12864bfb.c             |   30 +
 drivers/auxdisplay/ks0108.c                   |   17=20
 include/linux/cfag12864b.h                    |   42 ++
 include/linux/ks0108.h                        |   18 -
 8 files changed, 441 insertions(+), 78 deletions(-)

diff -puN Documentation/auxdisplay/cfag12864b~drivers-add-lcd-support-u=
pdate-5 Documentation/auxdisplay/cfag12864b
--- a/Documentation/auxdisplay/cfag12864b~drivers-add-lcd-support-updat=
e-5
+++ a/Documentation/auxdisplay/cfag12864b
@@ -96,30 +96,10 @@ Each bit represents one pixel. If the bi
 turn on. If the pixel is low, the pixel will turn off.
=20
 You can use the framebuffer as a file: fopen, fwrite, fclose...
+Although the LCD won't get updated until the next refresh time arrives=
=2E
=20
 Also, you can mmap the framebuffer: open & mmap, munmap & close...
-which is the best option.
+which is the best option for most uses.
=20
-You can use a copy of this header in your userspace programs.
-
----8<---
-/*
- *    Filename: cfag12864b.h
- * Description: cfag12864b LCD Display Driver Header for user-space ap=
ps
- *
- *      Author: Miguel Ojeda Sandonis <maxextreme@gmail.com>
- *        Date: 2006-10-27
- */
-
-#ifndef _CFAG12864B_H_
-#define _CFAG12864B_H_
-
-#define CFAG12864B_WIDTH	(128)
-#define CFAG12864B_HEIGHT	(64)
-#define CFAG12864B_SIZE		(1024)
-
-#endif // _CFAG12864B_H_
----8<---
-
-
-EOF
+Check Documentation/auxdisplay/cfag12864b-example.c
+for a real working userspace complete program with usage examples.
diff -puN /dev/null Documentation/auxdisplay/cfag12864b-example.c
--- /dev/null
+++ a/Documentation/auxdisplay/cfag12864b-example.c
@@ -0,0 +1,282 @@
+/*
+ *    Filename: cfag12864b-example.c
+ *     Version: 0.1.0
+ * Description: cfag12864b LCD userspace example program
+ *     License: GPLv2
+ *
+ *      Author: Copyright (C) Miguel Ojeda Sandonis <maxextreme@gmail.=
com>
+ *        Date: 2006-10-31
+ *
+ *  This program is free software; you can redistribute it and/or modi=
fy
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-13=
07  USA
+ *
+ */
+
+/*
+ * ------------------------
+ * start of cfag12864b code
+ * ------------------------
+ */
+
+#include <string.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/mman.h>
+
+#define CFAG12864B_WIDTH		(128)
+#define CFAG12864B_HEIGHT		(64)
+#define CFAG12864B_SIZE			(128 * 64 / 8)
+#define CFAG12864B_BPB			(8)
+#define CFAG12864B_ADDRESS(x, y)	((y) * CFAG12864B_WIDTH / \
+					CFAG12864B_BPB + (x) / CFAG12864B_BPB)
+#define CFAG12864B_BIT(n)		(((unsigned char) 1) << (n))
+
+#undef CFAG12864B_DOCHECK
+#ifdef CFAG12864B_DOCHECK
+	#define CFAG12864B_CHECK(x, y)		((x) < CFAG12864B_WIDTH && \
+						(y) < CFAG12864B_HEIGHT)
+#else
+	#define CFAG12864B_CHECK(x, y)		(1)
+#endif
+
+int cfag12864b_fd;
+unsigned char * cfag12864b_mem;
+unsigned char cfag12864b_buffer[CFAG12864B_SIZE];
+
+/*
+ * init a cfag12864b framebuffer device
+ *
+ * No error:       return =3D 0
+ * Unable to open: return =3D -1
+ * Unable to mmap: return =3D -2
+ */
+int cfag12864b_init(char *path)
+{
+	cfag12864b_fd =3D open(path, O_RDWR);
+	if (cfag12864b_fd =3D=3D -1)
+		return -1;
+
+	cfag12864b_mem =3D mmap(0, CFAG12864B_SIZE, PROT_READ | PROT_WRITE,
+		MAP_SHARED, cfag12864b_fd, 0);
+	if (cfag12864b_mem =3D=3D MAP_FAILED) {
+		close(cfag12864b_fd);
+		return -2;
+	}
+
+	return 0;
+}
+
+/*
+ * exit a cfag12864b framebuffer device
+ */
+void cfag12864b_exit(void)
+{
+	munmap(cfag12864b_mem, CFAG12864B_SIZE);
+	close(cfag12864b_fd);
+}
+
+/*
+ * set (x, y) pixel
+ */
+void cfag12864b_set(unsigned char x, unsigned char y)
+{
+	if (CFAG12864B_CHECK(x, y))
+		cfag12864b_buffer[CFAG12864B_ADDRESS(x, y)] |=3D
+			CFAG12864B_BIT(x % CFAG12864B_BPB);
+}
+
+/*
+ * unset (x, y) pixel
+ */
+void cfag12864b_unset(unsigned char x, unsigned char y)
+{
+	if (CFAG12864B_CHECK(x, y))
+		cfag12864b_buffer[CFAG12864B_ADDRESS(x, y)] &=3D
+			~CFAG12864B_BIT(x % CFAG12864B_BPB);
+}
+
+/*
+ * is set (x, y) pixel?
+ *
+ * Pixel off: return =3D 0
+ * Pixel on:  return =3D 1
+ */
+unsigned char cfag12864b_isset(unsigned char x, unsigned char y)
+{
+	if (CFAG12864B_CHECK(x, y))
+		if (cfag12864b_buffer[CFAG12864B_ADDRESS(x, y)] &
+			CFAG12864B_BIT(x % CFAG12864B_BPB))
+			return 1;
+
+	return 0;
+}
+
+/*
+ * not (x, y) pixel
+ */
+void cfag12864b_not(unsigned char x, unsigned char y)
+{
+	if (cfag12864b_isset(x, y))
+		cfag12864b_unset(x, y);
+	else
+		cfag12864b_set(x, y);
+}
+
+/*
+ * fill (set all pixels)
+ */
+void cfag12864b_fill(void)
+{
+	unsigned short i;
+
+	for (i =3D 0; i < CFAG12864B_SIZE; i++)
+		cfag12864b_buffer[i] =3D 0xFF;
+}
+
+/*
+ * clear (unset all pixels)
+ */
+void cfag12864b_clear(void)
+{
+	unsigned short i;
+
+	for (i =3D 0; i < CFAG12864B_SIZE; i++)
+		cfag12864b_buffer[i] =3D 0;
+}
+
+/*
+ * format a [128*64] matrix
+ *
+ * Pixel off: src[i] =3D 0
+ * Pixel on:  src[i] > 0
+ */
+void cfag12864b_format(unsigned char * matrix)
+{
+	unsigned char i, j, n;
+
+	for (i =3D 0; i < CFAG12864B_HEIGHT; i++)
+	for (j =3D 0; j < CFAG12864B_WIDTH / CFAG12864B_BPB; j++) {
+		cfag12864b_buffer[i * CFAG12864B_WIDTH / CFAG12864B_BPB +
+			j] =3D 0;
+		for (n =3D 0; n < CFAG12864B_BPB; n++)
+			if (matrix[i * CFAG12864B_WIDTH +
+				j * CFAG12864B_BPB + n])
+				cfag12864b_buffer[i * CFAG12864B_WIDTH /
+					CFAG12864B_BPB + j] |=3D
+					CFAG12864B_BIT(n);
+	}
+}
+
+/*
+ * blit buffer to lcd
+ */
+void cfag12864b_blit(void)
+{
+	memcpy(cfag12864b_mem, cfag12864b_buffer, CFAG12864B_SIZE);
+}
+
+/*
+ * ----------------------
+ * end of cfag12864b code
+ * ----------------------
+ */
+
+#include <stdio.h>
+#include <string.h>
+
+#define EXAMPLES	6
+
+void example(unsigned char n)
+{
+	unsigned short i, j;
+	unsigned char matrix[CFAG12864B_WIDTH * CFAG12864B_HEIGHT];
+
+	if(n > EXAMPLES)
+		return;
+
+	printf("Example %i/%i - ", n, EXAMPLES);
+
+	switch (n) {
+	case 1:
+		printf("Draw points setting bits");
+		cfag12864b_clear();
+		for (i =3D 0; i < CFAG12864B_WIDTH; i +=3D 2)
+			for (j =3D 0; j < CFAG12864B_HEIGHT; j +=3D 2)
+				cfag12864b_set(i, j);
+		break;
+
+	case 2:
+		printf("Clear the LCD");
+		cfag12864b_clear();
+		break;
+
+	case 3:
+		printf("Draw rows formatting a [128*64] matrix");
+		memset(matrix, 0, CFAG12864B_WIDTH * CFAG12864B_HEIGHT);
+		for (i =3D 0; i < CFAG12864B_WIDTH; i++)
+			for (j =3D 0; j < CFAG12864B_HEIGHT; j +=3D 2)
+				matrix[j * CFAG12864B_WIDTH + i] =3D 1;
+		cfag12864b_format(matrix);
+		break;
+
+	case 4:
+		printf("Fill the lcd");
+		cfag12864b_fill();
+		break;
+
+	case 5:
+		printf("Draw columns unsetting bits");
+		for (i =3D 0; i < CFAG12864B_WIDTH; i +=3D 2)
+			for (j =3D 0; j < CFAG12864B_HEIGHT; j++)
+				cfag12864b_unset(i, j);
+		break;
+
+	case 6:
+		printf("Do negative not-ing all bits");
+		for (i =3D 0; i < CFAG12864B_WIDTH; i++)
+			for (j =3D 0; j < CFAG12864B_HEIGHT; j ++)
+				cfag12864b_not(i, j);
+		break;
+	}
+
+	puts(" - [Press Enter]");
+}
+
+int main(int argc, char *argv[])
+{
+	unsigned char n;
+
+	if (argc !=3D 2) {
+		printf(
+			"Sintax:  %s fbdev\n"
+			"Usually: /dev/fb0, /dev/fb1...\n", argv[0]);
+		return -1;
+	}
+
+	if (cfag12864b_init(argv[1])) {
+		printf("Can't init %s fbdev\n", argv[1]);
+		return -2;
+	}
+
+	for (n =3D 1; n <=3D EXAMPLES; n++) {
+		example(n);
+		cfag12864b_blit();
+		while(getchar() !=3D '\n');
+	}
+
+	cfag12864b_exit();
+
+	return 0;
+}
diff -puN Documentation/auxdisplay/ks0108~drivers-add-lcd-support-updat=
e-5 Documentation/auxdisplay/ks0108
--- a/Documentation/auxdisplay/ks0108~drivers-add-lcd-support-update-5
+++ a/Documentation/auxdisplay/ks0108
@@ -53,5 +53,3 @@ If you aren't building LCD related hardw
 your LCD specific wiring information in the same folder.
=20
 For example, check Documentation/auxdisplay/cfag12864b.
-
-EOF
diff -puN drivers/auxdisplay/cfag12864b.c~drivers-add-lcd-support-updat=
e-5 drivers/auxdisplay/cfag12864b.c
--- a/drivers/auxdisplay/cfag12864b.c~drivers-add-lcd-support-update-5
+++ a/drivers/auxdisplay/cfag12864b.c
@@ -6,12 +6,11 @@
  *     Depends: ks0108
  *
  *      Author: Copyright (C) Miguel Ojeda Sandonis <maxextreme@gmail.=
com>
- *        Date: 2006-10-26
+ *        Date: 2006-10-31
  *
  *  This program is free software; you can redistribute it and/or modi=
fy
- *  it under the terms of the GNU General Public License as published =
by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
  *
  *  This program is distributed in the hope that it will be useful,
  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
@@ -32,11 +31,13 @@
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/jiffies.h>
-#include <linux/workqueue.h>
+#include <linux/mutex.h>
+#include <linux/uaccess.h>
 #include <linux/vmalloc.h>
+#include <linux/workqueue.h>
 #include <linux/ks0108.h>
 #include <linux/cfag12864b.h>
-#include <linux/uaccess.h>
+
=20
 #define CFAG12864B_NAME "cfag12864b"
=20
@@ -49,6 +50,11 @@ module_param(cfag12864b_rate, uint, S_IR
 MODULE_PARM_DESC(cfag12864b_rate,
 	"Refresh rate (hertzs)");
=20
+unsigned int cfag12864b_getrate(void)
+{
+	return cfag12864b_rate;
+}
+
 /*
  * cfag12864b Commands
  *
@@ -182,10 +188,6 @@ static void cfag12864b_nop(void)
  * cfag12864b Internal Commands
  */
=20
-static unsigned char *cfag12864b_cache;
-unsigned char *cfag12864b_buffer;
-EXPORT_SYMBOL_GPL(cfag12864b_buffer);
-
 static void cfag12864b_on(void)
 {
 	cfag12864b_setcontrollers(1, 1);
@@ -215,11 +217,56 @@ static void cfag12864b_clear(void)
  * Update work
  */
=20
+unsigned char *cfag12864b_buffer;
+static unsigned char *cfag12864b_cache;
+static DEFINE_MUTEX(cfag12864b_mutex);
+static unsigned char cfag12864b_updating;
 static void cfag12864b_update(void *arg);
 static struct workqueue_struct *cfag12864b_workqueue;
 DECLARE_WORK(cfag12864b_work, cfag12864b_update, NULL);
=20
-static unsigned char cfag12864b_updating;
+static void cfag12864b_queue(void)
+{
+	queue_delayed_work(cfag12864b_workqueue, &cfag12864b_work,
+		HZ / cfag12864b_rate);
+}
+
+unsigned char cfag12864b_enable(void)
+{
+	unsigned char ret;
+
+	mutex_lock(&cfag12864b_mutex);
+
+	if(!cfag12864b_updating) {
+		cfag12864b_updating =3D 1;
+		cfag12864b_queue();
+		ret =3D 0;
+	}
+	else
+		ret =3D 1;
+
+	mutex_unlock(&cfag12864b_mutex);
+
+	return ret;
+}
+
+void cfag12864b_disable(void)
+{
+	mutex_lock(&cfag12864b_mutex);
+
+	if(cfag12864b_updating) {
+		cfag12864b_updating =3D 0;
+		cancel_delayed_work(&cfag12864b_work);
+		flush_workqueue(cfag12864b_workqueue);
+	}
+
+	mutex_unlock(&cfag12864b_mutex);
+}
+
+unsigned char cfag12864b_isenabled(void)
+{
+	return cfag12864b_updating;
+}
=20
 static void cfag12864b_update(void *arg)
 {
@@ -252,11 +299,20 @@ static void cfag12864b_update(void *arg)
 	}
=20
 	if (cfag12864b_updating)
-		queue_delayed_work(cfag12864b_workqueue, &cfag12864b_work,
-			HZ / cfag12864b_rate);
+		cfag12864b_queue();
 }
=20
 /*
+ * cfag12864b Exported Symbols
+ */
+
+EXPORT_SYMBOL_GPL(cfag12864b_buffer);
+EXPORT_SYMBOL_GPL(cfag12864b_getrate);
+EXPORT_SYMBOL_GPL(cfag12864b_enable);
+EXPORT_SYMBOL_GPL(cfag12864b_disable);
+EXPORT_SYMBOL_GPL(cfag12864b_isenabled);
+
+/*
  * Module Init & Exit
  */
=20
@@ -290,17 +346,14 @@ static int __init cfag12864b_init(void)
 		goto bufferalloced;
 	}
=20
-	memset(cfag12864b_buffer, 0, CFAG12864B_SIZE);
-
-	cfag12864b_clear();
-	cfag12864b_on();
-
 	cfag12864b_workqueue =3D create_singlethread_workqueue(CFAG12864B_NAM=
E);
 	if (cfag12864b_workqueue =3D=3D NULL)
 		goto cachealloced;
=20
-	cfag12864b_updating =3D 1;
-	cfag12864b_update(NULL);
+	memset(cfag12864b_buffer, 0, CFAG12864B_SIZE);
+
+	cfag12864b_clear();
+	cfag12864b_on();
=20
 	return 0;
=20
@@ -316,12 +369,9 @@ none:
=20
 static void __exit cfag12864b_exit(void)
 {
-	cfag12864b_updating =3D 0;
-	mdelay((1000 / cfag12864b_rate) * 2);
-	destroy_workqueue(cfag12864b_workqueue);
-
+	cfag12864b_disable();
 	cfag12864b_off();
-
+	destroy_workqueue(cfag12864b_workqueue);
 	kfree(cfag12864b_cache);
 	free_page((unsigned long) cfag12864b_buffer);
 }
diff -puN drivers/auxdisplay/cfag12864bfb.c~drivers-add-lcd-support-upd=
ate-5 drivers/auxdisplay/cfag12864bfb.c
--- a/drivers/auxdisplay/cfag12864bfb.c~drivers-add-lcd-support-update-=
5
+++ a/drivers/auxdisplay/cfag12864bfb.c
@@ -6,12 +6,11 @@
  *     Depends: cfag12864b
  *
  *      Author: Copyright (C) Miguel Ojeda Sandonis <maxextreme@gmail.=
com>
- *        Date: 2006-10-26
+ *        Date: 2006-10-31
  *
  *  This program is free software; you can redistribute it and/or modi=
fy
- *  it under the terms of the GNU General Public License as published =
by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
  *
  *  This program is distributed in the hope that it will be useful,
  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
@@ -24,18 +23,18 @@
  *
  */
=20
+#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/errno.h>
-#include <linux/string.h>
-#include <linux/mm.h>
-#include <linux/slab.h>
 #include <linux/delay.h>
+#include <linux/errno.h>
 #include <linux/fb.h>
+#include <linux/mm.h>
 #include <linux/platform_device.h>
-#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/uaccess.h>
 #include <linux/cfag12864b.h>
-#include <asm/uaccess.h>
=20
 #define CFAG12864BFB_NAME "cfag12864bfb"
=20
@@ -155,7 +154,15 @@ static struct platform_device *cfag12864
=20
 static int __init cfag12864bfb_init(void)
 {
-	int ret =3D platform_driver_register(&cfag12864bfb_driver);
+	int ret;
+
+	if(cfag12864b_enable()) {
+		printk(KERN_ERR CFAG12864BFB_NAME ": ERROR: "
+			"can't enable cfag12864b refreshing (being used)\n");
+		return -ENODEV;
+	}
+
+	ret =3D platform_driver_register(&cfag12864bfb_driver);
=20
 	if (!ret) {
 		cfag12864bfb_device =3D
@@ -179,6 +186,7 @@ static void __exit cfag12864bfb_exit(voi
 {
 	platform_device_unregister(cfag12864bfb_device);
 	platform_driver_unregister(&cfag12864bfb_driver);
+	cfag12864b_disable();
 }
=20
 module_init(cfag12864bfb_init);
diff -puN drivers/auxdisplay/ks0108.c~drivers-add-lcd-support-update-5 =
drivers/auxdisplay/ks0108.c
--- a/drivers/auxdisplay/ks0108.c~drivers-add-lcd-support-update-5
+++ a/drivers/auxdisplay/ks0108.c
@@ -6,12 +6,11 @@
  *     Depends: parport
  *
  *      Author: Copyright (C) Miguel Ojeda Sandonis <maxextreme@gmail.=
com>
- *        Date: 2006-10-04
+ *        Date: 2006-10-31
  *
  *  This program is free software; you can redistribute it and/or modi=
fy
- *  it under the terms of the GNU General Public License as published =
by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
  *
  *  This program is distributed in the hope that it will be useful,
  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
@@ -27,12 +26,12 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/fs.h>
 #include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/io.h>
 #include <linux/parport.h>
+#include <linux/uaccess.h>
 #include <linux/ks0108.h>
-#include <asm/io.h>
-#include <asm/uaccess.h>
=20
 #define KS0108_NAME "ks0108"
=20
@@ -56,7 +55,7 @@ static struct parport *ks0108_parport;
 static struct pardevice *ks0108_pardevice;
=20
 /*
- * ks0108 Exported cmds (don't lock)
+ * ks0108 Exported Commands (don't lock)
  *
  *   You _should_ lock in the top driver: This functions _should not_
  *   get race conditions in any way. Locking for each byte here would =
be
@@ -68,7 +67,7 @@ static struct pardevice *ks0108_pardevic
  *   a specific combination, look at the function's name.
  *
  *   The ks0108_writecontrol bits need to be reverted ^(0,1,3) because
- *   the parallel port also revert them with a "not" logic gate.
+ *   the parallel port also revert them using a "not" logic gate.
  */
=20
 #define bit(n) (((unsigned char)1)<<(n))
diff -puN include/linux/cfag12864b.h~drivers-add-lcd-support-update-5 i=
nclude/linux/cfag12864b.h
--- a/include/linux/cfag12864b.h~drivers-add-lcd-support-update-5
+++ a/include/linux/cfag12864b.h
@@ -8,9 +8,8 @@
  *        Date: 2006-10-12
  *
  *  This program is free software; you can redistribute it and/or modi=
fy
- *  it under the terms of the GNU General Public License as published =
by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
  *
  *  This program is distributed in the hope that it will be useful,
  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
@@ -35,7 +34,44 @@
 				(CFAG12864B_PAGES) * \
 				(CFAG12864B_ADDRESSES))
=20
+/*
+ * The driver will blit this buffer to the LCD
+ *
+ * Its size is CFAG12864B_SIZE.
+ */
 extern unsigned char * cfag12864b_buffer;
=20
+/*
+ * Get the refresh rate of the LCD
+ *
+ * Returns the refresh rate (hertzs).
+ */
+extern unsigned int cfag12864b_getrate(void);
+
+/*
+ * Enable refreshing
+ *
+ * Returns 0 if successful (anyone was using it),
+ * or !=3D 0 if failed (someone is using it).
+ */
+extern unsigned char cfag12864b_enable(void);
+
+/*
+ * Disable refreshing
+ *
+ * You should call this only when you finish using the LCD.
+ */
+extern void cfag12864b_disable(void);
+
+/*
+ * Is enabled refreshing? (is anyone using the module?)
+ *
+ * Returns 0 if refreshing is not enabled (anyone is using it),
+ * or !=3D 0 if refreshing is enabled (someone is using it).
+ *
+ * Useful for buffer read-only modules.
+ */
+extern unsigned char cfag12864b_isenabled(void);
+
 #endif /* _CFAG12864B_H_ */
=20
diff -puN include/linux/ks0108.h~drivers-add-lcd-support-update-5 inclu=
de/linux/ks0108.h
--- a/include/linux/ks0108.h~drivers-add-lcd-support-update-5
+++ a/include/linux/ks0108.h
@@ -5,12 +5,11 @@
  *     License: GPLv2
  *
  *      Author: Copyright (C) Miguel Ojeda Sandonis <maxextreme@gmail.=
com>
- *        Date: 2006-10-04
+ *        Date: 2006-10-31
  *
  *  This program is free software; you can redistribute it and/or modi=
fy
- *  it under the terms of the GNU General Public License as published =
by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
  *
  *  This program is distributed in the hope that it will be useful,
  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
@@ -26,11 +25,22 @@
 #ifndef _KS0108_H_
 #define _KS0108_H_
=20
+/* Write a byte to the data port */
 extern void ks0108_writedata(unsigned char byte);
+
+/* Write a byte to the control port */
 extern void ks0108_writecontrol(unsigned char byte);
+
+/* Set the controller's current display state (0..1) */
 extern void ks0108_displaystate(unsigned char state);
+
+/* Set the controller's current startline (0..63) */
 extern void ks0108_startline(unsigned char startline);
+
+/* Set the controller's current address (0..63) */
 extern void ks0108_address(unsigned char address);
+
+/* Set the controller's current page (0..7) */
 extern void ks0108_page(unsigned char page);
=20
 #endif /* _KS0108_H_ */
_

Patches currently in -mm which might be from maxextreme@gmail.com are

drivers-add-lcd-support-3.patch
drivers-add-lcd-support-update-5.patch
drivers-add-lcd-support-update6.patch
drivers-add-lcd-support-update-7.patch
drivers-add-lcd-support-update-8.patch
drivers-add-lcd-support-update-9.patch
drivers-add-lcd-support-workqueue-fixups.patch

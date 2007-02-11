From: akpm@linux-foundation.org
Subject: - drivers-add-lcd-support-3.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:49:54 -0800
Message-ID: <200702112249.l1BMnsFC015799@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59954 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932732AbXBKWuH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:50:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maxextreme@gmail.com, greg@kroah.com, pmarques@grupopie.com, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     drivers: add LCD support
has been removed from the -mm tree.  Its filename was
     drivers-add-lcd-support-3.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
Subject: drivers: add LCD support
=46rom: Miguel Ojeda Sandonis <maxextreme@gmail.com>

Add support for auxiliary displays, the ks0108 LCD controller, the
cfag12864b LCD and adds a framebuffer device: cfag12864bfb.

- Add a "auxdisplay/" folder in "drivers/" for auxiliary display
  drivers.

- Add support for the ks0108 LCD Controller as a device driver.  (uses
  parport interface)

- Add support for the cfag12864b LCD as a device driver.  (uses ks0108
  LCD Controller driver)

- Add a framebuffer device called cfag12864bfb.  (uses cfag12864b LCD
  driver)

- Add the usual Documentation, includes, Makefiles, Kconfigs,
  MAINTAINERS, CREDITS...

- Miguel Ojeda will maintain all the stuff above.

[rdunlap@xenotime.net: workqueue fixups]
[akpm@osdl.org: kconfig fix]
Signed-off-by: Miguel Ojeda Sandonis <maxextreme@gmail.com>
Cc: Greg KH <greg@kroah.com>
Acked-by: Paulo Marques <pmarques@grupopie.com>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS                                       |   10=20
 Documentation/auxdisplay/cfag12864b           |  105 ++++
 Documentation/auxdisplay/cfag12864b-example.c |  282 +++++++++++
 Documentation/auxdisplay/ks0108               |   55 ++
 MAINTAINERS                                   |   24 +
 drivers/Kconfig                               |    2=20
 drivers/Makefile                              |    1=20
 drivers/auxdisplay/Kconfig                    |  109 ++++
 drivers/auxdisplay/Makefile                   |    6=20
 drivers/auxdisplay/cfag12864b.c               |  383 ++++++++++++++++
 drivers/auxdisplay/cfag12864bfb.c             |  180 +++++++
 drivers/auxdisplay/ks0108.c                   |  166 ++++++
 include/linux/cfag12864b.h                    |   77 +++
 include/linux/ks0108.h                        |   46 +
 14 files changed, 1446 insertions(+)

diff -puN CREDITS~drivers-add-lcd-support-3 CREDITS
--- a/CREDITS~drivers-add-lcd-support-3
+++ a/CREDITS
@@ -2571,6 +2571,16 @@ S: Subiaco, 6008
 S: Perth, Western Australia
 S: Australia
=20
+N: Miguel Ojeda Sandonis
+E: maxextreme@gmail.com
+D: Author: Auxiliary LCD Controller driver (ks0108)
+D: Author: Auxiliary LCD driver (cfag12864b)
+D: Author: Auxiliary LCD framebuffer driver (cfag12864bfb)
+D: Maintainer: Auxiliary display drivers tree (drivers/auxdisplay/*)
+S: C/ Mieses 20, 9-B
+S: Valladolid 47009
+S: Spain
+
 N: Greg Page
 E: gpage@sovereign.org
 D: IPX development and support
diff -puN /dev/null Documentation/auxdisplay/cfag12864b
--- /dev/null
+++ a/Documentation/auxdisplay/cfag12864b
@@ -0,0 +1,105 @@
+	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+	cfag12864b LCD Driver Documentation
+	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+License:		GPLv2
+Author & Maintainer:	Miguel Ojeda Sandonis <maxextreme@gmail.com>
+Date:			2006-10-27
+
+
+
+--------
+0. INDEX
+--------
+
+	1. DRIVER INFORMATION
+	2. DEVICE INFORMATION
+	3. WIRING
+	4. USERSPACE PROGRAMMING
+
+
+---------------------
+1. DRIVER INFORMATION
+---------------------
+
+This driver support one cfag12864b display at time.
+
+
+---------------------
+2. DEVICE INFORMATION
+---------------------
+
+Manufacturer:	Crystalfontz
+Device Name:	Crystalfontz 12864b LCD Series
+Device Code:	cfag12864b
+Webpage:	http://www.crystalfontz.com
+Device Webpage:	http://www.crystalfontz.com/products/12864b/
+Type:		LCD (Liquid Crystal Display)
+Width:		128
+Height:		64
+Colors:		2 (B/N)
+Controller:	ks0108
+Controllers:	2
+Pages:		8 each controller
+Addresses:	64 each page
+Data size:	1 byte each address
+Memory size:	2 * 8 * 64 * 1 =3D 1024 bytes =3D 1 Kbyte
+
+
+---------
+3. WIRING
+---------
+
+The cfag12864b LCD Series don't have official wiring.
+
+The common wiring is done to the parallel port as shown:
+
+Parallel Port                          cfag12864b
+
+  Name Pin#                            Pin# Name
+
+Strobe ( 1)------------------------------(17) Enable
+Data 0 ( 2)------------------------------( 4) Data 0
+Data 1 ( 3)------------------------------( 5) Data 1
+Data 2 ( 4)------------------------------( 6) Data 2
+Data 3 ( 5)------------------------------( 7) Data 3
+Data 4 ( 6)------------------------------( 8) Data 4
+Data 5 ( 7)------------------------------( 9) Data 5
+Data 6 ( 8)------------------------------(10) Data 6
+Data 7 ( 9)------------------------------(11) Data 7
+       (10)                      [+5v]---( 1) Vdd
+       (11)                      [GND]---( 2) Ground
+       (12)                      [+5v]---(14) Reset
+       (13)                      [GND]---(15) Read / Write
+  Line (14)------------------------------(13) Controller Select 1
+       (15)
+  Init (16)------------------------------(12) Controller Select 2
+Select (17)------------------------------(16) Data / Instruction
+Ground (18)---[GND]              [+5v]---(19) LED +
+Ground (19)---[GND]
+Ground (20)---[GND]              E    A             Values:
+Ground (21)---[GND]       [GND]---[P1]---(18) Vee    =B7 R =3D Resisto=
r =3D 22 ohm
+Ground (22)---[GND]                |                 =B7 P1 =3D Preset=
 =3D 10 Kohm
+Ground (23)---[GND]       ----   S ------( 3) V0     =B7 P2 =3D Preset=
 =3D 1 Kohm
+Ground (24)---[GND]       |  |
+Ground (25)---[GND] [GND]---[P2]---[R]---(20) LED -
+
+
+------------------------
+4. USERSPACE PROGRAMMING
+------------------------
+
+The cfag12864bfb describes a framebuffer device (/dev/fbX).
+
+It has a size of 1024 bytes =3D 1 Kbyte.
+Each bit represents one pixel. If the bit is high, the pixel will
+turn on. If the pixel is low, the pixel will turn off.
+
+You can use the framebuffer as a file: fopen, fwrite, fclose...
+Although the LCD won't get updated until the next refresh time arrives=
=2E
+
+Also, you can mmap the framebuffer: open & mmap, munmap & close...
+which is the best option for most uses.
+
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
+	if (n > EXAMPLES)
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
+		while (getchar() !=3D '\n');
+	}
+
+	cfag12864b_exit();
+
+	return 0;
+}
diff -puN /dev/null Documentation/auxdisplay/ks0108
--- /dev/null
+++ a/Documentation/auxdisplay/ks0108
@@ -0,0 +1,55 @@
+	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+	ks0108 LCD Controller Driver Documentation
+	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+License:		GPLv2
+Author & Maintainer:	Miguel Ojeda Sandonis <maxextreme@gmail.com>
+Date:			2006-10-27
+
+
+
+--------
+0. INDEX
+--------
+
+	1. DRIVER INFORMATION
+	2. DEVICE INFORMATION
+	3. WIRING
+
+
+---------------------
+1. DRIVER INFORMATION
+---------------------
+
+This driver support the ks0108 LCD controller.
+
+
+---------------------
+2. DEVICE INFORMATION
+---------------------
+
+Manufacturer:	Samsung
+Device Name:	KS0108 LCD Controller
+Device Code:	ks0108
+Webpage:	-
+Device Webpage:	-
+Type:		LCD Controller (Liquid Crystal Display Controller)
+Width:		64
+Height:		64
+Colors:		2 (B/N)
+Pages:		8
+Addresses:	64 each page
+Data size:	1 byte each address
+Memory size:	8 * 64 * 1 =3D 512 bytes
+
+
+---------
+3. WIRING
+---------
+
+The driver supports data parallel port wiring.
+
+If you aren't building LCD related hardware, you should check
+your LCD specific wiring information in the same folder.
+
+For example, check Documentation/auxdisplay/cfag12864b.
diff -puN MAINTAINERS~drivers-add-lcd-support-3 MAINTAINERS
--- a/MAINTAINERS~drivers-add-lcd-support-3
+++ a/MAINTAINERS
@@ -635,6 +635,12 @@ W:	http://people.redhat.com/sgrubb/audit
 T:	git kernel.org:/pub/scm/linux/kernel/git/dwmw2/audit-2.6.git
 S:	Maintained
=20
+AUXILIARY DISPLAY DRIVERS
+P:	Miguel Ojeda Sandonis
+M:	maxextreme@gmail.com
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+
 AVR32 ARCHITECTURE
 P:	Haavard Skinnemoen
 M:	hskinnemoen@atmel.com
@@ -836,6 +842,18 @@ L:	linux-kernel@vger.kernel.org
 L:	discuss@x86-64.org
 S:	Maintained
=20
+CFAG12864B LCD DRIVER
+P:	Miguel Ojeda Sandonis
+M:	maxextreme@gmail.com
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+
+CFAG12864BFB LCD FRAMEBUFFER DRIVER
+P:	Miguel Ojeda Sandonis
+M:	maxextreme@gmail.com
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+
 COMMON INTERNET FILE SYSTEM (CIFS)
 P:	Steve French
 M:	sfrench@samba.org
@@ -1971,6 +1989,12 @@ M:	davem@davemloft.net
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
=20
+KS0108 LCD CONTROLLER DRIVER
+P:	Miguel Ojeda Sandonis
+M:	maxextreme@gmail.com
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+
 LAPB module
 L:	linux-x25@vger.kernel.org
 S:	Orphan
diff -puN drivers/Kconfig~drivers-add-lcd-support-3 drivers/Kconfig
--- a/drivers/Kconfig~drivers-add-lcd-support-3
+++ a/drivers/Kconfig
@@ -80,6 +80,8 @@ source "drivers/rtc/Kconfig"
=20
 source "drivers/dma/Kconfig"
=20
+source "drivers/auxdisplay/Kconfig"
+
 source "drivers/kvm/Kconfig"
=20
 endmenu
diff -puN drivers/Makefile~drivers-add-lcd-support-3 drivers/Makefile
--- a/drivers/Makefile~drivers-add-lcd-support-3
+++ a/drivers/Makefile
@@ -38,6 +38,7 @@ obj-$(CONFIG_ATA)		+=3D ata/
 obj-$(CONFIG_FUSION)		+=3D message/
 obj-$(CONFIG_IEEE1394)		+=3D ieee1394/
 obj-y				+=3D cdrom/
+obj-y				+=3D auxdisplay/
 obj-$(CONFIG_MTD)		+=3D mtd/
 obj-$(CONFIG_SPI)		+=3D spi/
 obj-$(CONFIG_PCCARD)		+=3D pcmcia/
diff -puN /dev/null drivers/auxdisplay/Kconfig
--- /dev/null
+++ a/drivers/auxdisplay/Kconfig
@@ -0,0 +1,109 @@
+#
+# For a description of the syntax of this configuration file,
+# see Documentation/kbuild/kconfig-language.txt.
+#
+# Auxiliary display drivers configuration.
+#
+
+menu "Auxiliary Display support"
+
+config KS0108
+	tristate "KS0108 LCD Controller"
+	depends on PARPORT_PC
+	default n
+	---help---
+	  If you have a LCD controlled by one or more KS0108
+	  controllers, say Y. You will need also another more specific
+	  driver for your LCD.
+
+	  Depends on Parallel Port support. If you say Y at
+	  parport, you will be able to compile this as a module (M)
+	  and built-in as well (Y).
+
+	  To compile this as a module, choose M here:
+	  the module will be called ks0108.
+
+	  If unsure, say N.
+
+config KS0108_PORT
+	hex "Parallel port where the LCD is connected"
+	depends on KS0108
+	default 0x378
+	---help---
+	  The address of the parallel port where the LCD is connected.
+
+	  The first  standard parallel port address is 0x378.
+	  The second standard parallel port address is 0x278.
+	  The third  standard parallel port address is 0x3BC.
+
+	  You can specify a different address if you need.
+
+	  If you don't know what I'm talking about, load the parport module,
+	  and execute "dmesg" or "cat /proc/ioports". You can see there how
+	  many parallel ports are present and which address each one has.
+
+	  Usually you only need to use 0x378.
+
+	  If you compile this as a module, you can still override this
+	  using the module parameters.
+
+config KS0108_DELAY
+	int "Delay between each control writing (microseconds)"
+	depends on KS0108
+	default "2"
+	---help---
+	  Amount of time the ks0108 should wait between each control write
+	  to the parallel port.
+
+	  If your driver seems to miss random writings, increment this.
+
+	  If you don't know what I'm talking about, ignore it.
+
+	  If you compile this as a module, you can still override this
+	  value using the module parameters.
+
+config CFAG12864B
+	tristate "CFAG12864B LCD"
+	depends on X86
+	depends on FB
+	depends on KS0108
+	default n
+	---help---
+	  If you have a Crystalfontz 128x64 2-color LCD, cfag12864b Series,
+	  say Y. You also need the ks0108 LCD Controller driver.
+
+	  For help about how to wire your LCD to the parallel port,
+	  check Documentation/auxdisplay/cfag12864b
+
+	  Depends on the x86 arch and the framebuffer support.
+
+	  The LCD framebuffer driver can be attached to a console.
+	  It will work fine. However, you can't attach it to the fbdev driver
+	  of the xorg server.
+
+	  To compile this as a module, choose M here:
+	  the modules will be called cfag12864b and cfag12864bfb.
+
+	  If unsure, say N.
+
+config CFAG12864B_RATE
+       int "Refresh rate (hertz)"
+	depends on CFAG12864B
+	default "20"
+	---help---
+	  Refresh rate of the LCD.
+
+	  As the LCD is not memory mapped, the driver has to make the work by
+	  software. This means you should be careful setting this value highe=
r.
+	  If your CPUs are really slow or you feel the system is slowed down,
+	  decrease the value.
+
+	  Be careful modifying this value to a very high value:
+	  You can freeze the computer, or the LCD maybe can't draw as fast as=
 you
+	  are requesting.
+
+	  If you don't know what I'm talking about, ignore it.
+
+	  If you compile this as a module, you can still override this
+	  value using the module parameters.
+endmenu
diff -puN /dev/null drivers/auxdisplay/Makefile
--- /dev/null
+++ a/drivers/auxdisplay/Makefile
@@ -0,0 +1,6 @@
+#
+# Makefile for the kernel auxiliary displays device drivers.
+#
+
+obj-$(CONFIG_KS0108)		+=3D ks0108.o
+obj-$(CONFIG_CFAG12864B)	+=3D cfag12864b.o cfag12864bfb.o
diff -puN /dev/null drivers/auxdisplay/cfag12864b.c
--- /dev/null
+++ a/drivers/auxdisplay/cfag12864b.c
@@ -0,0 +1,383 @@
+/*
+ *    Filename: cfag12864b.c
+ *     Version: 0.1.0
+ * Description: cfag12864b LCD driver
+ *     License: GPLv2
+ *     Depends: ks0108
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
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/cdev.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/jiffies.h>
+#include <linux/mutex.h>
+#include <linux/uaccess.h>
+#include <linux/vmalloc.h>
+#include <linux/workqueue.h>
+#include <linux/ks0108.h>
+#include <linux/cfag12864b.h>
+
+
+#define CFAG12864B_NAME "cfag12864b"
+
+/*
+ * Module Parameters
+ */
+
+static unsigned int cfag12864b_rate =3D CONFIG_CFAG12864B_RATE;
+module_param(cfag12864b_rate, uint, S_IRUGO);
+MODULE_PARM_DESC(cfag12864b_rate,
+	"Refresh rate (hertzs)");
+
+unsigned int cfag12864b_getrate(void)
+{
+	return cfag12864b_rate;
+}
+
+/*
+ * cfag12864b Commands
+ *
+ *	E =3D Enable signal
+ *		Everytime E switch from low to high,
+ *		cfag12864b/ks0108 reads the command/data.
+ *
+ *	CS1 =3D First ks0108controller.
+ *		If high, the first ks0108 controller receives commands/data.
+ *
+ *	CS2 =3D Second ks0108 controller
+ *		If high, the second ks0108 controller receives commands/data.
+ *
+ *	DI =3D Data/Instruction
+ *		If low, cfag12864b will expect commands.
+ *		If high, cfag12864b will expect data.
+ *
+ */
+
+#define bit(n) (((unsigned char)1)<<(n))
+
+#define CFAG12864B_BIT_E	(0)
+#define CFAG12864B_BIT_CS1	(2)
+#define CFAG12864B_BIT_CS2	(1)
+#define CFAG12864B_BIT_DI	(3)
+
+static unsigned char cfag12864b_state;
+
+static void cfag12864b_set(void)
+{
+	ks0108_writecontrol(cfag12864b_state);
+}
+
+static void cfag12864b_setbit(unsigned char state, unsigned char n)
+{
+	if (state)
+		cfag12864b_state |=3D bit(n);
+	else
+		cfag12864b_state &=3D ~bit(n);
+}
+
+static void cfag12864b_e(unsigned char state)
+{
+	cfag12864b_setbit(state, CFAG12864B_BIT_E);
+	cfag12864b_set();
+}
+
+static void cfag12864b_cs1(unsigned char state)
+{
+	cfag12864b_setbit(state, CFAG12864B_BIT_CS1);
+}
+
+static void cfag12864b_cs2(unsigned char state)
+{
+	cfag12864b_setbit(state, CFAG12864B_BIT_CS2);
+}
+
+static void cfag12864b_di(unsigned char state)
+{
+	cfag12864b_setbit(state, CFAG12864B_BIT_DI);
+}
+
+static void cfag12864b_setcontrollers(unsigned char first,
+	unsigned char second)
+{
+	if (first)
+		cfag12864b_cs1(0);
+	else
+		cfag12864b_cs1(1);
+
+	if (second)
+		cfag12864b_cs2(0);
+	else
+		cfag12864b_cs2(1);
+}
+
+static void cfag12864b_controller(unsigned char which)
+{
+	if (which =3D=3D 0)
+		cfag12864b_setcontrollers(1, 0);
+	else if (which =3D=3D 1)
+		cfag12864b_setcontrollers(0, 1);
+}
+
+static void cfag12864b_displaystate(unsigned char state)
+{
+	cfag12864b_di(0);
+	cfag12864b_e(1);
+	ks0108_displaystate(state);
+	cfag12864b_e(0);
+}
+
+static void cfag12864b_address(unsigned char address)
+{
+	cfag12864b_di(0);
+	cfag12864b_e(1);
+	ks0108_address(address);
+	cfag12864b_e(0);
+}
+
+static void cfag12864b_page(unsigned char page)
+{
+	cfag12864b_di(0);
+	cfag12864b_e(1);
+	ks0108_page(page);
+	cfag12864b_e(0);
+}
+
+static void cfag12864b_startline(unsigned char startline)
+{
+	cfag12864b_di(0);
+	cfag12864b_e(1);
+	ks0108_startline(startline);
+	cfag12864b_e(0);
+}
+
+static void cfag12864b_writebyte(unsigned char byte)
+{
+	cfag12864b_di(1);
+	cfag12864b_e(1);
+	ks0108_writedata(byte);
+	cfag12864b_e(0);
+}
+
+static void cfag12864b_nop(void)
+{
+	cfag12864b_startline(0);
+}
+
+/*
+ * cfag12864b Internal Commands
+ */
+
+static void cfag12864b_on(void)
+{
+	cfag12864b_setcontrollers(1, 1);
+	cfag12864b_displaystate(1);
+}
+
+static void cfag12864b_off(void)
+{
+	cfag12864b_setcontrollers(1, 1);
+	cfag12864b_displaystate(0);
+}
+
+static void cfag12864b_clear(void)
+{
+	unsigned char i, j;
+
+	cfag12864b_setcontrollers(1, 1);
+	for (i =3D 0; i < CFAG12864B_PAGES; i++) {
+		cfag12864b_page(i);
+		cfag12864b_address(0);
+		for (j =3D 0; j < CFAG12864B_ADDRESSES; j++)
+			cfag12864b_writebyte(0);
+	}
+}
+
+/*
+ * Update work
+ */
+
+unsigned char *cfag12864b_buffer;
+static unsigned char *cfag12864b_cache;
+static DEFINE_MUTEX(cfag12864b_mutex);
+static unsigned char cfag12864b_updating;
+static void cfag12864b_update(struct work_struct *delayed_work);
+static struct workqueue_struct *cfag12864b_workqueue;
+static DECLARE_DELAYED_WORK(cfag12864b_work, cfag12864b_update);
+
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
+	if (!cfag12864b_updating) {
+		cfag12864b_updating =3D 1;
+		cfag12864b_queue();
+		ret =3D 0;
+	} else
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
+	if (cfag12864b_updating) {
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
+
+static void cfag12864b_update(struct work_struct *work)
+{
+	unsigned char c;
+	unsigned short i, j, k, b;
+
+	if (memcmp(cfag12864b_cache, cfag12864b_buffer, CFAG12864B_SIZE)) {
+		for (i =3D 0; i < CFAG12864B_CONTROLLERS; i++) {
+			cfag12864b_controller(i);
+			cfag12864b_nop();
+			for (j =3D 0; j < CFAG12864B_PAGES; j++) {
+				cfag12864b_page(j);
+				cfag12864b_nop();
+				cfag12864b_address(0);
+				cfag12864b_nop();
+				for (k =3D 0; k < CFAG12864B_ADDRESSES; k++) {
+					for (c =3D 0, b =3D 0; b < 8; b++)
+						if (cfag12864b_buffer
+							[i * CFAG12864B_ADDRESSES / 8
+							+ k / 8 + (j * 8 + b) *
+							CFAG12864B_WIDTH / 8]
+							& bit(k % 8))
+							c |=3D bit(b);
+					cfag12864b_writebyte(c);
+				}
+			}
+		}
+
+		memcpy(cfag12864b_cache, cfag12864b_buffer, CFAG12864B_SIZE);
+	}
+
+	if (cfag12864b_updating)
+		cfag12864b_queue();
+}
+
+/*
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
+ * Module Init & Exit
+ */
+
+static int __init cfag12864b_init(void)
+{
+	int ret =3D -EINVAL;
+
+	if (PAGE_SIZE < CFAG12864B_SIZE) {
+		printk(KERN_ERR CFAG12864B_NAME ": ERROR: "
+			"page size (%i) < cfag12864b size (%i)\n",
+			(unsigned int)PAGE_SIZE, CFAG12864B_SIZE);
+		ret =3D -ENOMEM;
+		goto none;
+	}
+
+	cfag12864b_buffer =3D (unsigned char *) __get_free_page(GFP_KERNEL);
+	if (cfag12864b_buffer =3D=3D NULL) {
+		printk(KERN_ERR CFAG12864B_NAME ": ERROR: "
+			"can't get a free page\n");
+		ret =3D -ENOMEM;
+		goto none;
+	}
+
+	cfag12864b_cache =3D kmalloc(sizeof(unsigned char) *
+		CFAG12864B_SIZE, GFP_KERNEL);
+	if (cfag12864b_buffer =3D=3D NULL) {
+		printk(KERN_ERR CFAG12864B_NAME ": ERROR: "
+			"can't alloc cache buffer (%i bytes)\n",
+			CFAG12864B_SIZE);
+		ret =3D -ENOMEM;
+		goto bufferalloced;
+	}
+
+	cfag12864b_workqueue =3D create_singlethread_workqueue(CFAG12864B_NAM=
E);
+	if (cfag12864b_workqueue =3D=3D NULL)
+		goto cachealloced;
+
+	memset(cfag12864b_buffer, 0, CFAG12864B_SIZE);
+
+	cfag12864b_clear();
+	cfag12864b_on();
+
+	return 0;
+
+cachealloced:
+	kfree(cfag12864b_cache);
+
+bufferalloced:
+	free_page((unsigned long) cfag12864b_buffer);
+
+none:
+	return ret;
+}
+
+static void __exit cfag12864b_exit(void)
+{
+	cfag12864b_disable();
+	cfag12864b_off();
+	destroy_workqueue(cfag12864b_workqueue);
+	kfree(cfag12864b_cache);
+	free_page((unsigned long) cfag12864b_buffer);
+}
+
+module_init(cfag12864b_init);
+module_exit(cfag12864b_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Miguel Ojeda Sandonis <maxextreme@gmail.com>");
+MODULE_DESCRIPTION("cfag12864b LCD driver");
diff -puN /dev/null drivers/auxdisplay/cfag12864bfb.c
--- /dev/null
+++ a/drivers/auxdisplay/cfag12864bfb.c
@@ -0,0 +1,180 @@
+/*
+ *    Filename: cfag12864bfb.c
+ *     Version: 0.1.0
+ * Description: cfag12864b LCD framebuffer driver
+ *     License: GPLv2
+ *     Depends: cfag12864b
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
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/fb.h>
+#include <linux/mm.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/uaccess.h>
+#include <linux/cfag12864b.h>
+
+#define CFAG12864BFB_NAME "cfag12864bfb"
+
+static struct fb_fix_screeninfo cfag12864bfb_fix __initdata =3D {
+	.id =3D "cfag12864b",
+	.type =3D FB_TYPE_PACKED_PIXELS,
+	.visual =3D FB_VISUAL_MONO10,
+	.xpanstep =3D 0,
+	.ypanstep =3D 0,
+	.ywrapstep =3D 0,
+	.line_length =3D CFAG12864B_WIDTH / 8,
+	.accel =3D FB_ACCEL_NONE,
+};
+
+static struct fb_var_screeninfo cfag12864bfb_var __initdata =3D {
+	.xres =3D CFAG12864B_WIDTH,
+	.yres =3D CFAG12864B_HEIGHT,
+	.xres_virtual =3D CFAG12864B_WIDTH,
+	.yres_virtual =3D CFAG12864B_HEIGHT,
+	.bits_per_pixel =3D 1,
+	.red =3D { 0, 1, 0 },
+      	.green =3D { 0, 1, 0 },
+      	.blue =3D { 0, 1, 0 },
+	.left_margin =3D 0,
+	.right_margin =3D 0,
+	.upper_margin =3D 0,
+	.lower_margin =3D 0,
+	.vmode =3D FB_VMODE_NONINTERLACED,
+};
+
+static int cfag12864bfb_mmap(struct fb_info *info, struct vm_area_stru=
ct *vma)
+{
+	return vm_insert_page(vma, vma->vm_start,
+		virt_to_page(cfag12864b_buffer));
+}
+
+static struct fb_ops cfag12864bfb_ops =3D {
+	.owner =3D THIS_MODULE,
+	.fb_fillrect =3D cfb_fillrect,
+	.fb_copyarea =3D cfb_copyarea,
+	.fb_imageblit =3D cfb_imageblit,
+	.fb_mmap =3D cfag12864bfb_mmap,
+};
+
+static int __init cfag12864bfb_probe(struct platform_device *device)
+{
+	int ret =3D -EINVAL;
+ 	struct fb_info *info =3D framebuffer_alloc(0, &device->dev);
+
+	if (!info)
+		goto none;
+
+	info->screen_base =3D (char __iomem *) cfag12864b_buffer;
+	info->screen_size =3D CFAG12864B_SIZE;
+	info->fbops =3D &cfag12864bfb_ops;
+	info->fix =3D cfag12864bfb_fix;
+	info->var =3D cfag12864bfb_var;
+	info->pseudo_palette =3D NULL;
+	info->par =3D NULL;
+	info->flags =3D FBINFO_FLAG_DEFAULT;
+
+	if (register_framebuffer(info) < 0)
+		goto fballoced;
+
+	platform_set_drvdata(device, info);
+
+	printk(KERN_INFO "fb%d: %s frame buffer device\n", info->node,
+		info->fix.id);
+
+	return 0;
+
+fballoced:
+	framebuffer_release(info);
+
+none:
+	return ret;
+}
+
+static int cfag12864bfb_remove(struct platform_device *device)
+{
+	struct fb_info *info =3D platform_get_drvdata(device);
+
+	if (info) {
+		unregister_framebuffer(info);
+		framebuffer_release(info);
+	}
+
+	return 0;
+}
+
+static struct platform_driver cfag12864bfb_driver =3D {
+	.probe	=3D cfag12864bfb_probe,
+	.remove =3D cfag12864bfb_remove,
+	.driver =3D {
+		.name	=3D CFAG12864BFB_NAME,
+	},
+};
+
+static struct platform_device *cfag12864bfb_device;
+
+static int __init cfag12864bfb_init(void)
+{
+	int ret;
+
+	if (cfag12864b_enable()) {
+		printk(KERN_ERR CFAG12864BFB_NAME ": ERROR: "
+			"can't enable cfag12864b refreshing (being used)\n");
+		return -ENODEV;
+	}
+
+	ret =3D platform_driver_register(&cfag12864bfb_driver);
+
+	if (!ret) {
+		cfag12864bfb_device =3D
+			platform_device_alloc(CFAG12864BFB_NAME, 0);
+
+		if (cfag12864bfb_device)
+			ret =3D platform_device_add(cfag12864bfb_device);
+		else
+			ret =3D -ENOMEM;
+
+		if (ret) {
+			platform_device_put(cfag12864bfb_device);
+			platform_driver_unregister(&cfag12864bfb_driver);
+		}
+	}
+
+	return ret;
+}
+
+static void __exit cfag12864bfb_exit(void)
+{
+	platform_device_unregister(cfag12864bfb_device);
+	platform_driver_unregister(&cfag12864bfb_driver);
+	cfag12864b_disable();
+}
+
+module_init(cfag12864bfb_init);
+module_exit(cfag12864bfb_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Miguel Ojeda Sandonis <maxextreme@gmail.com>");
+MODULE_DESCRIPTION("cfag12864b LCD framebuffer driver");
diff -puN /dev/null drivers/auxdisplay/ks0108.c
--- /dev/null
+++ a/drivers/auxdisplay/ks0108.c
@@ -0,0 +1,166 @@
+/*
+ *    Filename: ks0108.c
+ *     Version: 0.1.0
+ * Description: ks0108 LCD Controller driver
+ *     License: GPLv2
+ *     Depends: parport
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
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/io.h>
+#include <linux/parport.h>
+#include <linux/uaccess.h>
+#include <linux/ks0108.h>
+
+#define KS0108_NAME "ks0108"
+
+/*
+ * Module Parameters
+ */
+
+static unsigned int ks0108_port =3D CONFIG_KS0108_PORT;
+module_param(ks0108_port, uint, S_IRUGO);
+MODULE_PARM_DESC(ks0108_port, "Parallel port where the LCD is connecte=
d");
+
+static unsigned int ks0108_delay =3D CONFIG_KS0108_DELAY;
+module_param(ks0108_delay, uint, S_IRUGO);
+MODULE_PARM_DESC(ks0108_delay, "Delay between each control writing (mi=
croseconds)");
+
+/*
+ * Device
+ */
+
+static struct parport *ks0108_parport;
+static struct pardevice *ks0108_pardevice;
+
+/*
+ * ks0108 Exported Commands (don't lock)
+ *
+ *   You _should_ lock in the top driver: This functions _should not_
+ *   get race conditions in any way. Locking for each byte here would =
be
+ *   so slow and useless.
+ *
+ *   There are not bit definitions because they are not flags,
+ *   just arbitrary combinations defined by the documentation for each
+ *   function in the ks0108 LCD controller. If you want to know what m=
eans
+ *   a specific combination, look at the function's name.
+ *
+ *   The ks0108_writecontrol bits need to be reverted ^(0,1,3) because
+ *   the parallel port also revert them using a "not" logic gate.
+ */
+
+#define bit(n) (((unsigned char)1)<<(n))
+
+void ks0108_writedata(unsigned char byte)
+{
+	parport_write_data(ks0108_parport, byte);
+}
+
+void ks0108_writecontrol(unsigned char byte)
+{
+	udelay(ks0108_delay);
+	parport_write_control(ks0108_parport, byte ^ (bit(0) | bit(1) | bit(3=
)));
+}
+
+void ks0108_displaystate(unsigned char state)
+{
+	ks0108_writedata((state ? bit(0) : 0) | bit(1) | bit(2) | bit(3) | bi=
t(4) | bit(5));
+}
+
+void ks0108_startline(unsigned char startline)
+{
+	ks0108_writedata(min(startline,(unsigned char)63) | bit(6) | bit(7));
+}
+
+void ks0108_address(unsigned char address)
+{
+	ks0108_writedata(min(address,(unsigned char)63) | bit(6));
+}
+
+void ks0108_page(unsigned char page)
+{
+	ks0108_writedata(min(page,(unsigned char)7) | bit(3) | bit(4) | bit(5=
) | bit(7));
+}
+
+EXPORT_SYMBOL_GPL(ks0108_writedata);
+EXPORT_SYMBOL_GPL(ks0108_writecontrol);
+EXPORT_SYMBOL_GPL(ks0108_displaystate);
+EXPORT_SYMBOL_GPL(ks0108_startline);
+EXPORT_SYMBOL_GPL(ks0108_address);
+EXPORT_SYMBOL_GPL(ks0108_page);
+
+/*
+ * Module Init & Exit
+ */
+
+static int __init ks0108_init(void)
+{
+	int result;
+	int ret =3D -EINVAL;
+
+	ks0108_parport =3D parport_find_base(ks0108_port);
+	if (ks0108_parport =3D=3D NULL) {
+		printk(KERN_ERR KS0108_NAME ": ERROR: "
+			"parport didn't find %i port\n", ks0108_port);
+		goto none;
+	}
+
+	ks0108_pardevice =3D parport_register_device(ks0108_parport, KS0108_N=
AME,
+		NULL, NULL, NULL, PARPORT_DEV_EXCL, NULL);
+	if (ks0108_pardevice =3D=3D NULL) {
+		printk(KERN_ERR KS0108_NAME ": ERROR: "
+			"parport didn't register new device\n");
+		goto none;
+	}
+
+	result =3D parport_claim(ks0108_pardevice);
+	if (result !=3D 0) {
+		printk(KERN_ERR KS0108_NAME ": ERROR: "
+			"can't claim %i parport, maybe in use\n", ks0108_port);
+		ret =3D result;
+		goto registered;
+	}
+
+	return 0;
+
+registered:
+	parport_unregister_device(ks0108_pardevice);
+
+none:
+	return ret;
+}
+
+static void __exit ks0108_exit(void)
+{
+	parport_release(ks0108_pardevice);
+	parport_unregister_device(ks0108_pardevice);
+}
+
+module_init(ks0108_init);
+module_exit(ks0108_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Miguel Ojeda Sandonis <maxextreme@gmail.com>");
+MODULE_DESCRIPTION("ks0108 LCD Controller driver");
+
diff -puN /dev/null include/linux/cfag12864b.h
--- /dev/null
+++ a/include/linux/cfag12864b.h
@@ -0,0 +1,77 @@
+/*
+ *    Filename: cfag12864b.h
+ *     Version: 0.1.0
+ * Description: cfag12864b LCD driver header
+ *     License: GPLv2
+ *
+ *      Author: Copyright (C) Miguel Ojeda Sandonis <maxextreme@gmail.=
com>
+ *        Date: 2006-10-12
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
+#ifndef _CFAG12864B_H_
+#define _CFAG12864B_H_
+
+#define CFAG12864B_WIDTH	(128)
+#define CFAG12864B_HEIGHT	(64)
+#define CFAG12864B_CONTROLLERS	(2)
+#define CFAG12864B_PAGES	(8)
+#define CFAG12864B_ADDRESSES	(64)
+#define CFAG12864B_SIZE		((CFAG12864B_CONTROLLERS) * \
+				(CFAG12864B_PAGES) * \
+				(CFAG12864B_ADDRESSES))
+
+/*
+ * The driver will blit this buffer to the LCD
+ *
+ * Its size is CFAG12864B_SIZE.
+ */
+extern unsigned char * cfag12864b_buffer;
+
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
+#endif /* _CFAG12864B_H_ */
+
diff -puN /dev/null include/linux/ks0108.h
--- /dev/null
+++ a/include/linux/ks0108.h
@@ -0,0 +1,46 @@
+/*
+ *    Filename: ks0108.h
+ *     Version: 0.1.0
+ * Description: ks0108 LCD Controller driver header
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
+#ifndef _KS0108_H_
+#define _KS0108_H_
+
+/* Write a byte to the data port */
+extern void ks0108_writedata(unsigned char byte);
+
+/* Write a byte to the control port */
+extern void ks0108_writecontrol(unsigned char byte);
+
+/* Set the controller's current display state (0..1) */
+extern void ks0108_displaystate(unsigned char state);
+
+/* Set the controller's current startline (0..63) */
+extern void ks0108_startline(unsigned char startline);
+
+/* Set the controller's current address (0..63) */
+extern void ks0108_address(unsigned char address);
+
+/* Set the controller's current page (0..7) */
+extern void ks0108_page(unsigned char page);
+
+#endif /* _KS0108_H_ */
_

Patches currently in -mm which might be from maxextreme@gmail.com are

origin.patch

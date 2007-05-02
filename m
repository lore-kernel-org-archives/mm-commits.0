From: akpm@linux-foundation.org
Subject: + spi-kerneldoc.patch added to -mm tree
Date: Tue, 01 May 2007 17:17:36 -0700
Message-ID: <200705020017.l420HaJq009939@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49495 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946160AbXEBARr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 May 2007 20:17:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net, rdunlap@xenotime.net


The patch titled
     SPI kerneldoc
has been added to the -mm tree.  Its filename is
     spi-kerneldoc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SPI kerneldoc
From: David Brownell <david-b@pacbell.net>

Various documentation updates for the SPI infrastructure, to clarify things
that may not have been clear, to cope with lack of editing, and fix
omissions.

Also, plug SPI into the kernel-api DocBook template, and fix all the
resulting glitches in document generation.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/kernel-api.tmpl |   63 ++++++++++++++++++++++++
 Documentation/spi/spi-summary         |   43 +++++++++-------
 drivers/spi/spi.c                     |   26 ++++++++-
 include/linux/spi/spi.h               |   63 ++++++++++++++----------
 4 files changed, 147 insertions(+), 48 deletions(-)

diff -puN Documentation/DocBook/kernel-api.tmpl~spi-kerneldoc Documentation/DocBook/kernel-api.tmpl
--- a/Documentation/DocBook/kernel-api.tmpl~spi-kerneldoc
+++ a/Documentation/DocBook/kernel-api.tmpl
@@ -580,4 +580,67 @@ X!Idrivers/video/console/fonts.c
 !Edrivers/input/ff-core.c
 !Edrivers/input/ff-memless.c
   </chapter>
+
+  <chapter id="spi">
+      <title>Serial Peripheral Interface (SPI)</title>
+  <para>
+	SPI is the "Serial Peripheral Interface", widely used with
+	embedded systems because it is a simple and efficient
+	interface:  basically a multiplexed shift register.
+	Its three signal wires hold a clock (SCK, often in the range
+	of 1-20 MHz), a "Master Out, Slave In" (MOSI) data line, and
+	a "Master In, Slave Out" (MISO) data line.
+	SPI is a full duplex protocol; for each bit shifted out the
+	MOSI line (one per clock) another is shifted in on the MISO line.
+	Those bits are assembled into words of various sizes on the
+	way to and from system memory.
+	An additional chipselect line is usually active-low (nCS);
+	four signals are normally used for each peripheral, plus
+	sometimes an interrupt.
+  </para>
+  <para>
+	The SPI bus facilities listed here provide a generalized
+	interface to declare SPI busses and devices, manage them
+	according to the standard Linux driver model, and perform
+	input/output operations.
+	At this time, only "master" side interfaces are supported,
+	where Linux talks to SPI peripherals and does not implement
+	such a peripheral itself.
+	(Interfaces to support implementing SPI slaves would
+	necessarily look different.)
+  </para>
+  <para>
+	The programming interface is structured around two kinds of driver,
+	and two kinds of device.
+	A "Controller Driver" abstracts the controller hardware, which may
+	be as simple as a set of GPIO pins or as complex as a pair of FIFOs
+	connected to dual DMA engines on the other side of the SPI shift
+	register (maximizing throughput).  Such drivers bridge between
+	whatever bus they sit on (often the platform bus) and SPI, and
+	expose the SPI side of their device as a
+	<structname>struct spi_master</structname>.
+	SPI devices are children of that master, represented as a
+	<structname>struct spi_device</structname> and manufactured from
+	<structname>struct spi_board_info</structname> descriptors which
+	are usually provided by board-specific initialization code.
+	A <structname>struct spi_driver</structname> is called a
+	"Protocol Driver", and is bound to a spi_device using normal
+	driver model calls.
+  </para>
+  <para>
+	The I/O model is a set of queued messages.  Protocol drivers
+	submit one or more <structname>struct spi_message</structname>
+	objects, which are processed and completed asynchronously.
+	(There are synchronous wrappers, however.)  Messages are
+	built from one or more <structname>struct spi_transfer</structname>
+	objects, each of which wraps a full duplex SPI transfer.
+	A variety of protocol tweaking options are needed, because
+	different chips adopt very different policies for how they
+	use the bits tranferred with SPI.
+  </para>
+!Iinclude/linux/spi/spi.h
+!Fdrivers/spi/spi.c spi_register_board_info
+!Edrivers/spi/spi.c
+  </chapter>
+
 </book>
diff -puN Documentation/spi/spi-summary~spi-kerneldoc Documentation/spi/spi-summary
--- a/Documentation/spi/spi-summary~spi-kerneldoc
+++ a/Documentation/spi/spi-summary
@@ -8,7 +8,7 @@ What is SPI?
 The "Serial Peripheral Interface" (SPI) is a synchronous four wire serial
 link used to connect microcontrollers to sensors, memory, and peripherals.
 
-The three signal wires hold a clock (SCLK, often on the order of 10 MHz),
+The three signal wires hold a clock (SCK, often on the order of 10 MHz),
 and parallel data lines with "Master Out, Slave In" (MOSI) or "Master In,
 Slave Out" (MISO) signals.  (Other names are also used.)  There are four
 clocking modes through which data is exchanged; mode-0 and mode-3 are most
@@ -22,7 +22,7 @@ other signals, often including an interr
 
 Unlike serial busses like USB or SMBUS, even low level protocols for
 SPI slave functions are usually not interoperable between vendors
-(except for cases like SPI memory chips).
+(except for commodities like SPI memory chips).
 
   - SPI may be used for request/response style device protocols, as with
     touchscreen sensors and memory chips.
@@ -77,8 +77,9 @@ cards without needing a special purpose 
 How do these driver programming interfaces work?
 ------------------------------------------------
 The <linux/spi/spi.h> header file includes kerneldoc, as does the
-main source code, and you should certainly read that.  This is just
-an overview, so you get the big picture before the details.
+main source code, and you should certainly read that chapter of the
+kernel API document.  This is just an overview, so you get the big
+picture before those details.
 
 SPI requests always go into I/O queues.  Requests for a given SPI device
 are always executed in FIFO order, and complete asynchronously through
@@ -88,7 +89,7 @@ a command and then reading its response.
 
 There are two types of SPI driver, here called:
 
-  Controller drivers ... these are often built in to System-On-Chip
+  Controller drivers ... controllers may be built in to System-On-Chip
 	processors, and often support both Master and Slave roles.
 	These drivers touch hardware registers and may use DMA.
 	Or they can be PIO bitbangers, needing just GPIO pins.
@@ -108,18 +109,18 @@ those two types of driver.  At this writ
 programming interface.
 
 There is a minimal core of SPI programming interfaces, focussing on
-using driver model to connect controller and protocol drivers using
+using the driver model to connect controller and protocol drivers using
 device tables provided by board specific initialization code.  SPI
 shows up in sysfs in several locations:
 
-   /sys/devices/.../CTLR/spiB.C ... spi_device for on bus "B",
+   /sys/devices/.../CTLR/spiB.C ... spi_device on bus "B",
 	chipselect C, accessed through CTLR.
 
    /sys/devices/.../CTLR/spiB.C/modalias ... identifies the driver
 	that should be used with this device (for hotplug/coldplug)
 
    /sys/bus/spi/devices/spiB.C ... symlink to the physical
-   	spiB-C device
+   	spiB.C device
 
    /sys/bus/spi/drivers/D ... driver for one or more spi*.* devices
 
@@ -240,7 +241,7 @@ The board_info should provide enough inf
 without the chip's driver being loaded.  The most troublesome aspect of
 that is likely the SPI_CS_HIGH bit in the spi_device.mode field, since
 sharing a bus with a device that interprets chipselect "backwards" is
-not possible.
+not possible until the infrastructure knows how to deselect it.
 
 Then your board initialization code would register that table with the SPI
 infrastructure, so that it's available later when the SPI master controller
@@ -268,16 +269,14 @@ board info based on the board that was h
 call at least spi_unregister_device() when that board is removed.
 
 When Linux includes support for MMC/SD/SDIO/DataFlash cards through SPI, those
-configurations will also be dynamic.  Fortunately, those devices all support
-basic device identification probes, so that support should hotplug normally.
+configurations will also be dynamic.  Fortunately, such devices all support
+basic device identification probes, so they should hotplug normally.
 
 
 How do I write an "SPI Protocol Driver"?
 ----------------------------------------
-All SPI drivers are currently kernel drivers.  A userspace driver API
-would just be another kernel driver, probably offering some lowlevel
-access through aio_read(), aio_write(), and ioctl() calls and using the
-standard userspace sysfs mechanisms to bind to a given SPI device.
+Most SPI drivers are currently kernel drivers, but there's also support
+for userspace drivers.  Here we talk only about kernel drivers.
 
 SPI protocol drivers somewhat resemble platform device drivers:
 
@@ -319,7 +318,8 @@ might look like this unless you're creat
 
 As soon as it enters probe(), the driver may issue I/O requests to
 the SPI device using "struct spi_message".  When remove() returns,
-the driver guarantees that it won't submit any more such messages.
+or after probe() fails, the driver guarantees that it won't submit
+any more such messages.
 
   - An spi_message is a sequence of protocol operations, executed
     as one atomic sequence.  SPI driver controls include:
@@ -368,7 +368,8 @@ the driver guarantees that it won't subm
 Some drivers may need to modify spi_device characteristics like the
 transfer mode, wordsize, or clock rate.  This is done with spi_setup(),
 which would normally be called from probe() before the first I/O is
-done to the device.
+done to the device.  However, that can also be called at any time
+that no message is pending for that device.
 
 While "spi_device" would be the bottom boundary of the driver, the
 upper boundaries might include sysfs (especially for sensor readings),
@@ -445,11 +446,15 @@ SPI MASTER METHODS
 	This sets up the device clock rate, SPI mode, and word sizes.
 	Drivers may change the defaults provided by board_info, and then
 	call spi_setup(spi) to invoke this routine.  It may sleep.
+	Unless each SPI slave has its own configuration registers, don't
+	change them right away ... otherwise drivers could corrupt I/O
+	that's in progress for other SPI devices.
 
     master->transfer(struct spi_device *spi, struct spi_message *message)
     	This must not sleep.  Its responsibility is arrange that the
-	transfer happens and its complete() callback is issued; the two
-	will normally happen later, after other transfers complete.
+	transfer happens and its complete() callback is issued.  The two
+	will normally happen later, after other transfers complete, and
+	if the controller is idle it will need to be kickstarted.
 
     master->cleanup(struct spi_device *spi)
 	Your controller driver may use spi_device.controller_state to hold
diff -puN drivers/spi/spi.c~spi-kerneldoc drivers/spi/spi.c
--- a/drivers/spi/spi.c~spi-kerneldoc
+++ a/drivers/spi/spi.c
@@ -183,7 +183,12 @@ static LIST_HEAD(board_list);
 static DECLARE_MUTEX(board_lock);
 
 
-/* On typical mainboards, this is purely internal; and it's not needed
+/**
+ * spi_new_device - instantiate one new SPI device
+ * @master: Controller to which device is connected
+ * @chip: Describes the SPI device
+ *
+ * On typical mainboards, this is purely internal; and it's not needed
  * after board init creates the hard-wired devices.  Some development
  * platforms may not be able to use spi_register_board_info though, and
  * this is exported so that for example a USB or parport based adapter
@@ -251,7 +256,11 @@ fail:
 }
 EXPORT_SYMBOL_GPL(spi_new_device);
 
-/*
+/**
+ * spi_register_board_info - register SPI devices for a given board
+ * @info: array of chip descriptors
+ * @n: how many descriptors are provided
+ *
  * Board-specific early init code calls this (probably during arch_initcall)
  * with segments of the SPI device table.  Any device nodes are created later,
  * after the relevant parent SPI controller (bus_num) is defined.  We keep
@@ -337,9 +346,10 @@ static struct class spi_master_class = {
 /**
  * spi_alloc_master - allocate SPI master controller
  * @dev: the controller, possibly using the platform_bus
- * @size: how much driver-private data to preallocate; the pointer to this
+ * @size: how much zeroed driver-private data to allocate; the pointer to this
  *	memory is in the class_data field of the returned class_device,
  *	accessible with spi_master_get_devdata().
+ * Context: can sleep
  *
  * This call is used only by SPI master controller drivers, which are the
  * only ones directly touching chip registers.  It's how they allocate
@@ -375,6 +385,7 @@ EXPORT_SYMBOL_GPL(spi_alloc_master);
 /**
  * spi_register_master - register SPI master controller
  * @master: initialized master, originally from spi_alloc_master()
+ * Context: can sleep
  *
  * SPI master controllers connect to their drivers using some non-SPI bus,
  * such as the platform bus.  The final stage of probe() in that code
@@ -437,6 +448,7 @@ static int __unregister(struct device *d
 /**
  * spi_unregister_master - unregister SPI master controller
  * @master: the master being unregistered
+ * Context: can sleep
  *
  * This call is used only by SPI master controller drivers, which are the
  * only ones directly touching chip registers.
@@ -455,6 +467,7 @@ EXPORT_SYMBOL_GPL(spi_unregister_master)
 /**
  * spi_busnum_to_master - look up master associated with bus_num
  * @bus_num: the master's bus number
+ * Context: can sleep
  *
  * This call may be used with devices that are registered after
  * arch init time.  It returns a refcounted pointer to the relevant
@@ -492,6 +505,7 @@ static void spi_complete(void *arg)
  * spi_sync - blocking/synchronous SPI data transfers
  * @spi: device with which data will be exchanged
  * @message: describes the data transfers
+ * Context: can sleep
  *
  * This call may only be used from a context that may sleep.  The sleep
  * is non-interruptible, and has no timeout.  Low-overhead controller
@@ -508,7 +522,7 @@ static void spi_complete(void *arg)
  *
  * The return value is a negative error code if the message could not be
  * submitted, else zero.  When the value is zero, then message->status is
- * also defined:  it's the completion code for the transfer, either zero
+ * also defined;  it's the completion code for the transfer, either zero
  * or a negative error code from the controller driver.
  */
 int spi_sync(struct spi_device *spi, struct spi_message *message)
@@ -538,6 +552,7 @@ static u8	*buf;
  * @n_tx: size of txbuf, in bytes
  * @rxbuf: buffer into which data will be read
  * @n_rx: size of rxbuf, in bytes (need not be dma-safe)
+ * Context: can sleep
  *
  * This performs a half duplex MicroWire style transaction with the
  * device, sending txbuf and then reading rxbuf.  The return value
@@ -545,7 +560,8 @@ static u8	*buf;
  * This call may only be used from a context that may sleep.
  *
  * Parameters to this routine are always copied using a small buffer;
- * performance-sensitive or bulk transfer code should instead use
+ * portable code should never use this for more than 32 bytes.
+ * Performance-sensitive or bulk transfer code should instead use
  * spi_{async,sync}() calls with dma-safe buffers.
  */
 int spi_write_then_read(struct spi_device *spi,
diff -puN include/linux/spi/spi.h~spi-kerneldoc include/linux/spi/spi.h
--- a/include/linux/spi/spi.h~spi-kerneldoc
+++ a/include/linux/spi/spi.h
@@ -32,11 +32,12 @@ extern struct bus_type spi_bus_type;
  * @max_speed_hz: Maximum clock rate to be used with this chip
  *	(on this board); may be changed by the device's driver.
  *	The spi_transfer.speed_hz can override this for each transfer.
- * @chip-select: Chipselect, distinguishing chips handled by "master".
+ * @chip_select: Chipselect, distinguishing chips handled by @master.
  * @mode: The spi mode defines how data is clocked out and in.
  *	This may be changed by the device's driver.
- *	The "active low" default for chipselect mode can be overridden,
- *	as can the "MSB first" default for each word in a transfer.
+ *	The "active low" default for chipselect mode can be overridden
+ *	(by specifying SPI_CS_HIGH) as can the "MSB first" default for
+ *	each word in a transfer (by specifying SPI_LSB_FIRST).
  * @bits_per_word: Data transfers involve one or more words; word sizes
  *	like eight or 12 bits are common.  In-memory wordsizes are
  *	powers of two bytes (e.g. 20 bit samples use 32 bits).
@@ -48,14 +49,18 @@ extern struct bus_type spi_bus_type;
  * @controller_state: Controller's runtime state
  * @controller_data: Board-specific definitions for controller, such as
  *	FIFO initialization parameters; from board_info.controller_data
+ * @modalias: Name of the driver to use with this device, or an alias
+ *	for that name.  This appears in the sysfs "modalias" attribute
+ *	for driver coldplugging, and in uevents used for hotplugging
  *
- * An spi_device is used to interchange data between an SPI slave
+ * A @spi_device is used to interchange data between an SPI slave
  * (usually a discrete chip) and CPU memory.
  *
- * In "dev", the platform_data is used to hold information about this
+ * In @dev, the platform_data is used to hold information about this
  * device that's meaningful to the device's protocol driver, but not
  * to its controller.  One example might be an identifier for a chip
- * variant with slightly different functionality.
+ * variant with slightly different functionality; another might be
+ * information about how this particular board wires the chip's pins.
  */
 struct spi_device {
 	struct device		dev;
@@ -77,6 +82,7 @@ struct spi_device {
 	void			*controller_data;
 	const char		*modalias;
 
+	/*
 	// likely need more hooks for more protocol options affecting how
 	// the controller talks to each chip, like:
 	//  - memory packing (12 bit samples into low bits, others zeroed)
@@ -84,6 +90,7 @@ struct spi_device {
 	//  - drop chipselect after each word
 	//  - chipselect delays
 	//  - ...
+	*/
 };
 
 static inline struct spi_device *to_spi_device(struct device *dev)
@@ -165,18 +172,20 @@ static inline void spi_unregister_driver
  * @setup: updates the device mode and clocking records used by a
  *	device's SPI controller; protocol code may call this.  This
  *	must fail if an unrecognized or unsupported mode is requested.
+ *	It's always safe to call this unless transfers are pending on
+ *	the device whose settings are being modified.
  * @transfer: adds a message to the controller's transfer queue.
  * @cleanup: frees controller-specific state
  *
- * Each SPI master controller can communicate with one or more spi_device
+ * Each SPI master controller can communicate with one or more @spi_device
  * children.  These make a small bus, sharing MOSI, MISO and SCK signals
  * but not chip select signals.  Each device may be configured to use a
  * different clock rate, since those shared signals are ignored unless
  * the chip is selected.
  *
  * The driver for an SPI controller manages access to those devices through
- * a queue of spi_message transactions, copyin data between CPU memory and
- * an SPI slave device).  For each such message it queues, it calls the
+ * a queue of spi_message transactions, copying data between CPU memory and
+ * an SPI slave device.  For each such message it queues, it calls the
  * message's completion function when the transaction completes.
  */
 struct spi_master {
@@ -280,27 +289,27 @@ extern struct spi_master *spi_busnum_to_
  * struct spi_transfer - a read/write buffer pair
  * @tx_buf: data to be written (dma-safe memory), or NULL
  * @rx_buf: data to be read (dma-safe memory), or NULL
- * @tx_dma: DMA address of tx_buf, if spi_message.is_dma_mapped
- * @rx_dma: DMA address of rx_buf, if spi_message.is_dma_mapped
+ * @tx_dma: DMA address of tx_buf, if @spi_message.is_dma_mapped
+ * @rx_dma: DMA address of rx_buf, if @spi_message.is_dma_mapped
  * @len: size of rx and tx buffers (in bytes)
  * @speed_hz: Select a speed other then the device default for this
- *      transfer. If 0 the default (from spi_device) is used.
+ *      transfer. If 0 the default (from @spi_device) is used.
  * @bits_per_word: select a bits_per_word other then the device default
- *      for this transfer. If 0 the default (from spi_device) is used.
+ *      for this transfer. If 0 the default (from @spi_device) is used.
  * @cs_change: affects chipselect after this transfer completes
  * @delay_usecs: microseconds to delay after this transfer before
  *	(optionally) changing the chipselect status, then starting
- *	the next transfer or completing this spi_message.
- * @transfer_list: transfers are sequenced through spi_message.transfers
+ *	the next transfer or completing this @spi_message.
+ * @transfer_list: transfers are sequenced through @spi_message.transfers
  *
  * SPI transfers always write the same number of bytes as they read.
- * Protocol drivers should always provide rx_buf and/or tx_buf.
+ * Protocol drivers should always provide @rx_buf and/or @tx_buf.
  * In some cases, they may also want to provide DMA addresses for
  * the data being transferred; that may reduce overhead, when the
  * underlying driver uses dma.
  *
  * If the transmit buffer is null, zeroes will be shifted out
- * while filling rx_buf.  If the receive buffer is null, the data
+ * while filling @rx_buf.  If the receive buffer is null, the data
  * shifted in will be discarded.  Only "len" bytes shift out (or in).
  * It's an error to try to shift out a partial word.  (For example, by
  * shifting out three bytes with word size of sixteen or twenty bits;
@@ -309,7 +318,7 @@ extern struct spi_master *spi_busnum_to_
  * In-memory data values are always in native CPU byte order, translated
  * from the wire byte order (big-endian except with SPI_LSB_FIRST).  So
  * for example when bits_per_word is sixteen, buffers are 2N bytes long
- * and hold N sixteen bit words in CPU byte order.
+ * (@len = 2N) and hold N sixteen bit words in CPU byte order.
  *
  * When the word size of the SPI transfer is not a power-of-two multiple
  * of eight bits, those in-memory words include extra bits.  In-memory
@@ -318,7 +327,7 @@ extern struct spi_master *spi_busnum_to_
  *
  * All SPI transfers start with the relevant chipselect active.  Normally
  * it stays selected until after the last transfer in a message.  Drivers
- * can affect the chipselect signal using cs_change:
+ * can affect the chipselect signal using cs_change.
  *
  * (i) If the transfer isn't the last one in the message, this flag is
  * used to make the chipselect briefly go inactive in the middle of the
@@ -372,7 +381,7 @@ struct spi_transfer {
  * @queue: for use by whichever driver currently owns the message
  * @state: for use by whichever driver currently owns the message
  *
- * An spi_message is used to execute an atomic sequence of data transfers,
+ * A @spi_message is used to execute an atomic sequence of data transfers,
  * each represented by a struct spi_transfer.  The sequence is "atomic"
  * in the sense that no other spi_message may use that SPI bus until that
  * sequence completes.  On some systems, many such sequences can execute as
@@ -464,8 +473,9 @@ static inline void spi_message_free(stru
 }
 
 /**
- * spi_setup -- setup SPI mode and clock rate
+ * spi_setup - setup SPI mode and clock rate
  * @spi: the device whose settings are being modified
+ * Context: can sleep
  *
  * SPI protocol drivers may need to update the transfer mode if the
  * device doesn't work with the mode 0 default.  They may likewise need
@@ -474,7 +484,7 @@ static inline void spi_message_free(stru
  * The changes take effect the next time the device is selected and data
  * is transferred to or from it.
  *
- * Note that this call wil fail if the protocol driver specifies an option
+ * Note that this call will fail if the protocol driver specifies an option
  * that the underlying controller or its driver does not support.  For
  * example, not all hardware supports wire transfers using nine bit words,
  * LSB-first wire encoding, or active-high chipselects.
@@ -487,9 +497,10 @@ spi_setup(struct spi_device *spi)
 
 
 /**
- * spi_async -- asynchronous SPI transfer
+ * spi_async - asynchronous SPI transfer
  * @spi: device with which data will be exchanged
  * @message: describes the data transfers, including completion callback
+ * Context: any (irqs may be blocked, etc)
  *
  * This call may be used in_irq and other contexts which can't sleep,
  * as well as from task contexts which can sleep.
@@ -535,6 +546,7 @@ extern int spi_sync(struct spi_device *s
  * @spi: device to which data will be written
  * @buf: data buffer
  * @len: data buffer size
+ * Context: can sleep
  *
  * This writes the buffer and returns zero or a negative error code.
  * Callable only from contexts that can sleep.
@@ -558,8 +570,9 @@ spi_write(struct spi_device *spi, const 
  * @spi: device from which data will be read
  * @buf: data buffer
  * @len: data buffer size
+ * Context: can sleep
  *
- * This writes the buffer and returns zero or a negative error code.
+ * This reads the buffer and returns zero or a negative error code.
  * Callable only from contexts that can sleep.
  */
 static inline int
@@ -585,6 +598,7 @@ extern int spi_write_then_read(struct sp
  * spi_w8r8 - SPI synchronous 8 bit write followed by 8 bit read
  * @spi: device with which data will be exchanged
  * @cmd: command to be written before data is read back
+ * Context: can sleep
  *
  * This returns the (unsigned) eight bit number returned by the
  * device, or else a negative error code.  Callable only from
@@ -605,6 +619,7 @@ static inline ssize_t spi_w8r8(struct sp
  * spi_w8r16 - SPI synchronous 8 bit write followed by 16 bit read
  * @spi: device with which data will be exchanged
  * @cmd: command to be written before data is read back
+ * Context: can sleep
  *
  * This returns the (unsigned) sixteen bit number returned by the
  * device, or else a negative error code.  Callable only from
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
rework-pm_ops-pm_disk_mode-kill-misuse.patch
power-management-remove-firmware-disk-mode.patch
power-management-implement-pm_opsvalid-for-everybody.patch
pm-include-eio-from-errno-baseh.patch
acpi-driver-model-flags-and-platform_enable_wake.patch
update-documentation-driver-model-platformtxt.patch
at91_cf-minor-fix.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
kconfig-mentioneds-hibernation-not-just-swsusp.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
init-dma-masks-in-pnp_dev.patch
rtc-add-rtc-rs5c313-driver.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900-update.patch
char-cs5535_gpio-add-module_device_table.patch
parport-dev-driver-model-support.patch
layered-parport-code-uses-parport-dev.patch
pnpacpi-sets-pnpdev-devarchdata.patch
fix-hotplug-for-legacy-platform-drivers.patch
minor-spi_butterfly-cleanup.patch
spi-kerneldoc.patch
rtc-remove-sys-class-rtc-dev.patch
rtc-rtc-interfaces-dont-use-class_device.patch
rtc-simplified-rtc-sysfs-attribute-handling.patch
rtc-simplified-proc-driver-rtc-handling.patch
rtc-remove-rest-of-class_device.patch
rtc-suspend-resume-restores-system-clock.patch
rtc-simplified-rtc-sysfs-attribute-handling-tidy.patch
rtc-update-to-class-device-removal-patches.patch
rtc-kconfig-cleanup.patch
rtc-cmos-wakeup-interface.patch
acpi-wakeup-hooks-for-rtc-cmos.patch
workaround-rtc-related-acpi-table-bugs.patch
revert-rtc-add-rtc_merge_alarm.patch
remove-rtc_alm_set-mode-bugs.patch

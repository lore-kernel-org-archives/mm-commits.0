From: akpm@linux-foundation.org
Subject: - powerpc-xilinx-hwicap-cleanup.patch removed from -mm tree
Date: Mon, 03 Mar 2008 13:02:38 -0800
Message-ID: <200803032102.m23L2cVp006261@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753290AbYCCVCr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 16:02:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stephen.neuendorffer@xilinx.com, benh@kernel.crashing.org, grant.likely@secretlab.ca, jirislaby@gmail.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     powerpc: xilinx: hwicap: cleanup
has been removed from the -mm tree.  Its filename was
     powerpc-xilinx-hwicap-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: xilinx: hwicap: cleanup
From: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>

Fix some missing __user tags and incorrect section tags.
Convert semaphores to mutexes.
Make probed_devices re-entrancy and error condition safe.
Fix some backwards memcpys.
Some other minor cleanups.
Use kerneldoc format.

Signed-off-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/xilinx_hwicap/buffer_icap.c   |   80 +++++------
 drivers/char/xilinx_hwicap/fifo_icap.c     |   60 ++++----
 drivers/char/xilinx_hwicap/xilinx_hwicap.c |  138 ++++++++-----------
 drivers/char/xilinx_hwicap/xilinx_hwicap.h |   24 +--
 4 files changed, 144 insertions(+), 158 deletions(-)

diff -puN drivers/char/xilinx_hwicap/buffer_icap.c~powerpc-xilinx-hwicap-cleanup drivers/char/xilinx_hwicap/buffer_icap.c
--- a/drivers/char/xilinx_hwicap/buffer_icap.c~powerpc-xilinx-hwicap-cleanup
+++ a/drivers/char/xilinx_hwicap/buffer_icap.c
@@ -73,8 +73,8 @@
 #define XHI_BUFFER_START 0
 
 /**
- * buffer_icap_get_status: Get the contents of the status register.
- * @parameter base_address: is the base address of the device
+ * buffer_icap_get_status - Get the contents of the status register.
+ * @base_address: is the base address of the device
  *
  * The status register contains the ICAP status and the done bit.
  *
@@ -94,9 +94,9 @@ static inline u32 buffer_icap_get_status
 }
 
 /**
- * buffer_icap_get_bram: Reads data from the storage buffer bram.
- * @parameter base_address: contains the base address of the component.
- * @parameter offset: The word offset from which the data should be read.
+ * buffer_icap_get_bram - Reads data from the storage buffer bram.
+ * @base_address: contains the base address of the component.
+ * @offset: The word offset from which the data should be read.
  *
  * A bram is used as a configuration memory cache.  One frame of data can
  * be stored in this "storage buffer".
@@ -108,8 +108,8 @@ static inline u32 buffer_icap_get_bram(v
 }
 
 /**
- * buffer_icap_busy: Return true if the icap device is busy
- * @parameter base_address: is the base address of the device
+ * buffer_icap_busy - Return true if the icap device is busy
+ * @base_address: is the base address of the device
  *
  * The queries the low order bit of the status register, which
  * indicates whether the current configuration or readback operation
@@ -121,8 +121,8 @@ static inline bool buffer_icap_busy(void
 }
 
 /**
- * buffer_icap_busy: Return true if the icap device is not busy
- * @parameter base_address: is the base address of the device
+ * buffer_icap_busy - Return true if the icap device is not busy
+ * @base_address: is the base address of the device
  *
  * The queries the low order bit of the status register, which
  * indicates whether the current configuration or readback operation
@@ -134,9 +134,9 @@ static inline bool buffer_icap_done(void
 }
 
 /**
- * buffer_icap_set_size: Set the size register.
- * @parameter base_address: is the base address of the device
- * @parameter data: The size in bytes.
+ * buffer_icap_set_size - Set the size register.
+ * @base_address: is the base address of the device
+ * @data: The size in bytes.
  *
  * The size register holds the number of 8 bit bytes to transfer between
  * bram and the icap (or icap to bram).
@@ -148,9 +148,9 @@ static inline void buffer_icap_set_size(
 }
 
 /**
- * buffer_icap_mSetoffsetReg: Set the bram offset register.
- * @parameter base_address: contains the base address of the device.
- * @parameter data: is the value to be written to the data register.
+ * buffer_icap_set_offset - Set the bram offset register.
+ * @base_address: contains the base address of the device.
+ * @data: is the value to be written to the data register.
  *
  * The bram offset register holds the starting bram address to transfer
  * data from during configuration or write data to during readback.
@@ -162,9 +162,9 @@ static inline void buffer_icap_set_offse
 }
 
 /**
- * buffer_icap_set_rnc: Set the RNC (Readback not Configure) register.
- * @parameter base_address: contains the base address of the device.
- * @parameter data: is the value to be written to the data register.
+ * buffer_icap_set_rnc - Set the RNC (Readback not Configure) register.
+ * @base_address: contains the base address of the device.
+ * @data: is the value to be written to the data register.
  *
  * The RNC register determines the direction of the data transfer.  It
  * controls whether a configuration or readback take place.  Writing to
@@ -178,10 +178,10 @@ static inline void buffer_icap_set_rnc(v
 }
 
 /**
- * buffer_icap_set_bram: Write data to the storage buffer bram.
- * @parameter base_address: contains the base address of the component.
- * @parameter offset: The word offset at which the data should be written.
- * @parameter data: The value to be written to the bram offset.
+ * buffer_icap_set_bram - Write data to the storage buffer bram.
+ * @base_address: contains the base address of the component.
+ * @offset: The word offset at which the data should be written.
+ * @data: The value to be written to the bram offset.
  *
  * A bram is used as a configuration memory cache.  One frame of data can
  * be stored in this "storage buffer".
@@ -193,10 +193,10 @@ static inline void buffer_icap_set_bram(
 }
 
 /**
- * buffer_icap_device_read: Transfer bytes from ICAP to the storage buffer.
- * @parameter drvdata: a pointer to the drvdata.
- * @parameter offset: The storage buffer start address.
- * @parameter count: The number of words (32 bit) to read from the
+ * buffer_icap_device_read - Transfer bytes from ICAP to the storage buffer.
+ * @drvdata: a pointer to the drvdata.
+ * @offset: The storage buffer start address.
+ * @count: The number of words (32 bit) to read from the
  *           device (ICAP).
  **/
 static int buffer_icap_device_read(struct hwicap_drvdata *drvdata,
@@ -227,10 +227,10 @@ static int buffer_icap_device_read(struc
 };
 
 /**
- * buffer_icap_device_write: Transfer bytes from ICAP to the storage buffer.
- * @parameter drvdata: a pointer to the drvdata.
- * @parameter offset: The storage buffer start address.
- * @parameter count: The number of words (32 bit) to read from the
+ * buffer_icap_device_write - Transfer bytes from ICAP to the storage buffer.
+ * @drvdata: a pointer to the drvdata.
+ * @offset: The storage buffer start address.
+ * @count: The number of words (32 bit) to read from the
  *           device (ICAP).
  **/
 static int buffer_icap_device_write(struct hwicap_drvdata *drvdata,
@@ -261,8 +261,8 @@ static int buffer_icap_device_write(stru
 };
 
 /**
- * buffer_icap_reset: Reset the logic of the icap device.
- * @parameter drvdata: a pointer to the drvdata.
+ * buffer_icap_reset - Reset the logic of the icap device.
+ * @drvdata: a pointer to the drvdata.
  *
  * Writing to the status register resets the ICAP logic in an internal
  * version of the core.  For the version of the core published in EDK,
@@ -274,10 +274,10 @@ void buffer_icap_reset(struct hwicap_drv
 }
 
 /**
- * buffer_icap_set_configuration: Load a partial bitstream from system memory.
- * @parameter drvdata: a pointer to the drvdata.
- * @parameter data: Kernel address of the partial bitstream.
- * @parameter size: the size of the partial bitstream in 32 bit words.
+ * buffer_icap_set_configuration - Load a partial bitstream from system memory.
+ * @drvdata: a pointer to the drvdata.
+ * @data: Kernel address of the partial bitstream.
+ * @size: the size of the partial bitstream in 32 bit words.
  **/
 int buffer_icap_set_configuration(struct hwicap_drvdata *drvdata, u32 *data,
 			     u32 size)
@@ -333,10 +333,10 @@ int buffer_icap_set_configuration(struct
 };
 
 /**
- * buffer_icap_get_configuration: Read configuration data from the device.
- * @parameter drvdata: a pointer to the drvdata.
- * @parameter data: Address of the data representing the partial bitstream
- * @parameter size: the size of the partial bitstream in 32 bit words.
+ * buffer_icap_get_configuration - Read configuration data from the device.
+ * @drvdata: a pointer to the drvdata.
+ * @data: Address of the data representing the partial bitstream
+ * @size: the size of the partial bitstream in 32 bit words.
  **/
 int buffer_icap_get_configuration(struct hwicap_drvdata *drvdata, u32 *data,
 			     u32 size)
diff -puN drivers/char/xilinx_hwicap/fifo_icap.c~powerpc-xilinx-hwicap-cleanup drivers/char/xilinx_hwicap/fifo_icap.c
--- a/drivers/char/xilinx_hwicap/fifo_icap.c~powerpc-xilinx-hwicap-cleanup
+++ a/drivers/char/xilinx_hwicap/fifo_icap.c
@@ -94,9 +94,9 @@
 
 
 /**
- * fifo_icap_fifo_write: Write data to the write FIFO.
- * @parameter drvdata: a pointer to the drvdata.
- * @parameter data: the 32-bit value to be written to the FIFO.
+ * fifo_icap_fifo_write - Write data to the write FIFO.
+ * @drvdata: a pointer to the drvdata.
+ * @data: the 32-bit value to be written to the FIFO.
  *
  * This function will silently fail if the fifo is full.
  **/
@@ -108,8 +108,8 @@ static inline void fifo_icap_fifo_write(
 }
 
 /**
- * fifo_icap_fifo_read: Read data from the Read FIFO.
- * @parameter drvdata: a pointer to the drvdata.
+ * fifo_icap_fifo_read - Read data from the Read FIFO.
+ * @drvdata: a pointer to the drvdata.
  *
  * This function will silently fail if the fifo is empty.
  **/
@@ -121,9 +121,9 @@ static inline u32 fifo_icap_fifo_read(st
 }
 
 /**
- * fifo_icap_set_read_size: Set the the size register.
- * @parameter drvdata: a pointer to the drvdata.
- * @parameter data: the size of the following read transaction, in words.
+ * fifo_icap_set_read_size - Set the the size register.
+ * @drvdata: a pointer to the drvdata.
+ * @data: the size of the following read transaction, in words.
  **/
 static inline void fifo_icap_set_read_size(struct hwicap_drvdata *drvdata,
 		u32 data)
@@ -132,8 +132,8 @@ static inline void fifo_icap_set_read_si
 }
 
 /**
- * fifo_icap_start_config: Initiate a configuration (write) to the device.
- * @parameter drvdata: a pointer to the drvdata.
+ * fifo_icap_start_config - Initiate a configuration (write) to the device.
+ * @drvdata: a pointer to the drvdata.
  **/
 static inline void fifo_icap_start_config(struct hwicap_drvdata *drvdata)
 {
@@ -142,8 +142,8 @@ static inline void fifo_icap_start_confi
 }
 
 /**
- * fifo_icap_start_readback: Initiate a readback from the device.
- * @parameter drvdata: a pointer to the drvdata.
+ * fifo_icap_start_readback - Initiate a readback from the device.
+ * @drvdata: a pointer to the drvdata.
  **/
 static inline void fifo_icap_start_readback(struct hwicap_drvdata *drvdata)
 {
@@ -152,8 +152,8 @@ static inline void fifo_icap_start_readb
 }
 
 /**
- * fifo_icap_busy: Return true if the ICAP is still processing a transaction.
- * @parameter drvdata: a pointer to the drvdata.
+ * fifo_icap_busy - Return true if the ICAP is still processing a transaction.
+ * @drvdata: a pointer to the drvdata.
  **/
 static inline u32 fifo_icap_busy(struct hwicap_drvdata *drvdata)
 {
@@ -163,8 +163,8 @@ static inline u32 fifo_icap_busy(struct 
 }
 
 /**
- * fifo_icap_write_fifo_vacancy: Query the write fifo available space.
- * @parameter drvdata: a pointer to the drvdata.
+ * fifo_icap_write_fifo_vacancy - Query the write fifo available space.
+ * @drvdata: a pointer to the drvdata.
  *
  * Return the number of words that can be safely pushed into the write fifo.
  **/
@@ -175,8 +175,8 @@ static inline u32 fifo_icap_write_fifo_v
 }
 
 /**
- * fifo_icap_read_fifo_occupancy: Query the read fifo available data.
- * @parameter drvdata: a pointer to the drvdata.
+ * fifo_icap_read_fifo_occupancy - Query the read fifo available data.
+ * @drvdata: a pointer to the drvdata.
  *
  * Return the number of words that can be safely read from the read fifo.
  **/
@@ -187,11 +187,11 @@ static inline u32 fifo_icap_read_fifo_oc
 }
 
 /**
- * fifo_icap_set_configuration: Send configuration data to the ICAP.
- * @parameter drvdata: a pointer to the drvdata.
- * @parameter frame_buffer: a pointer to the data to be written to the
+ * fifo_icap_set_configuration - Send configuration data to the ICAP.
+ * @drvdata: a pointer to the drvdata.
+ * @frame_buffer: a pointer to the data to be written to the
  *		ICAP device.
- * @parameter num_words: the number of words (32 bit) to write to the ICAP
+ * @num_words: the number of words (32 bit) to write to the ICAP
  *		device.
 
  * This function writes the given user data to the Write FIFO in
@@ -266,10 +266,10 @@ int fifo_icap_set_configuration(struct h
 }
 
 /**
- * fifo_icap_get_configuration: Read configuration data from the device.
- * @parameter drvdata: a pointer to the drvdata.
- * @parameter data: Address of the data representing the partial bitstream
- * @parameter size: the size of the partial bitstream in 32 bit words.
+ * fifo_icap_get_configuration - Read configuration data from the device.
+ * @drvdata: a pointer to the drvdata.
+ * @data: Address of the data representing the partial bitstream
+ * @size: the size of the partial bitstream in 32 bit words.
  *
  * This function reads the specified number of words from the ICAP device in
  * the polled mode.
@@ -335,8 +335,8 @@ int fifo_icap_get_configuration(struct h
 }
 
 /**
- * buffer_icap_reset: Reset the logic of the icap device.
- * @parameter drvdata: a pointer to the drvdata.
+ * buffer_icap_reset - Reset the logic of the icap device.
+ * @drvdata: a pointer to the drvdata.
  *
  * This function forces the software reset of the complete HWICAP device.
  * All the registers will return to the default value and the FIFO is also
@@ -360,8 +360,8 @@ void fifo_icap_reset(struct hwicap_drvda
 }
 
 /**
- * fifo_icap_flush_fifo: This function flushes the FIFOs in the device.
- * @parameter drvdata: a pointer to the drvdata.
+ * fifo_icap_flush_fifo - This function flushes the FIFOs in the device.
+ * @drvdata: a pointer to the drvdata.
  */
 void fifo_icap_flush_fifo(struct hwicap_drvdata *drvdata)
 {
diff -puN drivers/char/xilinx_hwicap/xilinx_hwicap.c~powerpc-xilinx-hwicap-cleanup drivers/char/xilinx_hwicap/xilinx_hwicap.c
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.c~powerpc-xilinx-hwicap-cleanup
+++ a/drivers/char/xilinx_hwicap/xilinx_hwicap.c
@@ -84,7 +84,7 @@
 #include <linux/init.h>
 #include <linux/poll.h>
 #include <linux/proc_fs.h>
-#include <asm/semaphore.h>
+#include <linux/mutex.h>
 #include <linux/sysctl.h>
 #include <linux/version.h>
 #include <linux/fs.h>
@@ -119,6 +119,7 @@ module_param(xhwicap_minor, int, S_IRUGO
 
 /* An array, which is set to true when the device is registered. */
 static bool probed_devices[HWICAP_DEVICES];
+static struct mutex icap_sem;
 
 static struct class *icap_class;
 
@@ -199,14 +200,14 @@ static const struct config_registers v5_
 };
 
 /**
- * hwicap_command_desync: Send a DESYNC command to the ICAP port.
- * @parameter drvdata: a pointer to the drvdata.
+ * hwicap_command_desync - Send a DESYNC command to the ICAP port.
+ * @drvdata: a pointer to the drvdata.
  *
  * This command desynchronizes the ICAP After this command, a
  * bitstream containing a NULL packet, followed by a SYNCH packet is
  * required before the ICAP will recognize commands.
  */
-int hwicap_command_desync(struct hwicap_drvdata *drvdata)
+static int hwicap_command_desync(struct hwicap_drvdata *drvdata)
 {
 	u32 buffer[4];
 	u32 index = 0;
@@ -228,51 +229,18 @@ int hwicap_command_desync(struct hwicap_
 }
 
 /**
- * hwicap_command_capture: Send a CAPTURE command to the ICAP port.
- * @parameter drvdata: a pointer to the drvdata.
- *
- * This command captures all of the flip flop states so they will be
- * available during readback.  One can use this command instead of
- * enabling the CAPTURE block in the design.
- */
-int hwicap_command_capture(struct hwicap_drvdata *drvdata)
-{
-	u32 buffer[7];
-	u32 index = 0;
-
-	/*
-	 * Create the data to be written to the ICAP.
-	 */
-	buffer[index++] = XHI_DUMMY_PACKET;
-	buffer[index++] = XHI_SYNC_PACKET;
-	buffer[index++] = XHI_NOOP_PACKET;
-	buffer[index++] = hwicap_type_1_write(drvdata->config_regs->CMD) | 1;
-	buffer[index++] = XHI_CMD_GCAPTURE;
-	buffer[index++] = XHI_DUMMY_PACKET;
-	buffer[index++] = XHI_DUMMY_PACKET;
-
-	/*
-	 * Write the data to the FIFO and intiate the transfer of data
-	 * present in the FIFO to the ICAP device.
-	 */
-	return drvdata->config->set_configuration(drvdata,
-			&buffer[0], index);
-
-}
-
-/**
- * hwicap_get_configuration_register: Query a configuration register.
- * @parameter drvdata: a pointer to the drvdata.
- * @parameter reg: a constant which represents the configuration
+ * hwicap_get_configuration_register - Query a configuration register.
+ * @drvdata: a pointer to the drvdata.
+ * @reg: a constant which represents the configuration
  *		register value to be returned.
  * 		Examples:  XHI_IDCODE, XHI_FLR.
- * @parameter RegData: returns the value of the register.
+ * @reg_data: returns the value of the register.
  *
  * Sends a query packet to the ICAP and then receives the response.
  * The icap is left in Synched state.
  */
-int hwicap_get_configuration_register(struct hwicap_drvdata *drvdata,
-		u32 reg, u32 *RegData)
+static int hwicap_get_configuration_register(struct hwicap_drvdata *drvdata,
+		u32 reg, u32 *reg_data)
 {
 	int status;
 	u32 buffer[6];
@@ -300,14 +268,14 @@ int hwicap_get_configuration_register(st
 	/*
 	 * Read the configuration register
 	 */
-	status = drvdata->config->get_configuration(drvdata, RegData, 1);
+	status = drvdata->config->get_configuration(drvdata, reg_data, 1);
 	if (status)
 		return status;
 
 	return 0;
 }
 
-int hwicap_initialize_hwicap(struct hwicap_drvdata *drvdata)
+static int hwicap_initialize_hwicap(struct hwicap_drvdata *drvdata)
 {
 	int status;
 	u32 idcode;
@@ -344,7 +312,7 @@ int hwicap_initialize_hwicap(struct hwic
 }
 
 static ssize_t
-hwicap_read(struct file *file, char *buf, size_t count, loff_t *ppos)
+hwicap_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 {
 	struct hwicap_drvdata *drvdata = file->private_data;
 	ssize_t bytes_to_read = 0;
@@ -353,8 +321,9 @@ hwicap_read(struct file *file, char *buf
 	u32 bytes_remaining;
 	int status;
 
-	if (down_interruptible(&drvdata->sem))
-		return -ERESTARTSYS;
+	status = mutex_lock_interruptible(&drvdata->sem);
+	if (status)
+		return status;
 
 	if (drvdata->read_buffer_in_use) {
 		/* If there are leftover bytes in the buffer, just */
@@ -370,8 +339,9 @@ hwicap_read(struct file *file, char *buf
 			goto error;
 		}
 		drvdata->read_buffer_in_use -= bytes_to_read;
-		memcpy(drvdata->read_buffer + bytes_to_read,
-				drvdata->read_buffer, 4 - bytes_to_read);
+		memmove(drvdata->read_buffer,
+		       drvdata->read_buffer + bytes_to_read,
+		       4 - bytes_to_read);
 	} else {
 		/* Get new data from the ICAP, and return was was requested. */
 		kbuf = (u32 *) get_zeroed_page(GFP_KERNEL);
@@ -414,18 +384,20 @@ hwicap_read(struct file *file, char *buf
 			status = -EFAULT;
 			goto error;
 		}
-		memcpy(kbuf, drvdata->read_buffer, bytes_remaining);
+		memcpy(drvdata->read_buffer,
+		       kbuf,
+		       bytes_remaining);
 		drvdata->read_buffer_in_use = bytes_remaining;
 		free_page((unsigned long)kbuf);
 	}
 	status = bytes_to_read;
  error:
-	up(&drvdata->sem);
+	mutex_unlock(&drvdata->sem);
 	return status;
 }
 
 static ssize_t
-hwicap_write(struct file *file, const char *buf,
+hwicap_write(struct file *file, const char __user *buf,
 		size_t count, loff_t *ppos)
 {
 	struct hwicap_drvdata *drvdata = file->private_data;
@@ -435,8 +407,9 @@ hwicap_write(struct file *file, const ch
 	ssize_t len;
 	ssize_t status;
 
-	if (down_interruptible(&drvdata->sem))
-		return -ERESTARTSYS;
+	status = mutex_lock_interruptible(&drvdata->sem);
+	if (status)
+		return status;
 
 	left += drvdata->write_buffer_in_use;
 
@@ -465,7 +438,7 @@ hwicap_write(struct file *file, const ch
 			memcpy(kbuf, drvdata->write_buffer,
 					drvdata->write_buffer_in_use);
 			if (copy_from_user(
-			    (((char *)kbuf) + (drvdata->write_buffer_in_use)),
+			    (((char *)kbuf) + drvdata->write_buffer_in_use),
 			    buf + written,
 			    len - (drvdata->write_buffer_in_use))) {
 				free_page((unsigned long)kbuf);
@@ -508,7 +481,7 @@ hwicap_write(struct file *file, const ch
 	free_page((unsigned long)kbuf);
 	status = written;
  error:
-	up(&drvdata->sem);
+	mutex_unlock(&drvdata->sem);
 	return status;
 }
 
@@ -519,8 +492,9 @@ static int hwicap_open(struct inode *ino
 
 	drvdata = container_of(inode->i_cdev, struct hwicap_drvdata, cdev);
 
-	if (down_interruptible(&drvdata->sem))
-		return -ERESTARTSYS;
+	status = mutex_lock_interruptible(&drvdata->sem);
+	if (status)
+		return status;
 
 	if (drvdata->is_open) {
 		status = -EBUSY;
@@ -539,7 +513,7 @@ static int hwicap_open(struct inode *ino
 	drvdata->is_open = 1;
 
  error:
-	up(&drvdata->sem);
+	mutex_unlock(&drvdata->sem);
 	return status;
 }
 
@@ -549,8 +523,7 @@ static int hwicap_release(struct inode *
 	int i;
 	int status = 0;
 
-	if (down_interruptible(&drvdata->sem))
-		return -ERESTARTSYS;
+	mutex_lock(&drvdata->sem);
 
 	if (drvdata->write_buffer_in_use) {
 		/* Flush write buffer. */
@@ -569,7 +542,7 @@ static int hwicap_release(struct inode *
 
  error:
 	drvdata->is_open = 0;
-	up(&drvdata->sem);
+	mutex_unlock(&drvdata->sem);
 	return status;
 }
 
@@ -592,31 +565,36 @@ static int __devinit hwicap_setup(struct
 
 	dev_info(dev, "Xilinx icap port driver\n");
 
+	mutex_lock(&icap_sem);
+
 	if (id < 0) {
 		for (id = 0; id < HWICAP_DEVICES; id++)
 			if (!probed_devices[id])
 				break;
 	}
 	if (id < 0 || id >= HWICAP_DEVICES) {
+		mutex_unlock(&icap_sem);
 		dev_err(dev, "%s%i too large\n", DRIVER_NAME, id);
 		return -EINVAL;
 	}
 	if (probed_devices[id]) {
+		mutex_unlock(&icap_sem);
 		dev_err(dev, "cannot assign to %s%i; it is already in use\n",
 			DRIVER_NAME, id);
 		return -EBUSY;
 	}
 
 	probed_devices[id] = 1;
+	mutex_unlock(&icap_sem);
 
 	devt = MKDEV(xhwicap_major, xhwicap_minor + id);
 
-	drvdata = kmalloc(sizeof(struct hwicap_drvdata), GFP_KERNEL);
+	drvdata = kzalloc(sizeof(struct hwicap_drvdata), GFP_KERNEL);
 	if (!drvdata) {
 		dev_err(dev, "Couldn't allocate device private record\n");
-		return -ENOMEM;
+		retval = -ENOMEM;
+		goto failed0;
 	}
-	memset((void *)drvdata, 0, sizeof(struct hwicap_drvdata));
 	dev_set_drvdata(dev, (void *)drvdata);
 
 	if (!regs_res) {
@@ -648,7 +626,7 @@ static int __devinit hwicap_setup(struct
 	drvdata->config = config;
 	drvdata->config_regs = config_regs;
 
-	init_MUTEX(&drvdata->sem);
+	mutex_init(&drvdata->sem);
 	drvdata->is_open = 0;
 
 	dev_info(dev, "ioremap %lx to %p with size %x\n",
@@ -663,7 +641,7 @@ static int __devinit hwicap_setup(struct
 		goto failed3;
 	}
 	/*  devfs_mk_cdev(devt, S_IFCHR|S_IRUGO|S_IWUGO, DRIVER_NAME); */
-	class_device_create(icap_class, NULL, devt, NULL, DRIVER_NAME);
+	device_create(icap_class, dev, devt, "%s%d", DRIVER_NAME, id);
 	return 0;		/* success */
 
  failed3:
@@ -675,6 +653,11 @@ static int __devinit hwicap_setup(struct
  failed1:
 	kfree(drvdata);
 
+ failed0:
+	mutex_lock(&icap_sem);
+	probed_devices[id] = 0;
+	mutex_unlock(&icap_sem);
+
 	return retval;
 }
 
@@ -699,14 +682,16 @@ static int __devexit hwicap_remove(struc
 	if (!drvdata)
 		return 0;
 
-	class_device_destroy(icap_class, drvdata->devt);
+	device_destroy(icap_class, drvdata->devt);
 	cdev_del(&drvdata->cdev);
 	iounmap(drvdata->base_address);
 	release_mem_region(drvdata->mem_start, drvdata->mem_size);
 	kfree(drvdata);
 	dev_set_drvdata(dev, NULL);
-	probed_devices[MINOR(dev->devt)-xhwicap_minor] = 0;
 
+	mutex_lock(&icap_sem);
+	probed_devices[MINOR(dev->devt)-xhwicap_minor] = 0;
+	mutex_unlock(&icap_sem);
 	return 0;		/* success */
 }
 
@@ -821,28 +806,29 @@ static struct of_platform_driver hwicap_
 };
 
 /* Registration helpers to keep the number of #ifdefs to a minimum */
-static inline int __devinit hwicap_of_register(void)
+static inline int __init hwicap_of_register(void)
 {
 	pr_debug("hwicap: calling of_register_platform_driver()\n");
 	return of_register_platform_driver(&hwicap_of_driver);
 }
 
-static inline void __devexit hwicap_of_unregister(void)
+static inline void __exit hwicap_of_unregister(void)
 {
 	of_unregister_platform_driver(&hwicap_of_driver);
 }
 #else /* CONFIG_OF */
 /* CONFIG_OF not enabled; do nothing helpers */
-static inline int __devinit hwicap_of_register(void) { return 0; }
-static inline void __devexit hwicap_of_unregister(void) { }
+static inline int __init hwicap_of_register(void) { return 0; }
+static inline void __exit hwicap_of_unregister(void) { }
 #endif /* CONFIG_OF */
 
-static int __devinit hwicap_module_init(void)
+static int __init hwicap_module_init(void)
 {
 	dev_t devt;
 	int retval;
 
 	icap_class = class_create(THIS_MODULE, "xilinx_config");
+	mutex_init(&icap_sem);
 
 	if (xhwicap_major) {
 		devt = MKDEV(xhwicap_major, xhwicap_minor);
@@ -883,7 +869,7 @@ static int __devinit hwicap_module_init(
 	return retval;
 }
 
-static void __devexit hwicap_module_cleanup(void)
+static void __exit hwicap_module_cleanup(void)
 {
 	dev_t devt = MKDEV(xhwicap_major, xhwicap_minor);
 
diff -puN drivers/char/xilinx_hwicap/xilinx_hwicap.h~powerpc-xilinx-hwicap-cleanup drivers/char/xilinx_hwicap/xilinx_hwicap.h
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.h~powerpc-xilinx-hwicap-cleanup
+++ a/drivers/char/xilinx_hwicap/xilinx_hwicap.h
@@ -48,9 +48,9 @@ struct hwicap_drvdata {
 	u8 write_buffer[4];
 	u32 read_buffer_in_use;	  /* Always in [0,3] */
 	u8 read_buffer[4];
-	u32 mem_start;		  /* phys. address of the control registers */
-	u32 mem_end;		  /* phys. address of the control registers */
-	u32 mem_size;
+	resource_size_t mem_start;/* phys. address of the control registers */
+	resource_size_t mem_end;  /* phys. address of the control registers */
+	resource_size_t mem_size;
 	void __iomem *base_address;/* virt. address of the control registers */
 
 	struct device *dev;
@@ -61,7 +61,7 @@ struct hwicap_drvdata {
 	const struct config_registers *config_regs;
 	void *private_data;
 	bool is_open;
-	struct semaphore sem;
+	struct mutex sem;
 };
 
 struct hwicap_driver_config {
@@ -164,29 +164,29 @@ struct config_registers {
 #define XHI_DISABLED_AUTO_CRC       0x0000DEFCUL
 
 /**
- * hwicap_type_1_read: Generates a Type 1 read packet header.
- * @parameter: Register is the address of the register to be read back.
+ * hwicap_type_1_read - Generates a Type 1 read packet header.
+ * @reg: is the address of the register to be read back.
  *
  * Generates a Type 1 read packet header, which is used to indirectly
  * read registers in the configuration logic.  This packet must then
  * be sent through the icap device, and a return packet received with
  * the information.
  **/
-static inline u32 hwicap_type_1_read(u32 Register)
+static inline u32 hwicap_type_1_read(u32 reg)
 {
 	return (XHI_TYPE_1 << XHI_TYPE_SHIFT) |
-		(Register << XHI_REGISTER_SHIFT) |
+		(reg << XHI_REGISTER_SHIFT) |
 		(XHI_OP_READ << XHI_OP_SHIFT);
 }
 
 /**
- * hwicap_type_1_write: Generates a Type 1 write packet header
- * @parameter: Register is the address of the register to be read back.
+ * hwicap_type_1_write - Generates a Type 1 write packet header
+ * @reg: is the address of the register to be read back.
  **/
-static inline u32 hwicap_type_1_write(u32 Register)
+static inline u32 hwicap_type_1_write(u32 reg)
 {
 	return (XHI_TYPE_1 << XHI_TYPE_SHIFT) |
-		(Register << XHI_REGISTER_SHIFT) |
+		(reg << XHI_REGISTER_SHIFT) |
 		(XHI_OP_WRITE << XHI_OP_SHIFT);
 }
 
_

Patches currently in -mm which might be from stephen.neuendorffer@xilinx.com are

origin.patch


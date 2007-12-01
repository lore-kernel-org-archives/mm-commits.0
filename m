From: akpm@linux-foundation.org
Subject: - ps3-prefix-all-ps3-specific-kernel-modules-with.patch removed from -mm tree
Date: Fri, 30 Nov 2007 16:20:40 -0800
Message-ID: <200712010020.lB10KeSd031713@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38204 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755980AbXLAAUw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 19:20:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, mm-commits@vger.kernel.org


The patch titled
     ps3: prefix all ps3-specific kernel modules with `ps3-'
has been removed from the -mm tree.  Its filename was
     ps3-prefix-all-ps3-specific-kernel-modules-with.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ps3: prefix all ps3-specific kernel modules with `ps3-'
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

- vuart.ko -> ps3-vuart.ko
- sys-manager.ko -> ps3-sys-manager.ko

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ps3/Makefile          |    4 
 drivers/ps3/ps3-sys-manager.c |  702 +++++++++++++++++
 drivers/ps3/ps3-vuart.c       | 1271 ++++++++++++++++++++++++++++++++
 drivers/ps3/sys-manager.c     |  702 -----------------
 drivers/ps3/vuart.c           | 1271 --------------------------------
 5 files changed, 1975 insertions(+), 1975 deletions(-)

diff -puN drivers/ps3/Makefile~ps3-prefix-all-ps3-specific-kernel-modules-with drivers/ps3/Makefile
--- a/drivers/ps3/Makefile~ps3-prefix-all-ps3-specific-kernel-modules-with
+++ a/drivers/ps3/Makefile
@@ -1,6 +1,6 @@
-obj-$(CONFIG_PS3_VUART) += vuart.o
+obj-$(CONFIG_PS3_VUART) += ps3-vuart.o
 obj-$(CONFIG_PS3_PS3AV) += ps3av_mod.o
 ps3av_mod-objs		+= ps3av.o ps3av_cmd.o
 obj-$(CONFIG_PPC_PS3) += sys-manager-core.o
-obj-$(CONFIG_PS3_SYS_MANAGER) += sys-manager.o
+obj-$(CONFIG_PS3_SYS_MANAGER) += ps3-sys-manager.o
 obj-$(CONFIG_PS3_STORAGE) += ps3stor_lib.o
diff -puN /dev/null drivers/ps3/ps3-sys-manager.c
--- /dev/null
+++ a/drivers/ps3/ps3-sys-manager.c
@@ -0,0 +1,702 @@
+/*
+ *  PS3 System Manager.
+ *
+ *  Copyright (C) 2007 Sony Computer Entertainment Inc.
+ *  Copyright 2007 Sony Corp.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/workqueue.h>
+#include <linux/reboot.h>
+
+#include <asm/firmware.h>
+#include <asm/ps3.h>
+
+#include "vuart.h"
+
+MODULE_AUTHOR("Sony Corporation");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("PS3 System Manager");
+
+/**
+ * ps3_sys_manager - PS3 system manager driver.
+ *
+ * The system manager provides an asynchronous system event notification
+ * mechanism for reporting events like thermal alert and button presses to
+ * guests.  It also provides support to control system shutdown and startup.
+ *
+ * The actual system manager is implemented as an application running in the
+ * system policy module in lpar_1.  Guests communicate with the system manager
+ * through port 2 of the vuart using a simple packet message protocol.
+ * Messages are comprised of a fixed field header followed by a message
+ * specific payload.
+ */
+
+/**
+ * struct ps3_sys_manager_header - System manager message header.
+ * @version: Header version, currently 1.
+ * @size: Header size in bytes, curently 16.
+ * @payload_size: Message payload size in bytes.
+ * @service_id: Message type, one of enum ps3_sys_manager_service_id.
+ * @request_tag: Unique number to identify reply.
+ */
+
+struct ps3_sys_manager_header {
+	/* version 1 */
+	u8 version;
+	u8 size;
+	u16 reserved_1;
+	u32 payload_size;
+	u16 service_id;
+	u16 reserved_2;
+	u32 request_tag;
+};
+
+#define dump_sm_header(_h) _dump_sm_header(_h, __func__, __LINE__)
+static void __maybe_unused _dump_sm_header(
+	const struct ps3_sys_manager_header *h, const char *func, int line)
+{
+	pr_debug("%s:%d: version:      %xh\n", func, line, h->version);
+	pr_debug("%s:%d: size:         %xh\n", func, line, h->size);
+	pr_debug("%s:%d: payload_size: %xh\n", func, line, h->payload_size);
+	pr_debug("%s:%d: service_id:   %xh\n", func, line, h->service_id);
+	pr_debug("%s:%d: request_tag:  %xh\n", func, line, h->request_tag);
+}
+
+/**
+ * @PS3_SM_RX_MSG_LEN_MIN - Shortest received message length.
+ * @PS3_SM_RX_MSG_LEN_MAX - Longest received message length.
+ *
+ * Currently all messages received from the system manager are either
+ * (16 bytes header + 8 bytes payload = 24 bytes) or (16 bytes header
+ * + 16 bytes payload = 32 bytes).  This knowlege is used to simplify
+ * the logic.
+ */
+
+enum {
+	PS3_SM_RX_MSG_LEN_MIN = 24,
+	PS3_SM_RX_MSG_LEN_MAX = 32,
+};
+
+/**
+ * enum ps3_sys_manager_service_id - Message header service_id.
+ * @PS3_SM_SERVICE_ID_REQUEST:       guest --> sys_manager.
+ * @PS3_SM_SERVICE_ID_REQUEST_ERROR: guest <-- sys_manager.
+ * @PS3_SM_SERVICE_ID_COMMAND:       guest <-- sys_manager.
+ * @PS3_SM_SERVICE_ID_RESPONSE:      guest --> sys_manager.
+ * @PS3_SM_SERVICE_ID_SET_ATTR:      guest --> sys_manager.
+ * @PS3_SM_SERVICE_ID_EXTERN_EVENT:  guest <-- sys_manager.
+ * @PS3_SM_SERVICE_ID_SET_NEXT_OP:   guest --> sys_manager.
+ *
+ * PS3_SM_SERVICE_ID_REQUEST_ERROR is returned for invalid data values in a
+ * a PS3_SM_SERVICE_ID_REQUEST message.  It also seems to be returned when
+ * a REQUEST message is sent at the wrong time.
+ */
+
+enum ps3_sys_manager_service_id {
+	/* version 1 */
+	PS3_SM_SERVICE_ID_REQUEST = 1,
+	PS3_SM_SERVICE_ID_RESPONSE = 2,
+	PS3_SM_SERVICE_ID_COMMAND = 3,
+	PS3_SM_SERVICE_ID_EXTERN_EVENT = 4,
+	PS3_SM_SERVICE_ID_SET_NEXT_OP = 5,
+	PS3_SM_SERVICE_ID_REQUEST_ERROR = 6,
+	PS3_SM_SERVICE_ID_SET_ATTR = 8,
+};
+
+/**
+ * enum ps3_sys_manager_attr - Notification attribute (bit position mask).
+ * @PS3_SM_ATTR_POWER: Power button.
+ * @PS3_SM_ATTR_RESET: Reset button, not available on retail console.
+ * @PS3_SM_ATTR_THERMAL: Sytem thermal alert.
+ * @PS3_SM_ATTR_CONTROLLER: Remote controller event.
+ * @PS3_SM_ATTR_ALL: Logical OR of all.
+ *
+ * The guest tells the system manager which events it is interested in receiving
+ * notice of by sending the system manager a logical OR of notification
+ * attributes via the ps3_sys_manager_send_attr() routine.
+ */
+
+enum ps3_sys_manager_attr {
+	/* version 1 */
+	PS3_SM_ATTR_POWER = 1,
+	PS3_SM_ATTR_RESET = 2,
+	PS3_SM_ATTR_THERMAL = 4,
+	PS3_SM_ATTR_CONTROLLER = 8, /* bogus? */
+	PS3_SM_ATTR_ALL = 0x0f,
+};
+
+/**
+ * enum ps3_sys_manager_event - External event type, reported by system manager.
+ * @PS3_SM_EVENT_POWER_PRESSED: payload.value not used.
+ * @PS3_SM_EVENT_POWER_RELEASED: payload.value = time pressed in millisec.
+ * @PS3_SM_EVENT_RESET_PRESSED: payload.value not used.
+ * @PS3_SM_EVENT_RESET_RELEASED: payload.value = time pressed in millisec.
+ * @PS3_SM_EVENT_THERMAL_ALERT: payload.value = thermal zone id.
+ * @PS3_SM_EVENT_THERMAL_CLEARED: payload.value = thermal zone id.
+ */
+
+enum ps3_sys_manager_event {
+	/* version 1 */
+	PS3_SM_EVENT_POWER_PRESSED = 3,
+	PS3_SM_EVENT_POWER_RELEASED = 4,
+	PS3_SM_EVENT_RESET_PRESSED = 5,
+	PS3_SM_EVENT_RESET_RELEASED = 6,
+	PS3_SM_EVENT_THERMAL_ALERT = 7,
+	PS3_SM_EVENT_THERMAL_CLEARED = 8,
+	/* no info on controller events */
+};
+
+/**
+ * enum ps3_sys_manager_next_op - Operation to perform after lpar is destroyed.
+ */
+
+enum ps3_sys_manager_next_op {
+	/* version 3 */
+	PS3_SM_NEXT_OP_SYS_SHUTDOWN = 1,
+	PS3_SM_NEXT_OP_SYS_REBOOT = 2,
+	PS3_SM_NEXT_OP_LPAR_REBOOT = 0x82,
+};
+
+/**
+ * enum ps3_sys_manager_wake_source - Next-op wakeup source (bit position mask).
+ * @PS3_SM_WAKE_DEFAULT: Disk insert, power button, eject button, IR
+ * controller, and bluetooth controller.
+ * @PS3_SM_WAKE_RTC:
+ * @PS3_SM_WAKE_RTC_ERROR:
+ * @PS3_SM_WAKE_P_O_R: Power on reset.
+ *
+ * Additional wakeup sources when specifying PS3_SM_NEXT_OP_SYS_SHUTDOWN.
+ * System will always wake from the PS3_SM_WAKE_DEFAULT sources.
+ */
+
+enum ps3_sys_manager_wake_source {
+	/* version 3 */
+	PS3_SM_WAKE_DEFAULT   = 0,
+	PS3_SM_WAKE_RTC       = 0x00000040,
+	PS3_SM_WAKE_RTC_ERROR = 0x00000080,
+	PS3_SM_WAKE_P_O_R     = 0x10000000,
+};
+
+/**
+ * enum ps3_sys_manager_cmd - Command from system manager to guest.
+ *
+ * The guest completes the actions needed, then acks or naks the command via
+ * ps3_sys_manager_send_response().  In the case of @PS3_SM_CMD_SHUTDOWN,
+ * the guest must be fully prepared for a system poweroff prior to acking the
+ * command.
+ */
+
+enum ps3_sys_manager_cmd {
+	/* version 1 */
+	PS3_SM_CMD_SHUTDOWN = 1, /* shutdown guest OS */
+};
+
+/**
+ * ps3_sm_force_power_off - Poweroff helper.
+ *
+ * A global variable used to force a poweroff when the power button has
+ * been pressed irrespective of how init handles the ctrl_alt_del signal.
+ *
+ */
+
+static unsigned int ps3_sm_force_power_off;
+
+/**
+ * ps3_sys_manager_write - Helper to write a two part message to the vuart.
+ *
+ */
+
+static int ps3_sys_manager_write(struct ps3_system_bus_device *dev,
+	const struct ps3_sys_manager_header *header, const void *payload)
+{
+	int result;
+
+	BUG_ON(header->version != 1);
+	BUG_ON(header->size != 16);
+	BUG_ON(header->payload_size != 8 && header->payload_size != 16);
+	BUG_ON(header->service_id > 8);
+
+	result = ps3_vuart_write(dev, header,
+		sizeof(struct ps3_sys_manager_header));
+
+	if (!result)
+		result = ps3_vuart_write(dev, payload, header->payload_size);
+
+	return result;
+}
+
+/**
+ * ps3_sys_manager_send_attr - Send a 'set attribute' to the system manager.
+ *
+ */
+
+static int ps3_sys_manager_send_attr(struct ps3_system_bus_device *dev,
+	enum ps3_sys_manager_attr attr)
+{
+	struct ps3_sys_manager_header header;
+	struct {
+		u8 version;
+		u8 reserved_1[3];
+		u32 attribute;
+	} payload;
+
+	BUILD_BUG_ON(sizeof(payload) != 8);
+
+	dev_dbg(&dev->core, "%s:%d: %xh\n", __func__, __LINE__, attr);
+
+	memset(&header, 0, sizeof(header));
+	header.version = 1;
+	header.size = 16;
+	header.payload_size = 16;
+	header.service_id = PS3_SM_SERVICE_ID_SET_ATTR;
+
+	memset(&payload, 0, sizeof(payload));
+	payload.version = 1;
+	payload.attribute = attr;
+
+	return ps3_sys_manager_write(dev, &header, &payload);
+}
+
+/**
+ * ps3_sys_manager_send_next_op - Send a 'set next op' to the system manager.
+ *
+ * Tell the system manager what to do after this lpar is destroyed.
+ */
+
+static int ps3_sys_manager_send_next_op(struct ps3_system_bus_device *dev,
+	enum ps3_sys_manager_next_op op,
+	enum ps3_sys_manager_wake_source wake_source)
+{
+	struct ps3_sys_manager_header header;
+	struct {
+		u8 version;
+		u8 type;
+		u8 gos_id;
+		u8 reserved_1;
+		u32 wake_source;
+		u8 reserved_2[8];
+	} payload;
+
+	BUILD_BUG_ON(sizeof(payload) != 16);
+
+	dev_dbg(&dev->core, "%s:%d: (%xh)\n", __func__, __LINE__, op);
+
+	memset(&header, 0, sizeof(header));
+	header.version = 1;
+	header.size = 16;
+	header.payload_size = 16;
+	header.service_id = PS3_SM_SERVICE_ID_SET_NEXT_OP;
+
+	memset(&payload, 0, sizeof(payload));
+	payload.version = 3;
+	payload.type = op;
+	payload.gos_id = 3; /* other os */
+	payload.wake_source = wake_source;
+
+	return ps3_sys_manager_write(dev, &header, &payload);
+}
+
+/**
+ * ps3_sys_manager_send_request_shutdown - Send 'request' to the system manager.
+ *
+ * The guest sends this message to request an operation or action of the system
+ * manager.  The reply is a command message from the system manager.  In the
+ * command handler the guest performs the requested operation.  The result of
+ * the command is then communicated back to the system manager with a response
+ * message.
+ *
+ * Currently, the only supported request is the 'shutdown self' request.
+ */
+
+static int ps3_sys_manager_send_request_shutdown(
+	struct ps3_system_bus_device *dev)
+{
+	struct ps3_sys_manager_header header;
+	struct {
+		u8 version;
+		u8 type;
+		u8 gos_id;
+		u8 reserved_1[13];
+	} payload;
+
+	BUILD_BUG_ON(sizeof(payload) != 16);
+
+	dev_dbg(&dev->core, "%s:%d\n", __func__, __LINE__);
+
+	memset(&header, 0, sizeof(header));
+	header.version = 1;
+	header.size = 16;
+	header.payload_size = 16;
+	header.service_id = PS3_SM_SERVICE_ID_REQUEST;
+
+	memset(&payload, 0, sizeof(payload));
+	payload.version = 1;
+	payload.type = 1; /* shutdown */
+	payload.gos_id = 0; /* self */
+
+	return ps3_sys_manager_write(dev, &header, &payload);
+}
+
+/**
+ * ps3_sys_manager_send_response - Send a 'response' to the system manager.
+ * @status: zero = success, others fail.
+ *
+ * The guest sends this message to the system manager to acnowledge success or
+ * failure of a command sent by the system manager.
+ */
+
+static int ps3_sys_manager_send_response(struct ps3_system_bus_device *dev,
+	u64 status)
+{
+	struct ps3_sys_manager_header header;
+	struct {
+		u8 version;
+		u8 reserved_1[3];
+		u8 status;
+		u8 reserved_2[11];
+	} payload;
+
+	BUILD_BUG_ON(sizeof(payload) != 16);
+
+	dev_dbg(&dev->core, "%s:%d: (%s)\n", __func__, __LINE__,
+		(status ? "nak" : "ack"));
+
+	memset(&header, 0, sizeof(header));
+	header.version = 1;
+	header.size = 16;
+	header.payload_size = 16;
+	header.service_id = PS3_SM_SERVICE_ID_RESPONSE;
+
+	memset(&payload, 0, sizeof(payload));
+	payload.version = 1;
+	payload.status = status;
+
+	return ps3_sys_manager_write(dev, &header, &payload);
+}
+
+/**
+ * ps3_sys_manager_handle_event - Second stage event msg handler.
+ *
+ */
+
+static int ps3_sys_manager_handle_event(struct ps3_system_bus_device *dev)
+{
+	int result;
+	struct {
+		u8 version;
+		u8 type;
+		u8 reserved_1[2];
+		u32 value;
+		u8 reserved_2[8];
+	} event;
+
+	BUILD_BUG_ON(sizeof(event) != 16);
+
+	result = ps3_vuart_read(dev, &event, sizeof(event));
+	BUG_ON(result && "need to retry here");
+
+	if (event.version != 1) {
+		dev_dbg(&dev->core, "%s:%d: unsupported event version (%u)\n",
+			__func__, __LINE__, event.version);
+		return -EIO;
+	}
+
+	switch (event.type) {
+	case PS3_SM_EVENT_POWER_PRESSED:
+		dev_dbg(&dev->core, "%s:%d: POWER_PRESSED\n",
+			__func__, __LINE__);
+		ps3_sm_force_power_off = 1;
+		/*
+		 * A memory barrier is use here to sync memory since
+		 * ps3_sys_manager_final_restart() could be called on
+		 * another cpu.
+		 */
+		wmb();
+		kill_cad_pid(SIGINT, 1); /* ctrl_alt_del */
+		break;
+	case PS3_SM_EVENT_POWER_RELEASED:
+		dev_dbg(&dev->core, "%s:%d: POWER_RELEASED (%u ms)\n",
+			__func__, __LINE__, event.value);
+		break;
+	case PS3_SM_EVENT_RESET_PRESSED:
+		dev_dbg(&dev->core, "%s:%d: RESET_PRESSED\n",
+			__func__, __LINE__);
+		ps3_sm_force_power_off = 0;
+		/*
+		 * A memory barrier is use here to sync memory since
+		 * ps3_sys_manager_final_restart() could be called on
+		 * another cpu.
+		 */
+		wmb();
+		kill_cad_pid(SIGINT, 1); /* ctrl_alt_del */
+		break;
+	case PS3_SM_EVENT_RESET_RELEASED:
+		dev_dbg(&dev->core, "%s:%d: RESET_RELEASED (%u ms)\n",
+			__func__, __LINE__, event.value);
+		break;
+	case PS3_SM_EVENT_THERMAL_ALERT:
+		dev_dbg(&dev->core, "%s:%d: THERMAL_ALERT (zone %u)\n",
+			__func__, __LINE__, event.value);
+		printk(KERN_INFO "PS3 Thermal Alert Zone %u\n", event.value);
+		break;
+	case PS3_SM_EVENT_THERMAL_CLEARED:
+		dev_dbg(&dev->core, "%s:%d: THERMAL_CLEARED (zone %u)\n",
+			__func__, __LINE__, event.value);
+		break;
+	default:
+		dev_dbg(&dev->core, "%s:%d: unknown event (%u)\n",
+			__func__, __LINE__, event.type);
+		return -EIO;
+	}
+
+	return 0;
+}
+/**
+ * ps3_sys_manager_handle_cmd - Second stage command msg handler.
+ *
+ * The system manager sends this in reply to a 'request' message from the guest.
+ */
+
+static int ps3_sys_manager_handle_cmd(struct ps3_system_bus_device *dev)
+{
+	int result;
+	struct {
+		u8 version;
+		u8 type;
+		u8 reserved_1[14];
+	} cmd;
+
+	BUILD_BUG_ON(sizeof(cmd) != 16);
+
+	dev_dbg(&dev->core, "%s:%d\n", __func__, __LINE__);
+
+	result = ps3_vuart_read(dev, &cmd, sizeof(cmd));
+	BUG_ON(result && "need to retry here");
+
+	if(result)
+		return result;
+
+	if (cmd.version != 1) {
+		dev_dbg(&dev->core, "%s:%d: unsupported cmd version (%u)\n",
+			__func__, __LINE__, cmd.version);
+		return -EIO;
+	}
+
+	if (cmd.type != PS3_SM_CMD_SHUTDOWN) {
+		dev_dbg(&dev->core, "%s:%d: unknown cmd (%u)\n",
+			__func__, __LINE__, cmd.type);
+		return -EIO;
+	}
+
+	ps3_sys_manager_send_response(dev, 0);
+	return 0;
+}
+
+/**
+ * ps3_sys_manager_handle_msg - First stage msg handler.
+ *
+ * Can be called directly to manually poll vuart and pump message handler.
+ */
+
+static int ps3_sys_manager_handle_msg(struct ps3_system_bus_device *dev)
+{
+	int result;
+	struct ps3_sys_manager_header header;
+
+	result = ps3_vuart_read(dev, &header,
+		sizeof(struct ps3_sys_manager_header));
+
+	if(result)
+		return result;
+
+	if (header.version != 1) {
+		dev_dbg(&dev->core, "%s:%d: unsupported header version (%u)\n",
+			__func__, __LINE__, header.version);
+		dump_sm_header(&header);
+		goto fail_header;
+	}
+
+	BUILD_BUG_ON(sizeof(header) != 16);
+
+	if (header.size != 16 || (header.payload_size != 8
+		&& header.payload_size != 16)) {
+		dump_sm_header(&header);
+		BUG();
+	}
+
+	switch (header.service_id) {
+	case PS3_SM_SERVICE_ID_EXTERN_EVENT:
+		dev_dbg(&dev->core, "%s:%d: EVENT\n", __func__, __LINE__);
+		return ps3_sys_manager_handle_event(dev);
+	case PS3_SM_SERVICE_ID_COMMAND:
+		dev_dbg(&dev->core, "%s:%d: COMMAND\n", __func__, __LINE__);
+		return ps3_sys_manager_handle_cmd(dev);
+	case PS3_SM_SERVICE_ID_REQUEST_ERROR:
+		dev_dbg(&dev->core, "%s:%d: REQUEST_ERROR\n", __func__,
+			__LINE__);
+		dump_sm_header(&header);
+		break;
+	default:
+		dev_dbg(&dev->core, "%s:%d: unknown service_id (%u)\n",
+			__func__, __LINE__, header.service_id);
+		break;
+	}
+	goto fail_id;
+
+fail_header:
+	ps3_vuart_clear_rx_bytes(dev, 0);
+	return -EIO;
+fail_id:
+	ps3_vuart_clear_rx_bytes(dev, header.payload_size);
+	return -EIO;
+}
+
+/**
+ * ps3_sys_manager_final_power_off - The final platform machine_power_off routine.
+ *
+ * This routine never returns.  The routine disables asynchronous vuart reads
+ * then spins calling ps3_sys_manager_handle_msg() to receive and acknowledge
+ * the shutdown command sent from the system manager.  Soon after the
+ * acknowledgement is sent the lpar is destroyed by the HV.  This routine
+ * should only be called from ps3_power_off() through
+ * ps3_sys_manager_ops.power_off.
+ */
+
+static void ps3_sys_manager_final_power_off(struct ps3_system_bus_device *dev)
+{
+	BUG_ON(!dev);
+
+	dev_dbg(&dev->core, "%s:%d\n", __func__, __LINE__);
+
+	ps3_vuart_cancel_async(dev);
+
+	ps3_sys_manager_send_next_op(dev, PS3_SM_NEXT_OP_SYS_SHUTDOWN,
+		PS3_SM_WAKE_DEFAULT);
+	ps3_sys_manager_send_request_shutdown(dev);
+
+	printk(KERN_EMERG "System Halted, OK to turn off power\n");
+
+	while(1)
+		ps3_sys_manager_handle_msg(dev);
+}
+
+/**
+ * ps3_sys_manager_final_restart - The final platform machine_restart routine.
+ *
+ * This routine never returns.  The routine disables asynchronous vuart reads
+ * then spins calling ps3_sys_manager_handle_msg() to receive and acknowledge
+ * the shutdown command sent from the system manager.  Soon after the
+ * acknowledgement is sent the lpar is destroyed by the HV.  This routine
+ * should only be called from ps3_restart() through ps3_sys_manager_ops.restart.
+ */
+
+static void ps3_sys_manager_final_restart(struct ps3_system_bus_device *dev)
+{
+	BUG_ON(!dev);
+
+	dev_dbg(&dev->core, "%s:%d\n", __func__, __LINE__);
+
+	/* Check if we got here via a power button event. */
+
+	if (ps3_sm_force_power_off) {
+		dev_dbg(&dev->core, "%s:%d: forcing poweroff\n",
+			__func__, __LINE__);
+		ps3_sys_manager_final_power_off(dev);
+	}
+
+	ps3_vuart_cancel_async(dev);
+
+	ps3_sys_manager_send_attr(dev, 0);
+	ps3_sys_manager_send_next_op(dev, PS3_SM_NEXT_OP_LPAR_REBOOT,
+		PS3_SM_WAKE_DEFAULT);
+	ps3_sys_manager_send_request_shutdown(dev);
+
+	printk(KERN_EMERG "System Halted, OK to turn off power\n");
+
+	while(1)
+		ps3_sys_manager_handle_msg(dev);
+}
+
+/**
+ * ps3_sys_manager_work - Asynchronous read handler.
+ *
+ * Signaled when PS3_SM_RX_MSG_LEN_MIN bytes arrive at the vuart port.
+ */
+
+static void ps3_sys_manager_work(struct ps3_system_bus_device *dev)
+{
+	ps3_sys_manager_handle_msg(dev);
+	ps3_vuart_read_async(dev, PS3_SM_RX_MSG_LEN_MIN);
+}
+
+static int ps3_sys_manager_probe(struct ps3_system_bus_device *dev)
+{
+	int result;
+	struct ps3_sys_manager_ops ops;
+
+	dev_dbg(&dev->core, "%s:%d\n", __func__, __LINE__);
+
+	ops.power_off = ps3_sys_manager_final_power_off;
+	ops.restart = ps3_sys_manager_final_restart;
+	ops.dev = dev;
+
+	/* ps3_sys_manager_register_ops copies ops. */
+
+	ps3_sys_manager_register_ops(&ops);
+
+	result = ps3_sys_manager_send_attr(dev, PS3_SM_ATTR_ALL);
+	BUG_ON(result);
+
+	result = ps3_vuart_read_async(dev, PS3_SM_RX_MSG_LEN_MIN);
+	BUG_ON(result);
+
+	return result;
+}
+
+static int ps3_sys_manager_remove(struct ps3_system_bus_device *dev)
+{
+	dev_dbg(&dev->core, "%s:%d\n", __func__, __LINE__);
+	return 0;
+}
+
+static void ps3_sys_manager_shutdown(struct ps3_system_bus_device *dev)
+{
+	dev_dbg(&dev->core, "%s:%d\n", __func__, __LINE__);
+}
+
+static struct ps3_vuart_port_driver ps3_sys_manager = {
+	.core.match_id = PS3_MATCH_ID_SYSTEM_MANAGER,
+	.core.core.name = "ps3_sys_manager",
+	.probe = ps3_sys_manager_probe,
+	.remove = ps3_sys_manager_remove,
+	.shutdown = ps3_sys_manager_shutdown,
+	.work = ps3_sys_manager_work,
+};
+
+static int __init ps3_sys_manager_init(void)
+{
+	if (!firmware_has_feature(FW_FEATURE_PS3_LV1))
+		return -ENODEV;
+
+	return ps3_vuart_port_driver_register(&ps3_sys_manager);
+}
+
+module_init(ps3_sys_manager_init);
+/* Module remove not supported. */
+
+MODULE_ALIAS(PS3_MODULE_ALIAS_SYSTEM_MANAGER);
diff -puN /dev/null drivers/ps3/ps3-vuart.c
--- /dev/null
+++ a/drivers/ps3/ps3-vuart.c
@@ -0,0 +1,1271 @@
+/*
+ *  PS3 virtual uart
+ *
+ *  Copyright (C) 2006 Sony Computer Entertainment Inc.
+ *  Copyright 2006 Sony Corp.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+#include <linux/bitops.h>
+#include <asm/ps3.h>
+
+#include <asm/firmware.h>
+#include <asm/lv1call.h>
+
+#include "vuart.h"
+
+MODULE_AUTHOR("Sony Corporation");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("PS3 vuart");
+
+/**
+ * vuart - An inter-partition data link service.
+ *  port 0: PS3 AV Settings.
+ *  port 2: PS3 System Manager.
+ *
+ * The vuart provides a bi-directional byte stream data link between logical
+ * partitions.  Its primary role is as a communications link between the guest
+ * OS and the system policy module.  The current HV does not support any
+ * connections other than those listed.
+ */
+
+enum {PORT_COUNT = 3,};
+
+enum vuart_param {
+	PARAM_TX_TRIGGER = 0,
+	PARAM_RX_TRIGGER = 1,
+	PARAM_INTERRUPT_MASK = 2,
+	PARAM_RX_BUF_SIZE = 3, /* read only */
+	PARAM_RX_BYTES = 4, /* read only */
+	PARAM_TX_BUF_SIZE = 5, /* read only */
+	PARAM_TX_BYTES = 6, /* read only */
+	PARAM_INTERRUPT_STATUS = 7, /* read only */
+};
+
+enum vuart_interrupt_bit {
+	INTERRUPT_BIT_TX = 0,
+	INTERRUPT_BIT_RX = 1,
+	INTERRUPT_BIT_DISCONNECT = 2,
+};
+
+enum vuart_interrupt_mask {
+	INTERRUPT_MASK_TX = 1,
+	INTERRUPT_MASK_RX = 2,
+	INTERRUPT_MASK_DISCONNECT = 4,
+};
+
+/**
+ * struct ps3_vuart_port_priv - private vuart device data.
+ */
+
+struct ps3_vuart_port_priv {
+	u64 interrupt_mask;
+
+	struct {
+		spinlock_t lock;
+		struct list_head head;
+	} tx_list;
+	struct {
+		struct ps3_vuart_work work;
+		unsigned long bytes_held;
+		spinlock_t lock;
+		struct list_head head;
+	} rx_list;
+	struct ps3_vuart_stats stats;
+};
+
+static struct ps3_vuart_port_priv *to_port_priv(
+	struct ps3_system_bus_device *dev)
+{
+	BUG_ON(!dev);
+	BUG_ON(!dev->driver_priv);
+	return (struct ps3_vuart_port_priv *)dev->driver_priv;
+}
+
+/**
+ * struct ports_bmp - bitmap indicating ports needing service.
+ *
+ * A 256 bit read only bitmap indicating ports needing service.  Do not write
+ * to these bits.  Must not cross a page boundary.
+ */
+
+struct ports_bmp {
+	u64 status;
+	u64 unused[3];
+} __attribute__ ((aligned (32)));
+
+#define dump_ports_bmp(_b) _dump_ports_bmp(_b, __func__, __LINE__)
+static void __maybe_unused _dump_ports_bmp(
+	const struct ports_bmp* bmp, const char* func, int line)
+{
+	pr_debug("%s:%d: ports_bmp: %016lxh\n", func, line, bmp->status);
+}
+
+#define dump_port_params(_b) _dump_port_params(_b, __func__, __LINE__)
+static void __maybe_unused _dump_port_params(unsigned int port_number,
+	const char* func, int line)
+{
+#if defined(DEBUG)
+	static const char *strings[] = {
+		"tx_trigger      ",
+		"rx_trigger      ",
+		"interrupt_mask  ",
+		"rx_buf_size     ",
+		"rx_bytes        ",
+		"tx_buf_size     ",
+		"tx_bytes        ",
+		"interrupt_status",
+	};
+	int result;
+	unsigned int i;
+	u64 value;
+
+	for (i = 0; i < ARRAY_SIZE(strings); i++) {
+		result = lv1_get_virtual_uart_param(port_number, i, &value);
+
+		if (result) {
+			pr_debug("%s:%d: port_%u: %s failed: %s\n", func, line,
+				port_number, strings[i], ps3_result(result));
+			continue;
+		}
+		pr_debug("%s:%d: port_%u: %s = %lxh\n",
+			func, line, port_number, strings[i], value);
+	}
+#endif
+}
+
+struct vuart_triggers {
+	unsigned long rx;
+	unsigned long tx;
+};
+
+int ps3_vuart_get_triggers(struct ps3_system_bus_device *dev,
+	struct vuart_triggers *trig)
+{
+	int result;
+	unsigned long size;
+	unsigned long val;
+
+	result = lv1_get_virtual_uart_param(dev->port_number,
+		PARAM_TX_TRIGGER, &trig->tx);
+
+	if (result) {
+		dev_dbg(&dev->core, "%s:%d: tx_trigger failed: %s\n",
+			__func__, __LINE__, ps3_result(result));
+		return result;
+	}
+
+	result = lv1_get_virtual_uart_param(dev->port_number,
+		PARAM_RX_BUF_SIZE, &size);
+
+	if (result) {
+		dev_dbg(&dev->core, "%s:%d: tx_buf_size failed: %s\n",
+			__func__, __LINE__, ps3_result(result));
+		return result;
+	}
+
+	result = lv1_get_virtual_uart_param(dev->port_number,
+		PARAM_RX_TRIGGER, &val);
+
+	if (result) {
+		dev_dbg(&dev->core, "%s:%d: rx_trigger failed: %s\n",
+			__func__, __LINE__, ps3_result(result));
+		return result;
+	}
+
+	trig->rx = size - val;
+
+	dev_dbg(&dev->core, "%s:%d: tx %lxh, rx %lxh\n", __func__, __LINE__,
+		trig->tx, trig->rx);
+
+	return result;
+}
+
+int ps3_vuart_set_triggers(struct ps3_system_bus_device *dev, unsigned int tx,
+	unsigned int rx)
+{
+	int result;
+	unsigned long size;
+
+	result = lv1_set_virtual_uart_param(dev->port_number,
+		PARAM_TX_TRIGGER, tx);
+
+	if (result) {
+		dev_dbg(&dev->core, "%s:%d: tx_trigger failed: %s\n",
+			__func__, __LINE__, ps3_result(result));
+		return result;
+	}
+
+	result = lv1_get_virtual_uart_param(dev->port_number,
+		PARAM_RX_BUF_SIZE, &size);
+
+	if (result) {
+		dev_dbg(&dev->core, "%s:%d: tx_buf_size failed: %s\n",
+			__func__, __LINE__, ps3_result(result));
+		return result;
+	}
+
+	result = lv1_set_virtual_uart_param(dev->port_number,
+		PARAM_RX_TRIGGER, size - rx);
+
+	if (result) {
+		dev_dbg(&dev->core, "%s:%d: rx_trigger failed: %s\n",
+			__func__, __LINE__, ps3_result(result));
+		return result;
+	}
+
+	dev_dbg(&dev->core, "%s:%d: tx %xh, rx %xh\n", __func__, __LINE__,
+		tx, rx);
+
+	return result;
+}
+
+static int ps3_vuart_get_rx_bytes_waiting(struct ps3_system_bus_device *dev,
+	u64 *bytes_waiting)
+{
+	int result;
+
+	result = lv1_get_virtual_uart_param(dev->port_number,
+		PARAM_RX_BYTES, bytes_waiting);
+
+	if (result)
+		dev_dbg(&dev->core, "%s:%d: rx_bytes failed: %s\n",
+			__func__, __LINE__, ps3_result(result));
+
+	dev_dbg(&dev->core, "%s:%d: %lxh\n", __func__, __LINE__,
+		*bytes_waiting);
+	return result;
+}
+
+/**
+ * ps3_vuart_set_interrupt_mask - Enable/disable the port interrupt sources.
+ * @dev: The struct ps3_system_bus_device instance.
+ * @bmp: Logical OR of enum vuart_interrupt_mask values. A zero bit disables.
+ */
+
+static int ps3_vuart_set_interrupt_mask(struct ps3_system_bus_device *dev,
+	unsigned long mask)
+{
+	int result;
+	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
+
+	dev_dbg(&dev->core, "%s:%d: %lxh\n", __func__, __LINE__, mask);
+
+	priv->interrupt_mask = mask;
+
+	result = lv1_set_virtual_uart_param(dev->port_number,
+		PARAM_INTERRUPT_MASK, priv->interrupt_mask);
+
+	if (result)
+		dev_dbg(&dev->core, "%s:%d: interrupt_mask failed: %s\n",
+			__func__, __LINE__, ps3_result(result));
+
+	return result;
+}
+
+static int ps3_vuart_get_interrupt_status(struct ps3_system_bus_device *dev,
+	unsigned long *status)
+{
+	int result;
+	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
+	u64 tmp;
+
+	result = lv1_get_virtual_uart_param(dev->port_number,
+		PARAM_INTERRUPT_STATUS, &tmp);
+
+	if (result)
+		dev_dbg(&dev->core, "%s:%d: interrupt_status failed: %s\n",
+			__func__, __LINE__, ps3_result(result));
+
+	*status = tmp & priv->interrupt_mask;
+
+	dev_dbg(&dev->core, "%s:%d: m %lxh, s %lxh, m&s %lxh\n",
+		__func__, __LINE__, priv->interrupt_mask, tmp, *status);
+
+	return result;
+}
+
+int ps3_vuart_enable_interrupt_tx(struct ps3_system_bus_device *dev)
+{
+	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
+
+	return (priv->interrupt_mask & INTERRUPT_MASK_TX) ? 0
+		: ps3_vuart_set_interrupt_mask(dev, priv->interrupt_mask
+		| INTERRUPT_MASK_TX);
+}
+
+int ps3_vuart_enable_interrupt_rx(struct ps3_system_bus_device *dev)
+{
+	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
+
+	return (priv->interrupt_mask & INTERRUPT_MASK_RX) ? 0
+		: ps3_vuart_set_interrupt_mask(dev, priv->interrupt_mask
+		| INTERRUPT_MASK_RX);
+}
+
+int ps3_vuart_enable_interrupt_disconnect(struct ps3_system_bus_device *dev)
+{
+	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
+
+	return (priv->interrupt_mask & INTERRUPT_MASK_DISCONNECT) ? 0
+		: ps3_vuart_set_interrupt_mask(dev, priv->interrupt_mask
+		| INTERRUPT_MASK_DISCONNECT);
+}
+
+int ps3_vuart_disable_interrupt_tx(struct ps3_system_bus_device *dev)
+{
+	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
+
+	return (priv->interrupt_mask & INTERRUPT_MASK_TX)
+		? ps3_vuart_set_interrupt_mask(dev, priv->interrupt_mask
+		& ~INTERRUPT_MASK_TX) : 0;
+}
+
+int ps3_vuart_disable_interrupt_rx(struct ps3_system_bus_device *dev)
+{
+	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
+
+	return (priv->interrupt_mask & INTERRUPT_MASK_RX)
+		? ps3_vuart_set_interrupt_mask(dev, priv->interrupt_mask
+		& ~INTERRUPT_MASK_RX) : 0;
+}
+
+int ps3_vuart_disable_interrupt_disconnect(struct ps3_system_bus_device *dev)
+{
+	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
+
+	return (priv->interrupt_mask & INTERRUPT_MASK_DISCONNECT)
+		? ps3_vuart_set_interrupt_mask(dev, priv->interrupt_mask
+		& ~INTERRUPT_MASK_DISCONNECT) : 0;
+}
+
+/**
+ * ps3_vuart_raw_write - Low level write helper.
+ * @dev: The struct ps3_system_bus_device instance.
+ *
+ * Do not call ps3_vuart_raw_write directly, use ps3_vuart_write.
+ */
+
+static int ps3_vuart_raw_write(struct ps3_system_bus_device *dev,
+	const void* buf, unsigned int bytes, unsigned long *bytes_written)
+{
+	int result;
+	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
+
+	result = lv1_write_virtual_uart(dev->port_number,
+		ps3_mm_phys_to_lpar(__pa(buf)), bytes, bytes_written);
+
+	if (result) {
+		dev_dbg(&dev->core, "%s:%d: lv1_write_virtual_uart failed: "
+			"%s\n", __func__, __LINE__, ps3_result(result));
+		return result;
+	}
+
+	priv->stats.bytes_written += *bytes_written;
+
+	dev_dbg(&dev->core, "%s:%d: wrote %lxh/%xh=>%lxh\n", __func__, __LINE__,
+		*bytes_written, bytes, priv->stats.bytes_written);
+
+	return result;
+}
+
+/**
+ * ps3_vuart_raw_read - Low level read helper.
+ * @dev: The struct ps3_system_bus_device instance.
+ *
+ * Do not call ps3_vuart_raw_read directly, use ps3_vuart_read.
+ */
+
+static int ps3_vuart_raw_read(struct ps3_system_bus_device *dev, void *buf,
+	unsigned int bytes, unsigned long *bytes_read)
+{
+	int result;
+	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
+
+	dev_dbg(&dev->core, "%s:%d: %xh\n", __func__, __LINE__, bytes);
+
+	result = lv1_read_virtual_uart(dev->port_number,
+		ps3_mm_phys_to_lpar(__pa(buf)), bytes, bytes_read);
+
+	if (result) {
+		dev_dbg(&dev->core, "%s:%d: lv1_read_virtual_uart failed: %s\n",
+			__func__, __LINE__, ps3_result(result));
+		return result;
+	}
+
+	priv->stats.bytes_read += *bytes_read;
+
+	dev_dbg(&dev->core, "%s:%d: read %lxh/%xh=>%lxh\n", __func__, __LINE__,
+		*bytes_read, bytes, priv->stats.bytes_read);
+
+	return result;
+}
+
+/**
+ * ps3_vuart_clear_rx_bytes - Discard bytes received.
+ * @dev: The struct ps3_system_bus_device instance.
+ * @bytes: Max byte count to discard, zero = all pending.
+ *
+ * Used to clear pending rx interrupt source.  Will not block.
+ */
+
+void ps3_vuart_clear_rx_bytes(struct ps3_system_bus_device *dev,
+	unsigned int bytes)
+{
+	int result;
+	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
+	u64 bytes_waiting;
+	void* tmp;
+
+	result = ps3_vuart_get_rx_bytes_waiting(dev, &bytes_waiting);
+
+	BUG_ON(result);
+
+	bytes = bytes ? min(bytes, (unsigned int)bytes_waiting) : bytes_waiting;
+
+	dev_dbg(&dev->core, "%s:%d: %u\n", __func__, __LINE__, bytes);
+
+	if (!bytes)
+		return;
+
+	/* Add some extra space for recently arrived data. */
+
+	bytes += 128;
+
+	tmp = kmalloc(bytes, GFP_KERNEL);
+
+	if (!tmp)
+		return;
+
+	ps3_vuart_raw_read(dev, tmp, bytes, &bytes_waiting);
+
+	kfree(tmp);
+
+	/* Don't include these bytes in the stats. */
+
+	priv->stats.bytes_read -= bytes_waiting;
+}
+EXPORT_SYMBOL_GPL(ps3_vuart_clear_rx_bytes);
+
+/**
+ * struct list_buffer - An element for a port device fifo buffer list.
+ */
+
+struct list_buffer {
+	struct list_head link;
+	const unsigned char *head;
+	const unsigned char *tail;
+	unsigned long dbg_number;
+	unsigned char data[];
+};
+
+/**
+ * ps3_vuart_write - the entry point for writing data to a port
+ * @dev: The struct ps3_system_bus_device instance.
+ *
+ * If the port is idle on entry as much of the incoming data is written to
+ * the port as the port will accept.  Otherwise a list buffer is created
+ * and any remaning incoming data is copied to that buffer.  The buffer is
+ * then enqueued for transmision via the transmit interrupt.
+ */
+
+int ps3_vuart_write(struct ps3_system_bus_device *dev, const void *buf,
+	unsigned int bytes)
+{
+	static unsigned long dbg_number;
+	int result;
+	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
+	unsigned long flags;
+	struct list_buffer *lb;
+
+	dev_dbg(&dev->core, "%s:%d: %u(%xh) bytes\n", __func__, __LINE__,
+		bytes, bytes);
+
+	spin_lock_irqsave(&priv->tx_list.lock, flags);
+
+	if (list_empty(&priv->tx_list.head)) {
+		unsigned long bytes_written;
+
+		result = ps3_vuart_raw_write(dev, buf, bytes, &bytes_written);
+
+		spin_unlock_irqrestore(&priv->tx_list.lock, flags);
+
+		if (result) {
+			dev_dbg(&dev->core,
+				"%s:%d: ps3_vuart_raw_write failed\n",
+				__func__, __LINE__);
+			return result;
+		}
+
+		if (bytes_written == bytes) {
+			dev_dbg(&dev->core, "%s:%d: wrote %xh bytes\n",
+				__func__, __LINE__, bytes);
+			return 0;
+		}
+
+		bytes -= bytes_written;
+		buf += bytes_written;
+	} else
+		spin_unlock_irqrestore(&priv->tx_list.lock, flags);
+
+	lb = kmalloc(sizeof(struct list_buffer) + bytes, GFP_KERNEL);
+
+	if (!lb) {
+		return -ENOMEM;
+	}
+
+	memcpy(lb->data, buf, bytes);
+	lb->head = lb->data;
+	lb->tail = lb->data + bytes;
+	lb->dbg_number = ++dbg_number;
+
+	spin_lock_irqsave(&priv->tx_list.lock, flags);
+	list_add_tail(&lb->link, &priv->tx_list.head);
+	ps3_vuart_enable_interrupt_tx(dev);
+	spin_unlock_irqrestore(&priv->tx_list.lock, flags);
+
+	dev_dbg(&dev->core, "%s:%d: queued buf_%lu, %xh bytes\n",
+		__func__, __LINE__, lb->dbg_number, bytes);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ps3_vuart_write);
+
+/**
+ * ps3_vuart_queue_rx_bytes - Queue waiting bytes into the buffer list.
+ * @dev: The struct ps3_system_bus_device instance.
+ * @bytes_queued: Number of bytes queued to the buffer list.
+ *
+ * Must be called with priv->rx_list.lock held.
+ */
+
+static int ps3_vuart_queue_rx_bytes(struct ps3_system_bus_device *dev,
+	u64 *bytes_queued)
+{
+	static unsigned long dbg_number;
+	int result;
+	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
+	struct list_buffer *lb;
+	u64 bytes;
+
+	*bytes_queued = 0;
+
+	result = ps3_vuart_get_rx_bytes_waiting(dev, &bytes);
+	BUG_ON(result);
+
+	if (result)
+		return -EIO;
+
+	if (!bytes)
+		return 0;
+
+	/* Add some extra space for recently arrived data. */
+
+	bytes += 128;
+
+	lb = kmalloc(sizeof(struct list_buffer) + bytes, GFP_ATOMIC);
+
+	if (!lb)
+		return -ENOMEM;
+
+	ps3_vuart_raw_read(dev, lb->data, bytes, &bytes);
+
+	lb->head = lb->data;
+	lb->tail = lb->data + bytes;
+	lb->dbg_number = ++dbg_number;
+
+	list_add_tail(&lb->link, &priv->rx_list.head);
+	priv->rx_list.bytes_held += bytes;
+
+	dev_dbg(&dev->core, "%s:%d: buf_%lu: queued %lxh bytes\n",
+		__func__, __LINE__, lb->dbg_number, bytes);
+
+	*bytes_queued = bytes;
+
+	return 0;
+}
+
+/**
+ * ps3_vuart_read - The entry point for reading data from a port.
+ *
+ * Queue data waiting at the port, and if enough bytes to satisfy the request
+ * are held in the buffer list those bytes are dequeued and copied to the
+ * caller's buffer.  Emptied list buffers are retiered.  If the request cannot
+ * be statified by bytes held in the list buffers -EAGAIN is returned.
+ */
+
+int ps3_vuart_read(struct ps3_system_bus_device *dev, void *buf,
+	unsigned int bytes)
+{
+	int result;
+	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
+	unsigned long flags;
+	struct list_buffer *lb, *n;
+	unsigned long bytes_read;
+
+	dev_dbg(&dev->core, "%s:%d: %u(%xh) bytes\n", __func__, __LINE__,
+		bytes, bytes);
+
+	spin_lock_irqsave(&priv->rx_list.lock, flags);
+
+	/* Queue rx bytes here for polled reads. */
+
+	while (priv->rx_list.bytes_held < bytes) {
+		u64 tmp;
+
+		result = ps3_vuart_queue_rx_bytes(dev, &tmp);
+		if (result || !tmp) {
+			dev_dbg(&dev->core, "%s:%d: starved for %lxh bytes\n",
+				__func__, __LINE__,
+				bytes - priv->rx_list.bytes_held);
+			spin_unlock_irqrestore(&priv->rx_list.lock, flags);
+			return -EAGAIN;
+		}
+	}
+
+	list_for_each_entry_safe(lb, n, &priv->rx_list.head, link) {
+		bytes_read = min((unsigned int)(lb->tail - lb->head), bytes);
+
+		memcpy(buf, lb->head, bytes_read);
+		buf += bytes_read;
+		bytes -= bytes_read;
+		priv->rx_list.bytes_held -= bytes_read;
+
+		if (bytes_read < lb->tail - lb->head) {
+			lb->head += bytes_read;
+			dev_dbg(&dev->core, "%s:%d: buf_%lu: dequeued %lxh "
+				"bytes\n", __func__, __LINE__, lb->dbg_number,
+				bytes_read);
+			spin_unlock_irqrestore(&priv->rx_list.lock, flags);
+			return 0;
+		}
+
+		dev_dbg(&dev->core, "%s:%d: buf_%lu: free, dequeued %lxh "
+			"bytes\n", __func__, __LINE__, lb->dbg_number,
+			bytes_read);
+
+		list_del(&lb->link);
+		kfree(lb);
+	}
+
+	spin_unlock_irqrestore(&priv->rx_list.lock, flags);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ps3_vuart_read);
+
+/**
+ * ps3_vuart_work - Asynchronous read handler.
+ */
+
+static void ps3_vuart_work(struct work_struct *work)
+{
+	struct ps3_system_bus_device *dev =
+		ps3_vuart_work_to_system_bus_dev(work);
+	struct ps3_vuart_port_driver *drv =
+		ps3_system_bus_dev_to_vuart_drv(dev);
+
+	BUG_ON(!drv);
+	drv->work(dev);
+}
+
+int ps3_vuart_read_async(struct ps3_system_bus_device *dev, unsigned int bytes)
+{
+	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
+	unsigned long flags;
+
+	if (priv->rx_list.work.trigger) {
+		dev_dbg(&dev->core, "%s:%d: warning, multiple calls\n",
+			__func__, __LINE__);
+		return -EAGAIN;
+	}
+
+	BUG_ON(!bytes);
+
+	PREPARE_WORK(&priv->rx_list.work.work, ps3_vuart_work);
+
+	spin_lock_irqsave(&priv->rx_list.lock, flags);
+	if (priv->rx_list.bytes_held >= bytes) {
+		dev_dbg(&dev->core, "%s:%d: schedule_work %xh bytes\n",
+			__func__, __LINE__, bytes);
+		schedule_work(&priv->rx_list.work.work);
+		spin_unlock_irqrestore(&priv->rx_list.lock, flags);
+		return 0;
+	}
+
+	priv->rx_list.work.trigger = bytes;
+	spin_unlock_irqrestore(&priv->rx_list.lock, flags);
+
+	dev_dbg(&dev->core, "%s:%d: waiting for %u(%xh) bytes\n", __func__,
+		__LINE__, bytes, bytes);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ps3_vuart_read_async);
+
+void ps3_vuart_cancel_async(struct ps3_system_bus_device *dev)
+{
+	to_port_priv(dev)->rx_list.work.trigger = 0;
+}
+EXPORT_SYMBOL_GPL(ps3_vuart_cancel_async);
+
+/**
+ * ps3_vuart_handle_interrupt_tx - third stage transmit interrupt handler
+ *
+ * Services the transmit interrupt for the port.  Writes as much data from the
+ * buffer list as the port will accept.  Retires any emptied list buffers and
+ * adjusts the final list buffer state for a partial write.
+ */
+
+static int ps3_vuart_handle_interrupt_tx(struct ps3_system_bus_device *dev)
+{
+	int result = 0;
+	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
+	unsigned long flags;
+	struct list_buffer *lb, *n;
+	unsigned long bytes_total = 0;
+
+	dev_dbg(&dev->core, "%s:%d\n", __func__, __LINE__);
+
+	spin_lock_irqsave(&priv->tx_list.lock, flags);
+
+	list_for_each_entry_safe(lb, n, &priv->tx_list.head, link) {
+
+		unsigned long bytes_written;
+
+		result = ps3_vuart_raw_write(dev, lb->head, lb->tail - lb->head,
+			&bytes_written);
+
+		if (result) {
+			dev_dbg(&dev->core,
+				"%s:%d: ps3_vuart_raw_write failed\n",
+				__func__, __LINE__);
+			break;
+		}
+
+		bytes_total += bytes_written;
+
+		if (bytes_written < lb->tail - lb->head) {
+			lb->head += bytes_written;
+			dev_dbg(&dev->core,
+				"%s:%d cleared buf_%lu, %lxh bytes\n",
+				__func__, __LINE__, lb->dbg_number,
+				bytes_written);
+			goto port_full;
+		}
+
+		dev_dbg(&dev->core, "%s:%d free buf_%lu\n", __func__, __LINE__,
+			lb->dbg_number);
+
+		list_del(&lb->link);
+		kfree(lb);
+	}
+
+	ps3_vuart_disable_interrupt_tx(dev);
+port_full:
+	spin_unlock_irqrestore(&priv->tx_list.lock, flags);
+	dev_dbg(&dev->core, "%s:%d wrote %lxh bytes total\n",
+		__func__, __LINE__, bytes_total);
+	return result;
+}
+
+/**
+ * ps3_vuart_handle_interrupt_rx - third stage receive interrupt handler
+ *
+ * Services the receive interrupt for the port.  Creates a list buffer and
+ * copies all waiting port data to that buffer and enqueues the buffer in the
+ * buffer list.  Buffer list data is dequeued via ps3_vuart_read.
+ */
+
+static int ps3_vuart_handle_interrupt_rx(struct ps3_system_bus_device *dev)
+{
+	int result;
+	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
+	unsigned long flags;
+	u64 bytes;
+
+	dev_dbg(&dev->core, "%s:%d\n", __func__, __LINE__);
+
+	spin_lock_irqsave(&priv->rx_list.lock, flags);
+	result = ps3_vuart_queue_rx_bytes(dev, &bytes);
+
+	if (result) {
+		spin_unlock_irqrestore(&priv->rx_list.lock, flags);
+		return result;
+	}
+
+	if (priv->rx_list.work.trigger && priv->rx_list.bytes_held
+		>= priv->rx_list.work.trigger) {
+		dev_dbg(&dev->core, "%s:%d: schedule_work %lxh bytes\n",
+			__func__, __LINE__, priv->rx_list.work.trigger);
+		priv->rx_list.work.trigger = 0;
+		schedule_work(&priv->rx_list.work.work);
+	}
+
+	spin_unlock_irqrestore(&priv->rx_list.lock, flags);
+	return result;
+}
+
+static int ps3_vuart_handle_interrupt_disconnect(
+	struct ps3_system_bus_device *dev)
+{
+	dev_dbg(&dev->core, "%s:%d\n", __func__, __LINE__);
+	BUG_ON("no support");
+	return -1;
+}
+
+/**
+ * ps3_vuart_handle_port_interrupt - second stage interrupt handler
+ *
+ * Services any pending interrupt types for the port.  Passes control to the
+ * third stage type specific interrupt handler.  Returns control to the first
+ * stage handler after one iteration.
+ */
+
+static int ps3_vuart_handle_port_interrupt(struct ps3_system_bus_device *dev)
+{
+	int result;
+	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
+	unsigned long status;
+
+	result = ps3_vuart_get_interrupt_status(dev, &status);
+
+	if (result)
+		return result;
+
+	dev_dbg(&dev->core, "%s:%d: status: %lxh\n", __func__, __LINE__,
+		status);
+
+	if (status & INTERRUPT_MASK_DISCONNECT) {
+		priv->stats.disconnect_interrupts++;
+		result = ps3_vuart_handle_interrupt_disconnect(dev);
+		if (result)
+			ps3_vuart_disable_interrupt_disconnect(dev);
+	}
+
+	if (status & INTERRUPT_MASK_TX) {
+		priv->stats.tx_interrupts++;
+		result = ps3_vuart_handle_interrupt_tx(dev);
+		if (result)
+			ps3_vuart_disable_interrupt_tx(dev);
+	}
+
+	if (status & INTERRUPT_MASK_RX) {
+		priv->stats.rx_interrupts++;
+		result = ps3_vuart_handle_interrupt_rx(dev);
+		if (result)
+			ps3_vuart_disable_interrupt_rx(dev);
+	}
+
+	return 0;
+}
+
+struct vuart_bus_priv {
+	struct ports_bmp *bmp;
+	unsigned int virq;
+	struct semaphore probe_mutex;
+	int use_count;
+	struct ps3_system_bus_device *devices[PORT_COUNT];
+} static vuart_bus_priv;
+
+/**
+ * ps3_vuart_irq_handler - first stage interrupt handler
+ *
+ * Loops finding any interrupting port and its associated instance data.
+ * Passes control to the second stage port specific interrupt handler.  Loops
+ * until all outstanding interrupts are serviced.
+ */
+
+static irqreturn_t ps3_vuart_irq_handler(int irq, void *_private)
+{
+	struct vuart_bus_priv *bus_priv = _private;
+
+	BUG_ON(!bus_priv);
+
+	while (1) {
+		unsigned int port;
+
+		dump_ports_bmp(bus_priv->bmp);
+
+		port = (BITS_PER_LONG - 1) - __ilog2(bus_priv->bmp->status);
+
+		if (port == BITS_PER_LONG)
+			break;
+
+		BUG_ON(port >= PORT_COUNT);
+		BUG_ON(!bus_priv->devices[port]);
+
+		ps3_vuart_handle_port_interrupt(bus_priv->devices[port]);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int ps3_vuart_bus_interrupt_get(void)
+{
+	int result;
+
+	pr_debug(" -> %s:%d\n", __func__, __LINE__);
+
+	vuart_bus_priv.use_count++;
+
+	BUG_ON(vuart_bus_priv.use_count > 2);
+
+	if (vuart_bus_priv.use_count != 1) {
+		return 0;
+	}
+
+	BUG_ON(vuart_bus_priv.bmp);
+
+	vuart_bus_priv.bmp = kzalloc(sizeof(struct ports_bmp), GFP_KERNEL);
+
+	if (!vuart_bus_priv.bmp) {
+		pr_debug("%s:%d: kzalloc failed.\n", __func__, __LINE__);
+		result = -ENOMEM;
+		goto fail_bmp_malloc;
+	}
+
+	result = ps3_vuart_irq_setup(PS3_BINDING_CPU_ANY, vuart_bus_priv.bmp,
+		&vuart_bus_priv.virq);
+
+	if (result) {
+		pr_debug("%s:%d: ps3_vuart_irq_setup failed (%d)\n",
+			__func__, __LINE__, result);
+		result = -EPERM;
+		goto fail_alloc_irq;
+	}
+
+	result = request_irq(vuart_bus_priv.virq, ps3_vuart_irq_handler,
+		IRQF_DISABLED, "vuart", &vuart_bus_priv);
+
+	if (result) {
+		pr_debug("%s:%d: request_irq failed (%d)\n",
+			__func__, __LINE__, result);
+		goto fail_request_irq;
+	}
+
+	pr_debug(" <- %s:%d: ok\n", __func__, __LINE__);
+	return result;
+
+fail_request_irq:
+	ps3_vuart_irq_destroy(vuart_bus_priv.virq);
+	vuart_bus_priv.virq = NO_IRQ;
+fail_alloc_irq:
+	kfree(vuart_bus_priv.bmp);
+	vuart_bus_priv.bmp = NULL;
+fail_bmp_malloc:
+	vuart_bus_priv.use_count--;
+	pr_debug(" <- %s:%d: failed\n", __func__, __LINE__);
+	return result;
+}
+
+static int ps3_vuart_bus_interrupt_put(void)
+{
+	pr_debug(" -> %s:%d\n", __func__, __LINE__);
+
+	vuart_bus_priv.use_count--;
+
+	BUG_ON(vuart_bus_priv.use_count < 0);
+
+	if (vuart_bus_priv.use_count != 0)
+		return 0;
+
+	free_irq(vuart_bus_priv.virq, &vuart_bus_priv);
+
+	ps3_vuart_irq_destroy(vuart_bus_priv.virq);
+	vuart_bus_priv.virq = NO_IRQ;
+
+	kfree(vuart_bus_priv.bmp);
+	vuart_bus_priv.bmp = NULL;
+
+	pr_debug(" <- %s:%d\n", __func__, __LINE__);
+	return 0;
+}
+
+static int ps3_vuart_probe(struct ps3_system_bus_device *dev)
+{
+	int result;
+	struct ps3_vuart_port_driver *drv;
+	struct ps3_vuart_port_priv *priv = NULL;
+
+	dev_dbg(&dev->core, "%s:%d\n", __func__, __LINE__);
+
+	drv = ps3_system_bus_dev_to_vuart_drv(dev);
+
+	dev_dbg(&dev->core, "%s:%d: (%s)\n", __func__, __LINE__,
+		drv->core.core.name);
+
+	BUG_ON(!drv);
+
+	if (dev->port_number >= PORT_COUNT) {
+		BUG();
+		return -EINVAL;
+	}
+
+	down(&vuart_bus_priv.probe_mutex);
+
+	result = ps3_vuart_bus_interrupt_get();
+
+	if (result)
+		goto fail_setup_interrupt;
+
+	if (vuart_bus_priv.devices[dev->port_number]) {
+		dev_dbg(&dev->core, "%s:%d: port busy (%d)\n", __func__,
+			__LINE__, dev->port_number);
+		result = -EBUSY;
+		goto fail_busy;
+	}
+
+	vuart_bus_priv.devices[dev->port_number] = dev;
+
+	/* Setup dev->driver_priv. */
+
+	dev->driver_priv = kzalloc(sizeof(struct ps3_vuart_port_priv),
+		GFP_KERNEL);
+
+	if (!dev->driver_priv) {
+		result = -ENOMEM;
+		goto fail_dev_malloc;
+	}
+
+	priv = to_port_priv(dev);
+
+	INIT_LIST_HEAD(&priv->tx_list.head);
+	spin_lock_init(&priv->tx_list.lock);
+
+	INIT_LIST_HEAD(&priv->rx_list.head);
+	spin_lock_init(&priv->rx_list.lock);
+
+	INIT_WORK(&priv->rx_list.work.work, NULL);
+	priv->rx_list.work.trigger = 0;
+	priv->rx_list.work.dev = dev;
+
+	/* clear stale pending interrupts */
+
+	ps3_vuart_clear_rx_bytes(dev, 0);
+
+	ps3_vuart_set_interrupt_mask(dev, INTERRUPT_MASK_RX);
+
+	ps3_vuart_set_triggers(dev, 1, 1);
+
+	if (drv->probe)
+		result = drv->probe(dev);
+	else {
+		result = 0;
+		dev_info(&dev->core, "%s:%d: no probe method\n", __func__,
+			__LINE__);
+	}
+
+	if (result) {
+		dev_dbg(&dev->core, "%s:%d: drv->probe failed\n",
+			__func__, __LINE__);
+		down(&vuart_bus_priv.probe_mutex);
+		goto fail_probe;
+	}
+
+	up(&vuart_bus_priv.probe_mutex);
+
+	return result;
+
+fail_probe:
+	ps3_vuart_set_interrupt_mask(dev, 0);
+	kfree(dev->driver_priv);
+	dev->driver_priv = NULL;
+fail_dev_malloc:
+	vuart_bus_priv.devices[dev->port_number] = NULL;
+fail_busy:
+	ps3_vuart_bus_interrupt_put();
+fail_setup_interrupt:
+	up(&vuart_bus_priv.probe_mutex);
+	dev_dbg(&dev->core, "%s:%d: failed\n", __func__, __LINE__);
+	return result;
+}
+
+/**
+ * ps3_vuart_cleanup - common cleanup helper.
+ * @dev: The struct ps3_system_bus_device instance.
+ *
+ * Cleans interrupts and HV resources.  Must be called with
+ * vuart_bus_priv.probe_mutex held.  Used by ps3_vuart_remove and
+ * ps3_vuart_shutdown.  After this call, polled reading will still work.
+ */
+
+static int ps3_vuart_cleanup(struct ps3_system_bus_device *dev)
+{
+	dev_dbg(&dev->core, "%s:%d\n", __func__, __LINE__);
+
+	ps3_vuart_cancel_async(dev);
+	ps3_vuart_set_interrupt_mask(dev, 0);
+	ps3_vuart_bus_interrupt_put();
+	return 0;
+}
+
+/**
+ * ps3_vuart_remove - Completely clean the device instance.
+ * @dev: The struct ps3_system_bus_device instance.
+ *
+ * Cleans all memory, interrupts and HV resources.  After this call the
+ * device can no longer be used.
+ */
+
+static int ps3_vuart_remove(struct ps3_system_bus_device *dev)
+{
+	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
+	struct ps3_vuart_port_driver *drv;
+
+	BUG_ON(!dev);
+
+	down(&vuart_bus_priv.probe_mutex);
+
+	dev_dbg(&dev->core, " -> %s:%d: match_id %d\n", __func__, __LINE__,
+		dev->match_id);
+
+	if (!dev->core.driver) {
+		dev_dbg(&dev->core, "%s:%d: no driver bound\n", __func__,
+			__LINE__);
+		up(&vuart_bus_priv.probe_mutex);
+		return 0;
+	}
+
+	drv = ps3_system_bus_dev_to_vuart_drv(dev);
+
+	BUG_ON(!drv);
+
+	if (drv->remove) {
+		drv->remove(dev);
+	} else {
+		dev_dbg(&dev->core, "%s:%d: no remove method\n", __func__,
+		__LINE__);
+		BUG();
+	}
+
+	ps3_vuart_cleanup(dev);
+
+	vuart_bus_priv.devices[dev->port_number] = NULL;
+	kfree(priv);
+	priv = NULL;
+
+	dev_dbg(&dev->core, " <- %s:%d\n", __func__, __LINE__);
+	up(&vuart_bus_priv.probe_mutex);
+	return 0;
+}
+
+/**
+ * ps3_vuart_shutdown - Cleans interrupts and HV resources.
+ * @dev: The struct ps3_system_bus_device instance.
+ *
+ * Cleans interrupts and HV resources.  After this call the
+ * device can still be used in polling mode.  This behavior required
+ * by sys-manager to be able to complete the device power operation
+ * sequence.
+ */
+
+static int ps3_vuart_shutdown(struct ps3_system_bus_device *dev)
+{
+	struct ps3_vuart_port_driver *drv;
+
+	BUG_ON(!dev);
+
+	down(&vuart_bus_priv.probe_mutex);
+
+	dev_dbg(&dev->core, " -> %s:%d: match_id %d\n", __func__, __LINE__,
+		dev->match_id);
+
+	if (!dev->core.driver) {
+		dev_dbg(&dev->core, "%s:%d: no driver bound\n", __func__,
+			__LINE__);
+		up(&vuart_bus_priv.probe_mutex);
+		return 0;
+	}
+
+	drv = ps3_system_bus_dev_to_vuart_drv(dev);
+
+	BUG_ON(!drv);
+
+	if (drv->shutdown)
+		drv->shutdown(dev);
+	else if (drv->remove) {
+		dev_dbg(&dev->core, "%s:%d: no shutdown, calling remove\n",
+			__func__, __LINE__);
+		drv->remove(dev);
+	} else {
+		dev_dbg(&dev->core, "%s:%d: no shutdown method\n", __func__,
+			__LINE__);
+		BUG();
+	}
+
+	ps3_vuart_cleanup(dev);
+
+	dev_dbg(&dev->core, " <- %s:%d\n", __func__, __LINE__);
+
+	up(&vuart_bus_priv.probe_mutex);
+	return 0;
+}
+
+static int __init ps3_vuart_bus_init(void)
+{
+	pr_debug("%s:%d:\n", __func__, __LINE__);
+
+	if (!firmware_has_feature(FW_FEATURE_PS3_LV1))
+		return -ENODEV;
+
+	init_MUTEX(&vuart_bus_priv.probe_mutex);
+
+	return 0;
+}
+
+static void __exit ps3_vuart_bus_exit(void)
+{
+	pr_debug("%s:%d:\n", __func__, __LINE__);
+}
+
+core_initcall(ps3_vuart_bus_init);
+module_exit(ps3_vuart_bus_exit);
+
+/**
+ * ps3_vuart_port_driver_register - Add a vuart port device driver.
+ */
+
+int ps3_vuart_port_driver_register(struct ps3_vuart_port_driver *drv)
+{
+	int result;
+
+	pr_debug("%s:%d: (%s)\n", __func__, __LINE__, drv->core.core.name);
+
+	BUG_ON(!drv->core.match_id);
+	BUG_ON(!drv->core.core.name);
+
+	drv->core.probe = ps3_vuart_probe;
+	drv->core.remove = ps3_vuart_remove;
+	drv->core.shutdown = ps3_vuart_shutdown;
+
+	result = ps3_system_bus_driver_register(&drv->core);
+	return result;
+}
+EXPORT_SYMBOL_GPL(ps3_vuart_port_driver_register);
+
+/**
+ * ps3_vuart_port_driver_unregister - Remove a vuart port device driver.
+ */
+
+void ps3_vuart_port_driver_unregister(struct ps3_vuart_port_driver *drv)
+{
+	pr_debug("%s:%d: (%s)\n", __func__, __LINE__, drv->core.core.name);
+	ps3_system_bus_driver_unregister(&drv->core);
+}
+EXPORT_SYMBOL_GPL(ps3_vuart_port_driver_unregister);
diff -puN drivers/ps3/sys-manager.c~ps3-prefix-all-ps3-specific-kernel-modules-with /dev/null
--- a/drivers/ps3/sys-manager.c
+++ /dev/null
@@ -1,702 +0,0 @@
-/*
- *  PS3 System Manager.
- *
- *  Copyright (C) 2007 Sony Computer Entertainment Inc.
- *  Copyright 2007 Sony Corp.
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; version 2 of the License.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/workqueue.h>
-#include <linux/reboot.h>
-
-#include <asm/firmware.h>
-#include <asm/ps3.h>
-
-#include "vuart.h"
-
-MODULE_AUTHOR("Sony Corporation");
-MODULE_LICENSE("GPL v2");
-MODULE_DESCRIPTION("PS3 System Manager");
-
-/**
- * ps3_sys_manager - PS3 system manager driver.
- *
- * The system manager provides an asynchronous system event notification
- * mechanism for reporting events like thermal alert and button presses to
- * guests.  It also provides support to control system shutdown and startup.
- *
- * The actual system manager is implemented as an application running in the
- * system policy module in lpar_1.  Guests communicate with the system manager
- * through port 2 of the vuart using a simple packet message protocol.
- * Messages are comprised of a fixed field header followed by a message
- * specific payload.
- */
-
-/**
- * struct ps3_sys_manager_header - System manager message header.
- * @version: Header version, currently 1.
- * @size: Header size in bytes, curently 16.
- * @payload_size: Message payload size in bytes.
- * @service_id: Message type, one of enum ps3_sys_manager_service_id.
- * @request_tag: Unique number to identify reply.
- */
-
-struct ps3_sys_manager_header {
-	/* version 1 */
-	u8 version;
-	u8 size;
-	u16 reserved_1;
-	u32 payload_size;
-	u16 service_id;
-	u16 reserved_2;
-	u32 request_tag;
-};
-
-#define dump_sm_header(_h) _dump_sm_header(_h, __func__, __LINE__)
-static void __maybe_unused _dump_sm_header(
-	const struct ps3_sys_manager_header *h, const char *func, int line)
-{
-	pr_debug("%s:%d: version:      %xh\n", func, line, h->version);
-	pr_debug("%s:%d: size:         %xh\n", func, line, h->size);
-	pr_debug("%s:%d: payload_size: %xh\n", func, line, h->payload_size);
-	pr_debug("%s:%d: service_id:   %xh\n", func, line, h->service_id);
-	pr_debug("%s:%d: request_tag:  %xh\n", func, line, h->request_tag);
-}
-
-/**
- * @PS3_SM_RX_MSG_LEN_MIN - Shortest received message length.
- * @PS3_SM_RX_MSG_LEN_MAX - Longest received message length.
- *
- * Currently all messages received from the system manager are either
- * (16 bytes header + 8 bytes payload = 24 bytes) or (16 bytes header
- * + 16 bytes payload = 32 bytes).  This knowlege is used to simplify
- * the logic.
- */
-
-enum {
-	PS3_SM_RX_MSG_LEN_MIN = 24,
-	PS3_SM_RX_MSG_LEN_MAX = 32,
-};
-
-/**
- * enum ps3_sys_manager_service_id - Message header service_id.
- * @PS3_SM_SERVICE_ID_REQUEST:       guest --> sys_manager.
- * @PS3_SM_SERVICE_ID_REQUEST_ERROR: guest <-- sys_manager.
- * @PS3_SM_SERVICE_ID_COMMAND:       guest <-- sys_manager.
- * @PS3_SM_SERVICE_ID_RESPONSE:      guest --> sys_manager.
- * @PS3_SM_SERVICE_ID_SET_ATTR:      guest --> sys_manager.
- * @PS3_SM_SERVICE_ID_EXTERN_EVENT:  guest <-- sys_manager.
- * @PS3_SM_SERVICE_ID_SET_NEXT_OP:   guest --> sys_manager.
- *
- * PS3_SM_SERVICE_ID_REQUEST_ERROR is returned for invalid data values in a
- * a PS3_SM_SERVICE_ID_REQUEST message.  It also seems to be returned when
- * a REQUEST message is sent at the wrong time.
- */
-
-enum ps3_sys_manager_service_id {
-	/* version 1 */
-	PS3_SM_SERVICE_ID_REQUEST = 1,
-	PS3_SM_SERVICE_ID_RESPONSE = 2,
-	PS3_SM_SERVICE_ID_COMMAND = 3,
-	PS3_SM_SERVICE_ID_EXTERN_EVENT = 4,
-	PS3_SM_SERVICE_ID_SET_NEXT_OP = 5,
-	PS3_SM_SERVICE_ID_REQUEST_ERROR = 6,
-	PS3_SM_SERVICE_ID_SET_ATTR = 8,
-};
-
-/**
- * enum ps3_sys_manager_attr - Notification attribute (bit position mask).
- * @PS3_SM_ATTR_POWER: Power button.
- * @PS3_SM_ATTR_RESET: Reset button, not available on retail console.
- * @PS3_SM_ATTR_THERMAL: Sytem thermal alert.
- * @PS3_SM_ATTR_CONTROLLER: Remote controller event.
- * @PS3_SM_ATTR_ALL: Logical OR of all.
- *
- * The guest tells the system manager which events it is interested in receiving
- * notice of by sending the system manager a logical OR of notification
- * attributes via the ps3_sys_manager_send_attr() routine.
- */
-
-enum ps3_sys_manager_attr {
-	/* version 1 */
-	PS3_SM_ATTR_POWER = 1,
-	PS3_SM_ATTR_RESET = 2,
-	PS3_SM_ATTR_THERMAL = 4,
-	PS3_SM_ATTR_CONTROLLER = 8, /* bogus? */
-	PS3_SM_ATTR_ALL = 0x0f,
-};
-
-/**
- * enum ps3_sys_manager_event - External event type, reported by system manager.
- * @PS3_SM_EVENT_POWER_PRESSED: payload.value not used.
- * @PS3_SM_EVENT_POWER_RELEASED: payload.value = time pressed in millisec.
- * @PS3_SM_EVENT_RESET_PRESSED: payload.value not used.
- * @PS3_SM_EVENT_RESET_RELEASED: payload.value = time pressed in millisec.
- * @PS3_SM_EVENT_THERMAL_ALERT: payload.value = thermal zone id.
- * @PS3_SM_EVENT_THERMAL_CLEARED: payload.value = thermal zone id.
- */
-
-enum ps3_sys_manager_event {
-	/* version 1 */
-	PS3_SM_EVENT_POWER_PRESSED = 3,
-	PS3_SM_EVENT_POWER_RELEASED = 4,
-	PS3_SM_EVENT_RESET_PRESSED = 5,
-	PS3_SM_EVENT_RESET_RELEASED = 6,
-	PS3_SM_EVENT_THERMAL_ALERT = 7,
-	PS3_SM_EVENT_THERMAL_CLEARED = 8,
-	/* no info on controller events */
-};
-
-/**
- * enum ps3_sys_manager_next_op - Operation to perform after lpar is destroyed.
- */
-
-enum ps3_sys_manager_next_op {
-	/* version 3 */
-	PS3_SM_NEXT_OP_SYS_SHUTDOWN = 1,
-	PS3_SM_NEXT_OP_SYS_REBOOT = 2,
-	PS3_SM_NEXT_OP_LPAR_REBOOT = 0x82,
-};
-
-/**
- * enum ps3_sys_manager_wake_source - Next-op wakeup source (bit position mask).
- * @PS3_SM_WAKE_DEFAULT: Disk insert, power button, eject button, IR
- * controller, and bluetooth controller.
- * @PS3_SM_WAKE_RTC:
- * @PS3_SM_WAKE_RTC_ERROR:
- * @PS3_SM_WAKE_P_O_R: Power on reset.
- *
- * Additional wakeup sources when specifying PS3_SM_NEXT_OP_SYS_SHUTDOWN.
- * System will always wake from the PS3_SM_WAKE_DEFAULT sources.
- */
-
-enum ps3_sys_manager_wake_source {
-	/* version 3 */
-	PS3_SM_WAKE_DEFAULT   = 0,
-	PS3_SM_WAKE_RTC       = 0x00000040,
-	PS3_SM_WAKE_RTC_ERROR = 0x00000080,
-	PS3_SM_WAKE_P_O_R     = 0x10000000,
-};
-
-/**
- * enum ps3_sys_manager_cmd - Command from system manager to guest.
- *
- * The guest completes the actions needed, then acks or naks the command via
- * ps3_sys_manager_send_response().  In the case of @PS3_SM_CMD_SHUTDOWN,
- * the guest must be fully prepared for a system poweroff prior to acking the
- * command.
- */
-
-enum ps3_sys_manager_cmd {
-	/* version 1 */
-	PS3_SM_CMD_SHUTDOWN = 1, /* shutdown guest OS */
-};
-
-/**
- * ps3_sm_force_power_off - Poweroff helper.
- *
- * A global variable used to force a poweroff when the power button has
- * been pressed irrespective of how init handles the ctrl_alt_del signal.
- *
- */
-
-static unsigned int ps3_sm_force_power_off;
-
-/**
- * ps3_sys_manager_write - Helper to write a two part message to the vuart.
- *
- */
-
-static int ps3_sys_manager_write(struct ps3_system_bus_device *dev,
-	const struct ps3_sys_manager_header *header, const void *payload)
-{
-	int result;
-
-	BUG_ON(header->version != 1);
-	BUG_ON(header->size != 16);
-	BUG_ON(header->payload_size != 8 && header->payload_size != 16);
-	BUG_ON(header->service_id > 8);
-
-	result = ps3_vuart_write(dev, header,
-		sizeof(struct ps3_sys_manager_header));
-
-	if (!result)
-		result = ps3_vuart_write(dev, payload, header->payload_size);
-
-	return result;
-}
-
-/**
- * ps3_sys_manager_send_attr - Send a 'set attribute' to the system manager.
- *
- */
-
-static int ps3_sys_manager_send_attr(struct ps3_system_bus_device *dev,
-	enum ps3_sys_manager_attr attr)
-{
-	struct ps3_sys_manager_header header;
-	struct {
-		u8 version;
-		u8 reserved_1[3];
-		u32 attribute;
-	} payload;
-
-	BUILD_BUG_ON(sizeof(payload) != 8);
-
-	dev_dbg(&dev->core, "%s:%d: %xh\n", __func__, __LINE__, attr);
-
-	memset(&header, 0, sizeof(header));
-	header.version = 1;
-	header.size = 16;
-	header.payload_size = 16;
-	header.service_id = PS3_SM_SERVICE_ID_SET_ATTR;
-
-	memset(&payload, 0, sizeof(payload));
-	payload.version = 1;
-	payload.attribute = attr;
-
-	return ps3_sys_manager_write(dev, &header, &payload);
-}
-
-/**
- * ps3_sys_manager_send_next_op - Send a 'set next op' to the system manager.
- *
- * Tell the system manager what to do after this lpar is destroyed.
- */
-
-static int ps3_sys_manager_send_next_op(struct ps3_system_bus_device *dev,
-	enum ps3_sys_manager_next_op op,
-	enum ps3_sys_manager_wake_source wake_source)
-{
-	struct ps3_sys_manager_header header;
-	struct {
-		u8 version;
-		u8 type;
-		u8 gos_id;
-		u8 reserved_1;
-		u32 wake_source;
-		u8 reserved_2[8];
-	} payload;
-
-	BUILD_BUG_ON(sizeof(payload) != 16);
-
-	dev_dbg(&dev->core, "%s:%d: (%xh)\n", __func__, __LINE__, op);
-
-	memset(&header, 0, sizeof(header));
-	header.version = 1;
-	header.size = 16;
-	header.payload_size = 16;
-	header.service_id = PS3_SM_SERVICE_ID_SET_NEXT_OP;
-
-	memset(&payload, 0, sizeof(payload));
-	payload.version = 3;
-	payload.type = op;
-	payload.gos_id = 3; /* other os */
-	payload.wake_source = wake_source;
-
-	return ps3_sys_manager_write(dev, &header, &payload);
-}
-
-/**
- * ps3_sys_manager_send_request_shutdown - Send 'request' to the system manager.
- *
- * The guest sends this message to request an operation or action of the system
- * manager.  The reply is a command message from the system manager.  In the
- * command handler the guest performs the requested operation.  The result of
- * the command is then communicated back to the system manager with a response
- * message.
- *
- * Currently, the only supported request is the 'shutdown self' request.
- */
-
-static int ps3_sys_manager_send_request_shutdown(
-	struct ps3_system_bus_device *dev)
-{
-	struct ps3_sys_manager_header header;
-	struct {
-		u8 version;
-		u8 type;
-		u8 gos_id;
-		u8 reserved_1[13];
-	} payload;
-
-	BUILD_BUG_ON(sizeof(payload) != 16);
-
-	dev_dbg(&dev->core, "%s:%d\n", __func__, __LINE__);
-
-	memset(&header, 0, sizeof(header));
-	header.version = 1;
-	header.size = 16;
-	header.payload_size = 16;
-	header.service_id = PS3_SM_SERVICE_ID_REQUEST;
-
-	memset(&payload, 0, sizeof(payload));
-	payload.version = 1;
-	payload.type = 1; /* shutdown */
-	payload.gos_id = 0; /* self */
-
-	return ps3_sys_manager_write(dev, &header, &payload);
-}
-
-/**
- * ps3_sys_manager_send_response - Send a 'response' to the system manager.
- * @status: zero = success, others fail.
- *
- * The guest sends this message to the system manager to acnowledge success or
- * failure of a command sent by the system manager.
- */
-
-static int ps3_sys_manager_send_response(struct ps3_system_bus_device *dev,
-	u64 status)
-{
-	struct ps3_sys_manager_header header;
-	struct {
-		u8 version;
-		u8 reserved_1[3];
-		u8 status;
-		u8 reserved_2[11];
-	} payload;
-
-	BUILD_BUG_ON(sizeof(payload) != 16);
-
-	dev_dbg(&dev->core, "%s:%d: (%s)\n", __func__, __LINE__,
-		(status ? "nak" : "ack"));
-
-	memset(&header, 0, sizeof(header));
-	header.version = 1;
-	header.size = 16;
-	header.payload_size = 16;
-	header.service_id = PS3_SM_SERVICE_ID_RESPONSE;
-
-	memset(&payload, 0, sizeof(payload));
-	payload.version = 1;
-	payload.status = status;
-
-	return ps3_sys_manager_write(dev, &header, &payload);
-}
-
-/**
- * ps3_sys_manager_handle_event - Second stage event msg handler.
- *
- */
-
-static int ps3_sys_manager_handle_event(struct ps3_system_bus_device *dev)
-{
-	int result;
-	struct {
-		u8 version;
-		u8 type;
-		u8 reserved_1[2];
-		u32 value;
-		u8 reserved_2[8];
-	} event;
-
-	BUILD_BUG_ON(sizeof(event) != 16);
-
-	result = ps3_vuart_read(dev, &event, sizeof(event));
-	BUG_ON(result && "need to retry here");
-
-	if (event.version != 1) {
-		dev_dbg(&dev->core, "%s:%d: unsupported event version (%u)\n",
-			__func__, __LINE__, event.version);
-		return -EIO;
-	}
-
-	switch (event.type) {
-	case PS3_SM_EVENT_POWER_PRESSED:
-		dev_dbg(&dev->core, "%s:%d: POWER_PRESSED\n",
-			__func__, __LINE__);
-		ps3_sm_force_power_off = 1;
-		/*
-		 * A memory barrier is use here to sync memory since
-		 * ps3_sys_manager_final_restart() could be called on
-		 * another cpu.
-		 */
-		wmb();
-		kill_cad_pid(SIGINT, 1); /* ctrl_alt_del */
-		break;
-	case PS3_SM_EVENT_POWER_RELEASED:
-		dev_dbg(&dev->core, "%s:%d: POWER_RELEASED (%u ms)\n",
-			__func__, __LINE__, event.value);
-		break;
-	case PS3_SM_EVENT_RESET_PRESSED:
-		dev_dbg(&dev->core, "%s:%d: RESET_PRESSED\n",
-			__func__, __LINE__);
-		ps3_sm_force_power_off = 0;
-		/*
-		 * A memory barrier is use here to sync memory since
-		 * ps3_sys_manager_final_restart() could be called on
-		 * another cpu.
-		 */
-		wmb();
-		kill_cad_pid(SIGINT, 1); /* ctrl_alt_del */
-		break;
-	case PS3_SM_EVENT_RESET_RELEASED:
-		dev_dbg(&dev->core, "%s:%d: RESET_RELEASED (%u ms)\n",
-			__func__, __LINE__, event.value);
-		break;
-	case PS3_SM_EVENT_THERMAL_ALERT:
-		dev_dbg(&dev->core, "%s:%d: THERMAL_ALERT (zone %u)\n",
-			__func__, __LINE__, event.value);
-		printk(KERN_INFO "PS3 Thermal Alert Zone %u\n", event.value);
-		break;
-	case PS3_SM_EVENT_THERMAL_CLEARED:
-		dev_dbg(&dev->core, "%s:%d: THERMAL_CLEARED (zone %u)\n",
-			__func__, __LINE__, event.value);
-		break;
-	default:
-		dev_dbg(&dev->core, "%s:%d: unknown event (%u)\n",
-			__func__, __LINE__, event.type);
-		return -EIO;
-	}
-
-	return 0;
-}
-/**
- * ps3_sys_manager_handle_cmd - Second stage command msg handler.
- *
- * The system manager sends this in reply to a 'request' message from the guest.
- */
-
-static int ps3_sys_manager_handle_cmd(struct ps3_system_bus_device *dev)
-{
-	int result;
-	struct {
-		u8 version;
-		u8 type;
-		u8 reserved_1[14];
-	} cmd;
-
-	BUILD_BUG_ON(sizeof(cmd) != 16);
-
-	dev_dbg(&dev->core, "%s:%d\n", __func__, __LINE__);
-
-	result = ps3_vuart_read(dev, &cmd, sizeof(cmd));
-	BUG_ON(result && "need to retry here");
-
-	if(result)
-		return result;
-
-	if (cmd.version != 1) {
-		dev_dbg(&dev->core, "%s:%d: unsupported cmd version (%u)\n",
-			__func__, __LINE__, cmd.version);
-		return -EIO;
-	}
-
-	if (cmd.type != PS3_SM_CMD_SHUTDOWN) {
-		dev_dbg(&dev->core, "%s:%d: unknown cmd (%u)\n",
-			__func__, __LINE__, cmd.type);
-		return -EIO;
-	}
-
-	ps3_sys_manager_send_response(dev, 0);
-	return 0;
-}
-
-/**
- * ps3_sys_manager_handle_msg - First stage msg handler.
- *
- * Can be called directly to manually poll vuart and pump message handler.
- */
-
-static int ps3_sys_manager_handle_msg(struct ps3_system_bus_device *dev)
-{
-	int result;
-	struct ps3_sys_manager_header header;
-
-	result = ps3_vuart_read(dev, &header,
-		sizeof(struct ps3_sys_manager_header));
-
-	if(result)
-		return result;
-
-	if (header.version != 1) {
-		dev_dbg(&dev->core, "%s:%d: unsupported header version (%u)\n",
-			__func__, __LINE__, header.version);
-		dump_sm_header(&header);
-		goto fail_header;
-	}
-
-	BUILD_BUG_ON(sizeof(header) != 16);
-
-	if (header.size != 16 || (header.payload_size != 8
-		&& header.payload_size != 16)) {
-		dump_sm_header(&header);
-		BUG();
-	}
-
-	switch (header.service_id) {
-	case PS3_SM_SERVICE_ID_EXTERN_EVENT:
-		dev_dbg(&dev->core, "%s:%d: EVENT\n", __func__, __LINE__);
-		return ps3_sys_manager_handle_event(dev);
-	case PS3_SM_SERVICE_ID_COMMAND:
-		dev_dbg(&dev->core, "%s:%d: COMMAND\n", __func__, __LINE__);
-		return ps3_sys_manager_handle_cmd(dev);
-	case PS3_SM_SERVICE_ID_REQUEST_ERROR:
-		dev_dbg(&dev->core, "%s:%d: REQUEST_ERROR\n", __func__,
-			__LINE__);
-		dump_sm_header(&header);
-		break;
-	default:
-		dev_dbg(&dev->core, "%s:%d: unknown service_id (%u)\n",
-			__func__, __LINE__, header.service_id);
-		break;
-	}
-	goto fail_id;
-
-fail_header:
-	ps3_vuart_clear_rx_bytes(dev, 0);
-	return -EIO;
-fail_id:
-	ps3_vuart_clear_rx_bytes(dev, header.payload_size);
-	return -EIO;
-}
-
-/**
- * ps3_sys_manager_final_power_off - The final platform machine_power_off routine.
- *
- * This routine never returns.  The routine disables asynchronous vuart reads
- * then spins calling ps3_sys_manager_handle_msg() to receive and acknowledge
- * the shutdown command sent from the system manager.  Soon after the
- * acknowledgement is sent the lpar is destroyed by the HV.  This routine
- * should only be called from ps3_power_off() through
- * ps3_sys_manager_ops.power_off.
- */
-
-static void ps3_sys_manager_final_power_off(struct ps3_system_bus_device *dev)
-{
-	BUG_ON(!dev);
-
-	dev_dbg(&dev->core, "%s:%d\n", __func__, __LINE__);
-
-	ps3_vuart_cancel_async(dev);
-
-	ps3_sys_manager_send_next_op(dev, PS3_SM_NEXT_OP_SYS_SHUTDOWN,
-		PS3_SM_WAKE_DEFAULT);
-	ps3_sys_manager_send_request_shutdown(dev);
-
-	printk(KERN_EMERG "System Halted, OK to turn off power\n");
-
-	while(1)
-		ps3_sys_manager_handle_msg(dev);
-}
-
-/**
- * ps3_sys_manager_final_restart - The final platform machine_restart routine.
- *
- * This routine never returns.  The routine disables asynchronous vuart reads
- * then spins calling ps3_sys_manager_handle_msg() to receive and acknowledge
- * the shutdown command sent from the system manager.  Soon after the
- * acknowledgement is sent the lpar is destroyed by the HV.  This routine
- * should only be called from ps3_restart() through ps3_sys_manager_ops.restart.
- */
-
-static void ps3_sys_manager_final_restart(struct ps3_system_bus_device *dev)
-{
-	BUG_ON(!dev);
-
-	dev_dbg(&dev->core, "%s:%d\n", __func__, __LINE__);
-
-	/* Check if we got here via a power button event. */
-
-	if (ps3_sm_force_power_off) {
-		dev_dbg(&dev->core, "%s:%d: forcing poweroff\n",
-			__func__, __LINE__);
-		ps3_sys_manager_final_power_off(dev);
-	}
-
-	ps3_vuart_cancel_async(dev);
-
-	ps3_sys_manager_send_attr(dev, 0);
-	ps3_sys_manager_send_next_op(dev, PS3_SM_NEXT_OP_LPAR_REBOOT,
-		PS3_SM_WAKE_DEFAULT);
-	ps3_sys_manager_send_request_shutdown(dev);
-
-	printk(KERN_EMERG "System Halted, OK to turn off power\n");
-
-	while(1)
-		ps3_sys_manager_handle_msg(dev);
-}
-
-/**
- * ps3_sys_manager_work - Asynchronous read handler.
- *
- * Signaled when PS3_SM_RX_MSG_LEN_MIN bytes arrive at the vuart port.
- */
-
-static void ps3_sys_manager_work(struct ps3_system_bus_device *dev)
-{
-	ps3_sys_manager_handle_msg(dev);
-	ps3_vuart_read_async(dev, PS3_SM_RX_MSG_LEN_MIN);
-}
-
-static int ps3_sys_manager_probe(struct ps3_system_bus_device *dev)
-{
-	int result;
-	struct ps3_sys_manager_ops ops;
-
-	dev_dbg(&dev->core, "%s:%d\n", __func__, __LINE__);
-
-	ops.power_off = ps3_sys_manager_final_power_off;
-	ops.restart = ps3_sys_manager_final_restart;
-	ops.dev = dev;
-
-	/* ps3_sys_manager_register_ops copies ops. */
-
-	ps3_sys_manager_register_ops(&ops);
-
-	result = ps3_sys_manager_send_attr(dev, PS3_SM_ATTR_ALL);
-	BUG_ON(result);
-
-	result = ps3_vuart_read_async(dev, PS3_SM_RX_MSG_LEN_MIN);
-	BUG_ON(result);
-
-	return result;
-}
-
-static int ps3_sys_manager_remove(struct ps3_system_bus_device *dev)
-{
-	dev_dbg(&dev->core, "%s:%d\n", __func__, __LINE__);
-	return 0;
-}
-
-static void ps3_sys_manager_shutdown(struct ps3_system_bus_device *dev)
-{
-	dev_dbg(&dev->core, "%s:%d\n", __func__, __LINE__);
-}
-
-static struct ps3_vuart_port_driver ps3_sys_manager = {
-	.core.match_id = PS3_MATCH_ID_SYSTEM_MANAGER,
-	.core.core.name = "ps3_sys_manager",
-	.probe = ps3_sys_manager_probe,
-	.remove = ps3_sys_manager_remove,
-	.shutdown = ps3_sys_manager_shutdown,
-	.work = ps3_sys_manager_work,
-};
-
-static int __init ps3_sys_manager_init(void)
-{
-	if (!firmware_has_feature(FW_FEATURE_PS3_LV1))
-		return -ENODEV;
-
-	return ps3_vuart_port_driver_register(&ps3_sys_manager);
-}
-
-module_init(ps3_sys_manager_init);
-/* Module remove not supported. */
-
-MODULE_ALIAS(PS3_MODULE_ALIAS_SYSTEM_MANAGER);
diff -puN drivers/ps3/vuart.c~ps3-prefix-all-ps3-specific-kernel-modules-with /dev/null
--- a/drivers/ps3/vuart.c
+++ /dev/null
@@ -1,1271 +0,0 @@
-/*
- *  PS3 virtual uart
- *
- *  Copyright (C) 2006 Sony Computer Entertainment Inc.
- *  Copyright 2006 Sony Corp.
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; version 2 of the License.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/interrupt.h>
-#include <linux/workqueue.h>
-#include <linux/bitops.h>
-#include <asm/ps3.h>
-
-#include <asm/firmware.h>
-#include <asm/lv1call.h>
-
-#include "vuart.h"
-
-MODULE_AUTHOR("Sony Corporation");
-MODULE_LICENSE("GPL v2");
-MODULE_DESCRIPTION("PS3 vuart");
-
-/**
- * vuart - An inter-partition data link service.
- *  port 0: PS3 AV Settings.
- *  port 2: PS3 System Manager.
- *
- * The vuart provides a bi-directional byte stream data link between logical
- * partitions.  Its primary role is as a communications link between the guest
- * OS and the system policy module.  The current HV does not support any
- * connections other than those listed.
- */
-
-enum {PORT_COUNT = 3,};
-
-enum vuart_param {
-	PARAM_TX_TRIGGER = 0,
-	PARAM_RX_TRIGGER = 1,
-	PARAM_INTERRUPT_MASK = 2,
-	PARAM_RX_BUF_SIZE = 3, /* read only */
-	PARAM_RX_BYTES = 4, /* read only */
-	PARAM_TX_BUF_SIZE = 5, /* read only */
-	PARAM_TX_BYTES = 6, /* read only */
-	PARAM_INTERRUPT_STATUS = 7, /* read only */
-};
-
-enum vuart_interrupt_bit {
-	INTERRUPT_BIT_TX = 0,
-	INTERRUPT_BIT_RX = 1,
-	INTERRUPT_BIT_DISCONNECT = 2,
-};
-
-enum vuart_interrupt_mask {
-	INTERRUPT_MASK_TX = 1,
-	INTERRUPT_MASK_RX = 2,
-	INTERRUPT_MASK_DISCONNECT = 4,
-};
-
-/**
- * struct ps3_vuart_port_priv - private vuart device data.
- */
-
-struct ps3_vuart_port_priv {
-	u64 interrupt_mask;
-
-	struct {
-		spinlock_t lock;
-		struct list_head head;
-	} tx_list;
-	struct {
-		struct ps3_vuart_work work;
-		unsigned long bytes_held;
-		spinlock_t lock;
-		struct list_head head;
-	} rx_list;
-	struct ps3_vuart_stats stats;
-};
-
-static struct ps3_vuart_port_priv *to_port_priv(
-	struct ps3_system_bus_device *dev)
-{
-	BUG_ON(!dev);
-	BUG_ON(!dev->driver_priv);
-	return (struct ps3_vuart_port_priv *)dev->driver_priv;
-}
-
-/**
- * struct ports_bmp - bitmap indicating ports needing service.
- *
- * A 256 bit read only bitmap indicating ports needing service.  Do not write
- * to these bits.  Must not cross a page boundary.
- */
-
-struct ports_bmp {
-	u64 status;
-	u64 unused[3];
-} __attribute__ ((aligned (32)));
-
-#define dump_ports_bmp(_b) _dump_ports_bmp(_b, __func__, __LINE__)
-static void __maybe_unused _dump_ports_bmp(
-	const struct ports_bmp* bmp, const char* func, int line)
-{
-	pr_debug("%s:%d: ports_bmp: %016lxh\n", func, line, bmp->status);
-}
-
-#define dump_port_params(_b) _dump_port_params(_b, __func__, __LINE__)
-static void __maybe_unused _dump_port_params(unsigned int port_number,
-	const char* func, int line)
-{
-#if defined(DEBUG)
-	static const char *strings[] = {
-		"tx_trigger      ",
-		"rx_trigger      ",
-		"interrupt_mask  ",
-		"rx_buf_size     ",
-		"rx_bytes        ",
-		"tx_buf_size     ",
-		"tx_bytes        ",
-		"interrupt_status",
-	};
-	int result;
-	unsigned int i;
-	u64 value;
-
-	for (i = 0; i < ARRAY_SIZE(strings); i++) {
-		result = lv1_get_virtual_uart_param(port_number, i, &value);
-
-		if (result) {
-			pr_debug("%s:%d: port_%u: %s failed: %s\n", func, line,
-				port_number, strings[i], ps3_result(result));
-			continue;
-		}
-		pr_debug("%s:%d: port_%u: %s = %lxh\n",
-			func, line, port_number, strings[i], value);
-	}
-#endif
-}
-
-struct vuart_triggers {
-	unsigned long rx;
-	unsigned long tx;
-};
-
-int ps3_vuart_get_triggers(struct ps3_system_bus_device *dev,
-	struct vuart_triggers *trig)
-{
-	int result;
-	unsigned long size;
-	unsigned long val;
-
-	result = lv1_get_virtual_uart_param(dev->port_number,
-		PARAM_TX_TRIGGER, &trig->tx);
-
-	if (result) {
-		dev_dbg(&dev->core, "%s:%d: tx_trigger failed: %s\n",
-			__func__, __LINE__, ps3_result(result));
-		return result;
-	}
-
-	result = lv1_get_virtual_uart_param(dev->port_number,
-		PARAM_RX_BUF_SIZE, &size);
-
-	if (result) {
-		dev_dbg(&dev->core, "%s:%d: tx_buf_size failed: %s\n",
-			__func__, __LINE__, ps3_result(result));
-		return result;
-	}
-
-	result = lv1_get_virtual_uart_param(dev->port_number,
-		PARAM_RX_TRIGGER, &val);
-
-	if (result) {
-		dev_dbg(&dev->core, "%s:%d: rx_trigger failed: %s\n",
-			__func__, __LINE__, ps3_result(result));
-		return result;
-	}
-
-	trig->rx = size - val;
-
-	dev_dbg(&dev->core, "%s:%d: tx %lxh, rx %lxh\n", __func__, __LINE__,
-		trig->tx, trig->rx);
-
-	return result;
-}
-
-int ps3_vuart_set_triggers(struct ps3_system_bus_device *dev, unsigned int tx,
-	unsigned int rx)
-{
-	int result;
-	unsigned long size;
-
-	result = lv1_set_virtual_uart_param(dev->port_number,
-		PARAM_TX_TRIGGER, tx);
-
-	if (result) {
-		dev_dbg(&dev->core, "%s:%d: tx_trigger failed: %s\n",
-			__func__, __LINE__, ps3_result(result));
-		return result;
-	}
-
-	result = lv1_get_virtual_uart_param(dev->port_number,
-		PARAM_RX_BUF_SIZE, &size);
-
-	if (result) {
-		dev_dbg(&dev->core, "%s:%d: tx_buf_size failed: %s\n",
-			__func__, __LINE__, ps3_result(result));
-		return result;
-	}
-
-	result = lv1_set_virtual_uart_param(dev->port_number,
-		PARAM_RX_TRIGGER, size - rx);
-
-	if (result) {
-		dev_dbg(&dev->core, "%s:%d: rx_trigger failed: %s\n",
-			__func__, __LINE__, ps3_result(result));
-		return result;
-	}
-
-	dev_dbg(&dev->core, "%s:%d: tx %xh, rx %xh\n", __func__, __LINE__,
-		tx, rx);
-
-	return result;
-}
-
-static int ps3_vuart_get_rx_bytes_waiting(struct ps3_system_bus_device *dev,
-	u64 *bytes_waiting)
-{
-	int result;
-
-	result = lv1_get_virtual_uart_param(dev->port_number,
-		PARAM_RX_BYTES, bytes_waiting);
-
-	if (result)
-		dev_dbg(&dev->core, "%s:%d: rx_bytes failed: %s\n",
-			__func__, __LINE__, ps3_result(result));
-
-	dev_dbg(&dev->core, "%s:%d: %lxh\n", __func__, __LINE__,
-		*bytes_waiting);
-	return result;
-}
-
-/**
- * ps3_vuart_set_interrupt_mask - Enable/disable the port interrupt sources.
- * @dev: The struct ps3_system_bus_device instance.
- * @bmp: Logical OR of enum vuart_interrupt_mask values. A zero bit disables.
- */
-
-static int ps3_vuart_set_interrupt_mask(struct ps3_system_bus_device *dev,
-	unsigned long mask)
-{
-	int result;
-	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
-
-	dev_dbg(&dev->core, "%s:%d: %lxh\n", __func__, __LINE__, mask);
-
-	priv->interrupt_mask = mask;
-
-	result = lv1_set_virtual_uart_param(dev->port_number,
-		PARAM_INTERRUPT_MASK, priv->interrupt_mask);
-
-	if (result)
-		dev_dbg(&dev->core, "%s:%d: interrupt_mask failed: %s\n",
-			__func__, __LINE__, ps3_result(result));
-
-	return result;
-}
-
-static int ps3_vuart_get_interrupt_status(struct ps3_system_bus_device *dev,
-	unsigned long *status)
-{
-	int result;
-	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
-	u64 tmp;
-
-	result = lv1_get_virtual_uart_param(dev->port_number,
-		PARAM_INTERRUPT_STATUS, &tmp);
-
-	if (result)
-		dev_dbg(&dev->core, "%s:%d: interrupt_status failed: %s\n",
-			__func__, __LINE__, ps3_result(result));
-
-	*status = tmp & priv->interrupt_mask;
-
-	dev_dbg(&dev->core, "%s:%d: m %lxh, s %lxh, m&s %lxh\n",
-		__func__, __LINE__, priv->interrupt_mask, tmp, *status);
-
-	return result;
-}
-
-int ps3_vuart_enable_interrupt_tx(struct ps3_system_bus_device *dev)
-{
-	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
-
-	return (priv->interrupt_mask & INTERRUPT_MASK_TX) ? 0
-		: ps3_vuart_set_interrupt_mask(dev, priv->interrupt_mask
-		| INTERRUPT_MASK_TX);
-}
-
-int ps3_vuart_enable_interrupt_rx(struct ps3_system_bus_device *dev)
-{
-	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
-
-	return (priv->interrupt_mask & INTERRUPT_MASK_RX) ? 0
-		: ps3_vuart_set_interrupt_mask(dev, priv->interrupt_mask
-		| INTERRUPT_MASK_RX);
-}
-
-int ps3_vuart_enable_interrupt_disconnect(struct ps3_system_bus_device *dev)
-{
-	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
-
-	return (priv->interrupt_mask & INTERRUPT_MASK_DISCONNECT) ? 0
-		: ps3_vuart_set_interrupt_mask(dev, priv->interrupt_mask
-		| INTERRUPT_MASK_DISCONNECT);
-}
-
-int ps3_vuart_disable_interrupt_tx(struct ps3_system_bus_device *dev)
-{
-	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
-
-	return (priv->interrupt_mask & INTERRUPT_MASK_TX)
-		? ps3_vuart_set_interrupt_mask(dev, priv->interrupt_mask
-		& ~INTERRUPT_MASK_TX) : 0;
-}
-
-int ps3_vuart_disable_interrupt_rx(struct ps3_system_bus_device *dev)
-{
-	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
-
-	return (priv->interrupt_mask & INTERRUPT_MASK_RX)
-		? ps3_vuart_set_interrupt_mask(dev, priv->interrupt_mask
-		& ~INTERRUPT_MASK_RX) : 0;
-}
-
-int ps3_vuart_disable_interrupt_disconnect(struct ps3_system_bus_device *dev)
-{
-	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
-
-	return (priv->interrupt_mask & INTERRUPT_MASK_DISCONNECT)
-		? ps3_vuart_set_interrupt_mask(dev, priv->interrupt_mask
-		& ~INTERRUPT_MASK_DISCONNECT) : 0;
-}
-
-/**
- * ps3_vuart_raw_write - Low level write helper.
- * @dev: The struct ps3_system_bus_device instance.
- *
- * Do not call ps3_vuart_raw_write directly, use ps3_vuart_write.
- */
-
-static int ps3_vuart_raw_write(struct ps3_system_bus_device *dev,
-	const void* buf, unsigned int bytes, unsigned long *bytes_written)
-{
-	int result;
-	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
-
-	result = lv1_write_virtual_uart(dev->port_number,
-		ps3_mm_phys_to_lpar(__pa(buf)), bytes, bytes_written);
-
-	if (result) {
-		dev_dbg(&dev->core, "%s:%d: lv1_write_virtual_uart failed: "
-			"%s\n", __func__, __LINE__, ps3_result(result));
-		return result;
-	}
-
-	priv->stats.bytes_written += *bytes_written;
-
-	dev_dbg(&dev->core, "%s:%d: wrote %lxh/%xh=>%lxh\n", __func__, __LINE__,
-		*bytes_written, bytes, priv->stats.bytes_written);
-
-	return result;
-}
-
-/**
- * ps3_vuart_raw_read - Low level read helper.
- * @dev: The struct ps3_system_bus_device instance.
- *
- * Do not call ps3_vuart_raw_read directly, use ps3_vuart_read.
- */
-
-static int ps3_vuart_raw_read(struct ps3_system_bus_device *dev, void *buf,
-	unsigned int bytes, unsigned long *bytes_read)
-{
-	int result;
-	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
-
-	dev_dbg(&dev->core, "%s:%d: %xh\n", __func__, __LINE__, bytes);
-
-	result = lv1_read_virtual_uart(dev->port_number,
-		ps3_mm_phys_to_lpar(__pa(buf)), bytes, bytes_read);
-
-	if (result) {
-		dev_dbg(&dev->core, "%s:%d: lv1_read_virtual_uart failed: %s\n",
-			__func__, __LINE__, ps3_result(result));
-		return result;
-	}
-
-	priv->stats.bytes_read += *bytes_read;
-
-	dev_dbg(&dev->core, "%s:%d: read %lxh/%xh=>%lxh\n", __func__, __LINE__,
-		*bytes_read, bytes, priv->stats.bytes_read);
-
-	return result;
-}
-
-/**
- * ps3_vuart_clear_rx_bytes - Discard bytes received.
- * @dev: The struct ps3_system_bus_device instance.
- * @bytes: Max byte count to discard, zero = all pending.
- *
- * Used to clear pending rx interrupt source.  Will not block.
- */
-
-void ps3_vuart_clear_rx_bytes(struct ps3_system_bus_device *dev,
-	unsigned int bytes)
-{
-	int result;
-	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
-	u64 bytes_waiting;
-	void* tmp;
-
-	result = ps3_vuart_get_rx_bytes_waiting(dev, &bytes_waiting);
-
-	BUG_ON(result);
-
-	bytes = bytes ? min(bytes, (unsigned int)bytes_waiting) : bytes_waiting;
-
-	dev_dbg(&dev->core, "%s:%d: %u\n", __func__, __LINE__, bytes);
-
-	if (!bytes)
-		return;
-
-	/* Add some extra space for recently arrived data. */
-
-	bytes += 128;
-
-	tmp = kmalloc(bytes, GFP_KERNEL);
-
-	if (!tmp)
-		return;
-
-	ps3_vuart_raw_read(dev, tmp, bytes, &bytes_waiting);
-
-	kfree(tmp);
-
-	/* Don't include these bytes in the stats. */
-
-	priv->stats.bytes_read -= bytes_waiting;
-}
-EXPORT_SYMBOL_GPL(ps3_vuart_clear_rx_bytes);
-
-/**
- * struct list_buffer - An element for a port device fifo buffer list.
- */
-
-struct list_buffer {
-	struct list_head link;
-	const unsigned char *head;
-	const unsigned char *tail;
-	unsigned long dbg_number;
-	unsigned char data[];
-};
-
-/**
- * ps3_vuart_write - the entry point for writing data to a port
- * @dev: The struct ps3_system_bus_device instance.
- *
- * If the port is idle on entry as much of the incoming data is written to
- * the port as the port will accept.  Otherwise a list buffer is created
- * and any remaning incoming data is copied to that buffer.  The buffer is
- * then enqueued for transmision via the transmit interrupt.
- */
-
-int ps3_vuart_write(struct ps3_system_bus_device *dev, const void *buf,
-	unsigned int bytes)
-{
-	static unsigned long dbg_number;
-	int result;
-	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
-	unsigned long flags;
-	struct list_buffer *lb;
-
-	dev_dbg(&dev->core, "%s:%d: %u(%xh) bytes\n", __func__, __LINE__,
-		bytes, bytes);
-
-	spin_lock_irqsave(&priv->tx_list.lock, flags);
-
-	if (list_empty(&priv->tx_list.head)) {
-		unsigned long bytes_written;
-
-		result = ps3_vuart_raw_write(dev, buf, bytes, &bytes_written);
-
-		spin_unlock_irqrestore(&priv->tx_list.lock, flags);
-
-		if (result) {
-			dev_dbg(&dev->core,
-				"%s:%d: ps3_vuart_raw_write failed\n",
-				__func__, __LINE__);
-			return result;
-		}
-
-		if (bytes_written == bytes) {
-			dev_dbg(&dev->core, "%s:%d: wrote %xh bytes\n",
-				__func__, __LINE__, bytes);
-			return 0;
-		}
-
-		bytes -= bytes_written;
-		buf += bytes_written;
-	} else
-		spin_unlock_irqrestore(&priv->tx_list.lock, flags);
-
-	lb = kmalloc(sizeof(struct list_buffer) + bytes, GFP_KERNEL);
-
-	if (!lb) {
-		return -ENOMEM;
-	}
-
-	memcpy(lb->data, buf, bytes);
-	lb->head = lb->data;
-	lb->tail = lb->data + bytes;
-	lb->dbg_number = ++dbg_number;
-
-	spin_lock_irqsave(&priv->tx_list.lock, flags);
-	list_add_tail(&lb->link, &priv->tx_list.head);
-	ps3_vuart_enable_interrupt_tx(dev);
-	spin_unlock_irqrestore(&priv->tx_list.lock, flags);
-
-	dev_dbg(&dev->core, "%s:%d: queued buf_%lu, %xh bytes\n",
-		__func__, __LINE__, lb->dbg_number, bytes);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(ps3_vuart_write);
-
-/**
- * ps3_vuart_queue_rx_bytes - Queue waiting bytes into the buffer list.
- * @dev: The struct ps3_system_bus_device instance.
- * @bytes_queued: Number of bytes queued to the buffer list.
- *
- * Must be called with priv->rx_list.lock held.
- */
-
-static int ps3_vuart_queue_rx_bytes(struct ps3_system_bus_device *dev,
-	u64 *bytes_queued)
-{
-	static unsigned long dbg_number;
-	int result;
-	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
-	struct list_buffer *lb;
-	u64 bytes;
-
-	*bytes_queued = 0;
-
-	result = ps3_vuart_get_rx_bytes_waiting(dev, &bytes);
-	BUG_ON(result);
-
-	if (result)
-		return -EIO;
-
-	if (!bytes)
-		return 0;
-
-	/* Add some extra space for recently arrived data. */
-
-	bytes += 128;
-
-	lb = kmalloc(sizeof(struct list_buffer) + bytes, GFP_ATOMIC);
-
-	if (!lb)
-		return -ENOMEM;
-
-	ps3_vuart_raw_read(dev, lb->data, bytes, &bytes);
-
-	lb->head = lb->data;
-	lb->tail = lb->data + bytes;
-	lb->dbg_number = ++dbg_number;
-
-	list_add_tail(&lb->link, &priv->rx_list.head);
-	priv->rx_list.bytes_held += bytes;
-
-	dev_dbg(&dev->core, "%s:%d: buf_%lu: queued %lxh bytes\n",
-		__func__, __LINE__, lb->dbg_number, bytes);
-
-	*bytes_queued = bytes;
-
-	return 0;
-}
-
-/**
- * ps3_vuart_read - The entry point for reading data from a port.
- *
- * Queue data waiting at the port, and if enough bytes to satisfy the request
- * are held in the buffer list those bytes are dequeued and copied to the
- * caller's buffer.  Emptied list buffers are retiered.  If the request cannot
- * be statified by bytes held in the list buffers -EAGAIN is returned.
- */
-
-int ps3_vuart_read(struct ps3_system_bus_device *dev, void *buf,
-	unsigned int bytes)
-{
-	int result;
-	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
-	unsigned long flags;
-	struct list_buffer *lb, *n;
-	unsigned long bytes_read;
-
-	dev_dbg(&dev->core, "%s:%d: %u(%xh) bytes\n", __func__, __LINE__,
-		bytes, bytes);
-
-	spin_lock_irqsave(&priv->rx_list.lock, flags);
-
-	/* Queue rx bytes here for polled reads. */
-
-	while (priv->rx_list.bytes_held < bytes) {
-		u64 tmp;
-
-		result = ps3_vuart_queue_rx_bytes(dev, &tmp);
-		if (result || !tmp) {
-			dev_dbg(&dev->core, "%s:%d: starved for %lxh bytes\n",
-				__func__, __LINE__,
-				bytes - priv->rx_list.bytes_held);
-			spin_unlock_irqrestore(&priv->rx_list.lock, flags);
-			return -EAGAIN;
-		}
-	}
-
-	list_for_each_entry_safe(lb, n, &priv->rx_list.head, link) {
-		bytes_read = min((unsigned int)(lb->tail - lb->head), bytes);
-
-		memcpy(buf, lb->head, bytes_read);
-		buf += bytes_read;
-		bytes -= bytes_read;
-		priv->rx_list.bytes_held -= bytes_read;
-
-		if (bytes_read < lb->tail - lb->head) {
-			lb->head += bytes_read;
-			dev_dbg(&dev->core, "%s:%d: buf_%lu: dequeued %lxh "
-				"bytes\n", __func__, __LINE__, lb->dbg_number,
-				bytes_read);
-			spin_unlock_irqrestore(&priv->rx_list.lock, flags);
-			return 0;
-		}
-
-		dev_dbg(&dev->core, "%s:%d: buf_%lu: free, dequeued %lxh "
-			"bytes\n", __func__, __LINE__, lb->dbg_number,
-			bytes_read);
-
-		list_del(&lb->link);
-		kfree(lb);
-	}
-
-	spin_unlock_irqrestore(&priv->rx_list.lock, flags);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(ps3_vuart_read);
-
-/**
- * ps3_vuart_work - Asynchronous read handler.
- */
-
-static void ps3_vuart_work(struct work_struct *work)
-{
-	struct ps3_system_bus_device *dev =
-		ps3_vuart_work_to_system_bus_dev(work);
-	struct ps3_vuart_port_driver *drv =
-		ps3_system_bus_dev_to_vuart_drv(dev);
-
-	BUG_ON(!drv);
-	drv->work(dev);
-}
-
-int ps3_vuart_read_async(struct ps3_system_bus_device *dev, unsigned int bytes)
-{
-	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
-	unsigned long flags;
-
-	if (priv->rx_list.work.trigger) {
-		dev_dbg(&dev->core, "%s:%d: warning, multiple calls\n",
-			__func__, __LINE__);
-		return -EAGAIN;
-	}
-
-	BUG_ON(!bytes);
-
-	PREPARE_WORK(&priv->rx_list.work.work, ps3_vuart_work);
-
-	spin_lock_irqsave(&priv->rx_list.lock, flags);
-	if (priv->rx_list.bytes_held >= bytes) {
-		dev_dbg(&dev->core, "%s:%d: schedule_work %xh bytes\n",
-			__func__, __LINE__, bytes);
-		schedule_work(&priv->rx_list.work.work);
-		spin_unlock_irqrestore(&priv->rx_list.lock, flags);
-		return 0;
-	}
-
-	priv->rx_list.work.trigger = bytes;
-	spin_unlock_irqrestore(&priv->rx_list.lock, flags);
-
-	dev_dbg(&dev->core, "%s:%d: waiting for %u(%xh) bytes\n", __func__,
-		__LINE__, bytes, bytes);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(ps3_vuart_read_async);
-
-void ps3_vuart_cancel_async(struct ps3_system_bus_device *dev)
-{
-	to_port_priv(dev)->rx_list.work.trigger = 0;
-}
-EXPORT_SYMBOL_GPL(ps3_vuart_cancel_async);
-
-/**
- * ps3_vuart_handle_interrupt_tx - third stage transmit interrupt handler
- *
- * Services the transmit interrupt for the port.  Writes as much data from the
- * buffer list as the port will accept.  Retires any emptied list buffers and
- * adjusts the final list buffer state for a partial write.
- */
-
-static int ps3_vuart_handle_interrupt_tx(struct ps3_system_bus_device *dev)
-{
-	int result = 0;
-	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
-	unsigned long flags;
-	struct list_buffer *lb, *n;
-	unsigned long bytes_total = 0;
-
-	dev_dbg(&dev->core, "%s:%d\n", __func__, __LINE__);
-
-	spin_lock_irqsave(&priv->tx_list.lock, flags);
-
-	list_for_each_entry_safe(lb, n, &priv->tx_list.head, link) {
-
-		unsigned long bytes_written;
-
-		result = ps3_vuart_raw_write(dev, lb->head, lb->tail - lb->head,
-			&bytes_written);
-
-		if (result) {
-			dev_dbg(&dev->core,
-				"%s:%d: ps3_vuart_raw_write failed\n",
-				__func__, __LINE__);
-			break;
-		}
-
-		bytes_total += bytes_written;
-
-		if (bytes_written < lb->tail - lb->head) {
-			lb->head += bytes_written;
-			dev_dbg(&dev->core,
-				"%s:%d cleared buf_%lu, %lxh bytes\n",
-				__func__, __LINE__, lb->dbg_number,
-				bytes_written);
-			goto port_full;
-		}
-
-		dev_dbg(&dev->core, "%s:%d free buf_%lu\n", __func__, __LINE__,
-			lb->dbg_number);
-
-		list_del(&lb->link);
-		kfree(lb);
-	}
-
-	ps3_vuart_disable_interrupt_tx(dev);
-port_full:
-	spin_unlock_irqrestore(&priv->tx_list.lock, flags);
-	dev_dbg(&dev->core, "%s:%d wrote %lxh bytes total\n",
-		__func__, __LINE__, bytes_total);
-	return result;
-}
-
-/**
- * ps3_vuart_handle_interrupt_rx - third stage receive interrupt handler
- *
- * Services the receive interrupt for the port.  Creates a list buffer and
- * copies all waiting port data to that buffer and enqueues the buffer in the
- * buffer list.  Buffer list data is dequeued via ps3_vuart_read.
- */
-
-static int ps3_vuart_handle_interrupt_rx(struct ps3_system_bus_device *dev)
-{
-	int result;
-	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
-	unsigned long flags;
-	u64 bytes;
-
-	dev_dbg(&dev->core, "%s:%d\n", __func__, __LINE__);
-
-	spin_lock_irqsave(&priv->rx_list.lock, flags);
-	result = ps3_vuart_queue_rx_bytes(dev, &bytes);
-
-	if (result) {
-		spin_unlock_irqrestore(&priv->rx_list.lock, flags);
-		return result;
-	}
-
-	if (priv->rx_list.work.trigger && priv->rx_list.bytes_held
-		>= priv->rx_list.work.trigger) {
-		dev_dbg(&dev->core, "%s:%d: schedule_work %lxh bytes\n",
-			__func__, __LINE__, priv->rx_list.work.trigger);
-		priv->rx_list.work.trigger = 0;
-		schedule_work(&priv->rx_list.work.work);
-	}
-
-	spin_unlock_irqrestore(&priv->rx_list.lock, flags);
-	return result;
-}
-
-static int ps3_vuart_handle_interrupt_disconnect(
-	struct ps3_system_bus_device *dev)
-{
-	dev_dbg(&dev->core, "%s:%d\n", __func__, __LINE__);
-	BUG_ON("no support");
-	return -1;
-}
-
-/**
- * ps3_vuart_handle_port_interrupt - second stage interrupt handler
- *
- * Services any pending interrupt types for the port.  Passes control to the
- * third stage type specific interrupt handler.  Returns control to the first
- * stage handler after one iteration.
- */
-
-static int ps3_vuart_handle_port_interrupt(struct ps3_system_bus_device *dev)
-{
-	int result;
-	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
-	unsigned long status;
-
-	result = ps3_vuart_get_interrupt_status(dev, &status);
-
-	if (result)
-		return result;
-
-	dev_dbg(&dev->core, "%s:%d: status: %lxh\n", __func__, __LINE__,
-		status);
-
-	if (status & INTERRUPT_MASK_DISCONNECT) {
-		priv->stats.disconnect_interrupts++;
-		result = ps3_vuart_handle_interrupt_disconnect(dev);
-		if (result)
-			ps3_vuart_disable_interrupt_disconnect(dev);
-	}
-
-	if (status & INTERRUPT_MASK_TX) {
-		priv->stats.tx_interrupts++;
-		result = ps3_vuart_handle_interrupt_tx(dev);
-		if (result)
-			ps3_vuart_disable_interrupt_tx(dev);
-	}
-
-	if (status & INTERRUPT_MASK_RX) {
-		priv->stats.rx_interrupts++;
-		result = ps3_vuart_handle_interrupt_rx(dev);
-		if (result)
-			ps3_vuart_disable_interrupt_rx(dev);
-	}
-
-	return 0;
-}
-
-struct vuart_bus_priv {
-	struct ports_bmp *bmp;
-	unsigned int virq;
-	struct semaphore probe_mutex;
-	int use_count;
-	struct ps3_system_bus_device *devices[PORT_COUNT];
-} static vuart_bus_priv;
-
-/**
- * ps3_vuart_irq_handler - first stage interrupt handler
- *
- * Loops finding any interrupting port and its associated instance data.
- * Passes control to the second stage port specific interrupt handler.  Loops
- * until all outstanding interrupts are serviced.
- */
-
-static irqreturn_t ps3_vuart_irq_handler(int irq, void *_private)
-{
-	struct vuart_bus_priv *bus_priv = _private;
-
-	BUG_ON(!bus_priv);
-
-	while (1) {
-		unsigned int port;
-
-		dump_ports_bmp(bus_priv->bmp);
-
-		port = (BITS_PER_LONG - 1) - __ilog2(bus_priv->bmp->status);
-
-		if (port == BITS_PER_LONG)
-			break;
-
-		BUG_ON(port >= PORT_COUNT);
-		BUG_ON(!bus_priv->devices[port]);
-
-		ps3_vuart_handle_port_interrupt(bus_priv->devices[port]);
-	}
-
-	return IRQ_HANDLED;
-}
-
-static int ps3_vuart_bus_interrupt_get(void)
-{
-	int result;
-
-	pr_debug(" -> %s:%d\n", __func__, __LINE__);
-
-	vuart_bus_priv.use_count++;
-
-	BUG_ON(vuart_bus_priv.use_count > 2);
-
-	if (vuart_bus_priv.use_count != 1) {
-		return 0;
-	}
-
-	BUG_ON(vuart_bus_priv.bmp);
-
-	vuart_bus_priv.bmp = kzalloc(sizeof(struct ports_bmp), GFP_KERNEL);
-
-	if (!vuart_bus_priv.bmp) {
-		pr_debug("%s:%d: kzalloc failed.\n", __func__, __LINE__);
-		result = -ENOMEM;
-		goto fail_bmp_malloc;
-	}
-
-	result = ps3_vuart_irq_setup(PS3_BINDING_CPU_ANY, vuart_bus_priv.bmp,
-		&vuart_bus_priv.virq);
-
-	if (result) {
-		pr_debug("%s:%d: ps3_vuart_irq_setup failed (%d)\n",
-			__func__, __LINE__, result);
-		result = -EPERM;
-		goto fail_alloc_irq;
-	}
-
-	result = request_irq(vuart_bus_priv.virq, ps3_vuart_irq_handler,
-		IRQF_DISABLED, "vuart", &vuart_bus_priv);
-
-	if (result) {
-		pr_debug("%s:%d: request_irq failed (%d)\n",
-			__func__, __LINE__, result);
-		goto fail_request_irq;
-	}
-
-	pr_debug(" <- %s:%d: ok\n", __func__, __LINE__);
-	return result;
-
-fail_request_irq:
-	ps3_vuart_irq_destroy(vuart_bus_priv.virq);
-	vuart_bus_priv.virq = NO_IRQ;
-fail_alloc_irq:
-	kfree(vuart_bus_priv.bmp);
-	vuart_bus_priv.bmp = NULL;
-fail_bmp_malloc:
-	vuart_bus_priv.use_count--;
-	pr_debug(" <- %s:%d: failed\n", __func__, __LINE__);
-	return result;
-}
-
-static int ps3_vuart_bus_interrupt_put(void)
-{
-	pr_debug(" -> %s:%d\n", __func__, __LINE__);
-
-	vuart_bus_priv.use_count--;
-
-	BUG_ON(vuart_bus_priv.use_count < 0);
-
-	if (vuart_bus_priv.use_count != 0)
-		return 0;
-
-	free_irq(vuart_bus_priv.virq, &vuart_bus_priv);
-
-	ps3_vuart_irq_destroy(vuart_bus_priv.virq);
-	vuart_bus_priv.virq = NO_IRQ;
-
-	kfree(vuart_bus_priv.bmp);
-	vuart_bus_priv.bmp = NULL;
-
-	pr_debug(" <- %s:%d\n", __func__, __LINE__);
-	return 0;
-}
-
-static int ps3_vuart_probe(struct ps3_system_bus_device *dev)
-{
-	int result;
-	struct ps3_vuart_port_driver *drv;
-	struct ps3_vuart_port_priv *priv = NULL;
-
-	dev_dbg(&dev->core, "%s:%d\n", __func__, __LINE__);
-
-	drv = ps3_system_bus_dev_to_vuart_drv(dev);
-
-	dev_dbg(&dev->core, "%s:%d: (%s)\n", __func__, __LINE__,
-		drv->core.core.name);
-
-	BUG_ON(!drv);
-
-	if (dev->port_number >= PORT_COUNT) {
-		BUG();
-		return -EINVAL;
-	}
-
-	down(&vuart_bus_priv.probe_mutex);
-
-	result = ps3_vuart_bus_interrupt_get();
-
-	if (result)
-		goto fail_setup_interrupt;
-
-	if (vuart_bus_priv.devices[dev->port_number]) {
-		dev_dbg(&dev->core, "%s:%d: port busy (%d)\n", __func__,
-			__LINE__, dev->port_number);
-		result = -EBUSY;
-		goto fail_busy;
-	}
-
-	vuart_bus_priv.devices[dev->port_number] = dev;
-
-	/* Setup dev->driver_priv. */
-
-	dev->driver_priv = kzalloc(sizeof(struct ps3_vuart_port_priv),
-		GFP_KERNEL);
-
-	if (!dev->driver_priv) {
-		result = -ENOMEM;
-		goto fail_dev_malloc;
-	}
-
-	priv = to_port_priv(dev);
-
-	INIT_LIST_HEAD(&priv->tx_list.head);
-	spin_lock_init(&priv->tx_list.lock);
-
-	INIT_LIST_HEAD(&priv->rx_list.head);
-	spin_lock_init(&priv->rx_list.lock);
-
-	INIT_WORK(&priv->rx_list.work.work, NULL);
-	priv->rx_list.work.trigger = 0;
-	priv->rx_list.work.dev = dev;
-
-	/* clear stale pending interrupts */
-
-	ps3_vuart_clear_rx_bytes(dev, 0);
-
-	ps3_vuart_set_interrupt_mask(dev, INTERRUPT_MASK_RX);
-
-	ps3_vuart_set_triggers(dev, 1, 1);
-
-	if (drv->probe)
-		result = drv->probe(dev);
-	else {
-		result = 0;
-		dev_info(&dev->core, "%s:%d: no probe method\n", __func__,
-			__LINE__);
-	}
-
-	if (result) {
-		dev_dbg(&dev->core, "%s:%d: drv->probe failed\n",
-			__func__, __LINE__);
-		down(&vuart_bus_priv.probe_mutex);
-		goto fail_probe;
-	}
-
-	up(&vuart_bus_priv.probe_mutex);
-
-	return result;
-
-fail_probe:
-	ps3_vuart_set_interrupt_mask(dev, 0);
-	kfree(dev->driver_priv);
-	dev->driver_priv = NULL;
-fail_dev_malloc:
-	vuart_bus_priv.devices[dev->port_number] = NULL;
-fail_busy:
-	ps3_vuart_bus_interrupt_put();
-fail_setup_interrupt:
-	up(&vuart_bus_priv.probe_mutex);
-	dev_dbg(&dev->core, "%s:%d: failed\n", __func__, __LINE__);
-	return result;
-}
-
-/**
- * ps3_vuart_cleanup - common cleanup helper.
- * @dev: The struct ps3_system_bus_device instance.
- *
- * Cleans interrupts and HV resources.  Must be called with
- * vuart_bus_priv.probe_mutex held.  Used by ps3_vuart_remove and
- * ps3_vuart_shutdown.  After this call, polled reading will still work.
- */
-
-static int ps3_vuart_cleanup(struct ps3_system_bus_device *dev)
-{
-	dev_dbg(&dev->core, "%s:%d\n", __func__, __LINE__);
-
-	ps3_vuart_cancel_async(dev);
-	ps3_vuart_set_interrupt_mask(dev, 0);
-	ps3_vuart_bus_interrupt_put();
-	return 0;
-}
-
-/**
- * ps3_vuart_remove - Completely clean the device instance.
- * @dev: The struct ps3_system_bus_device instance.
- *
- * Cleans all memory, interrupts and HV resources.  After this call the
- * device can no longer be used.
- */
-
-static int ps3_vuart_remove(struct ps3_system_bus_device *dev)
-{
-	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
-	struct ps3_vuart_port_driver *drv;
-
-	BUG_ON(!dev);
-
-	down(&vuart_bus_priv.probe_mutex);
-
-	dev_dbg(&dev->core, " -> %s:%d: match_id %d\n", __func__, __LINE__,
-		dev->match_id);
-
-	if (!dev->core.driver) {
-		dev_dbg(&dev->core, "%s:%d: no driver bound\n", __func__,
-			__LINE__);
-		up(&vuart_bus_priv.probe_mutex);
-		return 0;
-	}
-
-	drv = ps3_system_bus_dev_to_vuart_drv(dev);
-
-	BUG_ON(!drv);
-
-	if (drv->remove) {
-		drv->remove(dev);
-	} else {
-		dev_dbg(&dev->core, "%s:%d: no remove method\n", __func__,
-		__LINE__);
-		BUG();
-	}
-
-	ps3_vuart_cleanup(dev);
-
-	vuart_bus_priv.devices[dev->port_number] = NULL;
-	kfree(priv);
-	priv = NULL;
-
-	dev_dbg(&dev->core, " <- %s:%d\n", __func__, __LINE__);
-	up(&vuart_bus_priv.probe_mutex);
-	return 0;
-}
-
-/**
- * ps3_vuart_shutdown - Cleans interrupts and HV resources.
- * @dev: The struct ps3_system_bus_device instance.
- *
- * Cleans interrupts and HV resources.  After this call the
- * device can still be used in polling mode.  This behavior required
- * by sys-manager to be able to complete the device power operation
- * sequence.
- */
-
-static int ps3_vuart_shutdown(struct ps3_system_bus_device *dev)
-{
-	struct ps3_vuart_port_driver *drv;
-
-	BUG_ON(!dev);
-
-	down(&vuart_bus_priv.probe_mutex);
-
-	dev_dbg(&dev->core, " -> %s:%d: match_id %d\n", __func__, __LINE__,
-		dev->match_id);
-
-	if (!dev->core.driver) {
-		dev_dbg(&dev->core, "%s:%d: no driver bound\n", __func__,
-			__LINE__);
-		up(&vuart_bus_priv.probe_mutex);
-		return 0;
-	}
-
-	drv = ps3_system_bus_dev_to_vuart_drv(dev);
-
-	BUG_ON(!drv);
-
-	if (drv->shutdown)
-		drv->shutdown(dev);
-	else if (drv->remove) {
-		dev_dbg(&dev->core, "%s:%d: no shutdown, calling remove\n",
-			__func__, __LINE__);
-		drv->remove(dev);
-	} else {
-		dev_dbg(&dev->core, "%s:%d: no shutdown method\n", __func__,
-			__LINE__);
-		BUG();
-	}
-
-	ps3_vuart_cleanup(dev);
-
-	dev_dbg(&dev->core, " <- %s:%d\n", __func__, __LINE__);
-
-	up(&vuart_bus_priv.probe_mutex);
-	return 0;
-}
-
-static int __init ps3_vuart_bus_init(void)
-{
-	pr_debug("%s:%d:\n", __func__, __LINE__);
-
-	if (!firmware_has_feature(FW_FEATURE_PS3_LV1))
-		return -ENODEV;
-
-	init_MUTEX(&vuart_bus_priv.probe_mutex);
-
-	return 0;
-}
-
-static void __exit ps3_vuart_bus_exit(void)
-{
-	pr_debug("%s:%d:\n", __func__, __LINE__);
-}
-
-core_initcall(ps3_vuart_bus_init);
-module_exit(ps3_vuart_bus_exit);
-
-/**
- * ps3_vuart_port_driver_register - Add a vuart port device driver.
- */
-
-int ps3_vuart_port_driver_register(struct ps3_vuart_port_driver *drv)
-{
-	int result;
-
-	pr_debug("%s:%d: (%s)\n", __func__, __LINE__, drv->core.core.name);
-
-	BUG_ON(!drv->core.match_id);
-	BUG_ON(!drv->core.core.name);
-
-	drv->core.probe = ps3_vuart_probe;
-	drv->core.remove = ps3_vuart_remove;
-	drv->core.shutdown = ps3_vuart_shutdown;
-
-	result = ps3_system_bus_driver_register(&drv->core);
-	return result;
-}
-EXPORT_SYMBOL_GPL(ps3_vuart_port_driver_register);
-
-/**
- * ps3_vuart_port_driver_unregister - Remove a vuart port device driver.
- */
-
-void ps3_vuart_port_driver_unregister(struct ps3_vuart_port_driver *drv)
-{
-	pr_debug("%s:%d: (%s)\n", __func__, __LINE__, drv->core.core.name);
-	ps3_system_bus_driver_unregister(&drv->core);
-}
-EXPORT_SYMBOL_GPL(ps3_vuart_port_driver_unregister);
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
time-fold-__get_realtime_clock_ts-into-getnstimeofday.patch
ps3-checkpatch-drivers-ps3-ps3-sys-managerc.patch
ps3-checkpatch-drivers-ps3-ps3-vuartc.patch

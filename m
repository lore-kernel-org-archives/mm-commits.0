From: akpm@linux-foundation.org
Subject: - ibmasm-dont-use-extern-in-function-declarations.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:02:46 -0700
Message-ID: <200707172302.l6HN2keA011620@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52539 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936783AbXGQXQp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dtor@insightbb.com, dtor@mail.ru, masbock@us.ibm.com, vernux@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     IBMASM: dont use extern in function declarations
has been removed from the -mm tree.  Its filename was
     ibmasm-dont-use-extern-in-function-declarations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: IBMASM: dont use extern in function declarations
From: Dmitry Torokhov <dtor@insightbb.com>

IBMASM: don't use extern in function declarations

We normally don't use extern in function declarations located in header files.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Cc: Vernon Mauery <vernux@us.ibm.com>
Cc: Max Asbock <masbock@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/ibmasm/ibmasm.h |   64 ++++++++++++++++-----------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff -puN drivers/misc/ibmasm/ibmasm.h~ibmasm-dont-use-extern-in-function-declarations drivers/misc/ibmasm/ibmasm.h
--- a/drivers/misc/ibmasm/ibmasm.h~ibmasm-dont-use-extern-in-function-declarations
+++ a/drivers/misc/ibmasm/ibmasm.h
@@ -163,55 +163,55 @@ struct service_processor {
 };
 
 /* command processing */
-extern struct command *ibmasm_new_command(struct service_processor *sp, size_t buffer_size);
-extern void ibmasm_exec_command(struct service_processor *sp, struct command *cmd);
-extern void ibmasm_wait_for_response(struct command *cmd, int timeout);
-extern void ibmasm_receive_command_response(struct service_processor *sp, void *response,  size_t size);
+struct command *ibmasm_new_command(struct service_processor *sp, size_t buffer_size);
+void ibmasm_exec_command(struct service_processor *sp, struct command *cmd);
+void ibmasm_wait_for_response(struct command *cmd, int timeout);
+void ibmasm_receive_command_response(struct service_processor *sp, void *response,  size_t size);
 
 /* event processing */
-extern int ibmasm_event_buffer_init(struct service_processor *sp);
-extern void ibmasm_event_buffer_exit(struct service_processor *sp);
-extern void ibmasm_receive_event(struct service_processor *sp, void *data,  unsigned int data_size);
-extern void ibmasm_event_reader_register(struct service_processor *sp, struct event_reader *reader);
-extern void ibmasm_event_reader_unregister(struct service_processor *sp, struct event_reader *reader);
-extern int ibmasm_get_next_event(struct service_processor *sp, struct event_reader *reader);
-extern void ibmasm_cancel_next_event(struct event_reader *reader);
+int ibmasm_event_buffer_init(struct service_processor *sp);
+void ibmasm_event_buffer_exit(struct service_processor *sp);
+void ibmasm_receive_event(struct service_processor *sp, void *data,  unsigned int data_size);
+void ibmasm_event_reader_register(struct service_processor *sp, struct event_reader *reader);
+void ibmasm_event_reader_unregister(struct service_processor *sp, struct event_reader *reader);
+int ibmasm_get_next_event(struct service_processor *sp, struct event_reader *reader);
+void ibmasm_cancel_next_event(struct event_reader *reader);
 
 /* heartbeat - from SP to OS */
-extern void ibmasm_register_panic_notifier(void);
-extern void ibmasm_unregister_panic_notifier(void);
-extern int ibmasm_heartbeat_init(struct service_processor *sp);
-extern void ibmasm_heartbeat_exit(struct service_processor *sp);
-extern void ibmasm_receive_heartbeat(struct service_processor *sp,  void *message, size_t size);
+void ibmasm_register_panic_notifier(void);
+void ibmasm_unregister_panic_notifier(void);
+int ibmasm_heartbeat_init(struct service_processor *sp);
+void ibmasm_heartbeat_exit(struct service_processor *sp);
+void ibmasm_receive_heartbeat(struct service_processor *sp,  void *message, size_t size);
 
 /* reverse heartbeat - from OS to SP */
-extern void ibmasm_init_reverse_heartbeat(struct service_processor *sp, struct reverse_heartbeat *rhb);
-extern int ibmasm_start_reverse_heartbeat(struct service_processor *sp, struct reverse_heartbeat *rhb);
-extern void ibmasm_stop_reverse_heartbeat(struct reverse_heartbeat *rhb);
+void ibmasm_init_reverse_heartbeat(struct service_processor *sp, struct reverse_heartbeat *rhb);
+int ibmasm_start_reverse_heartbeat(struct service_processor *sp, struct reverse_heartbeat *rhb);
+void ibmasm_stop_reverse_heartbeat(struct reverse_heartbeat *rhb);
 
 /* dot commands */
-extern void ibmasm_receive_message(struct service_processor *sp, void *data, int data_size);
-extern int ibmasm_send_driver_vpd(struct service_processor *sp);
-extern int ibmasm_send_os_state(struct service_processor *sp, int os_state);
+void ibmasm_receive_message(struct service_processor *sp, void *data, int data_size);
+int ibmasm_send_driver_vpd(struct service_processor *sp);
+int ibmasm_send_os_state(struct service_processor *sp, int os_state);
 
 /* low level message processing */
-extern int ibmasm_send_i2o_message(struct service_processor *sp);
-extern irqreturn_t ibmasm_interrupt_handler(int irq, void * dev_id);
+int ibmasm_send_i2o_message(struct service_processor *sp);
+irqreturn_t ibmasm_interrupt_handler(int irq, void * dev_id);
 
 /* remote console */
-extern void ibmasm_handle_mouse_interrupt(struct service_processor *sp);
-extern int ibmasm_init_remote_input_dev(struct service_processor *sp);
-extern void ibmasm_free_remote_input_dev(struct service_processor *sp);
+void ibmasm_handle_mouse_interrupt(struct service_processor *sp);
+int ibmasm_init_remote_input_dev(struct service_processor *sp);
+void ibmasm_free_remote_input_dev(struct service_processor *sp);
 
 /* file system */
-extern int ibmasmfs_register(void);
-extern void ibmasmfs_unregister(void);
-extern void ibmasmfs_add_sp(struct service_processor *sp);
+int ibmasmfs_register(void);
+void ibmasmfs_unregister(void);
+void ibmasmfs_add_sp(struct service_processor *sp);
 
 /* uart */
 #ifdef CONFIG_SERIAL_8250
-extern void ibmasm_register_uart(struct service_processor *sp);
-extern void ibmasm_unregister_uart(struct service_processor *sp);
+void ibmasm_register_uart(struct service_processor *sp);
+void ibmasm_unregister_uart(struct service_processor *sp);
 #else
 #define ibmasm_register_uart(sp)	do { } while(0)
 #define ibmasm_unregister_uart(sp)	do { } while(0)
_

Patches currently in -mm which might be from dtor@insightbb.com are

origin.patch
git-dvb.patch
git-input.patch
hdaps-switch-to-using-input-polldev.patch
applesmc-switch-to-using-input-polldev.patch
ams-switch-to-using-input-polldev.patch

From: akpm@linux-foundation.org
Subject: [merged] input-allow-certain-ev_abs-events-to-bypass-all-filtering.patch removed from -mm tree
Date: Wed, 29 Apr 2009 12:17:45 -0700
Message-ID: <200904291917.n3TJHjD4030686@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760667AbZD2T2v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Apr 2009 15:28:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rydberg@euromail.se, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     input: allow certain EV_ABS events to bypass all filtering
has been removed from the -mm tree.  Its filename was
     input-allow-certain-ev_abs-events-to-bypass-all-filtering.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: allow certain EV_ABS events to bypass all filtering
From: Henrik Rydberg <rydberg@euromail.se>

With the upcoming multi-touch interface as an example, there is a need to
make certain that all reported events actually get passed to the event
handler.  This patch equips the input core with the ability to bypass all
filtering for certain EV_ABS events.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/input.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff -puN drivers/input/input.c~input-allow-certain-ev_abs-events-to-bypass-all-filtering drivers/input/input.c
--- a/drivers/input/input.c~input-allow-certain-ev_abs-events-to-bypass-all-filtering
+++ a/drivers/input/input.c
@@ -29,6 +29,13 @@ MODULE_LICENSE("GPL");
 
 #define INPUT_DEVICES	256
 
+/*
+ * EV_ABS events which should not be cached are listed here.
+ */
+static __initdata unsigned int input_abs_bypass_init_data[] = {
+	0
+};
+
 static LIST_HEAD(input_dev_list);
 static LIST_HEAD(input_handler_list);
 
@@ -42,6 +49,8 @@ static DEFINE_MUTEX(input_mutex);
 
 static struct input_handler *input_table[8];
 
+static unsigned long input_abs_bypass[BITS_TO_LONGS(ABS_CNT)];
+
 static inline int is_event_supported(unsigned int code,
 				     unsigned long *bm, unsigned int max)
 {
@@ -192,6 +201,11 @@ static void input_handle_event(struct in
 	case EV_ABS:
 		if (is_event_supported(code, dev->absbit, ABS_MAX)) {
 
+			if (test_bit(code, input_abs_bypass)) {
+				disposition = INPUT_PASS_TO_HANDLERS;
+				break;
+			}
+
 			value = input_defuzz_abs_event(value,
 					dev->abs[code], dev->absfuzz[code]);
 
@@ -1634,10 +1648,19 @@ static const struct file_operations inpu
 	.open = input_open_file,
 };
 
+static void __init input_init_abs_bypass()
+{
+	const unsigned int *p;
+	for (p = input_abs_bypass_init_data; *p; p++)
+		input_abs_bypass[BIT_WORD(*p)] |= BIT_MASK(*p);
+}
+
 static int __init input_init(void)
 {
 	int err;
 
+	input_init_abs_bypass();
+
 	err = class_register(&input_class);
 	if (err) {
 		printk(KERN_ERR "input: unable to register input_dev class\n");
_

Patches currently in -mm which might be from rydberg@euromail.se are

linux-next.patch
input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger.patch


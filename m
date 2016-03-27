From: akpm@linux-foundation.org
Subject: [merged] drivers-input-eliminate-input_compat_test-macro.patch
 removed from -mm tree
Date: Sat, 26 Mar 2016 20:30:10 -0700
Message-ID: <56f753c2.awzrnltYMTYAHU/6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33111 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648AbcC0DaL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 26 Mar 2016 23:30:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dmitry.torokhov@gmail.com, luto@amacapital.net, luto@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/input: eliminate INPUT_COMPAT_TEST macro
has been removed from the -mm tree.  Its filename was
     drivers-input-eliminate-input_compat_test-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/input: eliminate INPUT_COMPAT_TEST macro

INPUT_COMPAT_TEST because much simpler after f4056b52845283 ("input:
redefine INPUT_COMPAT_TEST as in_compat_syscall()") so we can cleanly
eliminate it altogether.

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/input-compat.c |    6 +++---
 drivers/input/input-compat.h |    4 +---
 drivers/input/input.c        |    2 +-
 drivers/input/misc/uinput.c  |    4 ++--
 4 files changed, 7 insertions(+), 9 deletions(-)

diff -puN drivers/input/input-compat.c~drivers-input-eliminate-input_compat_test-macro drivers/input/input-compat.c
--- a/drivers/input/input-compat.c~drivers-input-eliminate-input_compat_test-macro
+++ a/drivers/input/input-compat.c
@@ -17,7 +17,7 @@
 int input_event_from_user(const char __user *buffer,
 			  struct input_event *event)
 {
-	if (INPUT_COMPAT_TEST && !COMPAT_USE_64BIT_TIME) {
+	if (in_compat_syscall() && !COMPAT_USE_64BIT_TIME) {
 		struct input_event_compat compat_event;
 
 		if (copy_from_user(&compat_event, buffer,
@@ -41,7 +41,7 @@ int input_event_from_user(const char __u
 int input_event_to_user(char __user *buffer,
 			const struct input_event *event)
 {
-	if (INPUT_COMPAT_TEST && !COMPAT_USE_64BIT_TIME) {
+	if (in_compat_syscall() && !COMPAT_USE_64BIT_TIME) {
 		struct input_event_compat compat_event;
 
 		compat_event.time.tv_sec = event->time.tv_sec;
@@ -65,7 +65,7 @@ int input_event_to_user(char __user *buf
 int input_ff_effect_from_user(const char __user *buffer, size_t size,
 			      struct ff_effect *effect)
 {
-	if (INPUT_COMPAT_TEST) {
+	if (in_compat_syscall()) {
 		struct ff_effect_compat *compat_effect;
 
 		if (size != sizeof(struct ff_effect_compat))
diff -puN drivers/input/input-compat.h~drivers-input-eliminate-input_compat_test-macro drivers/input/input-compat.h
--- a/drivers/input/input-compat.h~drivers-input-eliminate-input_compat_test-macro
+++ a/drivers/input/input-compat.h
@@ -17,8 +17,6 @@
 
 #ifdef CONFIG_COMPAT
 
-#define INPUT_COMPAT_TEST in_compat_syscall()
-
 struct input_event_compat {
 	struct compat_timeval time;
 	__u16 type;
@@ -57,7 +55,7 @@ struct ff_effect_compat {
 
 static inline size_t input_event_size(void)
 {
-	return (INPUT_COMPAT_TEST && !COMPAT_USE_64BIT_TIME) ?
+	return (in_compat_syscall() && !COMPAT_USE_64BIT_TIME) ?
 		sizeof(struct input_event_compat) : sizeof(struct input_event);
 }
 
diff -puN drivers/input/input.c~drivers-input-eliminate-input_compat_test-macro drivers/input/input.c
--- a/drivers/input/input.c~drivers-input-eliminate-input_compat_test-macro
+++ a/drivers/input/input.c
@@ -1015,7 +1015,7 @@ static int input_bits_to_string(char *bu
 {
 	int len = 0;
 
-	if (INPUT_COMPAT_TEST) {
+	if (in_compat_syscall()) {
 		u32 dword = bits >> 32;
 		if (dword || !skip_empty)
 			len += snprintf(buf, buf_size, "%x ", dword);
diff -puN drivers/input/misc/uinput.c~drivers-input-eliminate-input_compat_test-macro drivers/input/misc/uinput.c
--- a/drivers/input/misc/uinput.c~drivers-input-eliminate-input_compat_test-macro
+++ a/drivers/input/misc/uinput.c
@@ -664,7 +664,7 @@ struct uinput_ff_upload_compat {
 static int uinput_ff_upload_to_user(char __user *buffer,
 				    const struct uinput_ff_upload *ff_up)
 {
-	if (INPUT_COMPAT_TEST) {
+	if (in_compat_syscall()) {
 		struct uinput_ff_upload_compat ff_up_compat;
 
 		ff_up_compat.request_id = ff_up->request_id;
@@ -695,7 +695,7 @@ static int uinput_ff_upload_to_user(char
 static int uinput_ff_upload_from_user(const char __user *buffer,
 				      struct uinput_ff_upload *ff_up)
 {
-	if (INPUT_COMPAT_TEST) {
+	if (in_compat_syscall()) {
 		struct uinput_ff_upload_compat ff_up_compat;
 
 		if (copy_from_user(&ff_up_compat, buffer,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
include-linux-nodemaskh-create-next_node_in-helper.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch


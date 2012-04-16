From: akpm@linux-foundation.org
Subject: + c-r-ipc-selftest-tor-new-msg_peek_all-flag-for-msgrcv-checkpatch-fixes.patch added to -mm tree
Date: Mon, 16 Apr 2012 15:14:52 -0700
Message-ID: <20120416221452.A3EDBA01F8@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:33928 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751319Ab2DPWOz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Apr 2012 18:14:55 -0400
Received: by laai8 with SMTP id i8so261668laa.1
        for <mm-commits@vger.kernel.org>; Mon, 16 Apr 2012 15:14:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, skinsbursky@parallels.com


The patch titled
     Subject: c-r-ipc-selftest-tor-new-msg_peek_all-flag-for-msgrcv-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     c-r-ipc-selftest-tor-new-msg_peek_all-flag-for-msgrcv-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: c-r-ipc-selftest-tor-new-msg_peek_all-flag-for-msgrcv-checkpatch-fixes

ERROR: spaces required around that '=' (ctx:VxV)
#92: FILE: tools/testing/selftests/ipc/msgque_peek_all.c:29:
+const char *test_doc="Tests sysv5 msg queues supporting by checkpointing";
                     ^

ERROR: spaces required around that '=' (ctx:VxV)
#93: FILE: tools/testing/selftests/ipc/msgque_peek_all.c:30:
+const char *test_author="Stanislav Kinsbursky <skinsbursky@openvz.org>";
                        ^

ERROR: space required before the open parenthesis '('
#114: FILE: tools/testing/selftests/ipc/msgque_peek_all.c:51:
+	while(messages[i].mtype > 0) {

WARNING: quoted string split across lines
#123: FILE: tools/testing/selftests/ipc/msgque_peek_all.c:60:
+			printf("Received message[%i] size is wrong: %d "
+					"(should be %ld)\n", i,

WARNING: line over 80 characters
#170: FILE: tools/testing/selftests/ipc/msgque_peek_all.c:107:
+			printf("Peeked message type is wrong: %ld (should be %ld)\n",

WARNING: line over 80 characters
#178: FILE: tools/testing/selftests/ipc/msgque_peek_all.c:115:
+		ptr += round_up(msg->msize + sizeof(struct msgbuf_a), sizeof(struct msgbuf_a));

ERROR: space required before the open parenthesis '('
#188: FILE: tools/testing/selftests/ipc/msgque_peek_all.c:125:
+	while(messages[i].mtype > 0) {

WARNING: line over 80 characters
#189: FILE: tools/testing/selftests/ipc/msgque_peek_all.c:126:
+		if (msgsnd(msgq, &messages[i], strlen(messages[i].mtext) + 1, IPC_NOWAIT) != 0) {

total: 4 errors, 4 warnings, 201 lines checked

./patches/c-r-ipc-selftest-tor-new-msg_peek_all-flag-for-msgrcv.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/ipc/msgque_peek_all.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN tools/testing/selftests/ipc/msgque_peek_all.c~c-r-ipc-selftest-tor-new-msg_peek_all-flag-for-msgrcv-checkpatch-fixes tools/testing/selftests/ipc/msgque_peek_all.c
--- a/tools/testing/selftests/ipc/msgque_peek_all.c~c-r-ipc-selftest-tor-new-msg_peek_all-flag-for-msgrcv-checkpatch-fixes
+++ a/tools/testing/selftests/ipc/msgque_peek_all.c
@@ -26,8 +26,8 @@ struct msgbuf_a {
 };
 #endif
 
-const char *test_doc="Tests sysv5 msg queues supporting by checkpointing";
-const char *test_author="Stanislav Kinsbursky <skinsbursky@openvz.org>";
+const char *test_doc = "Tests sysv5 msg queues supporting by checkpointing";
+const char *test_author = "Stanislav Kinsbursky <skinsbursky@openvz.org>";
 
 #define MAX_MSG_LENGTH		32
 
@@ -48,7 +48,7 @@ static int receive_messages(int msgq)
 	struct my_msg msgbuf;
 
 	i = 0;
-	while(messages[i].mtype > 0) {
+	while (messages[i].mtype > 0) {
 		ret = msgrcv(msgq, &msgbuf, MAX_MSG_LENGTH,
 				messages[i].mtype, IPC_NOWAIT);
 		if (ret < 0) {
@@ -122,7 +122,7 @@ static int send_messages(int msgq)
 {
 	int i = 0;
 
-	while(messages[i].mtype > 0) {
+	while (messages[i].mtype > 0) {
 		if (msgsnd(msgq, &messages[i], strlen(messages[i].mtext) + 1, IPC_NOWAIT) != 0) {
 			printf("Parent: msgsnd[%i] failed (%m)", i);
 			return -errno;
_
Subject: Subject: c-r-ipc-selftest-tor-new-msg_peek_all-flag-for-msgrcv-checkpatch-fixes

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
mm-correctly-synchronize-rss-counters-at-exit-exec-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-apic-io_apicc-move-io_apic_level_ack_pending-inside-config_generic_pending_irq.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
percpu-remove-percpu_xxx-functions-fix.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
brlocks-lglocks-cleanups.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix.patch
vsprintf-correctly-handle-width-when-flag-used-in-%p-format-checkpatch-fixes.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
leds-led-module-for-da9052-53-pmic-v2-fix.patch
leds-add-led-driver-for-lm3556-chip-checkpatch-fixes.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
proc-clean-up-proc-pid-environ-handling-checkpatch-fixes.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
c-r-ipc-selftest-tor-new-msg_peek_all-flag-for-msgrcv-checkpatch-fixes.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


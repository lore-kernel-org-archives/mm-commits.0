From: akpm@linux-foundation.org
Subject: + frv-extend-gdbstub-to-support-more-features-of-gdb.patch added to -mm tree
Date: Fri, 26 Mar 2010 16:36:03 -0700
Message-ID: <201003262336.o2QNa3xY027567@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60602 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753415Ab0CZXgK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 19:36:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, jason.wessel@windriver.com


The patch titled
     frv: extend gdbstub to support more features of gdb
has been added to the -mm tree.  Its filename is
     frv-extend-gdbstub-to-support-more-features-of-gdb.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: frv: extend gdbstub to support more features of gdb
From: David Howells <dhowells@redhat.com>

Extend gdbstub to support more features of gdb remote protocol to keep
gdb-7 and emacs gud mode happy:

 (*) The D command.  Detach debugger.

 (*) The H command.  Handle setting the target thread by ignoring it.

 (*) The qAttached command.  Indicate we 'attached' to an existing process.

 (*) The qC command.  Indicate that the current thread ID is 0.

 (*) The qOffsets command.  Indicate that no relocation has been done.

 (*) The qSymbol:: command.  Indicate that we're not interested in looking up
     any symbol addresses.

 (*) The qSupported command.  Indicate the maximum packet size and the fact
     that reverse step and continue aren't supported.

 (*) The vCont? command.  Indicate that we don't support any of its variants.

Also make it possible to trace the commands and replies without tracing
the individual character I/O.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/include/asm/gdb-stub.h |    7 +++
 arch/frv/kernel/gdb-io.c        |    4 -
 arch/frv/kernel/gdb-stub.c      |   61 ++++++++++++++++++++++++++++++
 3 files changed, 70 insertions(+), 2 deletions(-)

diff -puN arch/frv/include/asm/gdb-stub.h~frv-extend-gdbstub-to-support-more-features-of-gdb arch/frv/include/asm/gdb-stub.h
--- a/arch/frv/include/asm/gdb-stub.h~frv-extend-gdbstub-to-support-more-features-of-gdb
+++ a/arch/frv/include/asm/gdb-stub.h
@@ -12,6 +12,7 @@
 #ifndef __ASM_GDB_STUB_H
 #define __ASM_GDB_STUB_H
 
+#undef GDBSTUB_DEBUG_IO
 #undef GDBSTUB_DEBUG_PROTOCOL
 
 #include <asm/ptrace.h>
@@ -108,6 +109,12 @@ extern void gdbstub_printk(const char *f
 extern void debug_to_serial(const char *p, int n);
 extern void console_set_baud(unsigned baud);
 
+#ifdef GDBSTUB_DEBUG_IO
+#define gdbstub_io(FMT,...) gdbstub_printk(FMT, ##__VA_ARGS__)
+#else
+#define gdbstub_io(FMT,...) ({ 0; })
+#endif
+
 #ifdef GDBSTUB_DEBUG_PROTOCOL
 #define gdbstub_proto(FMT,...) gdbstub_printk(FMT,##__VA_ARGS__)
 #else
diff -puN arch/frv/kernel/gdb-io.c~frv-extend-gdbstub-to-support-more-features-of-gdb arch/frv/kernel/gdb-io.c
--- a/arch/frv/kernel/gdb-io.c~frv-extend-gdbstub-to-support-more-features-of-gdb
+++ a/arch/frv/kernel/gdb-io.c
@@ -171,11 +171,11 @@ int gdbstub_rx_char(unsigned char *_ch, 
 		return -EINTR;
 	}
 	else if (st & (UART_LSR_FE|UART_LSR_OE|UART_LSR_PE)) {
-		gdbstub_proto("### GDB Rx Error (st=%02x) ###\n",st);
+		gdbstub_io("### GDB Rx Error (st=%02x) ###\n",st);
 		return -EIO;
 	}
 	else {
-		gdbstub_proto("### GDB Rx %02x (st=%02x) ###\n",ch,st);
+		gdbstub_io("### GDB Rx %02x (st=%02x) ###\n",ch,st);
 		*_ch = ch & 0x7f;
 		return 0;
 	}
diff -puN arch/frv/kernel/gdb-stub.c~frv-extend-gdbstub-to-support-more-features-of-gdb arch/frv/kernel/gdb-stub.c
--- a/arch/frv/kernel/gdb-stub.c~frv-extend-gdbstub-to-support-more-features-of-gdb
+++ a/arch/frv/kernel/gdb-stub.c
@@ -1344,6 +1344,44 @@ void gdbstub_get_mmu_state(void)
 
 } /* end gdbstub_get_mmu_state() */
 
+/*
+ * handle general query commands of the form 'qXXXXX'
+ */
+void gdbstub_handle_query(void)
+{
+	if (strcmp(input_buffer, "qAttached") == 0) {
+		/* return current thread ID */
+		sprintf(output_buffer, "1");
+		return;
+	}
+
+	if (strcmp(input_buffer, "qC") == 0) {
+		/* return current thread ID */
+		sprintf(output_buffer, "QC 0");
+		return;
+	}
+
+	if (strcmp(input_buffer, "qOffsets") == 0) {
+		/* return relocation offset of text and data segments */
+		sprintf(output_buffer, "Text=0;Data=0;Bss=0");
+		return;
+	}
+
+	if (strcmp(input_buffer, "qSymbol::") == 0) {
+		sprintf(output_buffer, "OK");
+		return;
+	}
+
+	if (strcmp(input_buffer, "qSupported") == 0) {
+		/* query of supported features */
+		sprintf(output_buffer, "PacketSize=%u;ReverseContinue-;ReverseStep-",
+			sizeof(input_buffer));
+		return;
+	}
+
+	gdbstub_strcpy(output_buffer,"E01");
+}
+
 /*****************************************************************************/
 /*
  * handle event interception and GDB remote protocol processing
@@ -1840,6 +1878,10 @@ void gdbstub(int sigval)
 		case 'k' :
 			goto done;	/* just continue */
 
+			/* detach */
+		case 'D':
+			gdbstub_strcpy(output_buffer, "OK");
+			break;
 
 			/* reset the whole machine (FIXME: system dependent) */
 		case 'r':
@@ -1852,6 +1894,14 @@ void gdbstub(int sigval)
 			__debug_status.dcr |= DCR_SE;
 			goto done;
 
+			/* extended command */
+		case 'v':
+			if (strcmp(input_buffer, "vCont?") == 0) {
+				output_buffer[0] = 0;
+				break;
+			}
+			goto unsupported_cmd;
+
 			/* set baud rate (bBB) */
 		case 'b':
 			ptr = &input_buffer[1];
@@ -1923,8 +1973,19 @@ void gdbstub(int sigval)
 			gdbstub_strcpy(output_buffer,"OK");
 			break;
 
+			/* Thread-setting packet */
+		case 'H':
+			gdbstub_strcpy(output_buffer, "OK");
+			break;
+
+		case 'q':
+			gdbstub_handle_query();
+			break;
+
 		default:
+		unsupported_cmd:
 			gdbstub_proto("### GDB Unsupported Cmd '%s'\n",input_buffer);
+			gdbstub_strcpy(output_buffer,"E01");
 			break;
 		}
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
patch-b26b2d49-added-lines-with-a-missing-semicolons.patch
linux-next.patch
frv-hide-uncached_access-when-pgprot_noncached-is-not-defined.patch
frv-fix-kernel-user-segment-handling-in-nommu-mode.patch
frv-extend-gdbstub-to-support-more-features-of-gdb.patch
frv-extend-gdbstub-to-support-more-features-of-gdb-fix.patch
keys-dont-need-to-use-rcu-in-keyring_read-as-semaphore-is-held.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
frv-duplicate-output_buffer-of-e03.patch
nommu-allow-private-mappings-of-read-only-devices.patch
umh-creds-convert-call_usermodehelper_keys-to-use-subprocess_info-init.patch
umh-creds-kill-subprocess_info-cred-logic.patch
coredump-factor-out-the-not-ispipe-file-checks.patch
coredump-cleanup-ispipe-code.patch
coredump-factor-out-put_cred-calls.patch
coredump-shift-down_writemmap_sem-into-coredump_wait.patch
proc-get_nr_threads-doesnt-need-siglock-any-longer.patch
proc-make-collect_sigign_sigcatch-rcu-safe.patch
proc-make-task_sig-lockless.patch
proc_sched_show_task-use-get_nr_threads.patch
keyctl_session_to_parent-use-thread_group_empty-to-check-singlethreadness.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch


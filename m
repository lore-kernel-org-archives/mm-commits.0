From: akpm@linux-foundation.org
Subject: [patch 43/78] scripts/spelling.txt: add "an user" pattern and fix typo instances
Date: Mon, 27 Feb 2017 14:28:47 -0800
Message-ID: <58b4a81f.SQ9cj2oJRaHt94df%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45670 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751531AbdB0Wp1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 17:45:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, yamada.masahiro@socionext.com

From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: scripts/spelling.txt: add "an user" pattern and fix typo instances

Fix typos and add the following to the scripts/spelling.txt:

  an user||a user
  an userspace||a userspace

I also added "userspace" to the list since it is a common word in
Linux.  I found some instances for "an userfaultfd", but I did not
add it to the list.  I felt it is endless to find words that start
with "user" such as "userland" etc., so must draw a line somewhere.

Link: http://lkml.kernel.org/r/1481573103-11329-4-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/ras.rst             |    2 +-
 Documentation/devicetree/bindings/opp/opp.txt |    2 +-
 Documentation/filesystems/quota.txt           |    2 +-
 Documentation/kselftest.txt                   |    4 ++--
 Documentation/media/dvb-drivers/ci.rst        |    2 +-
 Documentation/networking/cdc_mbim.txt         |    4 ++--
 Documentation/vm/userfaultfd.txt              |    2 +-
 arch/Kconfig                                  |    2 +-
 arch/powerpc/xmon/ppc-opc.c                   |    2 +-
 arch/x86/kvm/mmu.c                            |    2 +-
 drivers/media/dvb-core/dvb_ringbuffer.h       |    4 ++--
 drivers/scsi/lpfc/lpfc_attr.c                 |    2 +-
 fs/userfaultfd.c                              |    6 +++---
 include/net/mac80211.h                        |    2 +-
 kernel/irq/manage.c                           |    2 +-
 net/bluetooth/hci_sock.c                      |    6 +++---
 net/netfilter/nfnetlink_cthelper.c            |    2 +-
 scripts/spelling.txt                          |    2 ++
 tools/perf/Documentation/tips.txt             |    2 +-
 19 files changed, 27 insertions(+), 25 deletions(-)

diff -puN Documentation/admin-guide/ras.rst~scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances Documentation/admin-guide/ras.rst
--- a/Documentation/admin-guide/ras.rst~scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances
+++ a/Documentation/admin-guide/ras.rst
@@ -81,7 +81,7 @@ That defines some categories of errors:
   still run, eventually replacing the affected hardware by a hot spare,
   if available.
 
-  Also, when an error happens on an userspace process, it is also possible to
+  Also, when an error happens on a userspace process, it is also possible to
   kill such process and let userspace restart it.
 
 The mechanism for handling non-fatal errors is usually complex and may
diff -puN Documentation/devicetree/bindings/opp/opp.txt~scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances Documentation/devicetree/bindings/opp/opp.txt
--- a/Documentation/devicetree/bindings/opp/opp.txt~scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances
+++ a/Documentation/devicetree/bindings/opp/opp.txt
@@ -136,7 +136,7 @@ Optional properties:
   larger OPP table, based on what version of the hardware we are running on. We
   still can't have multiple nodes with the same opp-hz value in OPP table.
 
-  It's an user defined array containing a hierarchy of hardware version numbers,
+  It's a user defined array containing a hierarchy of hardware version numbers,
   supported by the OPP. For example: a platform with hierarchy of three levels
   of versions (A, B and C), this field should be like <X Y Z>, where X
   corresponds to Version hierarchy A, Y corresponds to version hierarchy B and Z
diff -puN Documentation/filesystems/quota.txt~scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances Documentation/filesystems/quota.txt
--- a/Documentation/filesystems/quota.txt~scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances
+++ a/Documentation/filesystems/quota.txt
@@ -6,7 +6,7 @@ Quota subsystem allows system administra
 number of used inodes (inode is a filesystem structure which is associated with
 each file or directory) for users and/or groups. For both used space and number
 of used inodes there are actually two limits. The first one is called softlimit
-and the second one hardlimit.  An user can never exceed a hardlimit for any
+and the second one hardlimit.  A user can never exceed a hardlimit for any
 resource (unless he has CAP_SYS_RESOURCE capability). User is allowed to exceed
 softlimit but only for limited period of time. This period is called "grace
 period" or "grace time". When grace time is over, user is not able to allocate
diff -puN Documentation/kselftest.txt~scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances Documentation/kselftest.txt
--- a/Documentation/kselftest.txt~scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances
+++ a/Documentation/kselftest.txt
@@ -59,14 +59,14 @@ Install selftests
 =================
 
 You can use kselftest_install.sh tool installs selftests in default
-location which is tools/testing/selftests/kselftest or an user specified
+location which is tools/testing/selftests/kselftest or a user specified
 location.
 
 To install selftests in default location:
    $ cd tools/testing/selftests
    $ ./kselftest_install.sh
 
-To install selftests in an user specified location:
+To install selftests in a user specified location:
    $ cd tools/testing/selftests
    $ ./kselftest_install.sh install_dir
 
diff -puN Documentation/media/dvb-drivers/ci.rst~scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances Documentation/media/dvb-drivers/ci.rst
--- a/Documentation/media/dvb-drivers/ci.rst~scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances
+++ a/Documentation/media/dvb-drivers/ci.rst
@@ -20,7 +20,7 @@ existing low level CI API.
 ca_zap
 ~~~~~~
 
-An userspace application, like ``ca_zap`` is required to handle encrypted
+A userspace application, like ``ca_zap`` is required to handle encrypted
 MPEG-TS streams.
 
 The ``ca_zap`` userland application is in charge of sending the
diff -puN Documentation/networking/cdc_mbim.txt~scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances Documentation/networking/cdc_mbim.txt
--- a/Documentation/networking/cdc_mbim.txt~scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances
+++ a/Documentation/networking/cdc_mbim.txt
@@ -38,7 +38,7 @@ Basic usage
 ===========
 
 MBIM functions are inactive when unmanaged. The cdc_mbim driver only
-provides an userspace interface to the MBIM control channel, and will
+provides a userspace interface to the MBIM control channel, and will
 not participate in the management of the function. This implies that a
 userspace MBIM management application always is required to enable a
 MBIM function.
@@ -200,7 +200,7 @@ structure described in section 10.5.29 o
 The DSS VLAN subdevices are used as a practical interface between the
 shared MBIM data channel and a MBIM DSS aware userspace application.
 It is not intended to be presented as-is to an end user. The
-assumption is that an userspace application initiating a DSS session
+assumption is that a userspace application initiating a DSS session
 also takes care of the necessary framing of the DSS data, presenting
 the stream to the end user in an appropriate way for the stream type.
 
diff -puN Documentation/vm/userfaultfd.txt~scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances Documentation/vm/userfaultfd.txt
--- a/Documentation/vm/userfaultfd.txt~scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances
+++ a/Documentation/vm/userfaultfd.txt
@@ -149,7 +149,7 @@ migration thread in the QEMU running in
 receive the page that triggered the userfault and it'll map it as
 usual with the UFFDIO_COPY|ZEROPAGE (without actually knowing if it
 was spontaneously sent by the source or if it was an urgent page
-requested through an userfault).
+requested through a userfault).
 
 By the time the userfaults start, the QEMU in the destination node
 doesn't need to keep any per-page state bitmap relative to the live
diff -puN arch/Kconfig~scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances arch/Kconfig
--- a/arch/Kconfig~scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances
+++ a/arch/Kconfig
@@ -29,7 +29,7 @@ config OPROFILE_EVENT_MULTIPLEX
 	  The number of hardware counters is limited. The multiplexing
 	  feature enables OProfile to gather more events than counters
 	  are provided by the hardware. This is realized by switching
-	  between events at an user specified time interval.
+	  between events at a user specified time interval.
 
 	  If unsure, say N.
 
diff -puN arch/powerpc/xmon/ppc-opc.c~scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances arch/powerpc/xmon/ppc-opc.c
--- a/arch/powerpc/xmon/ppc-opc.c~scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances
+++ a/arch/powerpc/xmon/ppc-opc.c
@@ -1587,7 +1587,7 @@ extract_tbr (unsigned long insn,
 #define CTX(op, xop)   (OP (op) | (((unsigned long)(xop)) & 0x7))
 #define CTX_MASK CTX(0x3f, 0x7)
 
-/* An User Context form instruction.  */
+/* A User Context form instruction.  */
 #define UCTX(op, xop)  (OP (op) | (((unsigned long)(xop)) & 0x1f))
 #define UCTX_MASK UCTX(0x3f, 0x1f)
 
diff -puN arch/x86/kvm/mmu.c~scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances arch/x86/kvm/mmu.c
--- a/arch/x86/kvm/mmu.c~scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances
+++ a/arch/x86/kvm/mmu.c
@@ -4102,7 +4102,7 @@ static void update_permission_bitmask(st
 				 * as a SMAP violation if all of the following
 				 * conditions are ture:
 				 *   - X86_CR4_SMAP is set in CR4
-				 *   - An user page is accessed
+				 *   - A user page is accessed
 				 *   - Page fault in kernel mode
 				 *   - if CPL = 3 or X86_EFLAGS_AC is clear
 				 *
diff -puN drivers/media/dvb-core/dvb_ringbuffer.h~scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances drivers/media/dvb-core/dvb_ringbuffer.h
--- a/drivers/media/dvb-core/dvb_ringbuffer.h~scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances
+++ a/drivers/media/dvb-core/dvb_ringbuffer.h
@@ -136,7 +136,7 @@ extern void dvb_ringbuffer_flush_spinloc
 }
 
 /**
- * dvb_ringbuffer_read_user - Reads a buffer into an user pointer
+ * dvb_ringbuffer_read_user - Reads a buffer into a user pointer
  *
  * @rbuf: pointer to struct dvb_ringbuffer
  * @buf: pointer to the buffer where the data will be stored
@@ -193,7 +193,7 @@ extern ssize_t dvb_ringbuffer_write(stru
 				    size_t len);
 
 /**
- * dvb_ringbuffer_write_user - Writes a buffer received via an user pointer
+ * dvb_ringbuffer_write_user - Writes a buffer received via a user pointer
  *
  * @rbuf: pointer to struct dvb_ringbuffer
  * @buf: pointer to the buffer where the data will be read
diff -puN drivers/scsi/lpfc/lpfc_attr.c~scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c~scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances
+++ a/drivers/scsi/lpfc/lpfc_attr.c
@@ -3329,7 +3329,7 @@ static DEVICE_ATTR(lpfc_static_vport, S_
  * @buf: Data buffer.
  * @count: Size of the data buffer.
  *
- * This function get called when an user write to the lpfc_stat_data_ctrl
+ * This function get called when a user write to the lpfc_stat_data_ctrl
  * sysfs file. This function parse the command written to the sysfs file
  * and take appropriate action. These commands are used for controlling
  * driver statistical data collection.
diff -puN fs/userfaultfd.c~scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances fs/userfaultfd.c
--- a/fs/userfaultfd.c~scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances
+++ a/fs/userfaultfd.c
@@ -1807,17 +1807,17 @@ static void init_once_userfaultfd_ctx(vo
 }
 
 /**
- * userfaultfd_file_create - Creates an userfaultfd file pointer.
+ * userfaultfd_file_create - Creates a userfaultfd file pointer.
  * @flags: Flags for the userfaultfd file.
  *
- * This function creates an userfaultfd file pointer, w/out installing
+ * This function creates a userfaultfd file pointer, w/out installing
  * it into the fd table. This is useful when the userfaultfd file is
  * used during the initialization of data structures that require
  * extra setup after the userfaultfd creation. So the userfaultfd
  * creation is split into the file pointer creation phase, and the
  * file descriptor installation phase.  In this way races with
  * userspace closing the newly installed file descriptor can be
- * avoided.  Returns an userfaultfd file pointer, or a proper error
+ * avoided.  Returns a userfaultfd file pointer, or a proper error
  * pointer.
  */
 static struct file *userfaultfd_file_create(int flags)
diff -puN include/net/mac80211.h~scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances include/net/mac80211.h
--- a/include/net/mac80211.h~scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances
+++ a/include/net/mac80211.h
@@ -3392,7 +3392,7 @@ enum ieee80211_reconfig_type {
  *	since there won't be any time to beacon before the switch anyway.
  * @pre_channel_switch: This is an optional callback that is called
  *	before a channel switch procedure is started (ie. when a STA
- *	gets a CSA or an userspace initiated channel-switch), allowing
+ *	gets a CSA or a userspace initiated channel-switch), allowing
  *	the driver to prepare for the channel switch.
  * @post_channel_switch: This is an optional callback that is called
  *	after a channel switch procedure is completed, allowing the
diff -puN kernel/irq/manage.c~scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances kernel/irq/manage.c
--- a/kernel/irq/manage.c~scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances
+++ a/kernel/irq/manage.c
@@ -353,7 +353,7 @@ static int setup_affinity(struct irq_des
 		return 0;
 
 	/*
-	 * Preserve the managed affinity setting and an userspace affinity
+	 * Preserve the managed affinity setting and a userspace affinity
 	 * setup, but make sure that one of the targets is online.
 	 */
 	if (irqd_affinity_is_managed(&desc->irq_data) ||
diff -puN net/bluetooth/hci_sock.c~scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances net/bluetooth/hci_sock.c
--- a/net/bluetooth/hci_sock.c~scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances
+++ a/net/bluetooth/hci_sock.c
@@ -851,7 +851,7 @@ static int hci_sock_release(struct socke
 
 	if (hdev) {
 		if (hci_pi(sk)->channel == HCI_CHANNEL_USER) {
-			/* When releasing an user channel exclusive access,
+			/* When releasing a user channel exclusive access,
 			 * call hci_dev_do_close directly instead of calling
 			 * hci_dev_close to ensure the exclusive access will
 			 * be released and the controller brought back down.
@@ -1172,7 +1172,7 @@ static int hci_sock_bind(struct socket *
 				/* In case the transport is already up and
 				 * running, clear the error here.
 				 *
-				 * This can happen when opening an user
+				 * This can happen when opening a user
 				 * channel and HCI_AUTO_OFF grace period
 				 * is still active.
 				 */
@@ -1190,7 +1190,7 @@ static int hci_sock_bind(struct socket *
 		if (!hci_sock_gen_cookie(sk)) {
 			/* In the case when a cookie has already been assigned,
 			 * this socket will transition from a raw socket into
-			 * an user channel socket. For a clean transition, send
+			 * a user channel socket. For a clean transition, send
 			 * the close notification first.
 			 */
 			skb = create_monitor_ctrl_close(sk);
diff -puN net/netfilter/nfnetlink_cthelper.c~scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances net/netfilter/nfnetlink_cthelper.c
--- a/net/netfilter/nfnetlink_cthelper.c~scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances
+++ a/net/netfilter/nfnetlink_cthelper.c
@@ -48,7 +48,7 @@ nfnl_userspace_cthelper(struct sk_buff *
 	if (helper == NULL)
 		return NF_DROP;
 
-	/* This is an user-space helper not yet configured, skip. */
+	/* This is a user-space helper not yet configured, skip. */
 	if ((helper->flags &
 	    (NF_CT_HELPER_F_USERSPACE | NF_CT_HELPER_F_CONFIGURED)) ==
 	     NF_CT_HELPER_F_USERSPACE)
diff -puN scripts/spelling.txt~scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances
+++ a/scripts/spelling.txt
@@ -86,6 +86,8 @@ alue||value
 ambigious||ambiguous
 amoung||among
 amout||amount
+an user||a user
+an userspace||a userspace
 analysator||analyzer
 ang||and
 anniversery||anniversary
diff -puN tools/perf/Documentation/tips.txt~scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances tools/perf/Documentation/tips.txt
--- a/tools/perf/Documentation/tips.txt~scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances
+++ a/tools/perf/Documentation/tips.txt
@@ -22,7 +22,7 @@ If you have debuginfo enabled, try: perf
 For memory address profiling, try: perf mem record / perf mem report
 For tracepoint events, try: perf report -s trace_fields
 To record callchains for each sample: perf record -g
-To record every process run by an user: perf record -u <user>
+To record every process run by a user: perf record -u <user>
 Skip collecing build-id when recording: perf record -B
 To change sampling frequency to 100 Hz: perf record -F 100
 See assembly instructions with percentage: perf annotate <symbol>
_

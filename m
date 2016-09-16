From: akpm@linux-foundation.org
Subject: + ima-serialize-the-binary_runtime_measurements.patch added to
 -mm tree
Date: Fri, 16 Sep 2016 16:22:31 -0700
Message-ID: <57dc7eb7.IX64Q7JSN47odWvC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59140 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754490AbcIPXWd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Sep 2016 19:22:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zohar@linux.vnet.ibm.com, bhe@redhat.com, bsingharora@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, erichte@linux.vnet.ibm.com, mpe@ellerman.id.au, stewart@linux.vnet.ibm.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ima: serialize the binary_runtime_measurements
has been added to the -mm tree.  Its filename is
     ima-serialize-the-binary_runtime_measurements.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ima-serialize-the-binary_runtime_measurements.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ima-serialize-the-binary_runtime_measurements.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: ima: serialize the binary_runtime_measurements

The TPM PCRs are only reset on a hard reboot.  In order to validate a
TPM's quote after a soft reboot (eg.  kexec -e), the IMA measurement list
of the running kernel must be saved and restored on boot.  This patch
serializes the IMA measurement list in the binary_runtime_measurements
format.

Link: http://lkml.kernel.org/r/1473938771-2782-5-git-send-email-zohar@linux.vnet.ibm.com
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Stewart Smith <stewart@linux.vnet.ibm.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Eric Richter <erichte@linux.vnet.ibm.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/integrity/ima/ima.h       |    1 
 security/integrity/ima/ima_fs.c    |    2 -
 security/integrity/ima/ima_kexec.c |   51 +++++++++++++++++++++++++++
 3 files changed, 53 insertions(+), 1 deletion(-)

diff -puN security/integrity/ima/ima.h~ima-serialize-the-binary_runtime_measurements security/integrity/ima/ima.h
--- a/security/integrity/ima/ima.h~ima-serialize-the-binary_runtime_measurements
+++ a/security/integrity/ima/ima.h
@@ -133,6 +133,7 @@ void ima_print_digest(struct seq_file *m
 struct ima_template_desc *ima_template_desc_current(void);
 int ima_restore_measurement_entry(struct ima_template_entry *entry);
 int ima_restore_measurement_list(loff_t bufsize, void *buf);
+int ima_measurements_show(struct seq_file *m, void *v);
 unsigned long ima_get_binary_runtime_size(void);
 int ima_init_template(void);
 
diff -puN security/integrity/ima/ima_fs.c~ima-serialize-the-binary_runtime_measurements security/integrity/ima/ima_fs.c
--- a/security/integrity/ima/ima_fs.c~ima-serialize-the-binary_runtime_measurements
+++ a/security/integrity/ima/ima_fs.c
@@ -116,7 +116,7 @@ void ima_putc(struct seq_file *m, void *
  *       [eventdata length]
  *       eventdata[n]=template specific data
  */
-static int ima_measurements_show(struct seq_file *m, void *v)
+int ima_measurements_show(struct seq_file *m, void *v)
 {
 	/* the list never shrinks, so we don't need a lock here */
 	struct ima_queue_entry *qe = v;
diff -puN security/integrity/ima/ima_kexec.c~ima-serialize-the-binary_runtime_measurements security/integrity/ima/ima_kexec.c
--- a/security/integrity/ima/ima_kexec.c~ima-serialize-the-binary_runtime_measurements
+++ a/security/integrity/ima/ima_kexec.c
@@ -23,6 +23,57 @@
 
 #include "ima.h"
 
+static int ima_dump_measurement_list(unsigned long *buffer_size, void **buffer,
+				     unsigned long segment_size)
+{
+	struct ima_queue_entry *qe;
+	struct seq_file file;
+	struct ima_kexec_hdr khdr = {
+		.version = 1, .buffer_size = 0, .count = 0};
+	int ret = 0;
+
+	/* segment size can't change between kexec load and execute */
+	file.buf = vmalloc(segment_size);
+	if (!file.buf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	file.size = segment_size;
+	file.read_pos = 0;
+	file.count = sizeof(khdr);	/* reserved space */
+
+	list_for_each_entry_rcu(qe, &ima_measurements, later) {
+		if (file.count < file.size) {
+			khdr.count++;
+			ima_measurements_show(&file, qe);
+		} else {
+			ret = -EINVAL;
+			break;
+		}
+	}
+
+	if (ret < 0)
+		goto out;
+
+	/*
+	 * fill in reserved space with some buffer details
+	 * (eg. version, buffer size, number of measurements)
+	 */
+	khdr.buffer_size = file.count;
+	memcpy(file.buf, &khdr, sizeof(khdr));
+	print_hex_dump(KERN_DEBUG, "ima dump: ", DUMP_PREFIX_NONE,
+			16, 1, file.buf,
+			file.count < 100 ? file.count : 100, true);
+
+	*buffer_size = file.count;
+	*buffer = file.buf;
+out:
+	if (ret == -EINVAL)
+		vfree(file.buf);
+	return ret;
+}
+
 /*
  * Restore the measurement list from the previous kernel.
  */
_

Patches currently in -mm which might be from zohar@linux.vnet.ibm.com are

ima-on-soft-reboot-restore-the-measurement-list.patch
ima-permit-duplicate-measurement-list-entries.patch
ima-maintain-memory-size-needed-for-serializing-the-measurement-list.patch
ima-serialize-the-binary_runtime_measurements.patch
ima-store-the-builtin-custom-template-definitions-in-a-list.patch
ima-support-restoring-multiple-template-formats.patch
ima-define-a-canonical-binary_runtime_measurements-list-format.patch


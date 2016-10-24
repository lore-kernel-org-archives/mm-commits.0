From: akpm@linux-foundation.org
Subject: +
 ima-maintain-memory-size-needed-for-serializing-the-measurement-list.patch
 added to -mm tree
Date: Mon, 24 Oct 2016 12:42:48 -0700
Message-ID: <580e6438.S7L1minZDpDx3u4G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56710 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941104AbcJXTmt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2016 15:42:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zohar@linux.vnet.ibm.com, andreas.steffen@strongswan.org, bsingharora@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, mpe@ellerman.id.au, sklar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ima: maintain memory size needed for serializing the measurement list
has been added to the -mm tree.  Its filename is
     ima-maintain-memory-size-needed-for-serializing-the-measurement-list.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ima-maintain-memory-size-needed-for-serializing-the-measurement-list.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ima-maintain-memory-size-needed-for-serializing-the-measurement-list.patch

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
Subject: ima: maintain memory size needed for serializing the measurement list

In preparation for serializing the binary_runtime_measurements, this patch
maintains the amount of memory required.

Link: http://lkml.kernel.org/r/1477017898-10375-5-git-send-email-bauerman@linux.vnet.ibm.com
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andreas Steffen <andreas.steffen@strongswan.org>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Josh Sklar <sklar@linux.vnet.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/integrity/ima/Kconfig     |   12 ++++++
 security/integrity/ima/ima.h       |    1 
 security/integrity/ima/ima_queue.c |   53 +++++++++++++++++++++++++--
 3 files changed, 64 insertions(+), 2 deletions(-)

diff -puN security/integrity/ima/Kconfig~ima-maintain-memory-size-needed-for-serializing-the-measurement-list security/integrity/ima/Kconfig
--- a/security/integrity/ima/Kconfig~ima-maintain-memory-size-needed-for-serializing-the-measurement-list
+++ a/security/integrity/ima/Kconfig
@@ -27,6 +27,18 @@ config IMA
 	  to learn more about IMA.
 	  If unsure, say N.
 
+config IMA_KEXEC
+	bool "Enable carrying the IMA measurement list across a soft boot"
+	depends on IMA && TCG_TPM && HAVE_IMA_KEXEC
+	default n
+	help
+	   TPM PCRs are only reset on a hard reboot.  In order to validate
+	   a TPM's quote after a soft boot, the IMA measurement list of the
+	   running kernel must be saved and restored on boot.
+
+	   Depending on the IMA policy, the measurement list can grow to
+	   be very large.
+
 config IMA_MEASURE_PCR_IDX
 	int
 	depends on IMA
diff -puN security/integrity/ima/ima.h~ima-maintain-memory-size-needed-for-serializing-the-measurement-list security/integrity/ima/ima.h
--- a/security/integrity/ima/ima.h~ima-maintain-memory-size-needed-for-serializing-the-measurement-list
+++ a/security/integrity/ima/ima.h
@@ -143,6 +143,7 @@ void ima_print_digest(struct seq_file *m
 struct ima_template_desc *ima_template_desc_current(void);
 int ima_restore_measurement_entry(struct ima_template_entry *entry);
 int ima_restore_measurement_list(loff_t bufsize, void *buf);
+unsigned long ima_get_binary_runtime_size(void);
 int ima_init_template(void);
 
 /*
diff -puN security/integrity/ima/ima_queue.c~ima-maintain-memory-size-needed-for-serializing-the-measurement-list security/integrity/ima/ima_queue.c
--- a/security/integrity/ima/ima_queue.c~ima-maintain-memory-size-needed-for-serializing-the-measurement-list
+++ a/security/integrity/ima/ima_queue.c
@@ -29,6 +29,11 @@
 #define AUDIT_CAUSE_LEN_MAX 32
 
 LIST_HEAD(ima_measurements);	/* list of all measurements */
+#ifdef CONFIG_IMA_KEXEC
+static unsigned long binary_runtime_size;
+#else
+static unsigned long binary_runtime_size = ULONG_MAX;
+#endif
 
 /* key: inode (before secure-hashing a file) */
 struct ima_h_table ima_htable = {
@@ -64,6 +69,24 @@ static struct ima_queue_entry *ima_looku
 	return ret;
 }
 
+/*
+ * Calculate the memory required for serializing a single
+ * binary_runtime_measurement list entry, which contains a
+ * couple of variable length fields (e.g template name and data).
+ */
+static int get_binary_runtime_size(struct ima_template_entry *entry)
+{
+	int size = 0;
+
+	size += sizeof(u32);	/* pcr */
+	size += sizeof(entry->digest);
+	size += sizeof(int);	/* template name size field */
+	size += strlen(entry->template_desc->name);
+	size += sizeof(entry->template_data_len);
+	size += entry->template_data_len;
+	return size;
+}
+
 /* ima_add_template_entry helper function:
  * - Add template entry to the measurement list and hash table, for
  *   all entries except those carried across kexec.
@@ -90,9 +113,30 @@ static int ima_add_digest_entry(struct i
 		key = ima_hash_key(entry->digest);
 		hlist_add_head_rcu(&qe->hnext, &ima_htable.queue[key]);
 	}
+
+	if (binary_runtime_size != ULONG_MAX) {
+		int size;
+
+		size = get_binary_runtime_size(entry);
+		binary_runtime_size = (binary_runtime_size < ULONG_MAX - size) ?
+		     binary_runtime_size + size : ULONG_MAX;
+	}
 	return 0;
 }
 
+/*
+ * Return the amount of memory required for serializing the
+ * entire binary_runtime_measurement list, including the ima_kexec_hdr
+ * structure.
+ */
+unsigned long ima_get_binary_runtime_size(void)
+{
+	if (binary_runtime_size >= (ULONG_MAX - sizeof(struct ima_kexec_hdr)))
+		return ULONG_MAX;
+	else
+		return binary_runtime_size + sizeof(struct ima_kexec_hdr);
+};
+
 static int ima_pcr_extend(const u8 *hash, int pcr)
 {
 	int result = 0;
@@ -106,8 +150,13 @@ static int ima_pcr_extend(const u8 *hash
 	return result;
 }
 
-/* Add template entry to the measurement list and hash table,
- * and extend the pcr.
+/*
+ * Add template entry to the measurement list and hash table, and
+ * extend the pcr.
+ *
+ * On systems which support carrying the IMA measurement list across
+ * kexec, maintain the total memory size required for serializing the
+ * binary_runtime_measurements.
  */
 int ima_add_template_entry(struct ima_template_entry *entry, int violation,
 			   const char *op, struct inode *inode,
_

Patches currently in -mm which might be from zohar@linux.vnet.ibm.com are

ima-on-soft-reboot-restore-the-measurement-list.patch
ima-permit-duplicate-measurement-list-entries.patch
ima-maintain-memory-size-needed-for-serializing-the-measurement-list.patch
ima-on-soft-reboot-save-the-measurement-list.patch
ima-store-the-builtin-custom-template-definitions-in-a-list.patch
ima-support-restoring-multiple-template-formats.patch
ima-define-a-canonical-binary_runtime_measurements-list-format.patch


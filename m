From: akpm@linux-foundation.org
Subject: +
 ima-define-a-canonical-binary_runtime_measurements-list-format.patch added
 to -mm tree
Date: Fri, 16 Sep 2016 16:22:42 -0700
Message-ID: <57dc7ec2.G0x164w20Z9F2Msu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59159 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754490AbcIPXWn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Sep 2016 19:22:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zohar@linux.vnet.ibm.com, bhe@redhat.com, bsingharora@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, erichte@linux.vnet.ibm.com, mpe@ellerman.id.au, stewart@linux.vnet.ibm.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ima: define a canonical binary_runtime_measurements list format
has been added to the -mm tree.  Its filename is
     ima-define-a-canonical-binary_runtime_measurements-list-format.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ima-define-a-canonical-binary_runtime_measurements-list-format.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ima-define-a-canonical-binary_runtime_measurements-list-format.patch

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
Subject: ima: define a canonical binary_runtime_measurements list format

The IMA binary_runtime_measurements list is currently in platform native
format.

To allow restoring a measurement list carried across kexec with a
different endianness than the targeted kernel, this patch defines
little-endian as the canonical format.  For big endian systems wanting to
save/restore the measurement list from a system with a different
endianness, a new boot command line parameter named "ima_canonical_fmt" is
defined.

Considerations: use of the "ima_canonical_fmt" boot command line option
will break existing userspace applications on big endian systems expecting
the binary_runtime_measurements list to be in platform native format.

Link: http://lkml.kernel.org/r/1473938771-2782-9-git-send-email-zohar@linux.vnet.ibm.com
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

 Documentation/kernel-parameters.txt       |    4 ++
 security/integrity/ima/ima.h              |    6 ++++
 security/integrity/ima/ima_fs.c           |   28 +++++++++++++++-----
 security/integrity/ima/ima_kexec.c        |   11 ++++++-
 security/integrity/ima/ima_template.c     |   24 +++++++++++++++--
 security/integrity/ima/ima_template_lib.c |    7 +++--
 6 files changed, 67 insertions(+), 13 deletions(-)

diff -puN Documentation/kernel-parameters.txt~ima-define-a-canonical-binary_runtime_measurements-list-format Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~ima-define-a-canonical-binary_runtime_measurements-list-format
+++ a/Documentation/kernel-parameters.txt
@@ -1611,6 +1611,10 @@ bytes respectively. Such letter suffixes
 			The builtin appraise policy appraises all files
 			owned by uid=0.
 
+	ima_canonical_fmt [IMA]
+			Use the canonical format for the binary runtime
+			measurements, instead of host native format.
+
 	ima_hash=	[IMA]
 			Format: { md5 | sha1 | rmd160 | sha256 | sha384
 				   | sha512 | ... }
diff -puN security/integrity/ima/ima.h~ima-define-a-canonical-binary_runtime_measurements-list-format security/integrity/ima/ima.h
--- a/security/integrity/ima/ima.h~ima-define-a-canonical-binary_runtime_measurements-list-format
+++ a/security/integrity/ima/ima.h
@@ -112,6 +112,12 @@ struct ima_kexec_hdr {
 	u64 count;
 };
 
+/*
+ * The default binary_runtime_measurements list format is defined as the
+ * platform native format.  The canonical format is defined as little-endian.
+ */
+extern bool ima_canonical_fmt;
+
 /* Internal IMA function definitions */
 int ima_init(void);
 int ima_fs_init(void);
diff -puN security/integrity/ima/ima_fs.c~ima-define-a-canonical-binary_runtime_measurements-list-format security/integrity/ima/ima_fs.c
--- a/security/integrity/ima/ima_fs.c~ima-define-a-canonical-binary_runtime_measurements-list-format
+++ a/security/integrity/ima/ima_fs.c
@@ -28,6 +28,16 @@
 
 static DEFINE_MUTEX(ima_write_mutex);
 
+bool ima_canonical_fmt;
+static int __init default_canonical_fmt_setup(char *str)
+{
+#ifdef __BIG_ENDIAN
+	ima_canonical_fmt = 1;
+#endif
+	return 1;
+}
+__setup("ima_canonical_fmt", default_canonical_fmt_setup);
+
 static int valid_policy = 1;
 #define TMPBUFLEN 12
 static ssize_t ima_show_htable_value(char __user *buf, size_t count,
@@ -122,7 +132,7 @@ int ima_measurements_show(struct seq_fil
 	struct ima_queue_entry *qe = v;
 	struct ima_template_entry *e;
 	char *template_name;
-	int namelen;
+	u32 pcr, namelen, template_data_len; /* temporary fields */
 	bool is_ima_template = false;
 	int i;
 
@@ -139,25 +149,29 @@ int ima_measurements_show(struct seq_fil
 	 * PCR used defaults to the same (config option) in
 	 * little-endian format, unless set in policy
 	 */
-	ima_putc(m, &e->pcr, sizeof(e->pcr));
+	pcr = !ima_canonical_fmt ? e->pcr : cpu_to_le32(e->pcr);
+	ima_putc(m, &pcr, sizeof(e->pcr));
 
 	/* 2nd: template digest */
 	ima_putc(m, e->digest, TPM_DIGEST_SIZE);
 
 	/* 3rd: template name size */
-	namelen = strlen(template_name);
+	namelen = !ima_canonical_fmt ? strlen(template_name) :
+		cpu_to_le32(strlen(template_name));
 	ima_putc(m, &namelen, sizeof(namelen));
 
 	/* 4th:  template name */
-	ima_putc(m, template_name, namelen);
+	ima_putc(m, template_name, strlen(template_name));
 
 	/* 5th:  template length (except for 'ima' template) */
 	if (strcmp(template_name, IMA_TEMPLATE_IMA_NAME) == 0)
 		is_ima_template = true;
 
-	if (!is_ima_template)
-		ima_putc(m, &e->template_data_len,
-			 sizeof(e->template_data_len));
+	if (!is_ima_template) {
+		template_data_len = !ima_canonical_fmt ? e->template_data_len :
+			cpu_to_le32(e->template_data_len);
+		ima_putc(m, &template_data_len, sizeof(e->template_data_len));
+	}
 
 	/* 6th:  template specific data */
 	for (i = 0; i < e->template_desc->num_fields; i++) {
diff -puN security/integrity/ima/ima_kexec.c~ima-define-a-canonical-binary_runtime_measurements-list-format security/integrity/ima/ima_kexec.c
--- a/security/integrity/ima/ima_kexec.c~ima-define-a-canonical-binary_runtime_measurements-list-format
+++ a/security/integrity/ima/ima_kexec.c
@@ -33,8 +33,7 @@ static int ima_dump_measurement_list(uns
 {
 	struct ima_queue_entry *qe;
 	struct seq_file file;
-	struct ima_kexec_hdr khdr = {
-		.version = 1, .buffer_size = 0, .count = 0};
+	struct ima_kexec_hdr khdr;
 	int ret = 0;
 
 	/* segment size can't change between kexec load and execute */
@@ -48,6 +47,8 @@ static int ima_dump_measurement_list(uns
 	file.read_pos = 0;
 	file.count = sizeof(khdr);	/* reserved space */
 
+	memset(&khdr, 0, sizeof(khdr));
+	khdr.version = 1;
 	list_for_each_entry_rcu(qe, &ima_measurements, later) {
 		if (file.count < file.size) {
 			khdr.count++;
@@ -66,7 +67,13 @@ static int ima_dump_measurement_list(uns
 	 * (eg. version, buffer size, number of measurements)
 	 */
 	khdr.buffer_size = file.count;
+	if (ima_canonical_fmt) {
+		khdr.version = cpu_to_le16(khdr.version);
+		khdr.count = cpu_to_le64(khdr.count);
+		khdr.buffer_size = cpu_to_le64(khdr.buffer_size);
+	}
 	memcpy(file.buf, &khdr, sizeof(khdr));
+
 	print_hex_dump(KERN_DEBUG, "ima dump: ", DUMP_PREFIX_NONE,
 			16, 1, file.buf,
 			file.count < 100 ? file.count : 100, true);
diff -puN security/integrity/ima/ima_template.c~ima-define-a-canonical-binary_runtime_measurements-list-format security/integrity/ima/ima_template.c
--- a/security/integrity/ima/ima_template.c~ima-define-a-canonical-binary_runtime_measurements-list-format
+++ a/security/integrity/ima/ima_template.c
@@ -304,6 +304,9 @@ static int ima_restore_template_data(str
 		}
 		offset += sizeof(field_data->len);
 
+		if (ima_canonical_fmt)
+			field_data->len = le32_to_cpu(field_data->len);
+
 		if (offset > (template_data_size - field_data->len)) {
 			pr_err("Restoring the template field data failed\n");
 			ret = -EINVAL;
@@ -354,7 +357,7 @@ int ima_restore_measurement_list(loff_t
 	struct binary_data_v1 *data_v1;
 
 	void *bufp = buf + sizeof(*khdr);
-	void *bufendp = buf + khdr->buffer_size;
+	void *bufendp;
 	struct ima_template_entry *entry;
 	struct ima_template_desc *template_desc;
 	unsigned long count = 0;
@@ -363,6 +366,12 @@ int ima_restore_measurement_list(loff_t
 	if (!buf || size < sizeof(*khdr))
 		return 0;
 
+	if (ima_canonical_fmt) {
+		khdr->version = le16_to_cpu(khdr->version);
+		khdr->count = le64_to_cpu(khdr->count);
+		khdr->buffer_size = le64_to_cpu(khdr->buffer_size);
+	}
+
 	if (khdr->version != 1) {
 		pr_err("attempting to restore a incompatible measurement list");
 		return 0;
@@ -373,6 +382,7 @@ int ima_restore_measurement_list(loff_t
 	 * v1 format: pcr, digest, template-name-len, template-name,
 	 *	      template-data-size, template-data
 	 */
+	bufendp = buf + khdr->buffer_size;
 	while ((bufp < bufendp) && (count++ < khdr->count)) {
 		if (count > ULONG_MAX - 1) {
 			pr_err("attempting to restore too many measurements");
@@ -380,6 +390,11 @@ int ima_restore_measurement_list(loff_t
 		}
 
 		hdr_v1 = bufp;
+
+		if (ima_canonical_fmt)
+			hdr_v1->template_name_len =
+			    le32_to_cpu(hdr_v1->template_name_len);
+
 		if ((hdr_v1->template_name_len > MAX_TEMPLATE_NAME_LEN) ||
 		    ((bufp + hdr_v1->template_name_len) > bufendp)) {
 			pr_err("attempting to restore a template name \
@@ -429,6 +444,10 @@ int ima_restore_measurement_list(loff_t
 		}
 		bufp += (u_int8_t) sizeof(data_v1->template_data_size);
 
+		if (ima_canonical_fmt)
+			data_v1->template_data_size =
+			    le32_to_cpu(data_v1->template_data_size);
+
 		if (bufp > (bufendp - data_v1->template_data_size)) {
 			pr_err("restoring the template data failed\n");
 			ret = -EINVAL;
@@ -443,7 +462,8 @@ int ima_restore_measurement_list(loff_t
 			break;
 
 		memcpy(entry->digest, hdr_v1->digest, TPM_DIGEST_SIZE);
-		entry->pcr = hdr_v1->pcr;
+		entry->pcr =
+		    !ima_canonical_fmt ? hdr_v1->pcr : le32_to_cpu(hdr_v1->pcr);
 		ret = ima_restore_measurement_entry(entry);
 		if (ret < 0)
 			break;
diff -puN security/integrity/ima/ima_template_lib.c~ima-define-a-canonical-binary_runtime_measurements-list-format security/integrity/ima/ima_template_lib.c
--- a/security/integrity/ima/ima_template_lib.c~ima-define-a-canonical-binary_runtime_measurements-list-format
+++ a/security/integrity/ima/ima_template_lib.c
@@ -103,8 +103,11 @@ static void ima_show_template_data_binar
 	u32 len = (show == IMA_SHOW_BINARY_OLD_STRING_FMT) ?
 	    strlen(field_data->data) : field_data->len;
 
-	if (show != IMA_SHOW_BINARY_NO_FIELD_LEN)
-		ima_putc(m, &len, sizeof(len));
+	if (show != IMA_SHOW_BINARY_NO_FIELD_LEN) {
+		u32 field_len = !ima_canonical_fmt ? len : cpu_to_le32(len);
+
+		ima_putc(m, &field_len, sizeof(field_len));
+	}
 
 	if (!len)
 		return;
_

Patches currently in -mm which might be from zohar@linux.vnet.ibm.com are

ima-on-soft-reboot-restore-the-measurement-list.patch
ima-permit-duplicate-measurement-list-entries.patch
ima-maintain-memory-size-needed-for-serializing-the-measurement-list.patch
ima-serialize-the-binary_runtime_measurements.patch
ima-store-the-builtin-custom-template-definitions-in-a-list.patch
ima-support-restoring-multiple-template-formats.patch
ima-define-a-canonical-binary_runtime_measurements-list-format.patch

